--Divine Swarm
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(ep,id)>0 then return end
	return aux.CanActivateSkill(tp)  
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=4
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(ep,id,0,0,0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,4,4,nil)
	if #g<4 then return end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)

	-- choose 1 of 3 to add (only if that code exists in Deck or GY and is able to hand)
	local options={21208154,57793869,62180201} -- replace with your 3 codes
	local availCodes={}
	local labels={}
	for i,code in ipairs(options) do
		-- check existence + is able to hand
		if Duel.IsExistingMatchingCard(function(c) return c:IsCode(code) and c:IsAbleToHand() end, tp, LOCATION_DECK, 0, 1, nil) then
			table.insert(availCodes, code)
			-- pick a string id slot for the label; ensure you have these strings in your localization
			table.insert(labels, aux.Stringid(id, i-1))
		end
	end
	if #availCodes==0 then return end

	local sel
	if #labels==1 then
		sel=0
	else
		sel=Duel.SelectOption(tp, table.unpack(labels))
	end
	local chosenCode = availCodes[sel+1]

	-- actually select the card from Deck/GY and add it to hand
	local addg=Duel.SelectMatchingCard(tp, function(c) return c:IsCode(chosenCode) and c:IsAbleToHand() end,
		tp, LOCATION_DECK, 0, 1, 1, nil)
	if #addg==0 then return end
	local added = addg:GetFirst()
	Duel.SendtoHand(added, nil, REASON_EFFECT)
	Duel.ConfirmCards(1-tp, added)
	Duel.ShuffleDeck(tp)

	-- summon 3 tokens (Tellus Wing Token = 19280590)
	local token_code = 19280590
	if Duel.GetLocationCount(tp,LOCATION_MZONE) > 2
		and Duel.IsPlayerCanSpecialSummonMonster(tp, token_code, 0, TYPE_TOKEN, 0, 0, 1, RACE_FAIRY, ATTRIBUTE_LIGHT) then
		for i=1,3 do
			local token = Duel.CreateToken(tp, token_code)
			Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end

	-- restriction: cannot NORMAL/SPECIAL Summon except the added card
	local code_locked = added:GetCode()
	-- special summon lock
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit(code_locked))
	e1:SetReset(RESET_PHASE+PHASE_END,3) -- lasts through your turn + opp + your turn + opp (3 resets)
	Duel.RegisterEffect(e1,tp)
	-- normal summon lock
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit(code_locked))
	e2:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e2,tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 then
    Duel.ConfirmDecktop(tp,4)  -- reveals top 4 cards
    local g=Duel.GetDecktopGroup(tp,4)  -- get them as a group
    Duel.SortDecktop(tp,tp,4)  -- lets you rearrange them
end
end

-- Limit function (returns true to block monsters whose code != allowed_code)
function s.splimit(code)
	return	function(e,c)
				return c and c:GetCode()~=code
			end
end




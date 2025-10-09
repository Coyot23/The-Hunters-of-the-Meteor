--THE WORLD REVOLVING
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x13)
	--synchro summon
	c:AddMustBeSpecialSummoned()
	c:EnableReviveLimit()
	--special summon
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SPSUMMON_PROC)
	e10:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e10:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e10)
	--Cannot be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.chaosed)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--unaffectable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(s.econ)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--Register that this card was in face-up Attack Position when it was targeted for an attack
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4a:SetCode(EVENT_BE_BATTLE_TARGET)
	e4a:SetOperation(s.regop)
	c:RegisterEffect(e4a)
	--no battle damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e4:SetCondition(s.damcon)
	c:RegisterEffect(e4)
	--enemy monster can't be destroyed by battle
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(s.damcon)
	e5:SetTarget(s.indestg)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--atkdown
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.atkcon)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)
	--counter
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,0))
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.cond1)
	e7:SetOperation(s.opd1)
	c:RegisterEffect(e7)
	--remove counter with die
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,1))
	e8:SetCategory(CATEGORY_DICE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(s.sccon)
--	e8:SetTarget(s.sctg)
	e8:SetOperation(s.scop)
	c:RegisterEffect(e8)
	--Activate 1 of these effects
	--gain 4000
	local e9a=Effect.CreateEffect(c)
	e9a:SetDescription(aux.Stringid(id,2))
	e9a:SetType(EFFECT_TYPE_IGNITION)
	e9a:SetCategory(CATEGORY_RECOVER)
	e9a:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e9a:SetRange(LOCATION_MZONE)
	e9a:SetCountLimit(1)
	e9a:SetCondition(s.eff1con)
	e9a:SetCost(Cost.PayLP(2000))
	e9a:SetTarget(s.eff1tg)
	e9a:SetOperation(s.eff1op)
	c:RegisterEffect(e9a)
--	shield and sword doesn't trigger
	local e9b=Effect.CreateEffect(c)
	e9b:SetDescription(aux.Stringid(id,3))
	e9b:SetType(EFFECT_TYPE_IGNITION)
	e9b:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e9b:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e9b:SetRange(LOCATION_MZONE)
	e9b:SetCountLimit(1)
	e9b:SetCondition(s.eff2con)
	e9b:SetCost(Cost.PayLP(2000))
	e9b:SetTarget(s.eff2tg)
	e9b:SetOperation(s.eff2op)
	c:RegisterEffect(e9b)
--  mix-up
	local e9c=Effect.CreateEffect(c)
	e9c:SetDescription(aux.Stringid(id,4))
	e9c:SetType(EFFECT_TYPE_IGNITION)
	e9c:SetCategory(CATEGORY_DESTROY)
	e9c:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e9c:SetRange(LOCATION_MZONE)
	e9c:SetCountLimit(1)
	e9c:SetCondition(s.eff3con)
	e9c:SetCost(Cost.PayLP(2000))
	e9c:SetTarget(s.eff3tg)
	e9c:SetOperation(s.eff3op)
	c:RegisterEffect(e9c)
--	Blanket negate
	local e9d=Effect.CreateEffect(c)
	e9d:SetDescription(aux.Stringid(id,5))
	e9d:SetType(EFFECT_TYPE_IGNITION)
	e9d:SetCategory(CATEGORY_DISABLE)
	e9d:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e9d:SetRange(LOCATION_MZONE)
	e9d:SetCountLimit(1)
	e9d:SetCondition(s.eff4con)
	e9d:SetCost(Cost.PayLP(2000))
	e9d:SetTarget(s.eff4tg)
	e9d:SetOperation(s.eff4op)
	c:RegisterEffect(e9d)
--	both target return bugged (asks to special summon to the opp field which is wrong, and doesn't summon anywya)
	local e9e=Effect.CreateEffect(c)
	e9e:SetDescription(aux.Stringid(id,6))
	e9e:SetType(EFFECT_TYPE_IGNITION)
	e9e:SetCategory(CATEGORY_TOHAND)
	e9e:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e9e:SetRange(LOCATION_MZONE)
	e9e:SetCountLimit(1)
	e9e:SetCondition(s.eff5con)
	e9e:SetCost(Cost.PayLP(2000))
	e9e:SetTarget(s.eff5tg)
	e9e:SetOperation(s.eff5op)
	c:RegisterEffect(e9e)
--	both discard 2
	local e9f=Effect.CreateEffect(c)
	e9f:SetDescription(aux.Stringid(id,7))
	e9f:SetType(EFFECT_TYPE_IGNITION)
	e9f:SetCategory(CATEGORY_HANDES)
	e9f:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e9f:SetRange(LOCATION_MZONE)
	e9f:SetCountLimit(1)
	e9f:SetCondition(s.eff6con)
	e9f:SetCost(Cost.PayLP(2000))
	e9f:SetTarget(s.eff6tg)
	e9f:SetOperation(s.eff6op)
	c:RegisterEffect(e9f)
--	gain 8000
	local e9g=Effect.CreateEffect(c)
	e9g:SetDescription(aux.Stringid(id,8))
	e9g:SetType(EFFECT_TYPE_IGNITION)
	e9g:SetCategory(CATEGORY_RECOVER)
	e9g:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e9g:SetRange(LOCATION_MZONE)
	e9g:SetCountLimit(1)
	e9g:SetCondition(s.eff7con)
	e9g:SetCost(Cost.PayLP(2000))
	e9g:SetTarget(s.eff7tg)
	e9g:SetOperation(s.eff7op)
	c:RegisterEffect(e9g)
	--final chaos
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,11))
	e10:SetCategory(CATEGORY_TODECK)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTarget(s.target)
	e10:SetOperation(s.operation)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,10))
	e11:SetCategory(CATEGORY_REMOVE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetOperation(s.rmop)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,9))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetTarget(s.sptg)
	e12:SetOperation(s.spop)
	c:RegisterEffect(e12)
end
s.counter_place_list={0x13}
function s.chaosed(e)
	local c=e:GetHandler()
	return not c:HasFlagEffect(id+1)
end
function s.econ(e)
	local c=e:GetHandler()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and not c:HasFlagEffect(id+1)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.regop(e)
	local c=e:GetHandler()
	if c==Duel.GetAttackTarget() and c:IsPosition(POS_FACEUP_ATTACK) then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE,0,1)
	else
		c:ResetFlagEffect(id)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:HasFlagEffect(id) and c==Duel.GetAttackTarget()
end
function s.indestg(e,c)
	local handler=e:GetHandler()
	return c==handler:GetBattleTarget()
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local c=e:GetHandler()
	return a and a:IsRelateToBattle() and a:IsControler(1-tp) and c:HasFlagEffect(id) and c==Duel.GetAttackTarget()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=Duel.GetAttacker():GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-atk)
--	e1:SetReset(RESETS_STANDARD_PHASE_END)
	c:RegisterEffect(e1)
	end
function s.cond1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsDisabled()
end
function s.opd1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x13,1)
	end
end
function s.sccon(e)
	return e:GetHandler():GetCounter(0x13)==7
end
--function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
--	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
--end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dc=Duel.TossDice(tp,1)
	if c:IsCanRemoveCounter(tp,0x13,dc,REASON_EFFECT) then
		c:RemoveCounter(tp,0x13,dc,REASON_EFFECT)
	end
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if c:IsCanRemoveCounter(tp,0x47,1,REASON_EFFECT) then
			c:RemoveCounter(tp,0x47,1,REASON_EFFECT)
		else
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
--- BEGINNING OF THE MULTI EFFECTS
--	gain 4000 LP
function s.eff1con(e)
	return e:GetHandler():GetCounter(0x13)==1
end
function s.eff1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,4000)
end
function s.eff1op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
--	swap all monster's atk and def
function s.eff2con(e)
	return e:GetHandler():GetCounter(0x13)==2
end
function s.filter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function s.eff2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function s.eff2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
--	destroy a monster you control
function s.eff3con(e)
	return e:GetHandler():GetCounter(0x13)==3
end
function s.eff3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.eff3op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--	negate all the effects of all cards on the field
function s.eff4con(e)
	return e:GetHandler():GetCounter(0x13)==4
end
function s.eff4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function s.eff4op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
--	both players return a card from the GY to the hand
function s.eff5con(e)
	return e:GetHandler():GetCounter(0x13)==5
end
function s.eff5tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local oc=nil
	if Duel.IsExistingTarget(Card.IsAbleToHand,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(102380,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
		local og=Duel.SelectTarget(1-tp,Card.IsAbleToHand,1-tp,LOCATION_GRAVE,0,1,1,nil,e,1-tp)
		oc=og:GetFirst()
	end
	local sc=sg:GetFirst()
	if oc~=nil then
		sg:AddCard(oc)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,#sg==1 and tp or PLAYER_ALL,sc:GetOwner())
	e:SetLabelObject(sc)
end
function s.eff5op(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local oc=g:GetFirst()
	if oc and oc==sc then oc=g:GetNext() end
	if sc and sc:IsRelateToEffect(e) then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
	end
	if oc and oc:IsRelateToEffect(e) then
		Duel.SendtoHand(oc,nil,REASON_EFFECT)
	end
end
--	both players discard 2 cards
function s.eff6con(e)
	return e:GetHandler():GetCounter(0x13)==6
end
function s.eff6tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,2)
end
function s.eff6op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleHand(tp)
	Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD)
	Duel.ShuffleHand(1-tp)
	Duel.DiscardHand(1-tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD)
	end
--	gain 8000 LP
function s.eff7con(e)
	return e:GetHandler():GetCounter(0x13)==7
end
function s.eff7tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(8000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,8000)
end
function s.eff7op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
--final chaos
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND|LOCATION_GRAVE,LOCATION_HAND|LOCATION_GRAVE)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND|LOCATION_GRAVE,LOCATION_HAND|LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND|LOCATION_GRAVE,LOCATION_HAND|LOCATION_GRAVE)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,LOCATION_DECK,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,90884404,0,TYPES_TOKEN,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,90884404,0,TYPES_TOKEN,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local ct=0
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		for i=1,ft do
			local token=Duel.CreateToken(tp,90884404)
			if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK) then ct=1 end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(s.val)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UNRELEASABLE_SUM)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCountLimit(1)
			e3:SetOperation(s.mtop)
			token:RegisterEffect(e3)
		end
	end
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft2>0 then
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
			if ct>0 then Duel.SpecialSummonComplete() return end
			ft2=1
		end
		for i=1,ft2 do
			local token=Duel.CreateToken(tp,90884404)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(s.val2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UNRELEASABLE_SUM)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCountLimit(1)
			e3:SetOperation(s.mtop)
			token:RegisterEffect(e3)
		end
	end
	Duel.SpecialSummonComplete()
	e:GetHandler():RegisterFlagEffect(id+1,RESETS_STANDARD_PHASE_END,0,1)
	--Create a global draw-prevention effect
	local e10=Effect.CreateEffect(e:GetHandler())
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_DRAW)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetTargetRange(1,1) -- both players
	e10:SetReset(RESET_DISABLE) -- this means it will NOT reset until duel ends or manually disabled
	Duel.RegisterEffect(e10,tp)
	--(optional) prevent future "draw" attempts entirely
	local e20=Effect.CreateEffect(e:GetHandler())
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_DRAW_COUNT)
	e20:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e20:SetTargetRange(1,1)
	e20:SetValue(0)
	e20:SetReset(RESET_DISABLE)
	Duel.RegisterEffect(e20,tp)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function s.val(e,c)
	return math.floor(Duel.GetLP(1-e:GetHandlerPlayer()))
end
function s.val2(e,c)
	return math.floor(Duel.GetLP(e:GetHandlerPlayer())/2)

end

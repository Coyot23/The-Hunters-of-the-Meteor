--Mission Tools
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
function s.revealmon(c) 
    return c:IsMonster() and not c:IsPublic() 
end
function s.revealst(c,e,tp)
    -- only allow revealing a Spell if there is a Trap in deck, or revealing a Trap if there is a Spell in deck
    if c:IsPublic() then return false end
    if c:IsSpell() then
        return Duel.IsExistingMatchingCard(Card.IsTrap,tp,LOCATION_DECK,0,1,nil)
    elseif c:IsTrap() then
        return Duel.IsExistingMatchingCard(Card.IsSpell,tp,LOCATION_DECK,0,1,nil)
    end
    return false
end
function s.thfilter(c,typ)
    return ((typ==TYPE_SPELL and c:IsTrap()) or (typ==TYPE_TRAP and c:IsSpell()))
        and c:IsAbleToHand()
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
    -- Case 1: Reveal Monster + Spell, search Trap
    local case1 = Duel.IsExistingMatchingCard(s.revealmon,tp,LOCATION_HAND,0,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsSpell,tp,LOCATION_HAND,0,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsTrap,tp,LOCATION_DECK,0,1,nil)

    -- Case 2: Reveal Monster + Trap, search Spell
    local case2 = Duel.IsExistingMatchingCard(s.revealmon,tp,LOCATION_HAND,0,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsTrap,tp,LOCATION_HAND,0,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsSpell,tp,LOCATION_DECK,0,1,nil)
	return case1 or case2
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(ep,id,0,0,0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g1=Duel.SelectMatchingCard(tp,s.revealmon,tp,LOCATION_HAND,0,1,1,nil)
    if #g1==0 then return end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,function(c) return s.revealst(c,e,tp) end,tp,LOCATION_HAND,0,1,1,nil)

    if #g2==0 then return end

    g1:Merge(g2)
    Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
    local typ=0
    if g2:GetFirst():IsSpell() then typ=TYPE_SPELL else typ=TYPE_TRAP end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,typ)
    if #sg>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
    end
end


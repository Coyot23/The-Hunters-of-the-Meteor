--Cyber Production Line
local s,id=GetID()
function s.initial_effect(c)
    aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end

-- target filter: the named card that "unlocks" the effect
function s.unlockfilter(c)
    return c:IsFaceup() and c:IsCode(70095154) -- replace with the named card’s code
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
    -- once per duel check
    if Duel.GetFlagEffect(ep,id)>0 then return false end
    -- must control the unlock card
    return Duel.IsExistingMatchingCard(s.unlockfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
    Duel.Hint(HINT_CARD,tp,id)
    Duel.RegisterFlagEffect(tp,id,0,0,0)

    local code=70095154 -- replace with the code of the card you want to generate
    local c1=Duel.CreateToken(tp,code)
    local c2=Duel.CreateToken(tp,code)
    local c3=Duel.CreateToken(tp,code)

    -- add one to hand
    Duel.SendtoHand(c1,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,c1)

    -- shuffle one into Deck
    Duel.SendtoDeck(c2,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)

    -- send one to GY
    Duel.SendtoGrave(c3,REASON_EFFECT)
end

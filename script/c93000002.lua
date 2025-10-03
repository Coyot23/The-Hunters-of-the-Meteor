--Parasite Swarm
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
--filter for special summoned from the extra deck
function s.cfilter(c)
	return c:IsSpecialSummoned() and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.CheckLPCost(tp,2000)
end
--the actual effect
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.PayLPCost(tp,2000)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tgfilter),tp,0x13,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
s.listed_names={6205579}
function s.tgfilter(c,e,tp)
	return c:IsCode(6205579) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end


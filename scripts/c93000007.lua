--Superior Dark
local s,id=GetID()
function s.initial_effect(c)
	aux.AddFieldSkillProcedure(c,2,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change Attribute to DARK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE|LOCATION_GRAVE,0)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetTarget(s.tg)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--Place 1 monster in the Spell/Trap Zone as a Continuous Spell
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(Cost.PayLP(1500))
	e3:SetTarget(s.pltg)
	e3:SetOperation(s.plop)
	c:RegisterEffect(e3)
	--Change Name
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(12644061)
	c:RegisterEffect(e4)
end
function s.tg(e,c)
	if c:GetFlagEffect(1)==0 then
		c:RegisterFlagEffect(1,0,0,0)
		local eff
		if c:IsLocation(LOCATION_MZONE) then
			eff={Duel.GetPlayerEffect(c:GetControler(),EFFECT_NECRO_VALLEY)}
		else
			eff={c:GetCardEffect(EFFECT_NECRO_VALLEY)}
		end
		c:ResetFlagEffect(1)
		for _,te in ipairs(eff) do
			local op=te:GetOperation()
			if not op or op(e,c) then return false end
		end
	end
	return true
end
function s.hplfilter(c,tp)
	return c:IsMonster() and c:IsSetCard(SET_CRYSTAL_BEAST) and not c:IsForbidden()
end
function s.validHandFilter(c,e,tp)
    if not s.hplfilter(c,tp) then return false end
    local atk,def=c:GetAttack(),c:GetDefense()
    return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,atk,def,e,tp)
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- Must have room in S/T Zone
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		-- Check hand monsters
		local g=Duel.GetMatchingGroup(s.validHandFilter,tp,LOCATION_HAND,0,nil,e,tp)
		for hc in g:Iter() do
			local atk,def=hc:GetAttack(),hc:GetDefense()
			if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,atk,def,e,tp) then
				return true
			end
		end
		return false
	end
end
function s.spfilter(c,atk,def,e,tp)
	return c:IsMonster() and c:IsSetCard(SET_CRYSTAL_BEAST) and c:GetAttack()==atk and c:GetDefense()==def and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsForbidden()
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local hc=Duel.SelectMatchingCard(tp,s.validHandFilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		Duel.MoveToField(hc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local atk,def=hc:GetAttack(),hc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		hc:RegisterEffect(e1)
		Duel.RaiseEvent(hc,EVENT_CUSTOM+CARD_CRYSTAL_TREE,e,0,tp,0,0)
	local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,atk,def,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

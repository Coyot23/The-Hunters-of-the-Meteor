--Perfectly Balanced
local s,id=GetID()
function s.initial_effect(c)
	aux.AddFieldSkillProcedure(c,2,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--avoid damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(s.damval)
	c:RegisterEffect(e2)
	--ATK increase
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)
	e6:SetCost(s.lpcost)
	e6:SetTarget(s.lptg)
	e6:SetOperation(s.lpop)
	c:RegisterEffect(e6)
end
function s.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsAbleToEnterBP() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(1-tp)>1 and Duel.GetLP(tp)>1 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetPlayer(tp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,1)
	Duel.SetLP(tp,1)
end
function s.damval(e,re,val,r,rp,rc)
	if val<=800000 and r&REASON_EFFECT==REASON_EFFECT then return 0 else return val end
end
--机巧辰-高暗御津羽靇
--Scripted by: shizuru
function c101101032.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101101032)
	e1:SetCondition(c101101032.spcon)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101101032,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c101101032.descost)
	e2:SetTarget(c101101032.destg)
	e2:SetOperation(c101101032.desop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101101032,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,101101032+100)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c101101032.recon)
	e3:SetTarget(c101101032.retg)
	e3:SetOperation(c101101032.reop)
	c:RegisterEffect(e3)
end
function c101101032.spfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA 
end
function c101101032.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101101032.spfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function c101101032.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c101101032.desfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA 
end
function c101101032.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101101032.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c101101032.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c101101032.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c101101032.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	local c=e:GetHandler()
	--check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c101101032.checkop)
	Duel.RegisterEffect(e1,tp)
	--cannot announce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c101101032.ancon)
	Duel.RegisterEffect(e2,tp)
end
function c101101032.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,101101032)~=0 then return end
	Duel.RegisterFlagEffect(tp,101101032,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c101101032.ancon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101101032)>0
end
function c101101032.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp
end
function c101101032.filter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c101101032.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() and chkc:IsType(TYPE_MONSTER) and c:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101101032.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_GRAVE)
end
function c101101032.reop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101101032.filter,tp,0,LOCATION_GRAVE,nil)
	if not g then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local atk=tc:GetTextAttack()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and atk>0 then
		  Duel.Recover(tp,atk,REASON_EFFECT)
	end
end

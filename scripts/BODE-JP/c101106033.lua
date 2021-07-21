--不屈の獣僕
--
--scripted by KillerDJ
function c101106033.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106033,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,101106033)
	e1:SetCondition(c101106033.spcon)
	e1:SetTarget(c101106033.sptg)
	e1:SetOperation(c101106033.spop)
	c:RegisterEffect(e1)
	if not c101106033.global_check then
		c101106033.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c101106033.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
	--ind
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c101106033.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c101106033.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),101106033,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c101106033.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,101106033)>=3 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c101106033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101106033.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101106033.indcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)<=1 and e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end

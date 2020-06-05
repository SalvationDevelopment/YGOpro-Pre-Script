--Toon Harpie Lady
--Ejeffers1239

function c100268002.initial_effect(c)

--summon

local e1=Effect.CreateEffect(c)

	e1:SetDescription(aux.Stringid(100268002,0))

	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)

	e1:SetType(EFFECT_TYPE_IGNITION)

	e1:SetRange(LOCATION_HAND)

	e1:SetCountLimit(1,100268002)

	e1:SetCondition(c100268002.spcon1)

	e1:SetTarget(c100268002.sptg1)

	e1:SetOperation(c100268002.spop1)

	c:RegisterEffect(e1)
	
	--cannot attack

	local e2=Effect.CreateEffect(c)

	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	 
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	 
	e2:SetOperation(c100268002.atklimit)

	c:RegisterEffect(e2)

	local e3=e2:Clone()

	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)

	c:RegisterEffect(e3)

	local e4=e2:Clone()

	e4:SetCode(EVENT_SPSUMMON_SUCCESS)

	c:RegisterEffect(e4)

	--direct attack

	local e5=Effect.CreateEffect(c)

	e5:SetType(EFFECT_TYPE_SINGLE)

	e5:SetCode(EFFECT_DIRECT_ATTACK)

	e5:SetCondition(c100268002.dircon)

	c:RegisterEffect(e5)

end

	function c100268002.cfilter(c)

	return c:IsFaceup() and c:IsCode(15259703)

end

function c100268002.cfilter2(c)

	return c:IsFaceup() and c:IsType(TYPE_TOON)

end
	
function c100268002.atklimit(e,tp,eg,ep,ev,re,r,rp)

	local e2=Effect.CreateEffect(e:GetHandler())

	e2:SetType(EFFECT_TYPE_SINGLE)
	 
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	 
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)

	e:GetHandler():RegisterEffect(e2)

end

function c100268002.dircon(e)

	local tp=e:GetHandlerPlayer()

	return Duel.IsExistingMatchingCard(c100268002.cfilter,tp,LOCATION_ONFIELD,0,1,nil)

		and not Duel.IsExistingMatchingCard(c100268002.cfilter2,tp,0,LOCATION_MZONE,1,nil)

end

function c100268002.spcon1(e,tp,eg,ep,ev,re,r,rp)

	return Duel.IsExistingMatchingCard(c100268002.cfilter,tp,LOCATION_ONFIELD,0,1,nil)

end

function c100268002.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0

		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)

end

function c100268002.spop1(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

	if not c:IsRelateToEffect(e) then return end

	 if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	 
		local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)

        if Duel.IsExistingMatchingCard(c100268002.cfilter2,tp,LOCATION_ONFIELD,0,1,c)

        and Duel.SelectYesNo(tp,aux.Stringid(100268002,0)) then
    
        Duel.BreakEffect()

        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)

        local sg=g:Select(tp,1,1,nil)

        Duel.HintSelection(sg)

        Duel.Destroy(sg,REASON_EFFECT)

    end

end

end


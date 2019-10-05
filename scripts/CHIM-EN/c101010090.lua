--Dream Mirror Hypnagogia

--Scripted by mallu11
function c101010090.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101010090+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101010090.target)
	e1:SetOperation(c101010090.activate)
	c:RegisterEffect(e1)
end
function c101010090.cfilter1(c,tp)
	return c:IsCode(74665651) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.IsExistingMatchingCard(c101010090.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,c)
end
function c101010090.cfilter2(c,tp)
	return c:IsCode(1050355) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c101010090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010090.cfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function c101010090.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c101010090.cfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	local g2=Duel.GetMatchingGroup(c101010090.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	if g1:GetCount()<=0 or g2:GetCount()<=0 then return end
	local g=g1:Clone()
	g:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010090,0))
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010090,1))
	local tg2=g:Select(tp,1,1,nil)
	Duel.MoveToField(tg1:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.MoveToField(tg2:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
end

--スタンド・イン
--
--Scripted By-ღ Viola
function c101008066.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(1,101008066+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c101008066.cost)
	e1:SetTarget(c101008066.target)
	e1:SetOperation(c101008066.activate)
	c:RegisterEffect(e1)
--
end
--
function c101008066.cfilter(c,e,tp)
	local rc=c:GetOriginalRace()
	local att=c:GetOriginalAttribute()
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c101008066.spfilter,tp,0,LOCATION_GRAVE,1,nil,rc,att,e,tp)
end
function c101008066.spfilter(c,rc,att,e,tp)
	return c:IsRace(rc) and c:IsAttribute(att)
		and c:IsCanBeEffectTarget(e)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
--
function c101008066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c101008066.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
--
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c101008066.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabelObject(sg:GetFirst())
	Duel.Release(sg,REASON_COST)
--
end
--
function c101008066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
--
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c101008066.spfilter(chkc,e:GetLabelObject():GetOriginalRace(),e:GetLabelObject():GetOriginalAttribute(),e,tp) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetMZoneCount(tp,e:GetLabelObject(),tp)>0
	end
	e:SetLabel(0)
--
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c101008066.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e:GetLabelObject():GetOriginalRace(),e:GetLabelObject():GetOriginalAttribute(),e,tp)
--
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
--
function c101008066.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
--

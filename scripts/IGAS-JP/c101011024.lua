--機巧蹄－天迦久御雷

--Scripted by mallu11
function c101011024.initial_effect(c)
	-spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101011024,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101011024)
	e1:SetCondition(c101011024.spcon1)
	e1:SetTarget(c101011024.sptg1)
	e1:SetOperation(c101011024.spop1)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101011024,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101011124)
	e2:SetCondition(c101011024.eqcon)
	e2:SetTarget(c101011024.eqtg)
	e2:SetOperation(c101011024.eqop)
	c:RegisterEffect(e2)
	--spsummon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101011024,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1,101011224)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c101011024.sptg2)
	e3:SetOperation(c101011024.spop2)
	c:RegisterEffect(e3)
end
function c101011024.cfilter(c)
	return c:GetSequence()>4
end
function c101011024.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c101011024.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>0
end
function c101011024.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101011024.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101011024.eqfilter(c,tp)
	return c:IsFaceup() and c:GetSequence()>4 and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c101011024.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	return ec==nil or ec:GetFlagEffect(101011024)==0
end
function c101011024.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101011024.eqfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c101011024.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101011024.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c101011024.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsControler(tp) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			if tc:IsControler(1-tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then 
				Duel.Destroy(tc,REASON_RULE)
				return
			end
			if not Duel.Equip(tp,tc,c,false) then return end
			tc:RegisterFlagEffect(101011024,RESET_EVENT+RESETS_STANDARD,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c101011024.eqlimit)
			tc:RegisterEffect(e1)
		else Duel.SendtoGrave(tc,REASON_RULE) end
	end
end
function c101011024.eqlimit(e,c)
	return e:GetOwner()==c
end
function c101011024.spfilter(c,e,tp)
	return c:GetEquipTarget()==e:GetHandler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101011024.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101011024.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c101011024.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101011024.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

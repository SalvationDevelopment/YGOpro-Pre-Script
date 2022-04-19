--分かつ烙印
--
--Script by Trishula9
function c101109070.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101109070+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101109070.cost)
	e1:SetTarget(c101109070.target)
	e1:SetOperation(c101109070.activate)
	c:RegisterEffect(e1)
end
function c101109070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c101109070.rfilter1(c,tp)
	return c:IsType(TYPE_FUSION) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c)>0
end
function c101109070.rfilter2(c,tp)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.GetMZoneCount(tp,c)>1
end
function c101109070.spfilter1(c,e,tp)
	return not c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101109070.spfilter2(c,e,tp)
	return not c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101109070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local b1=ft>0 and Duel.CheckReleaseGroup(tp,c101109070.rfilter1,1,nil,tp)
		and Duel.IsExistingTarget(c101109070.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,2,nil,e,tp)
	local b2=ft==0 and Duel.CheckReleaseGroup(tp,c101109070.rfilter2,1,nil,tp)
		and Duel.IsExistingTarget(c101109070.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,2,nil,e,tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c101109070.spfilter1(chkc,e,tp) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) and (b1 or b2)
	end
	e:SetLabel(0)
	if b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectReleaseGroup(tp,c101109070.rfilter2,1,1,nil,tp)
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		Duel.Release(g,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectTarget(tp,c101109070.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,2,2,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,2,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectReleaseGroup(tp,c101109070.rfilter1,1,1,nil,tp)
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		Duel.Release(g,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectTarget(tp,c101109070.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,2,2,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,2,0,0)
	end
end
function c101109070.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local b=aux.IsMaterialListCode(e:GetLabelObject(),68468459)
	if ft1<=0 and ft2<=0 then return end
	if g:GetCount()<=0 then return end
	if g:GetCount()==1 then
		if ft1>0 and ft2==0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		elseif ft1==0 and ft2>0 then
			Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
		else
			local tc=g:GetFirst()
			local s1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			local s2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
			local op=0
			Duel.Hint(HINT_SELECTMSG,tp,0)
			if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(101109070,0),aux.Stringid(101109070,1))
			elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(101109070,0))
			elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(101109070,1))+1
			else return end
			if op==0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP) end
		end
	end
	if g:GetCount()==2 then
		if b and ft1>1 and g:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)==2
			and Duel.SelectYesNo(tp,aux.Stringid(101109070,2)) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			if ft1>0 and ft2==0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101109070,3))
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			elseif ft1==0 and ft2>0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101109070,4))
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
			else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101109070,3))
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				Duel.SpecialSummon(g-sg,0,tp,1-tp,false,false,POS_FACEUP)
			end
		end
	end
end
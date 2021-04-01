--魔鍵－マフテア
--
--scripted by zerovoros a.k.a faultzone
function c101105056.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101105056.sptg)
	e1:SetOperation(c101105056.spop)
	c:RegisterEffect(e1)
end
function c101105056.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c101105056.fustg(e,tp,eg,ep,ev,re,r,rp,chk) or c101105056.rittg(e,tp,eg,ep,ev,re,r,rp,chk) end
end
function c101105056.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local fus=c101105056.fustg(e,tp,eg,ep,ev,re,r,rp,0)
	local rit=c101105056.rittg(e,tp,eg,ep,ev,re,r,rp,0)
	if fus or rit then
		local opt=0
		if fus and rit then
			opt=Duel.SelectOption(tp,aux.Stringid(101105056,0),aux.Stringid(101105056,1))
		elseif fus then
			opt=Duel.SelectOption(tp,aux.Stringid(101105056,0))
		else
			opt=Duel.SelectOption(tp,aux.Stringid(101105056,1))
		end
		if opt==0 then
			c101105056.fusop(e,tp,eg,ep,ev,re,r,rp)
		else
			c101105056.ritop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function c101105056.cfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_NORMAL)
end
function c101105056.fusfilter1(c,e,tp,m,f,chkf)
	return not c:IsImmuneToEffect(e)
end
function c101105056.fusfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x266) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c101105056.exfusfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c101105056.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c101105056.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c101105056.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
		if Duel.IsExistingMatchingCard(c101105056.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			local mg2=Duel.GetMatchingGroup(c101105056.exfusfilter,tp,LOCATION_DECK,0,nil,e)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				Auxiliary.FCheckAdditional=c101105056.fcheck
				Auxiliary.GCheckAdditional=c101105056.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c101105056.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		Auxiliary.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c101105056.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101105056.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c101105056.fusfilter1,nil,e)
	local exmat=false
	if Duel.IsExistingMatchingCard(c101105056.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		local mg2=Duel.GetMatchingGroup(c101105056.exfusfilter,tp,LOCATION_DECK,0,nil,e)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		Auxiliary.FCheckAdditional=c101105056.fcheck
		Auxiliary.GCheckAdditional=c101105056.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c101105056.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c101105056.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				Auxiliary.FCheckAdditional=c101105056.fcheck
				Auxiliary.GCheckAdditional=c101105056.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			Auxiliary.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c101105056.exritfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToGrave()
end
function c101105056.ritfilter(c)
	return c:IsSetCard(0x266)
end
function c101105056.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c101105056.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c101105056.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		if Duel.IsExistingMatchingCard(c101105056.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			local mg2=Duel.GetMatchingGroup(c101105056.exritfilter,tp,LOCATION_DECK,0,nil,e)
			if mg2:GetCount()>0 then
				mg:Merge(mg2)
			end
		end
		aux.RCheckAdditional=c101105056.rcheck
		aux.RGCheckAdditional=c101105056.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c101105056.ritfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101105056.ritop(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	if Duel.IsExistingMatchingCard(c101105056.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		local mg2=Duel.GetMatchingGroup(c101105056.exritfilter,tp,LOCATION_DECK,0,nil,e)
		if mg2:GetCount()>0 then
			m:Merge(mg2)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c101105056.rcheck
	aux.RGCheckAdditional=c101105056.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND,0,1,1,nil,c101105056.ritfilter,e,tp,m,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end

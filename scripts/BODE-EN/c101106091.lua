--Beetrooper Squad
--Scripted by: XGlitchy30
function c101106091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106091,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101106091+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101106091.cost)
	e1:SetTarget(c101106091.target)
	e1:SetOperation(c101106091.activate)
	c:RegisterEffect(e1)
end
function c101106091.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c101106091.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and c:IsRace(RACE_INSECT) and c:GetBaseAttack()>=1000
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c101106091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c101106091.cfilter,1,nil,tp)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,64213018,0x170,TYPES_TOKEN_MONSTER,1000,1000,3,RACE_INSECT,ATTRIBUTE_EARTH)
	end
	local g=Duel.SelectReleaseGroup(tp,c101106091.cfilter,1,1,nil,tp)
	local atk=g:GetFirst():GetBaseAttack()
	Duel.Release(g,REASON_COST)
	e:SetLabel(math.floor(atk/1000))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c101106091.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,64213018,0x170,TYPES_TOKEN_MONSTER,1000,1000,3,RACE_INSECT,ATTRIBUTE_EARTH) then return end
	local ct=(Duel.IsPlayerAffectedByEffect(tp,59822133)) and 1 or math.min(ft,e:GetLabel())
	local range={}
	for i=1,ct do
		table.insert(range,i)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101106091,1))
	local n=Duel.AnnounceNumber(tp,table.unpack(range)) 
	local sg=Group.CreateGroup()
	for i=1,n do
		local token=Duel.CreateToken(tp,101106091+100)
		sg:AddCard(token)
	end
	if #sg<=0 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end

--蟲の忍者－蜜
--Insect Ninja Mitsu
--Script by Lyris12
local s,id,o=GetID()
function s.initial_effect(c)
	--You can only use each effect of "Insect Ninja Mitsu" once per turn.
	--If you control a "Ninja" card or a face-down Defense Position monster: You can Special Summon this card from your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--When your opponent activates a monster effect (Quick Effect): You can target 1 face-down Defense Position monster you control; change it to face-up Defense Position, and if you do, change this card to face-down Defense Position, then, if the targeted monster was a "Ninja" monster, except "Insect Ninja Mitsu", negate that opponent's activated effect.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2b) or c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain(0) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsPosition(POS_FACEDOWN_DEFENSE) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEDOWN_DEFENSE)
		and c:IsCanTurnSet() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,Duel.SelectTarget(tp,Card.IsPosition,tp,LOCATION_MZONE,0,1,1,nil,POS_FACEDOWN_DEFENSE)+c,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToChain(0) and tc:IsLocation(LOCATION_MZONE) and tc:IsFacedown()
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)>0) then return end
	local c=e:GetHandler()
	if c:IsRelateToChain(0) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)>0 and tc:IsSetCard(0x2b) and not tc:IsCode(id) then
		Duel.BreakEffect()
		Duel.NegateEffect(ev)
	end
end

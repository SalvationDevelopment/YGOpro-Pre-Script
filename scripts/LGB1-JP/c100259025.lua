--FNo.0 未来龍皇ホープ

--Scripted by mallu11
function c100259025.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c100259025.mfilter,c100259025.xyzcheck,3,3,c100259025.ovfilter,aux.Stringid(100259025,0))
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100259025,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100259025.discon)
	e3:SetCost(c100259025.discost)
	e3:SetTarget(c100259025.distg)
	e3:SetOperation(c100259025.disop)
	c:RegisterEffect(e3)
end
c100259025.xyz_number=0
function c100259025.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and not c:IsSetCard(0x48)
end
function c100259025.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c100259025.ovfilter(c)
	return c:IsFaceup() and c:IsCode(65305468)
end
function c100259025.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsHasType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function c100259025.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100259025.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and re:GetHandler():IsRelateToEffect(re)
		and not re:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		local cat=e:GetCategory()
		e:SetCategory(bit.bor(cat,CATEGORY_CONTROL))
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
	end
end
function c100259025.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:GetHandler():IsRelateToEffect(re) and not re:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:GetHandler():IsAbleToChangeControler() and Duel.SelectYesNo(tp,aux.Stringid(100259025,2)) then
		Duel.GetControl(re:GetHandler(),tp)
	end
end

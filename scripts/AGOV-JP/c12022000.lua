--装甲超量要塞
function c12022000.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c12022000.ovfilter,aux.Stringid(12022000,0),2,c12022000.xyzop)
	c:EnableReviveLimit()
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c12022000.xyzcondition)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12022000,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c12022000.thcost)
	e2:SetTarget(c12022000.thtg)
	e2:SetOperation(c12022000.thop)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetCondition(c12022000.damcon)
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e3)
end

function c12022000.damcon(e)
	return e:GetHandler():GetEquipTarget():GetBattleTarget()~=nil
end

function c12022000.ovfilter(c)
	return c:IsFaceup() and (c:IsRank(3) or c:IsRank(4))
end
function c12022000.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,12022000)==0 end
	Duel.RegisterFlagEffect(tp,12022000,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function c12022000.xyzcondition(e)
	return e:GetHandler():GetOverlayCount() > 0
end

function c12022000.thfilter(c)
	return c:IsSetCard(0x4073) and c:IsAbleToHand()
end
function c12022000.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local ct=0
	local g=Duel.GetMatchingGroup(c12022000.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)==0 then return false end
	if g:GetClassCount(Card.GetCode)>=2 then
		ct=e:GetHandler():RemoveOverlayCard(tp,1,2,REASON_COST)
	else
		ct=e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
	e:SetLabel(ct)
end
function c12022000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12022000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function c12022000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ct=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c12022000.thfilter,tp,LOCATION_DECK,0,ct,ct,nil)
	if g:GetCount()>0 and g:GetClassCount(Card.GetCode)>=ct then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


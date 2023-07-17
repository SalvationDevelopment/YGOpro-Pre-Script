--重铠装-暗黑骑士枪兵
function c12023000.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,c12023000.ovfilter,aux.Stringid(12023000,0),7,c12023000.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c12023000.atkval)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c12023000.thtg)
	e2:SetOperation(c12023000.thop)
	c:RegisterEffect(e2)
	--overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12023000,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c12023000.ovtg)
	e3:SetOperation(c12023000.ovop)
	c:RegisterEffect(e3)
end

function c12023000.ovfilter(c)
	return c:IsFaceup() and (c:IsRank(5) or c:IsRank(6))
end
function c12023000.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,12023000)==0 end
	Duel.RegisterFlagEffect(tp,12023000,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function c12023000.atkval(e,c)
	return (c:GetOverlayCount()+c:GetEquipCount())*300
end

function c12023000.thfilter(c)
	return c:IsSetCard(0x73) and c:IsAbleToHand()
end
function c12023000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12023000.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12023000.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c12023000.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12023000.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c12023000.ovfilter2(c)
	return c:IsCanOverlay()
end
function c12023000.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c12023000.ovfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c12023000.ovfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
end

function c12023000.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c12023000.ovfilter2,tp,0,LOCATION_MZONE,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		Duel.Overlay(c,Group.FromCards(tc))
	end
end


--Pegasus Wing
--
--Scripted by 龙骑
function c101008090.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101008090,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c101008090.dacon)
	e1:SetTarget(c101008090.datg)
	e1:SetOperation(c101008090.daop)
	c:RegisterEffect(e1)	
end
function c101008090.cfilter(c)
	return c:IsType(TYPE_UNION)
end
function c101008090.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101008090.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsAbleToEnterBP()
end
function c101008090.filter(c)
	return c:IsSetCard(0x122) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c101008090.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c101008090.filter,tp,LOCATION_MZONE,0,1,nil) end
	local ft=Duel.GetMatchingGroupCount(c101008090.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101008090.filter,tp,LOCATION_MZONE,0,1,ft,nil)
end
function c101008090.dafilter(c,e)
	return c:IsSetCard(0x122) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK) and c:IsRelateToEffect(e)
end
function c101008090.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c101008090.dafilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetCondition(c101008090.rdcon)
		e2:SetOperation(c101008090.rdop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(101008090,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end
function c101008090.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and c:GetFlagEffect(101008090)>0
end
function c101008090.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
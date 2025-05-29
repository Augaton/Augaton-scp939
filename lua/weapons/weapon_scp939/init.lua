AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local scp939 = guthscp.modules.scp939
local config939 = guthscp.configs.scp939
scp939 = scp939 or {}

function SWEP:Deploy() self:SetHoldType( "normal" ) end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    owner:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("")

    local attackRange = config939.attack_range
    local attackAngle = math.cos(math.rad(60)) -- cône de 120° au total (60° de chaque côté)

    local shootPos = owner:GetShootPos()
    local aimDir = owner:GetAimVector()

    for _, ent in ipairs(ents.FindInSphere(shootPos, attackRange)) do
        if ent:IsPlayer() or ent:IsNPC() then
            if ent == owner or not ent:Alive() then continue end

            local dirToEnt = (ent:GetPos() + ent:OBBCenter() - shootPos):GetNormalized()
            local dot = aimDir:Dot(dirToEnt)

            if dot >= attackAngle then
                local dmg = DamageInfo()
                dmg:SetDamage(math.random(config939.min_attack, config939.max_attack))
                dmg:SetAttacker(owner)
                dmg:SetInflictor(self)
                dmg:SetDamageType(DMG_SLASH)
                ent:TakeDamageInfo(dmg)
            end
        end
    end
end

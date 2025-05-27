AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Deploy() self:SetHoldType( "normal" ) end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 1)
	local trace = self.Owner:GetEyeTrace();
    local ent = trace.Entity
    self.Owner:SetAnimation( PLAYER_ATTACK1 );
    self.Weapon:EmitSound( "" )
    if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
    	bullet = {}
        bullet.Num    = 1
        bullet.Src    = self.Owner:GetShootPos()
        bullet.Dir    = self.Owner:GetAimVector()
        bullet.Spread = Vector(0, 0, 0)
        bullet.Tracer = 0
        bullet.Force  = 25
        bullet.Damage = math.random(30, 60)
        self.Owner:FireBullets(bullet)
    end

end
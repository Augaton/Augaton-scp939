AddCSLuaFile()
if not scp049 then scp049 = {} end
local scp939 = guthscp.modules.scp939
local config939 = guthscp.configs.scp939

SWEP.Category               = "GuthSCP"
SWEP.PrintName              = "SCP-939"        
SWEP.Author                 = "Matius"
SWEP.Instructions           = "Guthen SCP 939 !"
SWEP.ViewModelFOV           = 56
SWEP.Spawnable              = true
SWEP.AdminOnly              = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Delay          = 2
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "None"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "None"
SWEP.Weight                 = 3
SWEP.AutoSwitchTo           = false
SWEP.AutoSwitchFrom         = false
SWEP.Slot                   = 0
SWEP.SlotPos                = 4
SWEP.DrawAmmo               = false
SWEP.DrawCrosshair          = true
SWEP.droppable              = false
SWEP.Primary.Distance       = 200
SWEP.IdleAnim               = true
SWEP.ViewModel              = ""
SWEP.WorldModel             = ""
SWEP.IconLetter             = "w"
SWEP.Primary.Sound          = ("weapons/939/bite.wav")
SWEP.HoldType               = "normal"
local SwepOwner				= nil
local Voice = {"talk1.mp3", "talk2.mp3", "talk3.mp3", "talk4.mp3", "talk5.mp3"}

function SWEP:Deploy() self:SetHoldType( "normal" ) end


function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
    self:EmitSound('weapons/scp939/bite.wav')
end

// weapons/scp939/

SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()
	if not SERVER then return end

	local ply = self:GetOwner()
    -- Play random sound
    local sounds = config939.random_sound
    if #sounds == 0 then return end

    ply:EmitSound(sounds[math.random(#sounds)], nil, nil)

	self:SetNextSecondaryFire( CurTime() + 5.0 )
end

if CLIENT then
    guthscp.spawnmenu.add_weapon(SWEP, "SCP-939 SWEP")
end
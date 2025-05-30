AddCSLuaFile()
if not scp939 then scp939 = {} end
local scp939 = guthscp.modules.scp939
local config939 = guthscp.configs.scp939

local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0.1,
	["$pp_colour_contrast"] = 0.5,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0.2,
	["$pp_colour_mulb"] = 0.2
}


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
end

// weapons/scp939/

if SERVER then
    util.AddNetworkString("scp939_sound_detection")
end

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

function SWEP:Holster()
    local ply = self:GetOwner()
    if IsValid(ply) then
        ply.silent_step = false
    end
    return true
end

function SWEP:Initialize()
    self:SetHoldType("normal")
    self.NextSilentUse = 0
end

function SWEP:Reload()

    if not config939.scp939_silentability then return end

    local ply = self:GetOwner()

    if not self.NextSilentUse then return end
    if not IsValid(ply) then return end

    if self.NextSilentUse and CurTime() < self.NextSilentUse then
        return 
    end

    ply.silent_step = true
    self.NextSilentUse = CurTime() + config939.scp939_silentabilitycooldown
    self.SilentEndTime = CurTime() + config939.scp939_silentabilityduration

    if SERVER then
        guthscp.player_message( ply, "Silent Step active for " .. config939.scp939_silentabilityduration .. " seconds." )
    end

    ply:EmitSound( "weapons/scp939/silentstep.mp3" )

    ply:SetSlowWalkSpeed( config939.walk_speed * config939.scp939_silentstepboost )
	ply:SetWalkSpeed( config939.walk_speed * config939.scp939_silentstepboost )
	ply:SetRunSpeed( config939.run_speed * config939.scp939_silentstepboost )

    timer.Simple(config939.scp939_silentabilityduration, function()
        if IsValid(ply) then
            ply.silent_step = false

            ply:SetSlowWalkSpeed( config939.walk_speed )
            ply:SetWalkSpeed( config939.walk_speed )
            ply:SetRunSpeed( config939.run_speed )

            ply:EmitSound( "weapons/scp939/silentstep.mp3" )

            if SERVER then
                guthscp.player_message(ply, "Silent Step over.")
            end
        end
    end)
end

hook.Add("HUDPaint", "SCP939_SilentAbilityHUD", function()
    if not config939.scp939_silentability then return end

    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()

    if not scp939.is_scp_939(ply) then return end

    local text = ""
    local color = Color(255, 50, 50)

    if ply.silent_step and wep.SilentEndTime then
        local remaining = math.max(0, wep.SilentEndTime - CurTime())
        text = "Silent Step Active : " .. string.format("%.1f", remaining) .. "s"
    elseif wep.NextSilentUse and CurTime() < wep.NextSilentUse then
        local cd = wep.NextSilentUse - CurTime()
        text = "Cooldown : " .. string.format("%.1f", cd) .. "s"
    else
        text = "Silent Step Ready"
        color = Color(50, 255, 50)
    end

    surface.SetFont("Trebuchet24")
    local textWidth, textHeight = surface.GetTextSize(text)

    local x = ScrW() * 0.5 - (textWidth / 2)
    local y = ScrH() * 0.85

    surface.SetTextColor(color)
    surface.SetTextPos(x, y)
    surface.DrawText(text)
end)

local cdping = 1
function SWEP:Think()
    hook.Add("Think", "SCP939NoDraw", function()
            local wep = self:GetOwner():GetActiveWeapon()
            local ply = self:GetOwner()

            if !IsValid( wep ) || not scp939.is_scp_939(ply) then hook.Remove("Think", "SCP939NoDraw") end

            hook.Add("RenderScreenspaceEffects", "PostProcess939", function()
                local wep = ply:GetActiveWeapon()
                if !IsValid( wep ) || not scp939.is_scp_939(ply) then
                    for k, v in pairs(player.GetAll()) do
                        v:SetNoDraw(false)
                        v:SetMaterial("") 
                        if v:Alive() && IsValid(v:GetActiveWeapon()) then
                            v:GetActiveWeapon():SetNoDraw(false)
                        end
                    end
                    hook.Remove("RenderScreenspaceEffects", "PostProcess939")
                else
                    DrawColorModify( tab )
                    DrawSobel( 0.2 )
                end
            end)

            for k, v in pairs(ents.FindInSphere(ply:GetPos(), config939.range_detection)) do
                if v:IsPlayer() && v:IsValid() && ply:Alive() && v:Alive() && v != ply then
                    if v:IsPlayer() && v != ply then
                        if scp939.shouldrevealplayer(ply,v) then
                            v:SetNoDraw(false)
                            local weapon = v:GetActiveWeapon()

                            if weapon and v:Alive() and IsValid( weapon ) then
                                weapon:SetNoDraw(false)
                            end

                            v:SetMaterial('vision/living')

                            if not config939.scp939_visualping then return end

                            if SERVER then
                                if self.NextPing and CurTime() > self.NextPing then
                                    self.NextPing = CurTime() + cdping
                                    net.Start("scp939_sound_ping")
                                    net.WriteVector(v:GetShootPos() + Vector(0,0,-5))
                                    net.Send(ply)
                                end
                            end

                        else
                            v:SetNoDraw(true)
                            local weapon = v:GetActiveWeapon()

                            if weapon and v:Alive() and IsValid( weapon ) then
                                weapon:SetNoDraw(true)
                            end

                            v:SetMaterial('')
                        end
                    end
                end
            end
        end)
    end

hook.Add("PostDrawTranslucentRenderables", "DrawPlayersThroughWalls", function()
    local ply = LocalPlayer()
    for _, v in pairs(ents.FindInSphere(ply:GetPos(), config939.range_detection)) do
        if v:IsPlayer() && v:IsValid() && LocalPlayer():Alive() && v:Alive() && v != LocalPlayer() then
            if scp939.shouldrevealplayer(ply,v) then
                cam.IgnoreZ(true)
                    render.SetColorModulation(1, 1, 1) 
                    render.SetBlend(1)
                    v:DrawModel()
                cam.IgnoreZ(false)

                render.SetColorModulation(1, 1, 1)
                render.SetBlend(1)
            end
        end
    end
end)





if CLIENT then
    guthscp.spawnmenu.add_weapon(SWEP, "SCP-939 SWEP")
end

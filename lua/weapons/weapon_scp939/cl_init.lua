include("shared.lua")

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

local function ShouldRevealPlayer(ply, target)
    if not IsValid(target) or not target:IsPlayer() or not target:Alive() then return false end
    if target == ply then return false end
    if not IsValid(ply:GetActiveWeapon()) then return false end
    if not scp939 or not scp939.is_scp_939 or not scp939.is_scp_939(ply) then return false end

    return (target:GetVelocity():Length() > 0 and not target:Crouching()) or target:IsSpeaking() or target.IsAttacker == true
end

net.Receive('PlayerShooting', function()
    entity = net.ReadEntity()
    if entity.IsAttacker == true then return end
    entity.IsAttacker = true
    timer.Create('RemoveAttacker', 5, 1, function()
        entity.IsAttacker = false
    end)
end)

function SWEP:Think()
    hook.Add("Think", "SCP939NoDraw", function()
        local wep = LocalPlayer():GetActiveWeapon()
        local ply = LocalPlayer()

        if !IsValid( wep ) || not scp939.is_scp_939(ply) then hook.Remove("Think", "SCP939NoDraw") end

        hook.Add("RenderScreenspaceEffects", "PostProcess939", function()
            local wep = LocalPlayer():GetActiveWeapon()
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

        for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), config939.range_detection)) do
            if v:IsPlayer() && v:IsValid() && LocalPlayer():Alive() && v:Alive() && v != LocalPlayer() then
                if v:IsPlayer() && v != LocalPlayer() then
                    if ShouldRevealPlayer(ply,v) then
                        v:SetNoDraw(false)
                        local weapon = v:GetActiveWeapon()
                        weapon:SetNoDraw(false)
                        v:SetMaterial('vision/living')
                    else
                        v:SetNoDraw(true)
                        local weapon = v:GetActiveWeapon()
                        weapon:SetNoDraw(true)
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
            if ShouldRevealPlayer(ply,v) then
                cam.IgnoreZ(true)
                    render.SetColorModulation(1, 0, 0) 
                    render.SetBlend(0.5)
                    v:DrawModel()
                cam.IgnoreZ(false)

                render.SetColorModulation(1, 1, 1)
                render.SetBlend(1)
            end
        end
    end
end)

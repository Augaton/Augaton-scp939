local scp939 = guthscp.modules.scp939
local config939 = guthscp.configs.scp939
scp939 = scp939 or {}

util.AddNetworkString( 'PlayerIsDead' )
util.AddNetworkString( 'PlayerShooting' )
util.AddNetworkString( 'PlayerIsShooting' )
util.AddNetworkString( 'SCP939HUDOFF' )

hook.Add("PlayerShouldTakeDamage", "scp939:no_damage", function(ply)
    if config939.scp939_immortal and scp939.is_scp_939(ply) then
        return false
    end
end)

local function disableSCP939HUD(ply)
    net.Start('SCP939HUDOFF')
    net.Send(ply)
end

hook.Add("PlayerDeath", "Playerdeath", function(ply) disableSCP939HUD(ply) end)
hook.Add("OnPlayerChangedTeam", "ResetVisibilityOnJobChange", function(ply) disableSCP939HUD(ply) end)

hook.Add('EntityFireBullets', 'PlayerIsShooting', function(entity)
    net.Start('PlayerShooting')
    net.WriteEntity(entity)
    net.Send(scp939.get_scps_939())
end)

local next_ping_check = 0
hook.Add("Think", "SCP939_PingGenerator", function()
    if CurTime() < next_ping_check then return end
    next_ping_check = CurTime() + 0.5

    local scps = scp939.get_scps_939()
    if #scps == 0 then return end

    for _, ply in ipairs(scps) do
        if not IsValid(ply) or not ply:Alive() then continue end

        for _, target in ipairs(ents.FindInSphere(ply:GetPos(), config939.range_detection or 1000)) do
            if target:IsPlayer() and scp939.shouldrevealplayer(ply, target) then
                
                net.Start("scp939_sound_ping")
                    net.WriteVector(target:GetPos() + Vector(0, 0, 40)) 
                net.Send(ply) 
            end
        end
    end
end)
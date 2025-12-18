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
local detection_range = config939.range_detection or 2500
local detection_range_sqr = detection_range * detection_range -- On calcule le carré une seule fois

hook.Add("Think", "SCP939_ServerPingLogic", function()
    local currentTime = CurTime()
    if currentTime < next_ping_check then return end
    next_ping_check = currentTime + 0.5

    local scps = scp939.get_scps_939()
    if #scps == 0 then return end

    local all_players = player.GetAll()
    
    for i = 1, #scps do
        local scp = scps[i]
        if not IsValid(scp) or not scp:Alive() then continue end

        local scpPos = scp:GetPos()
        local players_to_ping = {}

        for j = 1, #all_players do
            local target = all_players[j]
            
            if scp939.shouldrevealplayer(scp, target) then
                if scpPos:DistToSqr(target:GetPos()) < detection_range_sqr then
                    table.insert(players_to_ping, target:GetPos() + Vector(0, 0, 40))
                end
            end
        end

        if #players_to_ping > 0 then
            net.Start("scp939_sound_ping")
            net.WriteUInt(#players_to_ping, 8) 
            for _, pos in ipairs(players_to_ping) do
                net.WriteVector(pos)
            end
            net.Send(scp)
        end
    end
end)
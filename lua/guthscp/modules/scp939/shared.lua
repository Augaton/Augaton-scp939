local scp939 = guthscp.modules.scp939
local config939 = guthscp.configs.scp939
scp939 = scp939 or {}

scp939.filter = guthscp.players_filter:new("weapon_scp939")

if SERVER then
    scp939.filter:listen_disconnect()
    scp939.filter:listen_weapon_users("weapon_scp939")

    
	scp939.filter.event_added:add_listener( "scp939:setup", function( ply )
		--  speeds
		ply:SetSlowWalkSpeed( config939.walk_speed )
		ply:SetWalkSpeed( config939.walk_speed )
		ply:SetRunSpeed( config939.run_speed )
	end )
    scp939.filter.event_removed:add_listener("scp939:reset", function( ply )
    end)
end

function scp939.get_scps_939()
    return scp939.filter:get_entities()
end

function scp939.is_scp_939(ply)
    if CLIENT and ply == nil then
        ply = LocalPlayer()
    end
    return scp939.filter:is_in(ply)
end

// Silent Ability

hook.Add("PlayerDeath", "SCP939SilentReset", function(ply)
    if ply.silent_step then
        ply.silent_step = false
    end
end)

hook.Add("PlayerFootstep", "SCP939SilentStep", function(ply, pos, foot, sound, volume, rf)
    if scp939.is_scp_939(ply) and ply.silent_step then
        return true -- annule le son de pas
    end
end)

// Ping

local pings = {}

net.Receive("scp939_sound_ping", function()
    local pos = net.ReadVector()
    table.insert(pings, {
        pos = pos,
        time = CurTime(),
        duration = 0.5,     
    })
end)

if SERVER then
    util.AddNetworkString("scp939_sound_ping")
end

hook.Add("HUDPaint", "SCP939_VisualPing", function()
    if not config939.scp939_visualping then return end

    local ply = LocalPlayer()
    if not IsValid(ply) or not scp939.is_scp_939(ply) then return end

    local eyePos = ply:EyePos()
    local eyeAngles = ply:EyeAngles()

    for i = #pings, 1, -1 do
        local ping = pings[i]
        local delta = CurTime() - ping.time

        if delta > ping.duration then
            table.remove(pings, i)
        else
            local dir = (ping.pos - eyePos):GetNormalized()
            local angleToPing = eyeAngles:Forward():Dot(dir)
            local screenPos = ping.pos:ToScreen()

            local t = delta / ping.duration
            local radius = Lerp(t, 0, 70)
            local alpha = Lerp(1 - t, 255, 0)

            surface.SetDrawColor(255, 50, 50, alpha)
            draw.NoTexture()
            surface.DrawCircle(screenPos.x, screenPos.y, radius, 255, 50, 50)
        end
    end
end)

// init 939

function scp939.shouldrevealplayer(ply, target)
    if not IsValid(target) or not target:IsPlayer() or not target:Alive() then return false end
    if target == ply then return false end
    if not IsValid(ply:GetActiveWeapon()) then return false end
    if not scp939 or not scp939.is_scp_939 or not scp939.is_scp_939(ply) then return false end

    -- Movement detection
    local isMoving = target:GetVelocity():Length() > 10 and not target:Crouching()
    -- Voice detection
    local isTalking = target:IsSpeaking()
    -- Shoot detection ('RemoveAttacker')
    local hasShot = target.IsAttacker == true

    return isMoving or isTalking or hasShot
end

net.Receive('PlayerShooting', function()
    local entity = net.ReadEntity() -- Local !!
    if not IsValid(entity) or entity.IsAttacker == true then return end
    
    entity.IsAttacker = true
    timer.Create('RemoveAttacker_' .. entity:EntIndex(), 5, 1, function()
        if IsValid(entity) then entity.IsAttacker = false end
    end)
end)
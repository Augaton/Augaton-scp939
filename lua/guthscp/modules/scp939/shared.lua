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


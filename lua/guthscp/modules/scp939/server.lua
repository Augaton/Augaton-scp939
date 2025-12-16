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

hook.Add( "PlayerDeath", "Playerdeath", function(ply) 
    net.Start( 'SCP939HUDOFF' )
    net.Send( ply )
end)

hook.Add("OnPlayerChangedTeam", "ResetVisibilityOnJobChange", function(ply, oldTeam, newTeam)
    net.Start( 'SCP939HUDOFF' )
    net.Send(ply)
end)


hook.Add('EntityFireBullets', 'PlayerIsShooting', function(entity)
    net.Start('PlayerShooting')
    net.WriteEntity(entity)
    net.Send(scp939.get_scps_939())
end)
util.AddNetworkString( 'PlayerIsDead' )
util.AddNetworkString( 'PlayerShooting' )
util.AddNetworkString( 'PlayerIsShooting' )
util.AddNetworkString( 'SCP939HUDOFF' )


local scp939 = guthscp.modules.scp939
local config939 = guthscp.configs.scp939
scp939 = scp939 or {}

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
    net.Broadcast()
end)
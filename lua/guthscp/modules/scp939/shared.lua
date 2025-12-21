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
    local count = net.ReadUInt(8)
    for i = 1, count do
        local position = net.ReadVector()
        table.insert(pings, {
            pos = position,
            time = CurTime(),
            duration = 1.0, -- Durée d'affichage du point
        })
    end
end)

if SERVER then
    util.AddNetworkString("scp939_sound_ping")
end

local matCircle = Material("vgui/circle")
local ArrowPing = Material("materials/ping/arrow.png")
local colorRed = Color(255, 50, 50)

hook.Add("HUDPaint", "SCP939_VisualPing", function()
    local lp = LocalPlayer()
    if not IsValid(lp) or not scp939.is_scp_939(lp) then return end
    if #pings == 0 then return end

    local curTime = CurTime()
    local scrW, scrH = ScrW(), ScrH()

    for i = #pings, 1, -1 do
        local ping = pings[i]
        local delta = curTime - ping.time

        if delta > ping.duration then
            table.remove(pings, i)
            continue
        end

        -- Calcul de la position écran
        local screenData = ping.pos:ToScreen()
        
        -- C'est ici qu'on règle le problème du 0,0 :
        -- Si screenData.visible est faux, l'entité est derrière le joueur.
        -- On utilise math.Clamp pour forcer l'affichage sur les bords si hors écran.
        local x = math.Clamp(screenData.x, 20, scrW - 20)
        local y = math.Clamp(screenData.y, 20, scrH - 20)
        
        local alpha = (1 - (delta / ping.duration)) * 255
        local size = 20 * (1 - (delta / ping.duration))

        surface.SetMaterial(matCircle)
        surface.SetDrawColor(255, 50, 50, alpha)
        surface.DrawTexturedRectRotated(x, y, size + 10, size + 10, 0)
        
        -- Optionnel : Afficher la distance
        local dist = math.Round(lp:GetPos():Distance(ping.pos) * 0.019) .. "m"
        draw.SimpleTextOutlined(dist, "DermaDefault", x, y + 15, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, alpha))
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
local scp939 = guthscp.modules.scp939
local config939 = guthscp.configs.scp939

hook.Add("PlayerShouldTakeDamage", "scp939:no_damage", function(ply)
    if config939.scp939_immortal and scp939.is_scp_939(ply) then
        return false
    end
end)
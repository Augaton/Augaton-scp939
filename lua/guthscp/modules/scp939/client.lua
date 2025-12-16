local scp939 = guthscp.modules.scp939
local config939 = guthscp.configs.scp939
scp939 = scp939 or {}

net.Receive('SCP939HUDOFF', function()
    hook.Remove("Think", "SCP939NoDraw")
    hook.Remove("RenderScreenspaceEffects", "PostProcess939")
    hook.Remove("PreDrawOpaqueRenderables", "HidePlayersForSCP939")
    hook.Remove("PostDrawTranslucentRenderables", "DrawPlayersSCP939")

    for _, v in ipairs(player.GetAll()) do
        if IsValid(v) and v ~= LocalPlayer() then
            if v:GetMaterial() ~= "" then
                v:SetMaterial("")
            end

            if IsValid(v:GetActiveWeapon()) then
                v:GetActiveWeapon():SetNoDraw(false)
            end
        end

        v:SetNoDraw(false)
    end

    render.SetBlend(1)  -- Juste au cas où, reset du blend
    render.MaterialOverride(nil)
    render.SetColorModulation(1, 1, 1)
end)

local MODULE = {
	name = "SCP-939",
	author = "Augaton",
	version = "0.0.1",
	description = [[Control SCP 939, control what he do !]],
	icon = "icon16/key.png",
	version_url = "https://raw.githubusercontent.com/Augaton/guthscp939/refs/heads/main/lua/guthscp/modules/scp939/main.lua",
	dependencies = {
		base = "2.4.0",
        guthscpkeycard = "2.1.6",
	},
	requires = {
		-- ["server.lua"] = guthscp.REALMS.SERVER,
	},
}

MODULE.menu = {
	--  config
	config = {
		form = {
			"General",
            {
				type = "Number",
				name = "Keycard Level",
				id = "keycard_level",
				desc = [[Compatibility with keycard system. Set a keycard level to SCP-939's swep]],
				default = 5,
				min = 0,
				max = function( self, numwang )
					if self:is_disabled() then return 0 end

					return guthscp.modules.guthscpkeycard.max_keycard_level
				end,
				is_disabled = function( self, numwang )
					return guthscp.modules.guthscpkeycard == nil
				end,
			},
			"Sounds",
			{
				{
					type = "String[]",
					name = "Random Sounds",
					id = "random_sound",
					desc = "Random-sound played by SCP 939",
					default = {
						"weapons/scp939/talk1.mp3",
						"weapons/scp939/talk2.mp3",
						"weapons/scp939/talk3.mp3",
						"weapons/scp939/talk4.mp3",
                        "weapons/scp939/talk5.mp3",
					},
				},
			},
		},
	},
	--  details
	details = {
		{
			text = "CC-BY-SA",
			icon = "icon16/page_white_key.png",
		},
		"Social",
		{
			text = "Github",
			icon = "guthscp/icons/github.png",
			url = "https://github.com/augaton/scp-hacking-device-reloaded",
		},
		{
			text = "Steam",
			icon = "guthscp/icons/steam.png",
			url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3302753364"
		},
		{
			text = "Discord",
			icon = "guthscp/icons/discord.png",
			url = "https://discord.gg/kJFQe95pgh",
		},
	},
}

function MODULE:init()
    MODULE:info("The SCP 939 has been loaded !")
end

-- guthscp.module.hot_reload( "hdevicereloaded" )
return MODULE

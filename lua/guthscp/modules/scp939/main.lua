local MODULE = {
	name = "SCP-939",
	author = "Augaton",
	version = "0.0.3",
	description = [[Control SCP 939, control what he do !]],
	icon = "icon16/sound_mute.png",
	version_url = "https://raw.githubusercontent.com/Augaton/guthscp939/refs/heads/main/lua/guthscp/modules/scp939/main.lua",
	dependencies = {
		base = "2.4.0",
        guthscpkeycard = "2.1.6",
	},
	requires = {
	 	["server.lua"] = guthscp.REALMS.SERVER,
		["shared.lua"] = guthscp.REALMS.SHARED,
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
			{
				type = "Bool",
				name = "Immortal",
				id = "scp939_immortal",
				desc = "If checked, SCP-939 can't take damage",
				default = false,
			},
			{
				type = "Number",
				name = "Walk Speed",
				id = "walk_speed",
				desc = "Speed of walking for SCP-939, in hammer units",
				default = 150,
			},
			{
				type = "Number",
				name = "Run Speed",
				id = "run_speed",
				desc = "Speed of running for SCP-939, in hammer units",
				default = 210,
			},
			"939 System",
			{
				type = "Number",
				name = "Range",
				id = "range_detection",
				desc = "The range of detection of SCP 939, in hammer units",
				default = 2500,
			},
			"Sounds",
			{
				type = "String",
				name = "Biting Sound",
				id = "bitting_sound",
				desc = "Sound played by SCP 939 when attacking",
				default = "weapons/scp939/bite.wav",
			},
			{
				type = "String[]",
				name = "Random Sounds",
				id = "random_sound",
				desc = "Random-sound played by SCP 939 when imiting sound",
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

guthscp.module.hot_reload( "scp939" )
return MODULE

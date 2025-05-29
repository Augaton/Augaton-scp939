local MODULE = {
	name = "SCP-939",
	author = "Augaton",
	version = "1.0.0",
	description = [[SCP 939, the SCP that's need sound to do a disaster !]],
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
			{
				type = "Number",
				name = "Attack Range",
				id = "attack_range",
				desc = "Range of Attack for SCP-939, in hammer units",
				default = 125,
			},
			{
				type = "Number",
				name = "Minimal Damage",
				id = "min_attack",
				desc = "The minimal random damage for SCP-939 for each attack",
				default = 45,
			},
			{
				type = "Number",
				name = "Maximal Damage",
				id = "max_attack",
				desc = "The maximal random damage for SCP-939 for each attack",
				default = 60,
			},
			"939 System",
			{
				type = "Number",
				name = "Range",
				id = "range_detection",
				desc = "The range of detection of SCP 939, in hammer units",
				default = 2500,
			},
			{
				type = "Bool",
				name = "Visual Ping",
				id = "scp939_visualping",
				desc = "If checked, SCP-939 can see the person and a red circle that's indicate a 'ping', it's purely visual (expiremental, can provoke freeze)",
				default = false,
			},
			{
				type = "Bool",
				name = "Silent Step Ability",
				id = "scp939_silentability",
				desc = "If checked, SCP-939 can use a ability that's called Silent Step using your reload button",
				default = false,
			},
			{
				type = "Number",
				name = "Silent Step Duration",
				id = "scp939_silentabilityduration",
				desc = "The duration of the ability of SCP 939 Silent Step",
				default = 5,
			},
			{
				type = "Number",
				name = "Silent Step Cooldown",
				id = "scp939_silentabilitycooldown",
				desc = "The cooldown of the ability of SCP 939 Silent Step before reusing it",
				default = 20,
			},
			{
				type = "Number",
				name = "Silent Step Boost",
				id = "scp939_silentstepboost",
				desc = "The boost of the movement give to SCP 939 during Silent Step (below 1 is slowing, 1 is unchanged, more than 1 is boosting)",
				default = 1.5,
			},
			"Sounds",
			{
				type = "String",
				name = "Claw Attack Sound",
				id = "claw_sound",
				desc = "Sound played by SCP 939 when attacking",
				default = "weapons/scp939/claw.mp3",
			},
			{
				type = "String[]",
				name = "Claw Attack Hit Sound",
				id = "clawhitting_sound",
				desc = "Random-sound played by SCP 939 when hitting somebody",
				default = {
					"weapons/scp939/clawhit1.mp3",
					"weapons/scp939/clawhit2.mp3",
					"weapons/scp939/clawhit3.mp3",
				},
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
			url = "https://github.com/Augaton/guthscp939",
		},
		{
			text = "Steam",
			icon = "guthscp/icons/steam.png",
			url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3489863065"
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

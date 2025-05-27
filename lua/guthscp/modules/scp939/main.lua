local MODULE = {
	name = "SCP-939",
	author = "Augaton",
	version = "0.0.1",
	description = [[Control SCP 939, control what he do !]],
	icon = "icon16/key.png",
	version_url = "https://raw.githubusercontent.com/augaton/scp-hacking-device-reloaded/main/lua/guthscp/modules/hdevicereloaded/main.lua",
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
			"Configuration",
            
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

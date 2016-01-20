-- Player Info mod by MirceaKitsune

local function formspec_string(name)
	-- Turn the player table into a string
	local players_total = #minetest.get_connected_players()
	local players = ""
	for i, player in pairs(minetest.get_connected_players()) do
		-- Add player name
		local name = player:get_player_name()
		-- Add player ping
		local ping = minetest.get_player_information(name).avg_rtt / 2
		ping = math.floor(ping * 1000) -- Milliseconds

		-- Ping colors
		local ping_color = "#AAFFAA"
		if ping > 500 then
			ping_color = "#FFAAAA"
		elseif ping > 100 then
			ping_color = "#FFFF0AA"
		end

		players = players..ping_color..name.." ("..ping.."ms)"
		if i < players_total then
			players = players..","
		end
	end

	local formspec="size[4,8]"
	.."label[0,0;Players: "..players_total.." / "..minetest.setting_get("max_users").."]"
	.."button[2,0;2,1;player_list_refresh;Refresh]"
	.."textlist[0,1;4,6;player_list;"..players..";0;true]"
	.."button_exit[0,7;4,1;player_list_exit;Close]"
	return formspec
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "playerinfo" and fields["player_list_refresh"] then
		local name = player:get_player_name()
		minetest.show_formspec(name, "playerinfo", formspec_string(name))
	end
end)

minetest.register_privilege("playerinfo", { description = "Allows player to use the /players command ;-)" })

minetest.register_chatcommand("players", {
	params = "",
	description = "show connected player information",
	privs = {"playerinfo"},
	func = function(name, param)
		if minetest.is_singleplayer() then
			minetest.chat_send_player(name, "This command only works in multiplayer.")
		else
			minetest.show_formspec(name, "playerinfo", formspec_string(name))
		end
	end,
})

------------------------------------------------------------------------------------------------------------------------------------
-- BASIC MACHINES MOD by rnd
-- mod with basic simple automatization for minetest. No background processing, just one abm with 5s timer (clock generator), no other lag causing background processing.
------------------------------------------------------------------------------------------------------------------------------------



--  *** SETTINGS *** --
basic_keypad.timer = 5 -- main timestep
basic_keypad.machines_minstep = 1 -- minimal allowed activation timestep, if faster machines overheat

basic_keypad.max_range = 10 -- machines normal range of operation
basic_keypad.machines_operations = 10 -- 1 coal will provide 10 mover basic operations ( moving dirt 1 block distance)
basic_keypad.machines_TTL = 16 -- time to live for signals, how many hops before signal dissipates

basic_keypad.version = "10/02/2021a";
basic_keypad.clockgen = 1; -- if 0 all background continuously running activity (clockgen/keypad) repeating is disabled

-- how hard it is to move blocks, default factor 1, note fuel cost is this multiplied by distance and divided by machine_operations..
basic_keypad.hardness = {
["default:stone"]=3,["default:tree"]=1,["default:jungletree"]=1,["default:pine_tree"]=1,["default:aspen_tree"]=1,["default:acacia_tree"]=1, ["default:bush_leaves"] = 0.1,["default:leaves"] = 0.1, ["default:jungleleaves"] = 0.1,
["gloopblocks:pumice_cooled"]=2,["default:cloud"] = 999999,
["default:lava_source"]=5950,["default:water_source"]=5950,["default:obsidian"]=20,["bedrock2:bedrock"]=999999};
--move machines for free
basic_keypad.hardness["basic_keypad:mover"]=0.;
basic_keypad.hardness["basic_keypad:keypad"]=0.;
basic_keypad.hardness["basic_keypad:distributor"]=0.;
basic_keypad.hardness["basic_keypad:battery_0"]=0.;
basic_keypad.hardness["basic_keypad:battery_1"]=0.;
basic_keypad.hardness["basic_keypad:battery_2"]=0.;
basic_keypad.hardness["basic_keypad:detector"]=0.;
basic_keypad.hardness["basic_keypad:generator"]=999999.; -- can only place generator by hand
basic_keypad.hardness["basic_keypad:clockgen"]=0.;
basic_keypad.hardness["basic_keypad:ball_spawner"]=0.;
basic_keypad.hardness["basic_keypad:light_on"]=0.;
basic_keypad.hardness["basic_keypad:light_off"]=0.;

-- grief potential items need highest possible upgrades
basic_keypad.hardness["boneworld:acid_source_active"]=5950.;
basic_keypad.hardness["darkage:mud"]=5950.;

basic_keypad.hardness["es:toxic_water_source"]=5950.;basic_keypad.hardness["es:toxic_water_flowing"]=5950;
basic_keypad.hardness["default:river_water_source"]=5950.;

-- farming operations are much cheaper
basic_keypad.hardness["farming:wheat_8"]=1;basic_keypad.hardness["farming:cotton_8"]=1;
basic_keypad.hardness["farming:seed_wheat"]=0.5;basic_keypad.hardness["farming:seed_cotton"]=0.5;

-- digging mese crystals more expensive
basic_keypad.hardness["mese_crystals:mese_crystal_ore1"] = 10;
basic_keypad.hardness["mese_crystals:mese_crystal_ore2"] = 10;
basic_keypad.hardness["mese_crystals:mese_crystal_ore3"] = 10;
basic_keypad.hardness["mese_crystals:mese_crystal_ore4"] = 10;


-- define which nodes are dug up completely, like a tree
basic_keypad.dig_up_table = {["default:cactus"]=true,["default:tree"]=true,["default:jungletree"]=true,["default:pine_tree"]=true,
["default:acacia_tree"]=true,["default:aspen_tree"]=true,["default:papyrus"]=true};
				
-- set up nodes for harvest when digging: [nodename] = {what remains after harvest, harvest result}
basic_keypad.harvest_table = {
["mese_crystals:mese_crystal_ore4"] = {"mese_crystals:mese_crystal_ore1", "default:mese_crystal 3"}, -- harvesting mese crystals
["mese_crystals:mese_crystal_ore3"] = {"mese_crystals:mese_crystal_ore1", "default:mese_crystal 2"},
["mese_crystals:mese_crystal_ore2"] = {"mese_crystals:mese_crystal_ore1", "default:mese_crystal 1"},
["mese_crystals:mese_crystal_ore1"] = {"mese_crystals:mese_crystal_ore1", ""},
};

-- set up nodes for plant with reverse on and filter set (for example seeds -> plant) : [nodename] = plant_name
basic_keypad.plant_table  = {["farming:seed_barley"]="farming:barley_1",["farming:beans"]="farming:beanpole_1", -- so it works with farming redo mod
["farming:blueberries"]="farming:blueberry_1",["farming:carrot"]="farming:carrot_1",["farming:cocoa_beans"]="farming:cocoa_1",
["farming:coffee_beans"]="farming:coffee_1",["farming:corn"]="farming:corn_1",["farming:blueberries"]="farming:blueberry_1",
["farming:seed_cotton"]="farming:cotton_1",["farming:cucumber"]="farming:cucumber_1",["farming:grapes"]="farming:grapes_1",
["farming:melon_slice"]="farming:melon_1",["farming:potato"]="farming:potato_1",["farming:pumpkin_slice"]="farming:pumpkin_1",
["farming:raspberries"]="farming:raspberry_1",["farming:rhubarb"]="farming:rhubarb_1",["farming:tomato"]="farming:tomato_1",
["farming:seed_wheat"]="farming:wheat_1",["farming:seed_rice"]="farming:rice_1"}

-- list of objects that cant be teleported with mover
basic_keypad.no_teleport_table = {
["itemframes:item"] = true,
["signs:text"] = true
}

-- list of nodes mover cant take from in inventory mode
basic_keypad.limit_inventory_table = { -- node name = {list of bad inventories to take from} OR node name = true to ban all inventories
	["basic_keypad:autocrafter"]= {["recipe"]=1, ["output"]=1},
	["basic_keypad:constructor"]= {["recipe"]=1},
	["basic_keypad:battery_0"] = {["upgrade"] = 1},
	["basic_keypad:battery_1"] = {["upgrade"] = 1},
	["basic_keypad:battery_2"] = {["upgrade"] = 1},
	["basic_keypad:generator"] = {["upgrade"] = 1},
	["basic_keypad:mover"] = true,
	["basic_keypad:grinder"] = {["upgrade"] = 1},
	["moreblocks:circular_saw"] = true,
	["smartshop:shop"] = true,
}

-- when activated with keypad these will be "punched" to update their text too
basic_keypad.signs = {
["default:sign_wall_wood"] = true,
["signs:sign_wall_green"] = true,
["signs:sign_wall_green"] = true,
["signs:sign_wall_yellow"] = true,
["signs:sign_wall_red"] = true,
["signs:sign_wall_red"] = true,
["signs:sign_wall_white_black"] = true,
["signs:sign_yard"] = true
}

basic_keypad.connectables = { -- list of machines that distributor can connect to, used for distributor scan feature
	["basic_keypad:mover"]=0;
	["basic_keypad:keypad"]=0;
	["basic_keypad:distributor"]=0;
	["basic_keypad:battery_0"]=0;
	["basic_keypad:battery_1"]=0;
	["basic_keypad:battery_2"]=0;
	["basic_keypad:detector"]=0;
	["basic_keypad:generator"]=0;
	["basic_keypad:clockgen"]=0;
	["basic_keypad:ball_spawner"]=0;
	["basic_keypad:light_on"]=0;
	["basic_keypad:light_off"]=0;
}

--  *** END OF SETTINGS *** --


local machines_timer = basic_keypad.timer
local machines_minstep = basic_keypad.machines_minstep
local max_range = basic_keypad.max_range
local machines_operations = basic_keypad.machines_operations
local machines_TTL = basic_keypad.machines_TTL


local punchset = {}; 

minetest.register_on_joinplayer(function(player) 
	local name = player:get_player_name(); if name == nil then return end
	punchset[name] = {};
	punchset[name].state = 0;
end)

-- KEYPAD --

local function use_keypad(pos,ttl, again) -- position, time to live ( how many times can signal travel before vanishing to prevent infinite recursion ), do we want to activate again
	
	if ttl<0 then return end;
	local meta = minetest.get_meta(pos);	
	
	local t0 = meta:get_int("t");
	local t1 = minetest.get_gametime(); 
	local T = meta:get_int("T"); -- temperature
	
	if t0>t1-machines_minstep then -- activated before natural time
		T=T+1;
	else
		if T>0 then 
			T=T-1 
			if t1-t0>5 then T = 0 end
		end
	end
	meta:set_int("T",T);
	meta:set_int("t",t1); -- update last activation time
	
	if T > 2 then -- overheat
			minetest.sound_play("default_cool_lava",{pos = pos, max_hear_distance = 16, gain = 0.25})
			meta:set_string("infotext","overheat: temperature ".. T)
			return
	end
	
	
	local name =  meta:get_string("owner"); 
	if minetest.is_protected(pos,name) then meta:set_string("infotext", "Protection fail. reset."); meta:set_int("count",0); return end
	local count = meta:get_int("count") or 0; -- counts how many repeats left
	
	local repeating = meta:get_int("repeating");
	
	if repeating==1 and again~=1 then 
		-- stop it
		meta:set_int("repeating",0);
		meta:set_int("count", 0)
		meta:set_int("T",4);
		meta:set_string("infotext", "#KEYPAD: reseting. Punch again after 5s to activate")
		return;
	end	
	
	
	
	if count>0 then -- this is keypad repeating its activation
		count = count - 1; meta:set_int("count",count);  
	else
		meta:set_int("repeating",0); 
		--return 
	end
	
	if count>=0 then
		meta:set_string("infotext", "Keypad operation: ".. count .." cycles left")
	else
		meta:set_string("infotext", "Keypad operation: activation ".. -count)
	end
		
	if count>0 then -- only trigger repeat if count on
			if repeating == 0 then meta:set_int("repeating",1); end-- its repeating now
			if basic_keypad.clockgen==0 then return end
			minetest.after(machines_timer, function() 
				use_keypad(pos,machines_TTL,1) 
			end )  
		
	end
	
	local x0,y0,z0,mode;
	x0=meta:get_int("x0");y0=meta:get_int("y0");z0=meta:get_int("z0");
	x0=pos.x+x0;y0=pos.y+y0;z0=pos.z+z0;
	mode = meta:get_int("mode");

	-- pass the signal on to target, depending on mode
	
	local tpos = {x=x0,y=y0,z=z0}; -- target position
	local node = minetest.get_node(tpos);if not node.name then return end -- error
	local text = meta:get_string("text"); 
	
	if text ~= "" then -- TEXT MODE; set text on target
		if text == "@" then -- keyboard mode, set text from input
			text = meta:get_string("input") or "";
			meta:set_string("input",""); -- clear input again
		end
		
		local bit = string.byte(text);
		if bit == 33 then -- if text starts with !, then we send chat text to all nearby players, radius 5
			text = string.sub(text,2) ; if not text or text == "" then return end
			local players = minetest.get_connected_players();
			for _,player in pairs(players) do
				local pos1 = player:getpos();
				local dist = math.sqrt((pos1.x-tpos.x)^2 + (pos1.y-tpos.y)^2 + (pos1.z-tpos.z)^2 );
				if dist<=5 then
					minetest.chat_send_player(player:get_player_name(), text)
				end
			end
			return
		elseif bit == 36 then-- text starts with $, play sound
			text = string.sub(text,2) ; if not text or text == "" then return end
			local i = string.find(text, " ")
			if not i then
				minetest.sound_play(text, {pos=pos,gain=1.0,max_hear_distance = 16})
			else
				local pitch = tonumber(string.sub(text,i+1)) or 1;
				if pitch<0.01 or pitch > 10 then pitch =  1 end
				minetest.sound_play(string.sub(text,1,i-1), {pos=pos,gain=1.0,max_hear_distance = 16,pitch = pitch})
			end
		end
		
		local tmeta = minetest.get_meta(tpos);if not tmeta then return end
		
		if basic_keypad.signs[node.name] then -- update text on signs with signs_lib
			tmeta:set_string("infotext", text);
			tmeta:set_string("text",text);
			local table = minetest.registered_nodes[node.name];
			if not table.on_punch then return end -- error
			if signs_lib and signs_lib.update_sign then
				--signs_lib.update_sign(pos)
				table.on_punch(tpos, node, nil); -- warning - this can cause problems if no signs_lib installed
			end
			
			return
		end
		
		-- target is keypad, special functions: @, % that output to target keypad text
		if node.name == "basic_keypad:keypad" then -- special modify of target keypad text and change its target
			
			x0=tmeta:get_int("x0");y0=tmeta:get_int("y0");z0=tmeta:get_int("z0");
			x0=tpos.x+x0;y0=tpos.y+y0;z0=tpos.z+z0;
			tpos = {x=x0,y=y0,z=z0};
			
			if string.byte(text) == 64 then -- target keypad's text starts with @ ( ascii code 64) -> character replacement
				text = string.sub(text,2); if not text or text == "" then return end
				--read words[j] from blocks above keypad:
				local j=0;
				text = string.gsub(text, "@", 
					function() 
						j=j+1;
						return minetest.get_meta({x=pos.x,y=pos.y+j,z=pos.z}):get_string("infotext")
					end
				) ; -- replace every @ in ttext with string on blocks above

				-- set target keypad's text
				--tmeta = minetest.get_meta(tpos);if not tmeta then return end
				tmeta:set_string("text", text);
			elseif string.byte(text) == 37 then -- target keypad's text starts with % ( ascii code 37) -> word extraction
			
				local ttext = minetest.get_meta({x=pos.x,y=pos.y+1,z=pos.z}):get_string("infotext")
				local i = tonumber(string.sub(text,2,2)) or 1; --read the number following the %
				--extract i-th word from text 
				 local j = 0; 
				 for word in string.gmatch(ttext, "%S+") do 
					j=j+1; if j == i then text = word; break; end
				 end
				 
				-- set target keypad's target's text
				--tmeta = minetest.get_meta(tpos); if not tmeta then return end
				tmeta:set_string("text", text);
			else 
			
				if string.byte(text) == 64 then -- if text starts with @ clear target keypad text
					tmeta:set_string("text",""); 
					return
				end
				-- just set text..
				--tmeta = minetest.get_meta(tpos); if not tmeta then return end
				tmeta:set_string("infotext", text);
			end
			return
		end
		
		if node.name == "basic_keypad:detector" then -- change filter on detector
			if string.byte(text) == 64 then -- if text starts with @ clear the filter
				tmeta:set_string("node","");
			else
				tmeta:set_string("node",text);
			end
			return
		end
		
		if node.name == "basic_keypad:mover" then -- change filter on mover
			if string.byte(text) == 64 then -- if text starts with @ clear the filter
				tmeta:set_string("prefer","");
			else
				if check_mover_filter(tmeta:get_string("mode"), text,tmeta:get_int("reverse")) then -- mover input validate
					tmeta:set_string("prefer",text);
				end
			end
			return
		end
		
		if node.name == "basic_keypad:distributor" then
			local i = string.find(text," ");
			if i then
				local ti = tonumber(string.sub(text,1,i-1)) or 1;
				local tm = tonumber(string.sub(text,i+1)) or 1;
				if ti>=1 and ti<=16 and tm>=-2 and tm<=2 then
					tmeta:set_int("active"..ti,tm)
				end
			end
		return
		end
		
		tmeta:set_string("infotext", text); -- else just set text
	end
	
	
	--activate target
	local table = minetest.registered_nodes[node.name];
	if not table then return end -- error
	if not table.effector then return end -- error
	local effector=table.effector;
	
	if mode == 3 then -- keypad in toggle mode
		local state = meta:get_int("state") or 0;state = 1-state; meta:set_int("state",state);
		if state == 0 then mode = 1 else mode = 2 end
	end
	-- pass the signal on to target
	
	if mode == 2 then -- on
		if not effector.action_on then return end
		effector.action_on(tpos,node,ttl-1); -- run
	elseif mode == 1 then -- off
		if not effector.action_off then return end
		effector.action_off(tpos,node,ttl-1); -- run
	end
			
end

local function check_keypad(pos,name,ttl) -- called only when manually activated via punch
	local meta = minetest.get_meta(pos);
	local pass =  meta:get_string("pass");
	if pass == "" then 
		local iter = meta:get_int("iter");
		local count = meta:get_int("count");
		if count<iter-1 or iter<2 then meta:set_int("active_repeats",0) end -- so that keypad can work again, at least one operation must have occured though
		meta:set_int("count",iter); use_keypad(pos,machines_TTL,0) -- time to live set when punched
		return 
	end
	if name == "" then return end
		
	if meta:get_string("text") == "@" then -- keypad works as a keyboard
		local form  = 
		"size[3,1]" ..  -- width, height
		"field[0.25,0.25;3,1;pass;Enter text: ;".."".."] button_exit[0.,0.5;1,1;OK;OK]";
		minetest.show_formspec(name, "basic_keypad:check_keypad_"..minetest.pos_to_string(pos), form)
		return
	end
	
	pass = ""
	local form  = 
		"size[3,1.25]" ..  -- width, height
		"bgcolor[#FF8888BB; false]" ..
		"field[0.25,0.25;3,1;pass;Enter Password: ;".."".."] button_exit[0.,0.75;1,1;OK;OK]";
		minetest.show_formspec(name, "basic_keypad:check_keypad_"..minetest.pos_to_string(pos), form)
	return

end

minetest.register_node("basic_keypad:keypad", {
	description = "Keypad - basic way to activate machines by sending signal",
	tiles = {"keypad.png"},
	groups = {cracky=3},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Keypad. Right click to set it up or punch it. Set any password and text \"@\" to work as keyboard.")
		meta:set_string("owner", placer:get_player_name()); meta:set_int("public",1);
		meta:set_int("x0",0);meta:set_int("y0",0);meta:set_int("z0",0); -- target
	
		meta:set_string("pass", "");meta:set_int("mode",2); -- pasword, mode of operation
		meta:set_int("iter",1);meta:set_int("count",0); -- how many repeats to do, current repeat count
		local name = placer:get_player_name();punchset[name] =  {};punchset[name].state = 0
	end,
		
	effector = { 
		action_on = function (pos, node,ttl) 
		if type(ttl)~="number" then ttl = 1 end
		if ttl<0 then return end -- machines_TTL prevents infinite recursion
		use_keypad(pos,0,0) -- activate just 1 time
	end
	},
	
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos);
		local privs = minetest.get_player_privs(player:get_player_name());
		local cant_build = minetest.is_protected(pos,player:get_player_name());
		--meta:get_string("owner")~=player:get_player_name() and 
		if not privs.privs and cant_build then 
			return 
		end -- only  ppl sharing protection can set up keypad
		local x0,y0,z0,x1,y1,z1,pass,iter,mode;
		x0=meta:get_int("x0");y0=meta:get_int("y0");z0=meta:get_int("z0");iter=meta:get_int("iter") or 1;
		local text = meta:get_string("text") or "";
		mode = meta:get_int("mode") or 1;
		
		machines.pos1[player:get_player_name()] = {x=pos.x+x0,y=pos.y+y0,z=pos.z+z0};machines.mark_pos1(player:get_player_name()) -- mark pos1
		
		pass = meta:get_string("pass");
		local form  = 
		"size[4.75,3.75]" ..  -- width, height
		"bgcolor[#888888BB; false]" ..
		"field[2.5,0.25;2.25,1;pass;Password: ;"..pass.."]" .. 
		"field[0.25,2.5;3.25,1;text;text;".. text .."]" ..
		"field[0.25,0.25;1,1;mode;mode;"..mode.."]".. "field[1.25,0.25;1.1,1;iter;repeat;".. iter .."]"..
		
		"label[0.,0.75;".. minetest.colorize("lawngreen","MODE: 1=OFF/2=ON/3=TOGGLE").."]"..
		"field[0.25,3.5;1,1;x0;target;"..x0.."] field[1.25,3.5;1,1;y0;;"..y0.."] field[2.25,3.5;1,1;z0;;"..z0.."]"..
		"button[3.25,3.25;1,1;help;help] button_exit[3.25,2.25;1,1;OK;OK]"


		
		;
		-- if meta:get_string("owner")==player:get_player_name() then
			minetest.show_formspec(player:get_player_name(), "basic_keypad:keypad_"..minetest.pos_to_string(pos), form)
		-- else
			-- minetest.show_formspec(player:get_player_name(), "view_only_basic_keypad_keypad", form)
		-- end
	end
})

	
punchset.known_nodes = {["basic_keypad:keypad"]=true};

-- SETUP BY PUNCHING
minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	
	-- STRANGE PROBLEM: if player doesnt move it takes another punch at same block for this function to run again, and it works normally if player moved at least one block from his previous position
	-- it only happens with keypad - maybe caused by formspec displayed..
	
	local name = puncher:get_player_name(); if name==nil then return end
	if punchset[name]== nil then  -- set up punchstate
		punchset[name] = {} 
		punchset[name].node = ""
		punchset[name].pos1 = {x=0,y=0,z=0};punchset[name].pos2 = {x=0,y=0,z=0};punchset[name].pos = {x=0,y=0,z=0};
		punchset[name].state = 0; -- 0 ready for punch, 1 ready for start position, 2 ready for end position
		return
	end

	
	-- check for known node names in case of first punch
	if punchset[name].state == 0 and not punchset.known_nodes[node.name] then return end
	-- from now on only punches with mover/keypad/... or setup punches
	
	if punchset.known_nodes[node.name] then  -- check if player is suppose to be able to punch interact
			if node.name~="basic_keypad:keypad" then -- keypad is supposed to be punch interactive!
				if minetest.is_protected(pos, name) then return end
			end
	end
	
	if node.name == "basic_keypad:mover" then -- mover init code
		if punchset[name].state == 0 then 
			-- if not puncher:get_player_control().sneak then
				-- return
			-- end
			minetest.chat_send_player(name, "MOVER: Now punch source1, source2, end position to set up mover.")
			punchset[name].node = node.name;punchset[name].pos = {x=pos.x,y=pos.y,z=pos.z};
			punchset[name].state = 1 
			return
		end
	end
	
	 if punchset[name].node == "basic_keypad:mover" then -- mover code, not first punch
		
		if minetest.is_protected(pos,name) then
			minetest.chat_send_player(name, "MOVER: Punched position is protected. aborting.")
			punchset[name].node = "";
			punchset[name].state = 0; return
		end

		local meta = minetest.get_meta(punchset[name].pos);	if not meta then return end;
		local range = meta:get_float("upgrade") or 1; range = range*max_range;
		
		if punchset[name].state == 1 then 
			local privs = minetest.get_player_privs(puncher:get_player_name());
			if not privs.privs and (math.abs(punchset[name].pos.x - pos.x)>range or math.abs(punchset[name].pos.y - pos.y)>range or math.abs(punchset[name].pos.z - pos.z)>range) then
					minetest.chat_send_player(name, "MOVER: Punch closer to mover. reseting.")
					punchset[name].state = 0; return
			end
			
			if punchset[name].pos.x==pos.x and punchset[name].pos.y==pos.y and punchset[name].pos.z==pos.z then 
				minetest.chat_send_player(name, "MOVER: Punch something else. aborting.")
				punchset[name].state = 0;
				return 
			end
			
			punchset[name].pos1 = {x=pos.x,y=pos.y,z=pos.z};punchset[name].state = 2;
			machines.pos1[name] = punchset[name].pos1;machines.mark_pos1(name) -- mark position
			minetest.chat_send_player(name, "MOVER: Source1 position for mover set. Punch again to set source2 position.")
			return
		end
		
		
		if punchset[name].state == 2 then 
			local privs = minetest.get_player_privs(puncher:get_player_name());
			if not privs.privs and (math.abs(punchset[name].pos.x - pos.x)>range or math.abs(punchset[name].pos.y - pos.y)>range or math.abs(punchset[name].pos.z - pos.z)>range) then
					minetest.chat_send_player(name, "MOVER: Punch closer to mover. reseting.")
					punchset[name].state = 0; return
			end
			
			if punchset[name].pos.x==pos.x and punchset[name].pos.y==pos.y and punchset[name].pos.z==pos.z then 
				minetest.chat_send_player(name, "MOVER: Punch something else. aborting.")
				punchset[name].state = 0;
				return 
			end
			
			punchset[name].pos11 = {x=pos.x,y=pos.y,z=pos.z};punchset[name].state = 3;
			machines.pos11[name] = {x=pos.x,y=pos.y,z=pos.z};
			machines.mark_pos11(name) -- mark pos11
			minetest.chat_send_player(name, "MOVER: Source2 position for mover set. Punch again to set target position.")
			return
		end
		
		if punchset[name].state == 3 then 
			if punchset[name].node~="basic_keypad:mover" then punchset[name].state = 0 return end
			local privs = minetest.get_player_privs(puncher:get_player_name());
			local elevator_mode = false;
			if	(punchset[name].pos.x == pos.x and punchset[name].pos.z == pos.z) or
				(punchset[name].pos.x == pos.x and punchset[name].pos.y == pos.y) or
				(punchset[name].pos.y == pos.y and punchset[name].pos.z == pos.z) then -- check if elevator mode
				local ecost = math.abs(punchset[name].pos.y-pos.y) + math.abs(punchset[name].pos.x-pos.x) + math.abs(punchset[name].pos.z-pos.z)
				if ecost>3 then -- trying to make elevator?

					local meta = minetest.get_meta(punchset[name].pos);
					if meta:get_string("mode")=="object" then -- only if object mode
						--count number of diamond blocks to determine if elevator can be set up with this height distance
						local inv = meta:get_inventory();
						local upgrade = 0;
						if inv:get_stack("upgrade", 1):get_name() == "default:diamondblock" then
							upgrade = (inv:get_stack("upgrade", 1):get_count()) or 0;
						end
						
						local requirement = math.floor(ecost/100)+1;
						if upgrade<requirement then
							minetest.chat_send_player(name, "MOVER: Error while trying to make elevator. Need at least "..requirement .. " diamond block(s) in upgrade (1 for every 100 distance). ");
							punchset[name].state = 0; return
						else
							elevator_mode=true;
							meta:set_int("upgrade",upgrade+1);
							meta:set_int("elevator",1);
							minetest.chat_send_player(name, "MOVER: elevator setup completed, upgrade level " .. upgrade);
							meta:set_string("infotext", "ELEVATOR, activate to use.")
						end
						
					end
				
				end
				
			end
			
			if not privs.privs and not elevator_mode and (math.abs(punchset[name].pos.x - pos.x)>range or math.abs(punchset[name].pos.y - pos.y)>range or math.abs(punchset[name].pos.z - pos.z)>range) then
				minetest.chat_send_player(name, "MOVER: Punch closer to mover. aborting.")
				punchset[name].state = 0; return
			end
			
			punchset[name].pos2 = {x=pos.x,y=pos.y,z=pos.z}; punchset[name].state = 0;
			machines.pos2[name] = punchset[name].pos2;machines.mark_pos2(name) -- mark pos2
			
			minetest.chat_send_player(name, "MOVER: End position for mover set.")
			
			local x0 = punchset[name].pos1.x-punchset[name].pos.x;
			local y0 = punchset[name].pos1.y-punchset[name].pos.y;
			local z0 = punchset[name].pos1.z-punchset[name].pos.z;
			local meta = minetest.get_meta(punchset[name].pos);
	
			
			local x1 = punchset[name].pos11.x-punchset[name].pos.x;
			local y1 = punchset[name].pos11.y-punchset[name].pos.y;
			local z1 = punchset[name].pos11.z-punchset[name].pos.z;
			
			
			local x2 = punchset[name].pos2.x-punchset[name].pos.x;
			local y2 = punchset[name].pos2.y-punchset[name].pos.y;
			local z2 = punchset[name].pos2.z-punchset[name].pos.z;

			if x0>x1 then x0,x1 = x1,x0 end -- this ensures that x0<=x1
			if y0>y1 then y0,y1 = y1,y0 end
			if z0>z1 then z0,z1 = z1,z0 end
			
			meta:set_int("x1",x1);meta:set_int("y1",y1);meta:set_int("z1",z1);
			meta:set_int("x0",x0);meta:set_int("y0",y0);meta:set_int("z0",z0);
			meta:set_int("x2",x2);meta:set_int("y2",y2);meta:set_int("z2",z2);
			
			meta:set_int("pc",0); meta:set_int("dim",(x1-x0+1)*(y1-y0+1)*(z1-z0+1))
			return
		end
	end
	
	-- KEYPAD
	if node.name == "basic_keypad:keypad" then -- keypad init/usage code
		
		local meta = minetest.get_meta(pos);
		if not (meta:get_int("x0")==0 and meta:get_int("y0")==0 and meta:get_int("z0")==0) then -- already configured
			check_keypad(pos,name)-- not setup, just standard operation
			punchset[name].state = 0;
			return;
		else
			if minetest.is_protected(pos, name) then return minetest.chat_send_player(name, "KEYPAD: You must be able to build to set up keypad.") end
			--if meta:get_string("owner")~= name then minetest.chat_send_player(name, "KEYPAD: Only owner can set up keypad.") return end
			if punchset[name].state == 0 then 
				minetest.chat_send_player(name, "KEYPAD: Now punch the target block.")
				punchset[name].node = node.name;punchset[name].pos = {x=pos.x,y=pos.y,z=pos.z};
				punchset[name].state = 1 
				return
			end
		end
	end
	
	if punchset[name].node=="basic_keypad:keypad" then -- keypad setup code

		if minetest.is_protected(pos,name) then
			minetest.chat_send_player(name, "KEYPAD: Punched position is protected. aborting.")
			punchset[name].node = "";
			punchset[name].state = 0; return
		end

		if punchset[name].state == 1 then 
			local meta = minetest.get_meta(punchset[name].pos);
			local x = pos.x-punchset[name].pos.x;
			local y = pos.y-punchset[name].pos.y;
			local z = pos.z-punchset[name].pos.z;
			if math.abs(x)>max_range or math.abs(y)>max_range or math.abs(z)>max_range then
					minetest.chat_send_player(name, "KEYPAD: Punch closer to keypad. reseting.")
					punchset[name].state = 0; return
			end
			
			machines.pos1[name] = pos;
			machines.mark_pos1(name) -- mark pos1
			
			meta:set_int("x0",x);meta:set_int("y0",y);meta:set_int("z0",z);	
			punchset[name].state = 0 
			minetest.chat_send_player(name, "KEYPAD: Keypad target set with coordinates " .. x .. " " .. y .. " " .. z)
			meta:set_string("infotext", "Punch keypad to use it.");
			return
		end
	end	
	
end)

-- FORM PROCESSING for all machines
minetest.register_on_player_receive_fields(function(player,formname,fields)
	
	-- KEYPAD
	fname = "basic_keypad:keypad_"
	
	if string.sub(formname,0,string.len(fname)) == fname then
		local pos_s = string.sub(formname,string.len(fname)+1); local pos = minetest.string_to_pos(pos_s)
		local name = player:get_player_name(); if name==nil then return end
		local meta = minetest.get_meta(pos)
		local privs = minetest.get_player_privs(player:get_player_name());
		if (minetest.is_protected(pos,name) and not privs.privs) or not fields then return end -- only builder can interact

		if fields.help then
			local text = "target : represents coordinates ( x, y, z ) relative to keypad. (0,0,0) is keypad itself, (0,1,0) is one node above, (0,-1,0) one node below. X coordinate axes goes from east to west, Y from down to up, Z from south to north."..
			"\n\nPassword: enter password and press OK. Password will be encrypted. Next time you use keypad you will need to enter correct password to gain access."..
				"\n\nrepeat: number to control how many times activation is repeated after initial punch"..

				"\n\ntext: if set then text on target node will be changed. In case target is detector/mover, filter settings will be changed. Can be used for special operations."..

				"\n\n1=OFF/2=ON/3=TOGGLE control the way how target node is activated"..

			"\n**************************************************\nusage\n"..

				"\nJust punch ( left click ) keypad, then the target block will be activated."..
				"\nTo set text on other nodes ( text shows when you look at node ) just target the node and set nonempty text. Upon activation text will be set. When target node is another keypad, its \"text\" field will be set. When targets is mover/detector, its \"filter\" field will be set. To clear \"filter\" set text to \"@\".  When target is distributor, you can change i-th target of distributor to mode mode with \"i mode\""..

				"\n\nkeyboard : to use keypad as keyboard for text input write \"@\" in \"text\" field and set any password. Next time keypad is used it will work as text input device."..

				"\n\ndisplaying messages to nearby players ( up to 5 blocks around keypad's target ): set text to \"!text\". Upon activation player will see \"text\" in their chat."..

				"\n\nplaying sound to nearby players : set text to \"$sound_name\""..

				"\n\nadvanced: "..
				"\ntext replacement : Suppose keypad A is set with text \"@some @. text @!\" and there are blocks on top of keypad A with infotext '1' and '2'. Suppose we target B with A and activate A. Then text of keypad B will be set to \"some 1. text 2!\""..
				"\nword extraction: Suppose similiar setup but now keypad A is set with text \"%1\". Then upon activation text of keypad B will be set to 1.st word of infotext";
			
			
			local form = "size [8,7] textarea[0,0.1;8.5,8.5;help;KEYPAD HELP;".. minetest.formspec_escape(text).."]"
			minetest.show_formspec(name, "basic_keypad:help_keypad", form)
			return
		end
		
		if fields.OK == "OK" then
			local x0,y0,z0,pass,mode;
			x0=tonumber(fields.x0) or 0;y0=tonumber(fields.y0) or 1;z0=tonumber(fields.z0) or 0
			pass = fields.pass or ""; mode = tonumber(fields.mode) or 1;
			
			if minetest.is_protected({x=pos.x+x0,y=pos.y+y0,z=pos.z+z0},name) then
				minetest.chat_send_player(name, "KEYPAD: position is protected. aborting.")
				return
			end
			
			if not privs.privs and (math.abs(x0)>max_range or math.abs(y0)>max_range or math.abs(z0)>max_range) then
				minetest.chat_send_player(name,"#keypad: all coordinates must be between ".. -max_range .. " and " .. max_range); return
			end
			meta:set_int("x0",x0);meta:set_int("y0",y0);meta:set_int("z0",z0);
			
			if fields.pass then
				if fields.pass~="" and string.len(fields.pass)<=16 then -- dont replace password with hash which is longer - 27 chars
					pass=minetest.get_password_hash(pos.x, pass..pos.y);pass=minetest.get_password_hash(pos.y, pass..pos.z);
					meta:set_string("pass",pass); 
				end
			end
			
			if fields.text then
				meta:set_string("text", fields.text);
				if string.find(fields.text, "!") then minetest.log("action", string.format("%s set up keypad for message display at %s", name, minetest.pos_to_string(pos))) end
			end
			
			meta:set_int("iter",math.min(tonumber(fields.iter) or 1,500));meta:set_int("mode",mode);
			meta:set_string("infotext", "Punch keypad to use it.");
			if pass~="" then 
				if fields.text~="@" then
					meta:set_string("infotext",meta:get_string("infotext").. ". Password protected."); 
				else
					meta:set_string("infotext","punch keyboard to use it."); 
				end
			end
			
		end
		return
	end
	
	fname = "basic_keypad:check_keypad_"
	if string.sub(formname,0,string.len(fname)) == fname then
		local pos_s = string.sub(formname,string.len(fname)+1); local pos = minetest.string_to_pos(pos_s)
		local name = player:get_player_name(); if name==nil then return end
		local meta = minetest.get_meta(pos)
	
		if fields.OK == "OK" then
			
			local pass;
			pass = fields.pass or "";
			
			if meta:get_string("text")=="@" then -- keyboard mode
				meta:set_string("input", pass);
				meta:set_int("count",1);
				use_keypad(pos,machines_TTL,0);
				return
			end
					
			
			pass=minetest.get_password_hash(pos.x, pass..pos.y);pass=minetest.get_password_hash(pos.y, pass..pos.z);
			
			if pass~=meta:get_string("pass") then
				minetest.chat_send_player(name,"ACCESS DENIED. WRONG PASSWORD.")
				return
			end
		minetest.chat_send_player(name,"ACCESS GRANTED.")
		
		if meta:get_int("count")<=0 then -- only accept new operation requests if idle
			meta:set_int("count",meta:get_int("iter")); 
			meta:set_int("active_repeats",0);
			use_keypad(pos,machines_TTL,0)
		else 
			meta:set_int("count",0); 
			meta:set_string("infotext","operation aborted by user. punch to activate.") -- reset
		end
		
		return
		end
	end
	
	
end)

-- CRAFTS --

minetest.register_craft({
	 output = "basic_keypad:keypad",
	 recipe = {
	 {"default:stick"},
	 {"default:wood"},
	}
})

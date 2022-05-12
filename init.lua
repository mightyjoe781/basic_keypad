-- BASIC_MACHINES: lightweight automation mod for minetest
-- minetest 0.4.14
-- (c) 2015-2016 rnd

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.


basic_keypad = {};

dofile(minetest.get_modpath("basic_keypad").."/mark.lua") -- used for markings, borrowed and adapted from worldedit mod
dofile(minetest.get_modpath("basic_keypad").."/mover.lua") -- mover, detector, keypad, distributor
dofile(minetest.get_modpath("basic_keypad").."/protect.lua") -- enable interaction with players, adds local on protect/chat event handling

print("[MOD] basic_keypad loaded")

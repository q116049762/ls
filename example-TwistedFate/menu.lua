--create root menu
--[[menu = UI.  (Game.localPlayer.charName,Game.localPlayer.displayName,2);

--create base menu
Champions.CreateBaseMenu(menu,2);

menu.QMenu = menu:AddMenu("Q", "Q");

menu.QMenu.autoQ = QMenu:AddCheckBox(("autoQ"), ("Auto Q"));
menu.QMenu.harassQ = QMenu:AddCheckBox(("harassQ"), ("Harass Q"));
menu.QMenu.onlyQImmobile = QMenu:AddCheckBox(("onlyQImmobile"), ("Only Q Immobile"));
menu.QMenu.farmQ = QMenu:AddCheckBox(("farmQ"), ("Farm Q"));
menu.QMenu.jungleQ = QMenu:AddCheckBox(("jungleQ"), ("Jungle Q"));


menu.WMenu = menu:AddMenu("W", "W");

menu.WMenu.autoW = WMenu:AddCheckBox(("autoW"), ("Auto W"));
menu.WMenu.harassW = WMenu:AddCheckBox(("harass"), ("Harass W"));
menu.WMenu.wGold = WMenu:AddKeyBind(("wGold"), ("Gold key"),87,false,false);
menu.WMenu.wBlue = WMenu:AddKeyBind(("Wblue"), ("Blue key"),69,false,false);
menu.WMenu.wRed = WMenu:AddKeyBind(("Wred"), ("RED key"),50,false,false);
menu.WMenu.blockAA = WMenu:AddCheckBox(("blockAA"), ("Block AA if seeking GOLD card"));
menu.WMenu.ignoreW = WMenu:AddCheckBox(("ignoreW"), ("Ignore first card"));
menu.WMenu.farmW = WMenu:AddCheckBox(("farmW"), ("Farm W"));
menu.WMenu.WredFarm = WMenu:AddSlider(("WredFarm"), ("LaneClear red card above % mana"),80);

--permashow
menu.WMenu.wGold:PermaShow(true,false);
menu.WMenu.wBlue:PermaShow(true,false);
menu.WMenu.wRed:PermaShow(true,false);

menu.RMenu = menu:AddMenu("R", "R");
menu.RMenu.useR = RMenu:AddKeyBind(("useR"), ("Semi-manual cast R key"),84,false,false);
menu.RMenu.autoR = RMenu:AddCheckBox(("autoR"), ("Auto R"));
menu.RMenu.Renemy = RMenu:AddSlider(("Renemy"), ("Don't R if enemy in x range"),1000,0,2000);
menu.RMenu.RenemyA = RMenu:AddSlider(("RenemyA"), ("Don't R if ally in x range near target"),800,0,2000);
menu.RMenu.turetR = RMenu:AddCheckBox(("turetR"), ("Don't R under turret"));
]]
return function ()
local charName = Game.localPlayer.charName;
local displayName = Game.localPlayer.displayName;
 
--print(MODULE_NAME);
--create root menu
local menu = UI.Menu.CreateMenu(charName,displayName,2);

--create base menu , we should clear later when unload.
Champions.CreateBaseMenu(menu,0);

local QMenu = menu:AddMenu("Q", "Q");

local autoQ = QMenu:AddCheckBox(("autoQ"), ("Auto Q"));
local harassQ = QMenu:AddCheckBox(("harassQ"), ("Harass Q"));
--local onlyQImmobile = QMenu:AddCheckBox(("onlyQImmobile"), ("Only Q Immobile"));
local farmQ = QMenu:AddCheckBox(("farmQ"), ("Farm Q"));
local jungleQ = QMenu:AddCheckBox(("jungleQ"), ("Jungle Q"));
local hitchanceQ=QMenu:AddList(("hitchanceQ"), ("QHitchance"), { ("Medium"), (("High")), (("VeryHigh(Slow)")) }, 1);
			

local WMenu = menu:AddMenu("W", "W");

local autoW = WMenu:AddCheckBox(("autoW"), ("Auto W"));
local harassW = WMenu:AddCheckBox(("harassW"), ("Harass W"));
local wGold = WMenu:AddKeyBind(("wGold"), ("Gold key"),87,false,false);
local wBlue = WMenu:AddKeyBind(("Wblue"), ("Blue key"),69,false,false);
local wRed = WMenu:AddKeyBind(("Wred"), ("Red key"),50,false,false);
local blockAA = WMenu:AddCheckBox(("blockAA"), ("Block AA if seeking GOLD card"));
local ignoreW = WMenu:AddCheckBox(("ignoreW"), ("Ignore first card"),false);
local farmW = WMenu:AddCheckBox(("farmW"), ("Farm W"));
local WredFarm = WMenu:AddSlider(("WredFarm"), ("LaneClear red card above % mana"),80);

--permashow
wGold:PermaShow(true,false);
wBlue:PermaShow(true,false);
wRed:PermaShow(true,false);

 
local RMenu = menu:AddMenu("R", "R");
local useR = RMenu:AddKeyBind(("useR"), ("Semi-manual cast R key"),84,false,false);
useR:PermaShow(true,false);
local autoR = RMenu:AddCheckBox(("autoR"), ("Auto R"));
local Renemy = RMenu:AddSlider(("Renemy"), ("Don't R if enemy in x range"),1000,0,2000);
local RenemyA = RMenu:AddSlider(("RenemyA"), ("Don't R if ally in x range near target"),800,0,2000);
local turetR = RMenu:AddCheckBox(("turetR"), ("Don't R under turret"));

Champions.CreateColorMenu(menu:AddMenu(("draw"), ("Drawing")),false);
return menu;
end




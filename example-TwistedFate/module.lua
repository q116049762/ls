--An simple example to show you how to write scripts with greatsharp c++ build in function.
--print("hello world from lua!");
--Evade.Reset();
--[[for i = 0, 4, 1 do
    local entry = Game.localPlayer:GetSpellEntry(i);
    if entry:IsValid() then
        print( entry:GetName())
        print( tostring(entry:DisplayRange()))
        entry:PrintTooltip(true)
        if i==2 then --for spell E
            --PrintChat('BonusDamage:'..entry:GetCalculateInfo(Game.localPlayer,Game.fnvhash("BonusDamage"),i)); --TwistedFate E damage
        end
    end
end
for i, v in Game.localPlayer.buffManager.buffs:pairs() do
   if v.isValid then
    print(v:GetName(),v.hash,v.leftTime,v.short,v.isPermanent,v.type)
   end
end
Evade.Debug.SetDebugConfiguration(true)



local entry = Game.localPlayer:GetSpellEntry(63);
if entry:IsValid() then
    print( entry:GetName())
    entry:PrintTooltip(false)
    --print('BonusDamage2:'..entry:GetCalculateInfo(Game.localPlayer,0x89DF6813,1));
    --PrintChat('PercentHealth1000Cuts:'..entry:GetCalculateInfo(Game.localPlayer,Game.fnvhash("PercentHealth1000Cuts"),63)); --TwistedFate E damage
  
end]]

if 3494766226 ~= Game.localPlayer.hash then --Game.HashStringSDBM("TwistedFate") == 3494766226
    return
end

--disable cpp champion script if need
Champions.CppScriptMaster(false)

-- Menu:
menu = Environment.LoadModule("menu")
local logic = Environment.LoadModule("logic")
 

 
local function init()
   

        --Manager Spell class pointer so we call use  Champions.Clean() when unload
        Champions.Q=(SDKSpell.Create(SpellSlot.Q,1400,DamageType.Magical))
        Champions.W=(SDKSpell.Create(SpellSlot.W,100,DamageType.Magical))
        Champions.E=(SDKSpell.Create(SpellSlot.E,1200,DamageType.Magical))
        Champions.R=(SDKSpell.Create (SpellSlot.R,5500,DamageType.Magical))
         
        Champions.Q:SetSkillshot(0.25,60,1000,SkillshotType.SkillshotLine,true,CollisionFlag.CollidesWithYasuoWall,HitChance.High,true)
        Champions.R:SetSkillshot(1,65,math.huge,SkillshotType.SkillshotCircle,false,CollisionFlag.CollidesWithNothing,HitChance.High,true)
       
    
        menu = menu();
    	logic();
     
        
       
    
end

init()

Callback.Bind(CallbackType.OnUnload,function ()
    Champions.Clean()--clean QWER Spell pointer , spell range dmobj
end)


--[[local function SetMana()
    if (Combo || Player->HPPercent() < 20)
				{
					QMANA = 0;
					WMANA = 0;
					EMANA = 0;
					RMANA = 0;
					return;
				}

				QMANA = Q->ManaCost();
				WMANA = W->ManaCost();
				EMANA = E->ManaCost();
				RMANA = R->ManaCost();
end]]


--[[Callback.Bind(CallbackType.OnObjectCreate,function (sender,nid)
    
    print(sender);
    print(sender.__name);
    print(sender:GetUniqueName());
end)]]
 
 
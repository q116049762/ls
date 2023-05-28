return function()

    local Player = Game.localPlayer;
    local lastPickTick = 0;
    local maunalCardTick = 0;
    local cardok = true;
    local maunalCard = false;
    local Q = Champions.Q;
    local W = Champions.W;
    local R = Champions.R;
    local pickacard_tracker = Game.fnvhash("pickacard_tracker")
    local destiny_marker = Game.fnvhash("destiny_marker")
    local gate = Game.fnvhash("gate")
    local PickACard = Game.fnvhash("PickACard")

    local cardName = {
        PickACard = 0,
        GoldCardLock = 1,
        BlueCardLock = 2,
        RedCardLock = 3
    }
    local currentCard = 0;
    local FindCard = 0;

    local function setMana()

        if (Champions.Combo or Player.hpPercent < 20) then
            Champions.QMANA = (0);
            Champions.WMANA = (0);
            Champions.EMANA = (0);
            Champions.RMANA = (0);
            return;
        end

        Champions.QMANA = (Q:ManaCost());
        Champions.WMANA = (W:ManaCost());
        Champions.EMANA = (0);
        Champions.RMANA = (R:ManaCost());
        if (not R:Ready()) then
            Champions.RMANA = (Champions.QMANA -
                                  Player.charIntermediate.primaryARRegenRateRep *
                                  Q:Cooldown());
        else
            Champions.RMANA = (R:ManaCost());
        end
    end
    local function LogicW()
        if menu.W.autoW.value then
            local t = TargetSelector.GetTarget(1100, DamageType.Magical);

            if not Player:FindBuff(pickacard_tracker) then
                if Game.GetTickCount() - W.lastCastAttempt > 300 and
                    Game.GetTickCount() - lastPickTick > 100 then
                    if (R:Ready() and
                        (Player:FindBuff(destiny_marker) or
                            Player:FindBuff(gate))) then
                        W:Cast();
                    elseif t and t:IsValidTarget() and Champions.Combo then
                        W:Cast();

                    else

                        local entity = Orbwalker:GetTarget();
                        if entity then
                            if entity.isHero and Champions.Harass and
                                menu.W.harassW.value then
                                W:Cast();
                            elseif Champions.CanSpellFarm() and
                                Champions.LaneClear and
                                (entity.isMinion or entity.isTurret) and
                                menu.W.farmW.value then
                                W:Cast();
                            end

                        end
                    end
                end

            else

                local cardtype = cardName[W:DataInstance():GetName()] or 0;

                if currentCard == 0 then
                    currentCard = cardtype;
                elseif cardtype ~= currentCard then
                    cardok = true;
                end

                if cardok then
                    local entity = Orbwalker:GetTarget();
                    if entity and not entity.isHero then
                        entity = nil;
                    end
                    if (R:Ready() and
                        (Player:FindBuff(destiny_marker) or
                            Player:FindBuff(gate))) then
                        FindCard = 1;
                        if cardtype == 1 then W:Cast(); end

                    elseif entity and Champions.Combo and entity:IsValidTarget() and
                        W:GetDamage(entity, 0) +
                        Player:GetAutoAttackDamage(entity) >
                        entity.magicalShield + entity.hp + entity.allShield then
                        W:Cast();
                    elseif Player.mp < Champions.RMANA + Champions.QMANA +
                        Champions.WMANA and Player.hpPercent > 30 then
                        FindCard = 2;
                        if cardtype == 2 then W:Cast(); end
                    elseif entity and Champions.Harass and
                        entity:IsValidTarget() then
                        FindCard = 1;
                        if cardtype == 1 then W:Cast(); end
                    elseif Player.mpPercent > menu.W.WredFarm.value and
                        Champions.CanSpellFarm() and menu.W.farmW.value then
                        FindCard = 3;
                        if cardtype == 3 then W:Cast(); end
                    elseif Champions.LaneClear and Player.mp < Champions.RMANA +
                        Champions.QMANA * 2 + Champions.WMANA and
                        menu.W.farmW.value then
                        FindCard = 2;
                        if cardtype == 2 then W:Cast(); end
                    elseif Champions.Combo then
                        FindCard = 1;
                        if cardtype == 1 then W:Cast(); end
                    elseif (Champions.LaneClear and not t) then
                        FindCard = 2;
                        if cardtype == 2 then W:Cast(); end
                    end
                end
            end
        end
    end
    local function LogicWmaunal()
        local t = TargetSelector.GetTarget(1100, DamageType.Magical);

        if not Player:FindBuff(pickacard_tracker) then
            if Game.GetTickCount() - W.lastCastAttempt > 300 and
                Game.GetTickCount() - lastPickTick > 100 then
                if (R:Ready() and
                    (Player:FindBuff(destiny_marker) or Player:FindBuff(gate))) then
                    FindCard = 1;
                    W:Cast();
                elseif menu.W.wGold.value then
                    maunalCard = true;
                    maunalCardTick = Game.GetTickCount();
                    FindCard = 1;
                    if menu.W.wGold.key ~= 87 then W:Cast(); end
                elseif menu.W.Wblue.value then
                    maunalCard = true;
                    maunalCardTick = Game.GetTickCount();
                    FindCard = 2;
                    W:Cast();
                elseif menu.W.Wred.value then
                    maunalCard = true;
                    maunalCardTick = Game.GetTickCount();
                    FindCard = 3;
                    W:Cast();
                end
            end

        else

            local cardtype = cardName[W:DataInstance():GetName()] or 0;

            if currentCard == 0 then
                currentCard = cardtype;
            elseif cardtype ~= currentCard then
                cardok = true;
            end

            if cardok then

                if (R:Ready() and
                    (Player:FindBuff(destiny_marker) or Player:FindBuff(gate))) then
                    FindCard = 1;
                    if cardtype == 1 then W:Cast(); end

                elseif FindCard == cardtype then
                    W:Cast();
                end
            end
        end
    end
    local function LogicQ()
        local t = TargetSelector.GetTarget(Q.range, DamageType.Magical);

        if not Champions.None and
            Q:CastSpecialImmobileTarget(Player.position, false, false) then
            return
        end
        if t and t:IsValidTarget(Q.range) then
            if Q:GetDamage(t) > t.totalHealth and
                not Orbwalker.IsInAutoAttackRange(Player, t) then -- KsQ
                Q:Cast(t, menu.Q.hitchanceQ)
            end
            local datainstance = W:DataInstance();
            if W:Level() == 0 or
                ((datainstance.timeCooldownOver - Game.GetTime() <
                    datainstance.cooldown - 1.3 and
                    not Player:FindBuff(pickacard_tracker) and
                    (datainstance.timeCooldownOver - Game.GetTime() > 3 or
                        Player.position:CountEnemiesInRange(950) == 0))) then -- 进来优先W定住再Q

                if (Champions.Combo and Player.mp > Champions.RMANA +
                    Champions.QMANA) then
                    Q:Cast(t, menu.Q.hitchanceQ)
                end
                if (Champions.Harass and Player.mp > Champions.RMANA +
                    Champions.QMANA + Champions.WMANA + Champions.EMANA and
                    menu.Q.harassQ.value and Champions.CanHarass()) then
                    Q:Cast(t, menu.Q.hitchanceQ)
                end
            end
            for k, entity in ObjectManager.enemyHeroes:pairs() do
                if entity:IsValidTarget(Q.range) and
                    not Champions.CanMove(entity, 0.1) and
                    Q:Cast(entity, menu.Q.hitchanceQ) then
                    return;
                end
            end
        elseif Champions.CanSpellFarm() then
            if menu.Q.farmQ.value then
                local bestTarget = nil;
                local health = math.huge
                for k, entity in ObjectManager.enemyLaneMinions:pairs() do
                    if entity:IsValidTarget(Q.range) and entity.hp < health then
                        health = entity.hp;
                        bestTarget = entity;
                    end
                end
                if (bestTarget) then
                    Q:Cast(bestTarget, menu.Q.hitchanceQ)
                    return;
                end
            end
            if menu.Q.jungleQ.value then
                local bestTarget = nil;
                local health = math.huge
                for k, entity in ObjectManager.jungleMinions:pairs() do
                    if entity:IsValidTarget(Q.range) and entity.hp < health then
                        health = entity.hp;
                        bestTarget = entity;
                    end
                end
                if (bestTarget) then
                    Q:Cast(bestTarget, menu.Q.hitchanceQ)
                    return;
                end
            end

        end
    end
    local function LogicR()
        if menu.R.useR.value then
            if Player:FindBuff(destiny_marker) then
                local t = TargetSelector.GetTarget(R.range, DamageType.Magical);
                if (t and t:IsValidTarget()) then
                    R:Cast(t)
                    return;
                end
            else
                R:Cast();
                return;
            end
        end

        if not menu.R.autoR.value then return; end
        if Player.position:CountEnemiesInRange(menu.R.Renemy.value) then
            local t = TargetSelector.GetTarget(R.range, DamageType.Magical);
            if (t and t:IsValidTarget(R.range) and
                t.position:Distance(Player.position) > Q.range and
                t.position:CountAlliesInRange(menu.R.RenemyA.value) == 0) then
                if Q:GetDamage(t) + W:GetDamage(t) +
                    Player:GetAutoAttackDamage(t) * 3 > t.totalHealth and
                    t.position:CountEnemiesInRange(1000) < 3 then
                    local rPos = R:GetPrediction(t).castPosition;
                    if (menu.R.turetR.value) then
                        if (not rPos:IsUnderEnemyTurret()) then
                            R:Cast(rPos);
                            return
                        end
                    else
                        R:Cast(rPos);
                    end
                end
            end
        end
    end
    local function ontick()
        if Champions.LagFree(0) then -- we don't need to run 'setMana' every tick,so we 
            setMana();
        end
        if menu then
            --[[
        local WSpell = Game.GetSpellByHash(Game.spelldataHash("PickACard")) --you can get spelldata by hash
    if WSpell then
        local sucusss,value = WSpell:GetCalculateInfo(Game.fnvhash("GoldBase"),W:DataInstance().level)
        print(value)
    end]]

            if Game.GetTickCount() - maunalCardTick > 3500 then
                maunalCard = false
            end
            if not menu.W.ignoreW.value then cardok = true; end
            if W:Ready() then
                if not maunalCard then LogicW(); end
                LogicWmaunal();
            elseif cardName[W:DataInstance():GetName()] == 0 then
                currentCard = 0;
                cardok = false;
            end

            if Champions.LagFree(1) and Q:Ready() and menu.Q.autoQ.value then
                LogicQ()
            end

            if R:Ready() then LogicR(); end

        end
    end

    Callback.Bind(CallbackType.OnTick, ontick)
    Callback.Bind(CallbackType.OnBeforeAttack, function()
        if Champions.Combo and W:Ready() and menu.W.blockAA.value and
            cardName[W:DataInstance():GetName()] ~= 0 and FindCard == 1 then
            return CallbackResult.Cancel;
        end
    end)

    Callback.Bind(CallbackType.OnChangeSlotSpellName,
                  function(entity, slot, newName)
        if entity.isMe and slot == SpellSlot.W and newName == "PickACard" then
            maunalCard = false;
        end
    end)

    Callback.Bind(CallbackType.OnSpellAnimationStart, function(entity, castargs)
        if entity.isMe and castargs.spell:GetName() == "PickACard" then
            lastPickTick = Game.GetTickCount();
        end
    end)

end

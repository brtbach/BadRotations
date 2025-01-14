local rotationName = "PangDisc"

-- Version: 1350-02-09-2020

local function createToggles()
    -- Cooldown Button
    local CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.divineStar},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.divineStar},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.divineStar}
    }
    br.ui:createToggle(CooldownModes,"Cooldown", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.powerWordBarrier},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.powerWordBarrier}
    }
    br.ui:createToggle(DefensiveModes,"Defensive", 2, 0)
    -- Decurse Button
    local DecurseModes = {
        [1] = {mode = "On", value = 1, overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purify},
        [2] = {mode = "Off", value = 2, overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purify}
    }
    br.ui:createToggle(DecurseModes,"Decurse", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.psychicScream},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.psychicScream}
    }
    br.ui:createToggle(InterruptModes,"Interrupt", 4, 0)
    local BurstModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Auto Ramp Enabled", tip = "Will Automatically Ramp based on DBM", highlight = 1, icon = br.player.spell.powerWordShield},
        [2] = {mode = "Hold", value = 2, overlay = "Ramp Disabled", tip = "No Ramp Logic.", highlight = 0, icon = br.player.spell.powerWordShield}
    }
    br.ui:createToggle(BurstModes,"Burst", 0, -1)
end

local function createOptions()
    local optionTable

    local function generalOptions()
        -------------------------
        -------- UTILITY --------
        -------------------------
        local section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createCheckbox(section, "Enemy Target Lock")
        br.ui:createSpinner(section, "Heal OoC", 90, 1, 100, 1, "Set OoC HP value to heal.")
        br.ui:createCheckbox(section, "Power Word: Fortitude", "Maintain Fort Buff on Group")
        br.ui:createDropdown(section, "Dispel Magic", {"Only Target", "Auto"}, 1, "Dispel Target or Auto")
        br.ui:createDropdown(section, "Oh shit need heals", br.dropOptions.Toggle, 1, "Ignore dps limit")
        br.ui:createSpinner(section, "Body and Soul", 2, 0, 100, 1, "Movement (seconds) before Body and Soul")
        br.ui:createSpinner(section, "Angelic Feather", 2, 0, 100, 1, "Movement (seconds) before Feather")
        br.ui:createSpinner(section, "Fade", 95, 0, 100, 1, "Health to cast Fade if agro")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Shining Force - Int")
        br.ui:createCheckbox(section, "Psychic Scream - Int")
        if br.player.race == "Pandaren" then
            br.ui:createCheckbox(section, "Quaking Palm - Int")
        end
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "Cast Percent to Cast At. Default: 0")
        br.ui:checkSectionState(section)
    end

    local function healingOptions()
        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
        --Atonement
        br.ui:createCheckbox(section, "Obey Atonement Limits")
        br.ui:createCheckbox(section, "Obey Atonement Limits During Rapture")
        br.ui:createSpinnerWithout(section, "Tank Atonement HP", 95, 0, 100, 1, "Apply Atonement to Tank using Power Word: Shield and Power Word: Radiance. Health Percent to Cast At. Default: 95")
        br.ui:createSpinnerWithout(section, "Party Atonement HP", 95, 0, 100, 1, "Apply Atonement using Power Word: Shield and Power Word: Radiance. Health Percent to Cast At. Default: 95")
        br.ui:createSpinnerWithout(section, "Max Atonements", 3, 1, 40, 1, "Max Atonements to Keep Up At Once. Default: 3")
        br.ui:createDropdown(section, "Atonement Key", br.dropOptions.Toggle, 6, "Set key to press to spam atonements on everyone.")
        br.ui:createSpinner(section, "Heal Counter", 1, 1, 5, 1, "How many Heals to check before damaging")
        br.ui:createSpinner(section, "Shadow Mend", 65, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Penance Heal", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Pain Suppression Tank", 30, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Pain Suppression Party", 30, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section,"Revitalizing Voodoo Totem - Tank",30, 0, 100, 5 )
        br.ui:createSpinner(section,"Revitalizing Voodoo Totem - Party",30, 0, 100, 5 )
        if br.player.level < 28 then
            br.ui:createSpinner(section, "Low Level Flash Heal",60, 0, 100, 5)
        end

        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
        --Power Word: Radiance
        br.ui:createSpinner(section, "Power Word: Radiance", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "PWR Targets", 3, 0, 40, 1, "Minimum PWR Targets")
        --Shadow Covenant
        br.ui:createSpinner(section, "Shadow Covenant", 85, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Shadow Covenant Targets", 4, 0, 40, 1, "Minimum Shadow Covenant Targets")
        br.ui:checkSectionState(section)
    end
    local function damageOptions()
        -------------------------
        ----- DAMAGE OPTIONS ----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Damage")
        br.ui:createSpinnerWithout(section, "Damage Mana Threshold")
        br.ui:createCheckbox(section, "Shadow Word: Pain/Purge The Wicked")
        br.ui:createSpinnerWithout(section, "SW:P/PtW Targets", 3, 0, 20, 1, "Maximum SW:P/PtW Targets")
        br.ui:createCheckbox(section, "Schism")
        br.ui:createCheckbox(section, "Penance")
        br.ui:createCheckbox(section, "Power Word: Solace")
        br.ui:createCheckbox(section, "Mind Blast")
        br.ui:createCheckbox(section, "Smite")
        br.ui:createSpinner(section, "Mind Sear - AoE", 3, 1, 50, 1, "Number of Units to cast Mind Sear")
        br.ui:createSpinner(section, "Mind Sear - AoE - High Prio", 3, 1, 50, 1, "Number of Units to cast Mind Sear")
        br.ui:createSpinnerWithout(section, "Mind Sear - HP Cutoff", 80, 0 ,100, 5, "Lowest friendly HP to channel Sear")
        br.ui:createCheckbox(section, "SHW: Death Snipe")
        br.ui:createSpinner(section, "Mindbender", 80, 0, 100, 5, "Mana Percent to Cast At")
        br.ui:createSpinner(section, "Shadowfiend", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:checkSectionState(section)
    end
    local function cooldownOptions()
        -------------------------
        ------- COOLDOWNS -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        --Rapture when get Innervate
        br.ui:createCheckbox(section, "Rapture when get Innervate", "Auto Rapture when Innervated")
        --Rapture
        br.ui:createCheckbox(section, "Auto Rapture", "Auto Use Rapture based on DBM")
        br.ui:createSpinner(section, "Rapture", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Rapture Targets", 3, 0, 40, 1, "Minimum Rapture Targets")
        --Evangelism
        br.ui:createSpinner(section, "Evangelism", 70, 0, 100, 1, "Health Percent to Cast At")
        br.ui:createCheckbox(section, "Evangelism Ramp")
        br.ui:createSpinnerWithout(section, "Evangelism Targets", 3, 0, 40, 1, "Target count to Cast At")
        br.ui:createSpinnerWithout(section, "Atonement for Evangelism", 3, 0, 40, 1, "Minimum Atonement count to Cast At")
        br.ui:checkSectionState(section)
    end
    local function defenseOptions()
        -------------------------
        ------- DEFENSIVE -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Desperate Prayer", 40, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Pot / Healthstone", 35, 0, 100, 5, "Health Percent to Cast At")
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "Health Percent to Cast At")
        end
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "General",
            [2] = generalOptions
        },
        {
            [1] = "Healing",
            [2] = healingOptions
        },
        {
            [1] = "Damage",
            [2] = damageOptions
        },
        {
            [1] = "Cooldowns",
            [2] = cooldownOptions
        },
        {
            [1] = "Defensive",
            [2] = defenseOptions
        }
    }
    return optionTable
end

local function runRotation()
    local buff = br.player.buff
    local cast = br.player.cast
    local combatTime = br.getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local debuff = br.player.debuff
    local drinking = br.getBuffRemain("player", 274914) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or br.getBuffRemain("player", 192001) ~= 0
	local enemies = br.player.enemies
    local essence = br.player.essence
    local falling, swimming, flying, moving = br.getFallTime(), IsSwimming(), IsFlying(), br._G.GetUnitSpeed("player") > 0
    local freeMana = buff.innervate.exists() or buff.symbolOfHope.exists()
    local friends = friends or {}
    local gcd = br.player.gcd
    local gcdMax = br.player.gcdMax
    local healPot = br.getHealthPot()
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local lastSpell = br.lastSpellCast
    local level = br.player.level
    local lootDelay = br.getOptionValue("LootDelay")
    local lowest = br.friend[1]
    local mana = br.getMana("player")
    local mode = br.player.ui.mode
    local perk = br.player.perk
    local php = br.player.health
    local power, powmax, powgen = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
    local pullTimer = br.DBM:getPulltimer()
    local race = br.player.race
    local racial = br.player.getRacial()
    local solo = #br.friend == 1
    local spell = br.player.spell
    local tanks = br.getTanksTable()
    local talent = br.player.talent
    local ttd = br.getTTD
    local traits = br.player.traits
    local ttm = br.player.power.mana.ttm()
    local units = br.player.units
    local schismCount = debuff.schism.count()

    if br.timersTable then
        wipe(br.timersTable)
    end

    units.get(5)
    units.get(30)
    units.get(40)
    enemies.get(24)
    enemies.get(30)
    enemies.get(40)
    friends.yards40 = br.getAllies("player", 40)

    local atonementCount = br.player.buff.atonement.count()
    local schismBuff
    local ptwDebuff
    local deathnumber = tonumber((select(1, GetSpellDescription(32379):match("%d+"))), 10)

    local biggestGroup = 0
    local bestUnit
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        local thisGroup = #enemies.get(10,thisUnit)
        local targetGroup = #enemies.get(10,"target")

        if thisGroup > biggestGroup then
            biggestGroup = thisGroup
            bestUnit = thisUnit
        end
        if targetGroup == biggestGroup then
            biggestGroup = targetGroup
            bestUnit = "target"
        end
    end

    if br.isChecked("Enemy Target Lock") and inCombat then
        if br._G.UnitIsFriend("target", "player") or br.GetUnitIsDeadOrGhost("target") or not br.GetUnitExists("target") or br._G.UnitIsPlayer("target") then
            br._G.TargetLastEnemy()
        end
    end

    -- set penance target
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if debuff.schism.exists("target") and ttd("target") > 4 and br.getFacing("player","target")then
            schismBuff = "target"
        elseif debuff.schism.exists(thisUnit) and not br._G.UnitIsOtherPlayersPet(thisUnit) and ttd(thisUnit) > 4 and br.getFacing("player",thisUnit) then
            schismBuff = thisUnit
        end
        if schismBuff == nil then 
            if debuff.purgeTheWicked.exists("target") and ttd("target") > 4 and br.getFacing("player","target") then
                ptwDebuff = "target"
            elseif debuff.purgeTheWicked.exists(thisUnit) and not br._G.UnitIsOtherPlayersPet(thisUnit) and ttd(thisUnit) > 4 and br.getFacing("player",thisUnit)then
                ptwDebuff = thisUnit
            end
        end
    end

    local function atoneCount()
        notAtoned = 0
        for i = 1, #br.friend do
            thisUnit = br.friend[1].unit
            if not buff.atonement.exists(thisUnit) then
                notAtoned = notAtoned + 1
            end
        end
        return notAtoned
    end

    local current
    local function ptwTargets()
        current = 0
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if debuff.purgeTheWicked.exists(thisUnit) or debuff.shadowWordPain.exists(thisUnit) then
                current = current + 1
            end
        end
        return current
    end

    ---------------------
    ----- APL LISTS -----
    ---------------------
    local function Interruptstuff()
        if br.useInterrupts() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                    if br.isChecked("Shining Force - Int") and br.getDistance(thisUnit) < 40 then
                        if cast.shiningForce() then
                            return
                        end
                    end
                    if br.isChecked("Psychic Scream - Int") and br.getDistance(thisUnit) < 8 then
                        if cast.psychicScream() then
                            return
                        end
                    end
                    if br.isChecked("Quaking Palm - Int") and br.getDistance(thisUnit) < 5 then
                        if cast.quakingPalm(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
    end

    local function DefensiveTime()
        if br.useDefensive() then
            if br.isChecked("Fade") then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) > 1 and br._G.UnitAffectingCombat(thisUnit) then
                        if cast.fade() then
                            return
                        end
                    end
                end
            end
            if br.isChecked("Pot / Healthstone") and php <= br.getOptionValue("Pot / Healthstone") and inCombat and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(166799)) then
                if br.canUseItem(5512) then
                    br.useItem(5512)
                elseif br.canUseItem(healPot) then
                    br.useItem(healPot)
                elseif br.hasItem(166799) and br.canUseItem(166799) then
                    br.useItem(166799)
                end
            end
            -- Gift of the Naaru
            if br.isChecked("Gift of the Naaru") and php <= br.getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                if cast.giftOfTheNaaru() then
                    return
                end
            end
            if br.isChecked("Desperate Prayer") and php <= br.getOptionValue("Desperate Prayer") then
                if cast.desperatePrayer() then
                    return
                end
            end
        end
    end

    local function CooldownTime()
        if br.useCDs() then
            -- Pain Suppression
            if br.isChecked("Pain Suppression Tank") and inCombat then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= br.getValue("Pain Suppression Tank") and br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                        if cast.painSuppression(br.friend[i].unit) then
                            return
                        end
                    end
                end
            end
            if br.isChecked("Pain Suppression Party") and inCombat then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= br.getValue("Pain Suppression Tank") then
                        if cast.painSuppression(br.friend[i].unit) then
                            return
                        end
                    end
                end
            end
            if br.isChecked("Rapture when get Innervate") and freeMana then
                if cast.rapture() then
                    return
                end
            end
            for i = 1, #br.friend do
                if br.isChecked("Revitalizing Voodoo Totem - Tank") and br.hasEquiped(158320) and br.friend[i].hp <= br.getValue("Revitalizing Voodoo Totem - Tank") and br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                    if GetItemCooldown(158320) <= gcdMax then
                        br._G.UseItemByName(158320, lowest.unit)
                        br.addonDebug("Using Revitalizing Voodoo Totem")
                    end
                end
            end
            if br.isChecked("Revitalizing Voodoo Totem - Party") and br.hasEquiped(158320) and lowest.hp < br.getValue("Revitalizing Voodoo Totem - Party") or br.getValue("Revitalizing Voodoo Totem - Party") == 100 then
                if GetItemCooldown(158320) <= gcdMax then
                    br._G.UseItemByName(158320, lowest.unit)
                    br.addonDebug("Using Revitalizing Voodoo Totem")
                end
            end
            if br.isChecked("Rapture") then
                if br.getLowAllies(br.getValue("Rapture")) >= br.getValue("Rapture Targets") then
                    if cast.rapture() then
                        return
                    end
                end
            end
            if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") or (mana >= 30 and race == "BloodElf") then
                if race == "LightforgedDraenei" then
                    if cast.racial("target", "ground") then
                        return
                    end
                else
                    if cast.racial("player") then
                        return
                    end
                end
            end
        end
    end

    local function Dispelstuff()
        if mode.decurse == 1 then
            if br.isChecked("Dispel Magic") then
                if br.getOptionValue("Dispel Magic") == 1 then
                    if br.canDispel("target", spell.dispelMagic) and br.GetObjectExists("target") then
                        if cast.dispelMagic("target") then
                            br.addonDebug("Casting Dispel Magic")
                            return
                        end
                    end
                elseif br.getOptionValue("Dispel Magic") == 2 then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        if br.canDispel(thisUnit, spell.dispelMagic) then
                            if cast.dispelMagic(thisUnit) then
                                br.addonDebug("Casting Dispel Magic")
                                return
                            end
                        end
                    end
                end
            end
            --Purify
            for i = 1, #br.friend do
                if br.canDispel(br.friend[i].unit, spell.purify) then
                    if cast.purify(br.friend[i].unit) then
                        return
                    end
                end
            end
        end
    end

    local function Extrastuff()
        if br.IsMovingTime(br.getOptionValue("Angelic Feather")) and not IsSwimming() then
            if not runningTime then
                runningTime = GetTime()
            end
            if br.isChecked("Angelic Feather") and talent.angelicFeather and (not buff.angelicFeather.exists("player") or GetTime() > runningTime + 5) then
                if cast.angelicFeather("player") then
                    runningTime = GetTime()
                    br._G.SpellStopTargeting()
                end
            end
        end
        if br.IsMovingTime(br.getOptionValue("Body and Soul")) then
            if bnSTimer == nil then
                bnSTimer = GetTime() - 6
            end
            if br.isChecked("Body and Soul") and talent.bodyAndSoul and not buff.bodyAndSoul.exists("player") and GetTime() >= bnSTimer + 6 then
                if cast.powerWordShield("player") then
                    bnSTimer = GetTime()
                    return
                end
            end
        end
        if br.isChecked("Power Word: Fortitude") and br.timer:useTimer("PW:F Delay", math.random(20, 50)) then
            for i = 1, #br.friend do
                if not buff.powerWordFortitude.exists(br.friend[i].unit, "any") and br.getDistance("player", br.friend[i].unit) < 40 and not br.GetUnitIsDeadOrGhost(br.friend[i].unit) then
                    if cast.powerWordFortitude() then
                        return
                    end
                end
            end
        end
    end

    local function Keyshit()
        if (br.SpecificToggle("Atonement Key") and not GetCurrentKeyBoardFocus()) and br.isChecked("Atonement Key") then
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                if not buff.atonement.exists(thisUnit) then
                    if atoneCount() >= br.getOptionValue("Minimum PWR Targets") and not br.isMoving("player") and charges.powerWordRadiance.frac() >= 1 and level >= 23 then
                        if cast.powerWordRadiance(thisUnit) then 
                            return true
                        end
                    elseif atonementCount <= br.getOptionValue("Atonement for Evangelism") or (charges.powerWordRadiance.frac() < 1 or level < 23) and not debuff.weakenedSoul.exists(thisUnit) then
                        if cast.powerWordShield(thisUnit) then
                            return true
                        end
                    end
                end
                if br.useCDs() and br.isChecked("Evangelism Ramp") and atonementCount >= br.getOptionValue("Atonement for Evangelism") and (charges.powerWordRadiance.count() == 0 or atoneCount() <= br.getOptionValue("Minimum PWR Targets")) then
                    if cast.evangelism() then
                        br._G.RunMacroText("/br toggle burst 1")
                        return true
                    end
                end
            end
        end
    end

    local function HealingTime()
        if buff.rapture.exists("player") then
            if br.isChecked("Obey Atonement Limits During Rapture") then
                for i = 1, #br.friend do
                    if atonementCount < br.getValue("Max Atonements") or (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                        if br.getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                            if cast.powerWordShield(br.friend[i].unit) then
                                return true
                            end
                        end
                    end
                    if atonementCount >= br.getValue("Max Atonements") then
                        if cast.powerWordShield(lowest.unit) then
                            return true
                        end
                    end
                end
            else
                for i = 1, #br.friend do
                    if not buff.atonement.exists(br.friend[i].unit) and br.getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                        if cast.powerWordShield(br.friend[i].unit) then
                            return true
                        end
                    end
                end
                for i = 1, #br.friend do
                    if br.getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                        if cast.powerWordShield(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end

        if br.isChecked("Evangelism") and talent.evangelism and (atonementCount >= br.getValue("Atonement for Evangelism") or (not inRaid and atonementCount >= 3)) and not buff.rapture.exists("player") then
            if br.getLowAllies(br.getValue("Evangelism")) >= br.getValue("Evangelism Targets") then
                if cast.evangelism() then
                    return true
                end
            end
        end

        if br.isChecked("Power Word: Radiance") and atoneCount() >= 2 and not cast.last.powerWordRadiance() and mode.burst ~= 2 then
            if charges.powerWordRadiance.count() >= 1 then
                if br.getLowAllies(br.getValue("Power Word: Radiance")) >= br.getValue("PWR Targets") then
                    for i = 1, #br.friend do
                        if not buff.atonement.exists(br.friend[i].unit) and br.friend[i].hp <= br.getValue("Power Word: Radiance") and not br.isMoving("player") then
                            if cast.powerWordRadiance(br.friend[i].unit) then
                                return true
                            end
                        end
                    end
                end
            end
        end

        if br.isChecked("Shadow Covenant") and talent.shadowCovenant then
            if br.getLowAllies(br.getValue("Shadow Covenant")) >= br.getValue("Shadow Covenant Targets") then
                if cast.shadowCovenant(lowest.unit) then
                    return true
                end
            end
        end

        if (br.isChecked("Penance Heal") and talent.contrition and atonementCount >= 3) or (br.isChecked("Heal OoC") and not inCombat and lowest.hp <= br.getOptionValue("Heal OoC")) or (level < 28 and lowest.hp < br.getOptionValue("Penance Heal")) then
            if cast.penance(lowest.unit) then
                return true
            end
        end

        if br.isChecked("Shadow Mend") and not br.isMoving("player") then
            for i = 1, #br.friend do
                if (br.friend[i].hp <= br.getValue("Shadow Mend") and (not buff.atonement.exists(br.friend[i].unit) or br.player.instance ~= "raid")) or 
                (br.isChecked("Heal OoC") and not inCombat and lowest.hp <= br.getOptionValue("Heal OoC")) then
                    if cast.shadowMend(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end

        for i = 1, #tanks do
            if (tanks[i].hp <= br.getOptionValue("Tank Atonement HP") or br.getValue("Tank Atonement HP") == 100) and not buff.atonement.exists(tanks[i].unit) and not debuff.weakenedSoul.exists(tanks[i].unit) then
                if cast.powerWordShield(tanks[i].unit) then
                    return true
                end
            end
        end

        for i = 1, #br.friend do
            if (br.friend[i].hp <= br.getOptionValue("Party Atonement HP") or br.getOptionValue("Party Atonement HP") == 100) 
                and not debuff.weakenedSoul.exists(br.friend[i].unit) and not buff.atonement.exists(br.friend[i].unit) 
                and (atonementCount < br.getOptionValue("Max Atonements") or not br.isChecked("Obey Atonement Limits")) then
                if cast.powerWordShield(br.friend[i].unit) then
                    return true
                end
            end
        end

        if level < 28 then
            for i = 1, #br.friend do
                if br.isChecked("Low Level Flash Heal") and br.friend[i].hp <= br.getOptionValue("Low Level Flash Heal") then
                    if cast.flashHeal(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
    end

    local function DamageTime()
        if br.isChecked("Mind Sear - AoE - High Prio") and not cast.current.mindSear() then
            if biggestGroup >= br.getOptionValue("Mind Sear - AoE - High Prio") and lowest.hp > br.getOptionValue("Mind Sear - HP Cutoff") then
                if cast.mindSear(bestUnit) then return true end
            end
        end

        if br.isChecked("Power Word: Solace") and talent.powerWordSolace then
            if schismBuff ~= nil and br.getFacing("player",schismBuff) then
                if cast.powerWordSolace(schismBuff) then
                    return
                end
            elseif schismBuff == nil then
                if cast.powerWordSolace(units.dyn40) then
                    return
                end
            end
        end
        if br.isChecked("SHW: Death Snipe") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (br.getHP(thisUnit) <= 20) or br._G.UnitHealth(thisUnit) <= deathnumber then
                    if cast.shadowWordDeath(thisUnit) then
                        return 
                    end
                end
            end
        end
        if br.isChecked("Shadow Word: Pain/Purge The Wicked") and (br.getSpellCD(spell.penance) > gcdMax or (br.getSpellCD(spell.penance) <= gcdMax and debuff.purgeTheWicked.count() == 0)) then
            if talent.purgeTheWicked then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if ptwTargets() < br.getValue("SW:P/PtW Targets")  then
                        if not debuff.purgeTheWicked.exists("target") and ttd("target") > 6 then
                            if cast.purgeTheWicked("target") then
                                return 
                            end
                        elseif debuff.purgeTheWicked.remain(thisUnit) < 6 and not br._G.UnitIsOtherPlayersPet(thisUnit) and ttd(thisUnit) > 6 then
                            if cast.purgeTheWicked(thisUnit) then
                                return
                            end
                        end
                    end
                end
            end
            if not talent.purgeTheWicked and cd.penance.remains() > gcd then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if ptwTargets() < br.getValue("SW:P/PtW Targets") then
                        if not debuff.shadowWordPain.exists("target") and ttd("target") > 6 then
                            if cast.shadowWordPain("target") then
                                return 
                            end
                        elseif debuff.shadowWordPain.remain(thisUnit) < 4.8 and not br._G.UnitIsOtherPlayersPet(thisUnit) and ttd(thisUnit) > 6 then
                            if cast.shadowWordPain(thisUnit) then
                                return
                            end
                        end
                    end
                end
            end
        end

        -- Mindbender
        if br.isChecked("Mindbender") and mana <= br.getValue("Mindbender") and atonementCount >= 3 and talent.mindbender then
            if schismBuff ~= nil then
                if cast.mindbender(schismBuff) then
                    return
                end
            elseif cast.mindbender() then
               return
            end
        end
        -- Shadowfiend
        if br.isChecked("Shadowfiend") and not talent.mindbender and atonementCount >= 3 then
            if schismBuff ~= nil then
                if cast.shadowfiend(schismBuff) then
                   return
                end
            elseif cast.shadowfiend() then
                return
            end
        end

        if talent.schism and br.isChecked("Schism") and cd.penance.remain() <= gcdMax + 1 and not br.isMoving("player") and ttd(units.dyn40) > 9 and not br.isExplosive(units.dyn40) then
            if cast.schism(units.dyn40) then
                return
            end
        end

        if br.isChecked("Penance") then
            if schismBuff ~= nil and br.getFacing("player",schismBuff) then
                if cast.penance(schismBuff) then
                    return
                end
            elseif ptwDebuff ~= nil and schismBuff == nil and br.getFacing("player",ptwDebuff)then
                if cast.penance(ptwDebuff) then
                    return
                end
            elseif (not schismBuff or ptwDebuff) and ttd(units.dyn40) > 2.5 then
                if cast.penance(units.dyn40) then
                   return
                end
            end
        end

        if essence.concentratedFlame.active and br.getSpellCD(295373) <= gcd then
            if br.getLineOfSight(units.dyn40) and br.getDistance(units.dyn40) <= 40 then
                if cast.concentratedFlame(units.dyn40) then
                    return true
                end
            end
        end

        if br.isChecked("Mind Sear - AoE") and not cast.current.mindSear() then
            if biggestGroup >= br.getOptionValue("Mind Sear - AoE") and lowest.hp > br.getOptionValue("Mind Sear - HP Cutoff") then
                if cast.mindSear(bestUnit) then return end
            end
        end


        if br.isChecked("Mind Blast") and not br.isMoving("player") then
            if schismBuff ~= nil and br.getFacing("player",schismBuff) then
                if cast.mindBlast(schismBuff) then
                    return
                end
            elseif cast.mindBlast(units.dyn40) then
                return
            end
        end

        if br.isChecked("Smite") and not br.isMoving("player") and not cast.current.mindSear() then
            if schismBuff ~= nil and br.getFacing("player",schismBuff) then
                if cast.smite(schismBuff) then
                    return
                end
            elseif cast.smite(units.dyn40) then
                return
            end
        end
    end
 
    local localHealingCount = br.discHealCount
    ------------------------------
    ------- Start the Stuff ------
    if br.pause(true) or drinking or br.isLooting() or (biggestGroup >= br.getOptionValue("Mind Sear - AoE - High Prio") and cast.current.mindSear()) or cast.current.penance() then
        return true
    else
        if not inCombat then
            if br.isChecked("Heal OoC") then
                if HealingTime() then return true end
            end
            if Extrastuff() then return end
            if Dispelstuff() then return end
            if Keyshit() then return true end
        elseif inCombat then
            if Dispelstuff() then return end
            if Interruptstuff() then return end
            if DefensiveTime() then return end
            if CooldownTime() then return end
            if Keyshit() then return true end
            if localHealingCount < br.getOptionValue("Heal Counter") or not br.isChecked("Heal Counter") or #enemies.yards40 == 0 or buff.rapture.exists("player") or br.SpecificToggle("Oh shit need heals") then
                if HealingTime() then return true end
            end
            if Extrastuff() then return end
            if DamageTime() then return end
        end
    end
end

local id = 256
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)

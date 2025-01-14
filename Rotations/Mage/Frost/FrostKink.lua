local rotationName = "Kink"
local rotationVer  = "v1.2.7"
local colorBlue     = "|cff3FC7EB"
local colorWhite = "|cffffffff"
local targetMoveCheck, opener, fbInc = false, false, false
local lastTargetX, lastTargetY, lastTargetZ
local ropNotice = false
local lastIF = 0
local if5Start, if5End = 0, 0

-- Credit to Fiskee for the basis of this rotation, and a special thanks to Adspirit for his edits that made this rotation what it is currently. 

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.frozenOrb},
        [2] = {mode = "Sing", value = 2, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.frostbolt},
    }
    br.ui:createToggle(RotationModes,"Rotation", 1, 0)

    -- Cooldown Button
    local CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.icyVeins},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.icyVeins},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.frostbolt},
        [4] = {mode = "Lust", value = 4, overlay = "Cooldowns With Lust", tip = "Cooldowns will be used with bloodlust or simlar effects.", highlight = 0, icon = br.player.spell.icyVeins}
    }
    br.ui:createToggle(CooldownModes,"Cooldown", 2, 0)

    -- Defensive Button
    local DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceBarrier},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceBarrier}
    }
    br.ui:createToggle(DefensiveModes,"Defensive", 3, 0)

    -- Interrupt Button
    local InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterspell}
    }
    br.ui:createToggle(InterruptModes,"Interrupt", 4, 0)

    -- Frozen Orb Button
    local FrozenOrbModes = {
        [1] = {mode = "On", value = 1, overlay = "Auto FO Enabled", tip = "Will Automatically use Frozen Orb", highlight = 1, icon = br.player.spell.frozenOrb},
        [2] = {mode = "Off", value = 2, overlay = "Auto FO Disabled", tip = "Will not use Frozen Orb", highlight = 0, icon = br.player.spell.frozenOrb}
    }
    br.ui:createToggle(FrozenOrbModes,"FrozenOrb", 5, 0)

    -- Ebonbolt Button
    local EbonboltModes = {
        [1] = {mode = "On", value = 1, overlay = "Ebonbolt Enabled", tip = "Will use Ebonbolt", highlight = 1, icon = br.player.spell.ebonbolt},
        [2] = {mode = "Off", value = 2, overlay = "Ebonbolt Disabled", tip = "Will not use Ebonbolt", highlight = 0, icon = br.player.spell.ebonbolt}
    }
    br.ui:createToggle(EbonboltModes,"Ebonbolt", 6, 0)

    -- Comet Storm Button
    local CometStormModes = {
        [1] = {mode = "On", value = 1, overlay = "Comet Storm Enabled", tip = "Will use Comet Storm", highlight = 1, icon = br.player.spell.cometStorm},
        [2] = {mode = "Off", value = 2, overlay = "Comet Storm Disabled", tip = "Will not use Comet Storm", highlight = 0, icon = br.player.spell.cometStorm}
    }
    br.ui:createToggle(CometStormModes,"CometStorm", 7, 0)

    -- Cone of Cold Button
    local ConeOfColdModes = {
        [1] = {mode = "On", value = 1, overlay = "Cone Of Cold Enabled", tip = "Will use Cone Of Cold", highlight = 1, icon = br.player.spell.coneOfCold},
        [2] = {mode = "Off", value = 2, overlay = "Cone Of Cold Disabled", tip = "Will not use Cone Of Cold", highlight = 0, icon = br.player.spell.coneOfCold}
    }
    br.ui:createToggle(ConeOfColdModes,"ConeOfCold", 1, 1)

    -- Fire Blast Button
    local FireBlastModes = {
        [1] = {mode = "On", value = 1, overlay = "Fire Blast Enabled", tip = "Will use Fire Blast", highlight = 1, icon = br.player.spell.fireBlast},
        [2] = {mode = "Off", value = 2, overlay = "Fire Blast Disabled", tip = "Will not use Fire Blast", highlight = 0, icon = br.player.spell.fireBlast}
    }
    br.ui:createToggle(FireBlastModes,"FireBlast", 2, 1)

    -- Rune of Power Button
    local RoPModes = {
        [1] = {mode = "On", value = 1, overlay = "Rune of Power Enabled", tip = "Will use Rune of Power", highlight = 1, icon = br.player.spell.runeOfPower},
        [2] = {mode = "Off", value = 2, overlay = "Rune of Power Disabled", tip = "Will not use Rune of Power", highlight = 0, icon = br.player.spell.runeOfPower}
    }
    br.ui:createToggle(RoPModes,"RoP", 3, 1)

    -- Arcane Explosion Button
    local ArcaneExplosionModes = {
        [1] = {mode = "On", value = 1, overlay = "Arcane Explosion Enabled", tip = "Will use Arcane Explosion", highlight = 1, icon = br.player.spell.arcaneExplosion},
        [2] = {mode = "Off", value = 2, overlay = "Arcane Explosion Disabled", tip = "Will not use Arcane Explosion", highlight = 0, icon = br.player.spell.arcaneExplosion}
    }
    br.ui:createToggle(ArcaneExplosionModes,"ArcaneExplosion", 4, 1)

    -- Frost Nova Button
    local FrostNovaModes = {
        [1] = {mode = "On", value = 1, overlay = "Frost Nova Enabled", tip = "Will use Frost Nova", highlight = 1, icon = br.player.spell.frostNova},
        [2] = {mode = "Off", value = 2, overlay = "Frost Nova Disabled", tip = "Will not use Frost Nova", highlight = 0, icon = br.player.spell.frostNova}
    }
    br.ui:createToggle(FrostNovaModes,"FrostNova", 5, 1)

    -- Ice Lance Button
    local IceLanceModes = {
        [1] = {mode = "On", value = 1, overlay = "Ice Lance Movement Enabled", tip = "Will use Ice Lance w/ movement", highlight = 1, icon = br.player.spell.iceLance},
        [2] = {mode = "Off", value = 2, overlay = "Ice Lance Movement Disabled", tip = "Will not use Ice Lance w/ movement", highlight = 0, icon = br.player.spell.iceLance}
    }
    br.ui:createToggle(IceLanceModes,"IceLance", 0, 1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local rotationKeys = {"None", GetBindingKey("Rotation Function 1"), GetBindingKey("Rotation Function 2"), GetBindingKey("Rotation Function 3"), GetBindingKey("Rotation Function 4"), GetBindingKey("Rotation Function 5")}
    local optionTable
    local function rotationOptions()
        local section
        ------------------------
        --- GENERAL  OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  
         colorBlue .. " Frost" .. 
         colorWhite .. " .:|:. " .. 
         colorBlue .. "General ".. 
         colorWhite.."Ver: " ..
         colorBlue .. rotationVer .. 
         colorWhite.." .:|:. ")
        -- APL
        br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFBB00SimC", "|cffFFBB00Leveling", "|cffFFBB00Ice Lance Spam"}, 1, "|cffFFBB00Set APL Mode to use.")

        -- Filler Spell
        br.ui:createDropdownWithout(section, "Filler Spell", {"|cffFFBB00Frostbolt", "|cffFFBB00Ice Lance"}, 1, "|cffFFBB00Filler Spell to use.")

        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFBB00Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

        -- Ice Floes Delay
        br.ui:createSpinnerWithout(section, "Ice Floes Delay", 1.5, 0, 10, 0.1, "|cffFFBB00Delay between casting Ice Floes.")

        -- Pre-Pull Timer
        br.ui:createCheckbox(section, "Pre-Pull Logic", "|cffFFBB00Will precast Frostbolt on pull if pulltimer is active")

        -- Opener
        --br.ui:createCheckbox(section,"Opener")
        -- Pet Management
        br.ui:createCheckbox(section, "Pet Management", "|cffFFBB00 Select to enable/disable auto pet management")
        br.ui:checkSectionState(section)

        ------------------------
        ---   DPS SETTINGS   ---
        ------------------------
         section = br.ui:createSection(br.ui.window.profile, colorBlue .. " DPS" .. colorWhite .. ".:|:. " ..colorBlue .. " DPS Settings")
        -- Blizzard Units
        br.ui:createSpinnerWithout(section, "Blizzard Units", 2, 1, 10, 1, "|cffFFBB00Min. number of units Blizzard will be cast on.")
        
        -- Cone of Cold Units
        br.ui:createSpinnerWithout(section, "Cone of Cold Units", 2, 1, 10, 1, "|cffFFBB00Min. number of units Cone of Cold will be cast on.")

        -- Frozen Orb Units
        br.ui:createSpinnerWithout(section, "Frozen Orb Units", 3, 1, 10, 1, "|cffFFBB00Min. number of units Frozen Orb will be cast on.")

        -- Arcane Explosion Units
        br.ui:createSpinner(section, "Arcane Explosion Units", 2, 1, 10, 1, "|cffFFB000 Number of adds to cast Arcane Explosion")

        -- Frozen Orb Key
        br.ui:createDropdown(section, "Frozen Orb Key", br.dropOptions.Toggle, 6, "|cffFFFFFFSet key to manually use Frozen Orb")

        -- Comet Storm Units
        br.ui:createSpinnerWithout(section, "Comet Storm Units", 2, 1, 10, 1, "|cffFFBB00Min. number of units Comet Storm will be cast on.")

        -- Casting Interrupt Delay
        br.ui:createSpinner(section, "Casting Interrupt Delay", 0.3, 0, 1, 0.1, "|cffFFBB00Activate to delay interrupting own casts to use procs.")

        -- Cast Mirror Image
        br.ui:createCheckbox(section, "Mirror Image", "|cffFFBB00Use Mirror Image during boss fights.")

        -- Casting Interrupt Delay
        br.ui:createCheckbox(section, "No Ice Lance", "|cffFFBB00Use No Ice Lance Rotation.")

        -- Predict movement
        --br.ui:createCheckbox(section, "Disable Movement Prediction", "|cffFFBB00 Disable prediction of unit movement for casts")
                -- Pre-Pull Timer
        br.ui:createCheckbox(section, "Pull OoC", "|cffFFBB00 Toggles whether or not the rotation automatically engages into combat.")
        -- Auto target
        br.ui:createCheckbox(section, "Auto Target", "|cffFFBB00 Will auto change to a new target, if current target is dead")
        br.ui:checkSectionState(section)
        ------------------------
        ---     UTILITY      ---
        ------------------------
         section = br.ui:createSection(br.ui.window.profile, colorBlue .. " UTLY" .. colorWhite.. ".:|:. " ..colorBlue .. " Utility")
        -- Spellsteal
        br.ui:createCheckbox(section, "Spellsteal", "|cffFFBB00 Will use Spellsteal, delay can be changed using dispel delay in healing engine")

        -- Remove Curse
        br.ui:createDropdown(section, "Remove Curse", {"|cff00FF00Player","|cffFFFF00Target","|cffFFBB00Player/Target","|cffFF0000Mouseover","|cffFFBB00Any"}, 1, "","|ccfFFFFFFTarget to cast on, set delay in healing engine settings")

        -- Arcane Intellect
        br.ui:createCheckbox(section, "Arcane Intellect", "|cffFFBB00 Will use Arcane Intellect")

        -- Focus Magic
        br.ui:createCheckbox(section, "Focus Magic", "|cffFFBB00 Will use Focus Magic")

        -- Slow Fall
        br.ui:createSpinner(section, "Slow Fall Distance", 30, 0, 100, 1, "|cffFFBB00 Will cast slow fall based on the fall distance")          

        br.ui:checkSectionState(section)

        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, colorBlue .. " CDs" .. colorWhite.. ".:|:. " ..colorBlue .. " Cooldowns")
        -- Cooldowns Time to Die limit
        br.ui:createSpinnerWithout(section, "Cooldowns Time to Die Limit", 5, 1, 30, 1, "|cffFFBB00Min. calculated time to die to use CDs.")

        -- Racial
        br.ui:createCheckbox(section, "Racial")

        -- Trinkets        
        br.ui:createDropdownWithout(section, "Trinket 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use trinkets.")
        br.ui:createDropdownWithout(section, "Trinket 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use trinkets.")
        -- Potion
        br.ui:createCheckbox(section, "Potion")

        -- Pre Pot
        br.ui:createCheckbox(section, "Pre Pot", "|cffFFBB00 Requires Pre-Pull logic to be active")

        -- AoE when using CD
        br.ui:createCheckbox(section, "Obey AoE units when using CDs", "|cffFFBB00 Use user AoE settings when using CDs")

        br.ui:checkSectionState(section)

        ------------------------
        --- Defensive OPTIONS ---
        ------------------------
      section = br.ui:createSection(br.ui.window.profile, colorBlue .. " DEF" .. colorWhite.. ".:|:. " ..colorBlue .. " Defensive")
        -- Healthstone
        br.ui:createSpinner(section, "Pot/Stoned", 60, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")

        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")

        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")
        end

        -- Ice Barrier
        br.ui:createSpinner(section, "Ice Barrier", 80, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")

        -- Ice Barrier OOC
        br.ui:createCheckbox(section, "Ice Barrier OOC", "|cffFFBB00Keep Ice Barrier up out of combat")

        -- Ice Block
        br.ui:createSpinner(section, "Ice Block", 20, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")

        --Dispel
        --br.ui:createCheckbox(section, "Auto Dispel/Purge", "|cffFFBB00 Auto dispel/purge in m+, based on whitelist, set delay in healing engine settings")
        br.ui:checkSectionState(section)

        ------------------------
        ---Interrupt  OPTIONS---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, colorBlue.." Interrupts")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percent to Cast At")
        -- Don't interrupt
        br.ui:createCheckbox(section, "Do Not Cancel Cast", "|cffFFBB00Will not interrupt own spellcasting to cast Counterspell")
        br.ui:checkSectionState(section)

        ------------------------
        ---TOGGLE KEY OPTIONS---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, colorBlue.." Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
        -- Defensive Key Toggle
        br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end
----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------
    --- Toggles ---
    ---------------
    br.UpdateToggle("Rotation", 0.25)
    br.UpdateToggle("Cooldown", 0.25)
    br.UpdateToggle("Defensive", 0.25)
    br.UpdateToggle("Interrupt", 0.25)
    br.player.ui.mode.frozenOrb = br.data.settings[br.selectedSpec].toggles["FrozenOrb"]
    br.player.ui.mode.cometStorm = br.data.settings[br.selectedSpec].toggles["CometStorm"]
    br.player.ui.mode.ebonbolt = br.data.settings[br.selectedSpec].toggles["Ebonbolt"]
    br.player.ui.mode.coc = br.data.settings[br.selectedSpec].toggles["ConeOfCold"]
    br.player.ui.mode.fb = br.data.settings[br.selectedSpec].toggles["FireBlast"]
    br.player.ui.mode.rop = br.data.settings[br.selectedSpec].toggles["RoP"]
    br.player.ui.mode.ae = br.data.settings[br.selectedSpec].toggles["ArcaneExplosion"]
    br.player.ui.mode.fn = br.data.settings[br.selectedSpec].toggles["FrostNova"]
    br.player.ui.mode.il = br.data.settings[br.selectedSpec].toggles["IceLance"]
    
    --------------
    --- Locals ---
    --------------
    local activePet = br.player.pet
    local activePetId = br.player.petId
    local artifact = br.player.artifact
    local buff = br.player.buff
    local cast = br.player.cast
    local castable = br.player.cast.debug
    local combatTime = br.getCombatTime()
    local conduit = br.player.conduit
    local covenant = br.player.covenant
    local cd = br.player.cd
    local charges = br.player.charges
    local deadMouse = br.GetUnitIsDeadOrGhost("mouseover")
    local deadtar, attacktar, hastar, playertar = deadtar or br.GetUnitIsDeadOrGhost("target"), attacktar or br._G.UnitCanAttack("target", "player"), hastar or br.GetObjectExists("target"), br._G.UnitIsPlayer("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local essence = br.player.essence
    local equiped = br.player.equiped
    local falling, swimming, flying = br.getFallTime(), IsSwimming(), IsFlying()
    local friendly = br.GetUnitIsFriend("target", "player")
    local gcd = br.player.gcd
    local gcdMax = br.player.gcdMax
    local hasMouse = br.GetObjectExists("mouseover")
    local hasteAmount = GetHaste() / 100
    local hasPet = IsPetActive()
    local healPot = br.getHealthPot()
    local ui = br.player.ui
    local heirloomNeck = 122663 or 122664
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local lastSpell = br.lastSpellCast
    local level = br.player.level
    local lootDelay = br.getOptionValue("LootDelay")
    local manaPercent = br.player.power.mana.percent()
    local mode = br.player.ui.mode
    local moving = br.isMoving("player") ~= false or br.player.moving
    local pet = br.player.pet.list
    local php = br.player.health
    local playerCasting = br._G.UnitCastingInfo("player")
    local playerMouse = br._G.UnitIsPlayer("mouseover")
    local power, powmax, powgen, powerDeficit = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
    local pullTimer = br.PullTimerRemain()
    local runeforge = br.player.runeforge
    local race = br.player.race
    local solo = br.player.instance == "none"
    local spell = br.player.spell
    local talent = br.player.talent
    local targetUnit = "target"
    local thp = br.getHP("target")
    local travelTime = br.getDistance("target") / 50 --Ice lance
    local ttm = br.player.power.mana.ttm()
    local units = br.player.units
    local use = br.player.use
    local reapingDamage = br.getOptionValue("Reaping Flames Damage") * 1000
    -- Super scuffed IF tracker
    local curIF = select(3,br._G.AuraUtil.FindAuraByName(GetSpellInfo(116267), "player", "HELPFUL"))
    if curIF then
        if curIF ~= lastIF then
            if curIF == 1 and lastIF == 2 then
                if5Start = GetTime() + 5
                if5End = GetTime() + 7 - 0.1
            end
            lastIF = curIF
        end
    else
        if5Start = 0
        if5End = 0
    end
    local function ifCheck()
        if if5Start ~= 0 and br.isChecked("No Ice Lance") then
            --cast_time+travel_time>incanters_flow_time_to.5.up&cast_time+travel_time<incanters_flow_time_to.4.down
            local hitTime = GetTime() + cast.time.glacialSpike() + br.getDistance("target") / 40
            if hitTime > if5Start and hitTime < if5End then
                return true
            end
        end
        return false
    end

    -- Show/Hide toggles
    if not br._G.UnitAffectingCombat("player") then
        if not talent.cometStorm then
            br.buttonCometStorm:Hide()
        else
            br.buttonCometStorm:Show()
        end
        if not talent.ebonbolt then
            br.buttonEbonbolt:Hide()
        else
            br.buttonEbonbolt:Show()
        end
    end
    -- spellqueue ready
    local function spellQueueReady()
        --Check if we can queue cast
        local castingInfo = {br._G.UnitCastingInfo("player")}
        if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
    end

    --cast time
    local function interruptCast(spellID)
        local castingInfo = {br._G.UnitCastingInfo("player")}
        if castingInfo[9] and castingInfo[9] == spellID then
            if br.isChecked("Casting Interrupt Delay") then
                if (GetTime()-(castingInfo[4]/1000)) >= br.getOptionValue("Casting Interrupt Delay") then
                    return true
                end
            else
                return true
            end
        end
        return false
    end

    --Player cast remain
    local playerCastRemain = 0
    if br._G.UnitCastingInfo("player") then
        playerCastRemain = (select(5, br._G.UnitCastingInfo("player")) / 1000) - GetTime()
    end

    -- Pet Stance
    local function petFollowActive()
        for i = 1, NUM_PET_ACTION_SLOTS do
            local name, _, _,isActive = GetPetActionInfo(i)
            if isActive and name == "PET_ACTION_FOLLOW" then
                return true
            end
        end
        return false
    end       

    -- Ice Floes
    if moving and talent.iceFloes and buff.iceFloes.exists() then
        moving = false
    end

    --rop notice
    if not ropNotice and talent.runeOfPower then
        print("Rune Of Power talent not supported in rotation yet, use manually")
        ropNotice = true
    elseif ropNotice and not talent.runeOfPower then
        ropNotice = false
    end

    --buff cache locals
    local fofExists = buff.fingersOfFrost.exists()
    local bfExists = buff.brainFreeze.exists()
    local iciclesStack = buff.icicles.stack()

    if br.isCastingSpell(spell.frostbolt) then
        iciclesStack = iciclesStack + 1
    end

    units.get(40)
    enemies.get(10)
    enemies.get(10, "target", true)
    enemies.get(40, nil, nil, nil, spell.frostbolt)

    local dispelDelay = 1.5
    if br.isChecked("Dispel delay") then
        dispelDelay = br.getValue("Dispel delay")
    end

    if br.profileStop == nil or not inCombat then
        br.profileStop = false
    end
    --ttd
    local function ttd(unit)
        local ttdSec = br.getTTD(unit)
        if br.getOptionCheck("Enhanced Time to Die") then
            return ttdSec
        end
        if ttdSec == -1 then
            return 999
        end
        return ttdSec
    end
    --is frozen
    local function isFrozen(unit)
        local function getRawDistance(unit)
            local x1, y1, z1 = br.GetObjectPosition("player")
            local x2, y2, z2 = br.GetObjectPosition(unit)
            return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
        end
        local distance = getRawDistance(unit)
        local travelTime = distance / 50 + 0.15 --Ice lance
        if buff.fingersOfFrost.remain() > (gcd + travelTime) or debuff.frostNova.remain(unit, "any") > (gcd + travelTime) or debuff.iceNova.remain(unit, "any") > (gcd + travelTime) or debuff.wintersChill.remain(unit) > (gcd + travelTime) then
            return true
        end
        return false
    end

    --calc damge
    local function calcDamage(spellID, unit)
        local spellPower = GetSpellBonusDamage(5)
        local spMod
        local dmg = 0
        local frostMageDmg = 0.81
        if spellID == spell.frostbolt then
            dmg = spellPower * 0.511
        elseif spellID == spell.iceLance then
            dmg = spellPower * 0.35
            if unit.frozen then
                dmg = dmg * 3
            end
        elseif spellID == spell.waterbolt then
            dmg = spellPower * 0.75 * 0.2925
        elseif spellID == spell.iceNova then
            dmg = spellPower * 0.45 * 400 / 100
        elseif spellID == spell.flurry then
            dmg = spellPower * 0.316 * 3
        elseif spellID == spell.ebonbolt then
            dmg = spellPower * 3.2175
        else
            return 0
        end
        return dmg * frostMageDmg * (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100))
    end

    local function calcHP(unit)
        local thisUnit = unit.unit
        local hp = br._G.UnitHealth(thisUnit)
        if br.unlocked then --EasyWoWToolbox ~= nil then
            local castID, _, castTarget = br._G.UnitCastID("player")
            if castID and castTarget and br.GetUnitIsUnit(unit, castTarget) and playerCasting then
                hp = hp - calcDamage(castID, unit)
            end
            for k, v in pairs(spell.abilities) do
                if br.InFlight.Check(v, thisUnit) then
                    hp = hp - calcDamage(v, unit)
                end
            end
            -- if br.GetUnitIsVisible("pet") then
            --     castID, _, castTarget = br._G.UnitCastID("pet")
            --     if castID and castTarget and br.GetUnitIsUnit(unit, castTarget) and br._G.UnitCastingInfo("pet") then
            --         local castRemain = (select(5, br._G.UnitCastingInfo("pet")) / 1000) - GetTime()
            --         if castRemain < 0.5 then
            --             hp = hp - calcDamage(castID, unit)
            --         end
            --     end
            -- end
        end
        return hp
    end

    --Spell steal
    local doNotSteal = {
        [273432] = "Bound By Shadow(Uldir)",
        [269935] = "Bound By Shadow(KR)"
    }
    local function spellstealCheck(unit)
        local i = 1
        local buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = br._G.UnitBuff(unit, i)
        while buffName do
            if doNotSteal[spellId] then
                return false
            elseif isStealable and (GetTime() - (expirationTime - duration)) > dispelDelay then
                return true
            end
            i = i + 1
            buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = br._G.UnitBuff(unit, i)            
        end
        return false
    end

    -- Blacklist enemies
    local function isTotem(unit)
        local eliteTotems = {
            -- totems we can dot
            [125977] = "Reanimate Totem",
            [127315] = "Reanimate Totem",
            [146731] = "Zombie Dust Totem"
        }
        local creatureType = br._G.UnitCreatureType(unit)
        local objectID = br.GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then
                return true
            end
        end
        return false
    end

    local noDotUnits = {
        [135824] = true, -- Nerubian Voidweaver
        [139057] = true, -- Nazmani Bloodhexer
        [129359] = true, -- Sawtooth Shark
        [129448] = true, -- Hammer Shark
        [134503] = true, -- Silithid Warrior
        [137458] = true, -- Rotting Spore
        [139185] = true, -- Minion of Zul
        [120651] = true -- Explosive
    }

    local function noDotCheck(unit)
        if br.isChecked("Dot Blacklist") and (noDotUnits[br.GetObjectID(unit)] or br._G.UnitIsCharmed(unit)) then
            return true
        end
        if isTotem(unit) then
            return true
        end
        local unitCreator = br._G.UnitCreator(unit)
        if unitCreator ~= nil and br._G.UnitIsPlayer(unitCreator) ~= nil and br._G.UnitIsPlayer(unitCreator) == true then
            return true
        end
        if br.GetObjectID(unit) == 137119 and br.getBuffRemain(unit, 271965) > 0 then
            return true
        end
        return false
    end

    local standingTime = 0
    if br.DontMoveStartTime then
        standingTime = GetTime() - br.DontMoveStartTime
    end

    --wipe timers table
    if br.timersTable then
        wipe(br.timersTable)
    end

    --local enemies table with extra data
    local facingUnits = 0
    local enemyTable40 = {}
    if #enemies.yards40 > 0 then
        local highestHP
        local lowestHP
        local distance20Max
        local distance20Min
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if (not noDotCheck(thisUnit) or br.GetUnitIsUnit(thisUnit, "target")) and not br.GetUnitIsDeadOrGhost(thisUnit) and (mode.rotation ~= 2 or br.GetUnitIsUnit(thisUnit, "target")) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = br.getDistance(thisUnit)
                enemyUnit.distance20 = math.abs(enemyUnit.distance - 20)
                enemyUnit.hpabs = br._G.UnitHealth(thisUnit)
                enemyUnit.facing = br.getFacing("player", thisUnit)
                if br.getOptionValue("APL Mode") == 2 then
                    enemyUnit.frozen = isFrozen(thisUnit)
                end
                enemyUnit.calcHP = calcHP(enemyUnit)
                tinsert(enemyTable40, enemyUnit)
                if enemyUnit.facing then
                    facingUnits = facingUnits + 1
                end
                if highestHP == nil or highestHP < enemyUnit.hpabs then
                    highestHP = enemyUnit.hpabs
                end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then
                    lowestHP = enemyUnit.hpabs
                end
                if distance20Max == nil or distance20Max < enemyUnit.distance20 then
                    distance20Max = enemyUnit.distance20
                end
                if distance20Min == nil or distance20Min > enemyUnit.distance20 then
                    distance20Min = enemyUnit.distance20
                end
            end
        end
        if #enemyTable40 > 1 then
            for i = 1, #enemyTable40 do
                local hpNorm = (5 - 1) / (highestHP - lowestHP) * (enemyTable40[i].hpabs - highestHP) + 5 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0 / 0) then
                    hpNorm = 0
                end -- NaN check
                local distance20Norm = (3 - 1) / (distance20Max - distance20Min) * (enemyTable40[i].distance20 - distance20Min) + 1 -- normalization of distance 20, low is good
                if distance20Norm ~= distance20Norm or tostring(distance20Norm) == tostring(0 / 0) then
                    distance20Norm = 0
                end -- NaN check
                local enemyScore = hpNorm + distance20Norm
                if enemyTable40[i].facing then
                    enemyScore = enemyScore + 10
                end
                if enemyTable40[i].ttd > 1.5 then
                    enemyScore = enemyScore + 10
                end
                enemyTable40[i].enemyScore = enemyScore
            end
            table.sort(
                enemyTable40,
                function(x, y)
                    return x.enemyScore > y.enemyScore
                end
            )
        end
        
        if br.isChecked("Auto Target") and #enemyTable40 > 0 and ((br.GetUnitExists("target") and (br.GetUnitIsDeadOrGhost("target")) and not br.GetUnitIsUnit(enemyTable40[1].unit, "target")) or not br.GetUnitExists("target")) then
            br._G.TargetUnit(enemyTable40[1].unit)
            return true
        end
        for i = 1, #enemyTable40 do
            if br.GetUnitIsUnit(enemyTable40[i].unit, "target") then
                targetUnit = enemyTable40[i]
            end
        end
    end

    -- spell usable check
    local function spellUsable(spellID)
        if br.isKnown(spellID) and not select(2, IsUsableSpell(spellID)) and br.getSpellCD(spellID) == 0 then
            return true
        end
        return false
    end

    --blizzard check
    local blizzardUnits = 0
    for i = 1, #enemies.yards10tnc do
        local thisUnit = enemies.yards10tnc[i]
        if ttd(thisUnit) > 4 then
            blizzardUnits = blizzardUnits + 1
        end
    end

    --
    local function castFrozenOrb(minUnits, safe, minttd)
        if not br.isKnown(spell.frozenOrb) or br.getSpellCD(spell.frozenOrb) ~= 0 or mode.frozenOrb ~= 1 then
            return false
        end  
        local x, y, z = br.GetObjectPosition("player")
        local length = 35
        local width = 17
        ttd = ttd or 0
        safe = safe or true
        local function getRectUnit(facing)
            local halfWidth = width/2
            local nlX, nlY, nlZ = br._G.GetPositionFromPosition(x, y, z, halfWidth, facing + math.rad(90), 0)
            local nrX, nrY, nrZ = br._G.GetPositionFromPosition(x, y, z, halfWidth, facing + math.rad(270), 0)
            local frX, frY, frZ = br._G.GetPositionFromPosition(nrX, nrY, nrZ, length, facing, 0)
            return nlX, nlY, nrX, nrY, frX, frY
        end
        local enemiesTable = br.getEnemies("player", length, true)
        local facing = br._G.ObjectFacing("player")        
        local unitsInRect = 0
        local nlX, nlY, nrX, nrY, frX, frY = getRectUnit(facing)
        local thisUnit
        for i = 1, #enemiesTable do
            thisUnit = enemiesTable[i]
            local uX, uY, uZ = br.GetObjectPosition(thisUnit)
            if br.isInside(uX, uY, nlX, nlY, nrX, nrY, frX, frY) and not br._G.TraceLine(x, y, z+2, uX, uY, uZ+2, 0x100010) then
                if safe and not br._G.UnitAffectingCombat(thisUnit) and not br.isDummy(thisUnit) then
                    unitsInRect = 0
                    break
                end            
                if ttd(thisUnit) >= minttd then                
                    unitsInRect = unitsInRect + 1
                end
            end
        end
        if unitsInRect >= minUnits then
            br._G.CastSpellByName(GetSpellInfo(spell.frozenOrb))
            return true
        else
            return false
        end
    end

    --Clear last cast table ooc to avoid strange casts
    if not inCombat and #br.lastCastTable.tracker > 0 then
        wipe(br.lastCastTable.tracker)
    end

    ---Target move timer
    if lastTargetX == nil then
        lastTargetX, lastTargetY, lastTargetZ = 0, 0, 0
    end
    if br.timer:useTimer("targetMove", 0.8) or combatTime < 0.2 then
        if br.GetUnitIsVisible("target") then
            local currentX, currentY, currentZ = br.GetObjectPosition("target")
            local targetMoveDistance = math.sqrt(((currentX - lastTargetX) ^ 2) + ((currentY - lastTargetY) ^ 2) + ((currentZ - lastTargetZ) ^ 2))
            lastTargetX, lastTargetY, lastTargetZ = br.GetObjectPosition("target")
            if targetMoveDistance < 3 then
                targetMoveCheck = true
            else
                targetMoveCheck = false
            end
        end
    end
    --Tank move check for aoe
    local tankMoving = false
    if inInstance then
        for i = 1, #br.friend do
            if (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and br.isMoving(br.friend[i].unit) then
                tankMoving = true
            end
        end
    end

    function mageDamage()
        local X,Y,Z = br.GetObjectPosition("player")
        print(Z)
        Z = select(3, br._G.TraceLine(X, Y, Z + 10, X, Y, Z - 10, 0x110))
        print(Z)
    end
    local function actionList_Extras()
        if br.isChecked("DPS Testing") and br.GetObjectExists("target") and br.getCombatTime() >= (tonumber(br.getOptionValue("DPS Testing")) * 60) and br.isDummy() then
            br._G.StopAttack()
            br._G.ClearTarget()
            if br.isChecked("Pet Management") and not talent.lonelyWinter then
                br._G.PetStopAttack()
                br._G.PetFollow()
            end
            print(tonumber(br.getOptionValue("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
            br.profileStop = true
        end

        --Ice Barrier
        if not IsResting() and not inCombat and not playerCasting and br.isChecked("Ice Barrier OOC") then
            if cast.iceBarrier("player") then
                return true
            end
        end
        
        --Pet assist
        if br.isChecked("Pet Management") and br.GetUnitIsVisible("pet") and not petFollowActive() and (not inCombat or br.getDistance("target", "pet") > 40) then
            br._G.PetFollow()
        end

        -- Spell Steal
        if br.isChecked("Spellsteal") and inCombat then
            for i = 1, #enemyTable40 do
                if spellstealCheck(enemyTable40[i].unit) then
                    if cast.spellsteal(enemyTable40[i].unit) then return true end
                end
            end
        end

        -- Arcane Intellect
        if br.timer:useTimer("AI Delay", math.random(15, 30)) then
            for i = 1, #br.friend do
                if not buff.arcaneIntellect.exists(br.friend[i].unit,"any") and br.getDistance("player", br.friend[i].unit) < 40 and not br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br._G.UnitIsPlayer(br.friend[i].unit) then
                    if cast.arcaneIntellect() then return true end
                end
            end
        end
        
        -- Focus Magic
        if ui.checked("Focus Magic") and br.timer:useTimer("FM Delay", math.random(15, 30)) then
            if not buff.focusMagic.exists() and not br.GetUnitIsDeadOrGhost("player") then
                if cast.focusMagic("player") then return true end
            end
        end
        
        -- Trinkets
            -- Trinket 1
            if (br.getOptionValue("Trinket 1") == 1 or (br.getOptionValue("Trinket 1") == 2 and br.useCDs())) and inCombat then
                if use.able.slot(13) then
                    use.slot(13)
                end
            end

        -- Trinket 2
            if (br.getOptionValue("Trinket 2") == 1 or (br.getOptionValue("Trinket 2") == 2 and br.useCDs())) and inCombat then
                if use.able.slot(14) then
                    use.slot(14)
                end
            end     

        -- Slow Fall
        if br.isChecked("Slow Fall Distance") and not buff.slowFall.exists() then
            if IsFalling() and br.getFallDistance() >= br.getOptionValue("Slow Fall Distance") then
                if cast.slowFall("player") then return end
            end
        end         
    end

    local function actionList_Defensive()
        if br.useDefensive() then
            --Ice Block
            if br.isChecked("Ice Block") and php <= br.getOptionValue("Ice Block") and cd.iceBlock.remain() <= gcd then
                if br._G.UnitCastingInfo("player") then
                    br._G.SpellStopCasting()
                end
                if cast.iceBlock("player") then
                    return true
                end
            end

            --Pot/Stone
            if br.isChecked("Pot/Stoned") and php <= br.getOptionValue("Pot/Stoned") and inCombat and (br.hasHealthPot() or br.hasItem(5512)) then
                if br.canUseItem(5512) then
                    br.useItem(5512)
                elseif br.canUseItem(healPot) then
                    br.useItem(healPot)
                end
            end

            --Heirloom Neck
            if br.isChecked("Heirloom Neck") and php <= br.getOptionValue("Heirloom Neck") then
                if br.hasEquiped(heirloomNeck) then
                    if GetItemCooldown(heirloomNeck) == 0 then
                        br.useItem(heirloomNeck)
                    end
                end
            end

            --Ice Barrier
            if br.isChecked("Ice Barrier") and not playerCasting and php <= br.getOptionValue("Ice Barrier") then
                if cast.iceBarrier("player") then
                    return true
                end
            end

            --Gift of the Naaru (Racial)
            if br.player.race == "Draenei"  and br.isChecked("Gift of the Naaru") and php <= br.getOptionValue("Gift of the Naaru") and php > 0 then
                if br.castSpell("player", racial, false, false, false) then
                    return
                end
            end
            
            --Remove Curse, Yoinked from Aura balance
            if br.isChecked("Remove Curse") then
                if br.getOptionValue("Remove Curse") == 1 then
                    if br.canDispel("player",spell.removeCurse) then
                        if cast.removeCurse("player") then return true end
                    end
                elseif br.getOptionValue("Remove Curse") == 2 then
                    if br.canDispel("target",spell.removeCurse) then
                        if cast.removeCurse("target") then return true end
                    end
                elseif br.getOptionValue("Remove Curse") == 3 then
                    if br.canDispel("player",spell.removeCurse) then
                        if cast.removeCurse("player") then return true end
                    elseif br.canDispel("target",spell.removeCurse) then
                        if cast.removeCurse("target") then return true end
                    end
                elseif br.getOptionValue("Remove Curse") == 4 then
                    if br.canDispel("mouseover",spell.removeCurse) then
                        if cast.removeCurse("mouseover") then return true end
                    end
                elseif br.getOptionValue("Remove Curse") == 5 then
                    for i = 1, #br.friend do
                        if br.canDispel(br.friend[i].unit,spell.removeCurse) then
                            if cast.removeCurse(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
        end
    end

    local function actionList_Interrupts()
        if br.useInterrupts() and cd.counterspell.remain() == 0 then
            if not br.isChecked("Do Not Cancel Cast") or not playerCasting then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                        if cast.counterspell(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
    end

    --[[
Simc Action list Date: 01/28/2021
-----------------------------------
actions.cds=potion,if=prev_off_gcd.icy_veins|fight_remains<30
actions.cds+=/deathborne
actions.cds+=/mirrors_of_torment,if=active_enemies<3&(conduit.siphoned_malice|soulbind.wasteland_propriety)
actions.cds+=/rune_of_power,if=cooldown.icy_veins.remains>12&buff.rune_of_power.down
actions.cds+=/icy_veins,if=buff.rune_of_power.down&(buff.icy_veins.down|talent.rune_of_power)&(buff.slick_ice.down|active_enemies>=2)
actions.cds+=/time_warp,if=runeforge.temporal_warp&buff.exhaustion.up&(prev_off_gcd.icy_veins|fight_remains<30)
actions.cds+=/use_items
actions.cds+=/blood_fury
actions.cds+=/berserking
actions.cds+=/lights_judgment
actions.cds+=/fireblood
actions.cds+=/ancestral_call
actions.cds+=/bag_of_tricks
    ]]


    local function actionList_Cooldowns()
        if br.useCDs() and ttd("target") >= br.getOptionValue("Cooldowns Time to Die Limit") then
            -- actions.cds=potion,if=prev_off_gcd.icy_veins|fight_remains<30
            if br.isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() and (cast.last.icyVeins() or ttd("target") < 30) then
                br.addonDebug("[Action:Cooldowns] Damage Potion")
                use.battlePotionOfIntellect()
                return true
            end
        ------------------------------------------------
        -- Covenants (Level 60) ------------------------
        ------------------------------------------------
        if level == 60 and not moving then
            ------------------------------------------------
            -- Deathborne : Necrolord ----------------------
            ------------------------------------------------
            if covenant.necrolord.active and spellUsable(307443) and select(2,GetSpellCooldown(307443)) <= gcdMax then
                if cast.deathborne() then br.addonDebug("[Action:Cooldowns] Deathborne") return true end
            end
            ------------------------------------------------
            -- Mirrors of Torment : Venthyr ----------------
            ------------------------------------------------
            -- actions.aoe+=/mirrors_of_torment
            if covenant.venthyr.active and spellUsable(spell.mirrorsOfTorment) and select(2,GetSpellCooldown(spell.mirrorsOfTorment)) <= gcdMax and #enemies.yards8t >= 2 then
                if cast.mirrorsOfTorment() then br.addonDebug("[Action:Cooldowns] Mirrors Of Torment") return true end
            end
            ------------------------------------------------
            -- Shifting Power : Night Fae ------------------
            ------------------------------------------------
            -- actions.aoe+=/shifting_power
            if covenant.nightFae.active and spellUsable(314791) and select(2,GetSpellCooldown(314791)) <= gcdMax and ttd("target") > 8 then
                if cast.shiftingPower() then br.addonDebug("[Action:Cooldowns] Shifting Power") return true end
            end
            ------------------------------------------------
            -- Radiant Spark : Kyrian ----------------------
            ------------------------------------------------
            -- actions.aoe+=/radiant_spark
            if covenant.kyrian.active and spellUsable(307443) and select(2,GetSpellCooldown(307443)) <= gcdMax then 
                if cast.radiantSpark() then br.addonDebug("[Action:Cooldowns] Radiant Spark") return true end
            end
        end

            -- actions.cds+=/icy_veins,if=buff.rune_of_power.down&(buff.icy_veins.down|talent.rune_of_power)&(buff.slick_ice.down|active_enemies>=2)
            if cast.able.icyVeins() and not buff.iceForm.exists() and not buff.runeOfPower.exists() and (not buff.icyVeins.exists() or talent.runeOfpower) and (not buff.slickIce.exists() or blizzardUnits >= 2) then br._G.CastSpellByName(GetSpellInfo(spell.icyVeins)) br.addonDebug("[Action:Cooldowns] Icy Veins") return true end

            -- actions.cooldowns+=/mirror_image
            if cast.able.mirrorImage() and ui.checked("Mirror Image") and cast.mirrorImage("player") then br.addonDebug("[Action:Cooldowns] Mirror Image") return true end

            -- # Rune of Power is always used with Frozen Orb. Any leftover charges at the end of the fight should be used, ideally if the boss doesn't die in the middle of the Rune buff.
            -- actions.cooldowns+=/rune_of_power,if=prev_gcd.1.frozen_orb|target.time_to_die>10+cast_time&target.time_to_die<20
            -- # On single target fights, the cooldown of Rune of Power is lower than the cooldown of Frozen Orb, this gives extra Rune of Power charges that should be used with active talents, if possible.
            -- actions.cooldowns+=/call_action_list,name=talent_rop,if=talent.rune_of_power.enabled&active_enemies=1&cooldown.rune_of_power.full_recharge_time<cooldown.frozen_orb.remains
            -- actions.cooldowns+=/use_items  
            --racials
            if br.isChecked("Racial") then
                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" then
                    if race == "LightforgedDraenei" then
                        if cast.racial("target","ground") then return true end
                    else
                        if cast.racial("player") then return true end
                    end
                end
            end
        end

        -- Trinkets
        -- Trinket 1
        if (br.getOptionValue("Trinket 1") == 1 or (br.getOptionValue("Trinket 1") == 2 and br.useCDs())) and inCombat then
            if use.able.slot(13) then
                use.slot(13)
            end
        end

        -- Trinket 2
        if (br.getOptionValue("Trinket 2") == 1 or (br.getOptionValue("Trinket 2") == 2 and br.useCDs())) and inCombat then
            if use.able.slot(14) then
                use.slot(14)
            end
        end     
    end

    local function actionList_Leveling()
        -- Rune of Power on Cooldown
        if mode.rop ~= 2 and cast.able.runeofPower() and not moving and ui.checked("Rune of Power") and not buff.runeOfPower.exists() then 
            if cast.runeofPower() then return true end 
        end

        actionList_Cooldowns()
        
        if targetUnit.frozen or targetUnit.calcHP < calcDamage(spell.iceLance, targetUnit) or (inInstance and targetUnit.ttd < cast.time.frostbolt()) then
            if cast.iceLance("target") then
                return true
            end
        end

        if bfExists or br.isCastingSpell(spell.ebonbolt) then
            if cast.flurry("target") then
                return true
            end
        end

        if mode.fn == 1 and not isFrozen("target") and br.getDistance("target") < 12 and not br.isBoss("target") then
            if cast.frostNova("player") then
                return true
            end
        end

        if mode.coc == 1 then
            if br.getDistance("target") <= 8 then
                if cast.coneOfCold("player") then return true end
            end
        end

        if not isTotem("target") and mode.ae == 1 and cast.able.arcaneExplosion() and br.getDistance("target") <= 10 and manaPercent > 30 and #enemies.yards10 >= br.getOptionValue("Arcane Explosion Units") then
            if cast.arcaneExplosion("player","aoe", 3, 10) then return true end 
        end

        if mode.frozenOrb ~= 2 and not talent.concentratedCoolness then
            if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                if castFrozenOrb(1, true, 4) then return true end
            else
                if castFrozenOrb(br.getOptionValue("Frozen Orb Units"), true, 4) then return true end
            end
        else
            if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                if cast.frozenOrb(nil,"aoe",1,8,true) then return true end 
            else
                if cast.frozenOrb(nil,"aoe",1,8,true) then return true end 
            end
        end

        if mode.frozenOrb == 1 and br.useCDs() and not talent.concentratedCoolness then
            if castFrozenOrb(1, true, 4) then return true end
        else
        -- Frozen Orb Key
            if mode.frozenOrb == 2 and br.isChecked("Frozen Orb Key") and br.SpecificToggle("Frozen Orb Key") and not GetCurrentKeyBoardFocus() and not talent.concentratedCoolness then
                br._G.CastSpellByName(GetSpellInfo(spell.frozenOrb))
                return
            end
        end

        -- Concentrated Coolness Talent
        if talent.concentratedCoolnes and br.isChecked("Frozen Orb Key") and br.SpecificToggle("Frozen Orb Key") and not GetCurrentKeyBoardFocus() and not talent.concentratedCoolness then
            cast.frozenOrb(nil,"aoe",1,8,true)
            return true 
        end

        if mode.rotation ~= 2 and not playerCasting and blizzardUnits >= br.getOptionValue("Blizzard Units") and not tankMoving and not moving then
            if br.createCastFunction("best", false, br.getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, true, 3) then
                return true
            end
        end

        if targetUnit.calcHP > calcDamage(spell.iceNova, targetUnit) or #br.getEnemies("target", 8) > 2 then
            if cd.iceNova.remain() <= gcd and ((playerCasting and br._G.UnitCastID("player") == spell.frostbolt) or cast.inFlight.frostbolt()) then
                return true
            end
            if cast.iceNova("target") then
                return true
            end
        end

        if moving then
            if cast.iceLance("target") then
                return true
            end
        end

        if mode.fb == 1 and cast.able.fireBlast("target") then 
            if cast.fireBlast("target") then return true end
        end

        if cast.frostbolt("target") then
            return true
        end

        if targetUnit.facing then
            if mode.ebonbolt == 1 and targetUnit.calcHP > (calcDamage(spell.frostbolt, targetUnit) * 2) and targetUnit.ttd > 4 then
                if cast.ebonbolt("target") then return true end
            end
        end

    end

    local function actionList_ST()  
        -- # In some situations, you can shatter Ice Nova even after already casting Flurry and Ice Lance. Otherwise this action is used when the mage has FoF after casting Flurry, see above.
        -- arcane explosion
        if not isTotem("target") and mode.ae ~= 2 and cast.able.arcaneExplosion() and br.getDistance("target") <= 10 and manaPercent > 30 and #enemies.yards10 >= br.getOptionValue("Arcane Explosion Units") then
            if cast.arcaneExplosion("player","aoe", 3, 10) then return true end 
         end 
            
        -- actions.single=ice_nova,if=cooldown.ice_nova.ready&debuff.winters_chill.up
        if debuff.wintersChill.exists("target") then
            if cast.iceLance("target") then return true end
        end

        
        if moving and mode.il ~= 2 then if cast.iceLance() then return true end end

        -- # Without GS, Ebonbolt is always shattered. With GS, Ebonbolt is shattered if it would waste Brain Freeze charge (i.e. when the mage starts casting Ebonbolt with Brain Freeze active) or when below 4 Icicles (if Ebonbolt is cast when the mage has 4-5 Icicles, it's better to use the Brain Freeze from it on Glacial Spike).
        -- actions.single+=/flurry,if=talent.ebonbolt.enabled&prev_gcd.1.ebonbolt&(!talent.glacial_spike.enabled|buff.icicles.stack<4|buff.brain_freeze.react)
        if talent.ebonbolt and cast.last.ebonbolt() and (not talent.glacialSpike or iciclesStack < 4 or bfExists) then
            if cast.flurry("target") then return true end
        end

        -- # Glacial Spike is always shattered.
        -- actions.single+=/flurry,if=talent.glacial_spike.enabled&prev_gcd.1.glacial_spike&buff.brain_freeze.react
        if talent.glacialSpike and bfExists and (cast.last.glacialSpike() or targetUnit.ttd < 3) then
            if cast.flurry("target") then return true end
        end

        -- # Without GS, the mage just tries to shatter as many Frostbolts as possible. With GS, the mage only shatters Frostbolt that would put them at 1-3 Icicle stacks. Difference between shattering Frostbolt with 1-3 Icicles and 1-4 Icicles is small, but 1-3 tends to be better in more situations (the higher GS damage is, the more it leans towards 1-3). Forcing shatter on Frostbolt is still a small gain, so is not caring about FoF. Ice Lance is too weak to warrant delaying Brain Freeze Flurry.
        -- actions.single+=/flurry,if=prev_gcd.1.frostbolt&buff.brain_freeze.react&(!talent.glacial_spike.enabled|buff.icicles.stack<4)
        if cast.last.frostbolt() and bfExists and (not talent.glacialSpike or iciclesStack < 4 or targetUnit.ttd < 3) then
            if cast.flurry("target") then return true end
        end

        -- actions.single+=/frozen_orb
        if mode.frozenOrb == 1 and not moving and targetMoveCheck then
            if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                if castFrozenOrb(1, true, 4) then return true end
            else
                if castFrozenOrb(br.getOptionValue("Frozen Orb Units"), true, 4) then return true end
            end
        else

        -- Frozen Orb Key
            if mode.frozenOrb == 2 and br.isChecked("Frozen Orb Key") and br.SpecificToggle("Frozen Orb Key") and not GetCurrentKeyBoardFocus() then
                br._G.CastSpellByName(GetSpellInfo(spell.frozenOrb))
                return
            end
        end

        -- # With Freezing Rain and at least 2 targets, Blizzard needs to be used with higher priority to make sure you can fit both instant Blizzards into a single Freezing Rain. Starting with three targets, Blizzard leaves the low priority filler role and is used on cooldown (and just making sure not to waste Brain Freeze charges) with or without Freezing Rain.
        -- actions.single+=/blizzard,if=active_enemies>2|active_enemies>1&cast_time=0&buff.fingers_of_frost.react<2
        if mode.rotation ~= 2 and not tankMoving and not moving and not playerCasting then
            if br.createCastFunction("best", false, 3, 8, spell.blizzard, nil, true, 3) then
                return true
            end
            if buff.fingersOfFrost.stack() < 2 and buff.freezingRain.exists() then
                if br.createCastFunction("best", false, 2, 8, spell.blizzard, nil, true, 3) then
                    return true
                end
            end
        end

        -- # Trying to pool charges of FoF for anything isn't worth it. Use them as they come.
        -- actions.single+=/ice_lance,if=buff.fingers_of_frost.react
        if not br.isChecked("No Ice Lance") then
            if fofExists and (not (bfExists and iciclesStack >= 5) or targetUnit.ttd < 3) then
                if cast.iceLance("target") then return true end
            end
        elseif fofExists and ((#br.getEnemies("target", 5) > 1 and talent.splittingIce) or targetUnit.ttd < 3) then
            if cast.iceLance("target") then return true end
        end

        -- actions.single+=/comet_storm
        if talent.cometStorm and not moving and mode.cometStorm == 1 and not br.isMoving("target") and targetUnit.ttd > 3 and ((not br.isChecked("Obey AoE units when using CDs") and br.useCDs()) or #br.getEnemies("target", 5) >= br.getOptionValue("Comet Storm Units")) then
            if cast.cometStorm("target") then
                if br.GetUnitIsVisible("pet") and not br.isBoss("target") then
                    C_Timer.After(playerCastRemain + 0.4, function()
                        if br.GetUnitIsVisible("target") then
                            local x,y,z = br.GetObjectPosition("target")
                            br.castAtPosition(x,y,z, spell.petFreeze)
                        end
                    end)
                end
                return true 
            end
        end

        -- actions.single+=/ebonbolt
        if mode.ebonbolt == 1 and not moving and targetUnit.ttd > 5 and targetUnit.facing and not bfExists and (not talent.glacialSpike or iciclesStack >= 5) then
            if cast.ebonbolt("target") then return true end
        end

        -- # Ray of Frost is used after all Fingers of Frost charges have been used and there isn't active Frozen Orb that could generate more. This is only a small gain against multiple targets, as Ray of Frost isn't too impactful.
        -- actions.single+=/ray_of_frost,if=!action.frozen_orb.in_flight&ground_aoe.frozen_orb.remains=0
        if standingTime > 1 and cd.frozenOrb.remain() < 45 and targetUnit.facing then
            if cast.rayOfFrost("target") then return true end
        end 

        -- # Blizzard is used as low priority filler against 2 targets. When using Freezing Rain, it's a medium gain to use the instant Blizzard even against a single target, especially with low mastery.
        -- actions.single+=/blizzard,if=cast_time=0|active_enemies>1
        if mode.rotation ~= 2 and not tankMoving and not moving and not playerCasting then
            if buff.freezingRain.exists() then
                if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                    if br.createCastFunction("best", false, 1, 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                else
                    if br.createCastFunction("best", false, br.getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                end
            else
                if blizzardUnits >= 2 and not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                    if br.createCastFunction("best", false, 2, 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                elseif blizzardUnits >= br.getOptionValue("Blizzard Units") then
                    if br.createCastFunction("best", false, br.getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                end
            end
        end

        -- # Glacial Spike is used when there's a Brain Freeze proc active (i.e. only when it can be shattered). This is a small to medium gain in most situations. Low mastery leans towards using it when available. When using Splitting Ice and having another target nearby, it's slightly better to use GS when available, as the second target doesn't benefit from shattering the main target.
        -- actions.single+=/glacial_spike,if=buff.brain_freeze.react|prev_gcd.1.ebonbolt|active_enemies>1&talent.splitting_ice.enabled
        if (bfExists or cast.last.ebonbolt() or ifCheck() or (not br.isChecked("No Ice Lance") and #br.getEnemies("target", 5) > 1 and talent.splittingIce)) and iciclesStack >= 5 and not moving and targetUnit.facing then
            if cast.glacialSpike("target") then return true end
        end

        -- actions.single+=/ice_nova
        if not moving and targetUnit.facing then
            if cast.iceNova("target") then return true end
        end

        -- fireblast
        if mode.fb ~= 2 and cast.able.fireBlast("target") then 
            if cast.fireBlast("target") then return true end
        end

        -- actions.single+=/use_item,name=tidestorm_codex,if=buff.icy_veins.down&buff.rune_of_power.down
        -- actions.single+=/frostbolt
        if not moving and targetUnit.facing and (br.isChecked("No Ice Lance") or not fofExists) then
            if cast.frostbolt("target") then return true end
        end

        -- actions.single+=/call_action_list,name=movement
       -- if talent.iceFloes and moving and buff.iceFloes.exists() and charges.iceFloes.count() > 0 and playerCastRemain < 0.5 then
    --        if cast.iceFloes("player") then return true end
     --   end

        -- actions.single+=/frostbolt
        --Filler Spell
        if ui.value("Filler Spell") ~= 2 then
            if cast.frostbolt("target") then return true end
        else
            if cast.iceLance("target") then return true end
        end
        -- Fire Blast Moving
        ---if mode.fb ~= 2 and moving and cast.able.fireBlast() then if cast.fireBlast() then return true end end 
    end

    local function actionList_AoE()
        -- # With Freezing Rain, it's better to prioritize using Frozen Orb when both FO and Blizzard are off cooldown. Without Freezing Rain, the converse is true although the difference is miniscule until very high target counts.
        -- arcane explosion
        if not isTotem("target") and mode.ae ~= 2 and mode.rotation ~= 2 and cast.able.arcaneExplosion() and br.getDistance("target") <= 10 and manaPercent > 30 and #enemies.yards10 >= br.getOptionValue("Arcane Explosion Units") then
             if cast.arcaneExplosion("player","aoe", 3, 10) then return true end 
        end

        -- actions.aoe=frozen_orb
        if mode.frozenOrb == 1 and not moving and targetMoveCheck then
            if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                if castFrozenOrb(1, true, 4) then return true end
            else
                if castFrozenOrb(br.getOptionValue("Frozen Orb Units"), true, 4) then return true end
            end
        else
        -- Frozen Orb Key
            if mode.frozenOrb == 2 and br.isChecked("Frozen Orb Key") and br.SpecificToggle("Frozen Orb Key") and not GetCurrentKeyBoardFocus() then
                br._G.CastSpellByName(GetSpellInfo(spell.frozenOrb))
                return
            end
        end

        -- # Using Cone of Cold is mostly DPS neutral with the AoE target thresholds. It only becomes decent gain with roughly 7 or more targets.
        -- actions.aoe+=/cone_of_cold
       --[[ if mode.coc == 1 then
           -- if castBestConeAngle then
             --   if castBestConeAngle(spell.coneOfCold,10,90,4,false) then return true end
            if br.getEnemiesInCone(90,10) >= ui.value("Cone of Cold Units") then
                if cast.coneOfCold("player") then return true end
            end
        end--]]

        
        if mode.fn ~= 2 and not isFrozen("target") and br.getDistance("target") < 12 and not br.isBoss("target") then
            if cast.frostNova("player") then
                return true
            end
        end

        if mode.coc == 1 then
            if br.getDistance("target") <= 8 and blizzardUnits >= ui.value("Cone of Cold Units") then
                if cast.coneOfCold("player") then return true end
            end
        end

        -- actions.aoe+=/blizzard
        if mode.rotation ~= 2 and not tankMoving and not moving and not playerCasting then
            if buff.freezingRain.exists() then
                if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                    if br.createCastFunction("best", false, 4, 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                else
                    if br.createCastFunction("best", false, br.getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                end
            else
                if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                    if br.createCastFunction("best", false, 4, 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                else
                    if br.createCastFunction("best", false, br.getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                end
            end
        end

        -- actions.aoe+=/comet_storm
        if mode.cometStorm == 1 and not moving and not br.isMoving("target") and targetUnit.ttd > 3 and ((br.isChecked("Ignore AoE units when using CDs") and br.useCDs()) or #br.getEnemies("target", 5) >= br.getOptionValue("Comet Storm Units")) then
            if cast.cometStorm("target") then
                if br.GetUnitIsVisible("pet") and not br.isBoss("target") then
                    C_Timer.After(playerCastRemain + 0.4, function()
                        if br.GetUnitIsVisible("target") then
                            local x,y,z = br.GetObjectPosition("target")
                            br.castAtPosition(x,y,z, spell.petFreeze)
                        end
                    end)
                end
                return true 
            end
        end

        -- actions.aoe+=/ice_nova
        if targetUnit.facing then
            if cast.iceNova("target") then return true end
        end

        -- # Simplified Flurry conditions from the ST action list. Since the mage is generating far less Brain Freeze charges, the exact condition here isn't all that important.
        -- actions.aoe+=/flurry,if=prev_gcd.1.ebonbolt|buff.brain_freeze.react&(prev_gcd.1.frostbolt&(buff.icicles.stack<4|!talent.glacial_spike.enabled)|prev_gcd.1.glacial_spike)
        if cast.last.ebonbolt() or bfExists and (cast.last.frostbolt() and (iciclesStack < 4 or not talent.glacialSpike) or cast.last.glacialSpike()) then
            if cast.flurry("target") then return true end
        end

        -- actions.aoe+=/ice_lance,if=buff.fingers_of_frost.react
        if fofExists then
            if cast.iceLance("target") then return true end
        end

        -- # The mage will generally be generating a lot of FoF charges when using the AoE action list. Trying to delay Ray of Frost until there are no FoF charges and no active Frozen Orbs would lead to it not being used at all.
        -- actions.aoe+=/ray_of_frost
        if standingTime > 1 and targetUnit.ttd > 4 and targetUnit.facing then
            if cast.rayOfFrost("target") then return true end
        end

        -- actions.aoe+=/ebonbolt
        if mode.ebonbolt == 1 and not moving and targetUnit.ttd > 5 and targetUnit.facing and not bfExists and (not talent.glacialSpike or iciclesStack >= 5) then
            if cast.ebonbolt("target") then return true end
        end

        -- actions.aoe+=/glacial_spike
        if not moving and targetUnit.facing and iciclesStack >= 5 and bfExists then
            if cast.glacialSpike("target") then return true end
        end

        -- actions.aoe+=/use_item,name=tidestorm_codex,if=buff.icy_veins.down&buff.rune_of_power.down
        -- actions.aoe+=/frostbolt
        if not moving and targetUnit.facing and not fofExists then
            if cast.frostbolt("target") then return true end
        end

        -- actions.aoe+=/call_action_list,name=movement
        if talent.iceFloes and moving and not buff.iceFloes.exists() and cast.timeSinceLast.iceFloes() >= ui.value("Ice Floes Delay") then
            if cast.iceFloes("player") then return true end
        end

        -- actions.aoe+=/ice_lance
        if cast.iceLance("target") then return true end

        -- Fire Blast Moving
       -- if mode.fb ~= 2 and moving and cast.able.fireBlast() then if cast.fireBlast() then return true end end 

    end

    --[[
Simc Action list Date: 01/28/2021
-----------------------------------
actions.aoe=frozen_orb
actions.aoe+=/blizzard
actions.aoe+=/flurry,if=(remaining_winters_chill=0|debuff.winters_chill.down)&(prev_gcd.1.ebonbolt|buff.brain_freeze.react&buff.fingers_of_frost.react=0)
actions.aoe+=/ice_nova
actions.aoe+=/comet_storm
actions.aoe+=/ice_lance,if=buff.fingers_of_frost.react|debuff.frozen.remains>travel_time|remaining_winters_chill&debuff.winters_chill.remains>travel_time
actions.aoe+=/radiant_spark
actions.aoe+=/mirrors_of_torment
actions.aoe+=/shifting_power
actions.aoe+=/fire_blast,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down
actions.aoe+=/arcane_explosion,if=mana.pct>30&active_enemies>=6&!runeforge.glacial_fragments
actions.aoe+=/ebonbolt
actions.aoe+=/ice_lance,if=runeforge.glacial_fragments&talent.splitting_ice&travel_time<ground_aoe.blizzard.remains
actions.aoe+=/wait,sec=0.1,if=runeforge.glacial_fragments&talent.splitting_ice
actions.aoe+=/frostbolt
     ]]

    local function actionList_AoE_SL() 
        -- actions.aoe=frozen_orb
        if mode.frozenOrb == 1 and not moving and targetMoveCheck then
            if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                if castFrozenOrb(1, true, 4) then br.addonDebug("[Action:AoE] Frozen Orb") return true end
            else
                if castFrozenOrb(br.getOptionValue("Frozen Orb Units"), true, 4) then br.addonDebug("[Action:AoE] Frozen Orb") return true end
            end
        else
        -- Frozen Orb Key
            if mode.frozenOrb == 2 and br.isChecked("Frozen Orb Key") and br.SpecificToggle("Frozen Orb Key") and not GetCurrentKeyBoardFocus() then
                br.addonDebug("[Action:AoE] Frozen Orb")
                br._G.CastSpellByName(GetSpellInfo(spell.frozenOrb))
                return 
            end
        end
        -- actions.aoe+=/blizzard
        if mode.rotation ~= 2 and not tankMoving and not moving and not playerCasting then
            if buff.freezingRain.exists() then
                if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                    if br.createCastFunction("best", false, 4, 8, spell.blizzard, nil, false, 3) then br.addonDebug("[Action:AoE] Blizzard")
                        return true
                    end
                else
                    if br.createCastFunction("best", false, br.getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, false, 3) then br.addonDebug("[Action:AoE] Blizzard")
                        return true
                    end
                end
            else
                if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                    if br.createCastFunction("best", false, 4, 8, spell.blizzard, nil, true, 3) then br.addonDebug("[Action:AoE] Blizzard")
                        return true
                    end
                else
                    if br.createCastFunction("best", false, br.getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, true, 3) then br.addonDebug("[Action:AoE] Blizzard")
                        return true
                    end
                end
            end
        end
        -- actions.aoe+=/flurry,if=(remaining_winters_chill=0|debuff.winters_chill.down)&(prev_gcd.1.ebonbolt|buff.brain_freeze.react&buff.fingers_of_frost.react=0)
        if (debuff.wintersChill.exists() and debuff.wintersChill.remain() <= 0 or not debuff.wintersChill.exists())
        and (cast.last.ebonbolt() or buff.brainFreeze.exists() and not buff.fingersOfFrost.exists())
        then
            if cast.flurry("target") then br.addonDebug("[Action:AoE] Flurry") return true end
        end
        -- actions.aoe+=/ice_nova
        if cast.able.iceNova() then 
            if cast.iceNova("target") then br.addonDebug("[Action:AoE] Ice Nova") return true end 
        end
        -- actions.aoe+=/comet_storm
        if cast.cometStorm("target") then
            if br.GetUnitIsVisible("pet") and not br.isBoss("target") then
                C_Timer.After(playerCastRemain + 0.4, function()
                    if br.GetUnitIsVisible("target") then
                        local x,y,z = br.GetObjectPosition("target")
                        br.castAtPosition(x,y,z, spell.petFreeze)
                    end
                end)
            end
            return true 
        end
        -- actions.aoe+=/ice_lance,if=buff.fingers_of_frost.react|debuff.frozen.remains>travel_time|remaining_winters_chill&debuff.winters_chill.remains>travel_time
        if buff.fingersOfFrost.exists() or isFrozen("target") or debuff.wintersChill.exists("target") and debuff.wintersChill.remains("target") > travelTime then
            if cast.iceLance("target") then br.addonDebug("[Action:AoE] Ice Lance (Frozen or Winters Chill)") return true end 
        end
        ------------------------------------------------
        -- Covenants (Level 60) ------------------------
        ------------------------------------------------
        if level == 60 and not moving then
            ------------------------------------------------
            -- Mirrors of Torment : Venthyr ----------------
            ------------------------------------------------
            -- actions.aoe+=/mirrors_of_torment
            if covenant.venthyr.active and spellUsable(314793) and select(2,GetSpellCooldown(314793)) <= gcdMax then
                if cast.mirrorsOfTorment() then br.addonDebug("[Action:AoE] Mirrors Of Torment") return true end
            end
            ------------------------------------------------
            -- Shifting Power : Night Fae ------------------
            ------------------------------------------------
            -- actions.aoe+=/shifting_power
            if covenant.nightFae.active and spellUsable(314791) and select(2,GetSpellCooldown(314791)) <= gcdMax then
                if cast.shiftingPower() then br.addonDebug("[Action:AoE] Shifting Power") return true end
            end
            ------------------------------------------------
            -- Radiant Spark : Kyrian ----------------------
            ------------------------------------------------
            -- actions.aoe+=/radiant_spark
            if covenant.kyrian.active and spellUsable(307443) and select(2,GetSpellCooldown(307443)) <= gcdMax  then 
                if cast.radiantSpark() then br.addonDebug("[Action:AoE] Radiant Spark") return true end
            end
            ------------------------------------------------
            -- Radiant Spark : Kyrian ----------------------
            ------------------------------------------------

        end
        -- actions.aoe+=/fire_blast,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down
        -- actions.aoe+=/arcane_explosion,if=mana.pct>30&active_enemies>=6&!runeforge.glacial_fragments
        if not isTotem("target") and mode.ae ~= 2 and mode.rotation ~= 2 
        and cast.able.arcaneExplosion() and br.getDistance("target") <= 10 and manaPercent > 30 and blizzardUnits >= 6 and not runeforge.glacialFragments.equiped then
            if cast.arcaneExplosion("player","aoe", 3, 10) then br.addonDebug("[Action:AoE] Arcane Explosion") return true end 
        end
        -- actions.aoe+=/ebonbolt
        if mode.ebonbolt ~= 2 and not moving and ttd("target") > 5 then 
            if cast.ebonbolt("target") then br.addonDebug("[Action:AoE] Ebonbolt") return true end
        end 
        -- actions.aoe+=/ice_lance,if=runeforge.glacial_fragments&talent.splitting_ice&travel_time<ground_aoe.blizzard.remains
        -- actions.aoe+=/wait,sec=0.1,if=runeforge.glacial_fragments&talent.splitting_ice
        -- actions.aoe+=/frostbolt
        if not moving then if cast.frostbolt("target") then br.addonDebug("[Action:AoE] Frostbolt") return true end end 
    end

    --[[
Simc Action list Date: 01/28/2021
-----------------------------------
actions.st=flurry,if=(remaining_winters_chill=0|debuff.winters_chill.down)&(prev_gcd.1.ebonbolt|buff.brain_freeze.react&(prev_gcd.1.glacial_spike|prev_gcd.1.frostbolt&(!conduit.ire_of_the_ascended|cooldown.radiant_spark.remains|runeforge.freezing_winds)|prev_gcd.1.radiant_spark|buff.fingers_of_frost.react=0&(debuff.mirrors_of_torment.up|buff.freezing_winds.up|buff.expanded_potential.react)))
actions.st+=/frozen_orb
actions.st+=/blizzard,if=buff.freezing_rain.up|active_enemies>=2|runeforge.glacial_fragments&remaining_winters_chill=2
actions.st+=/ray_of_frost,if=remaining_winters_chill=1&debuff.winters_chill.remains
actions.st+=/glacial_spike,if=remaining_winters_chill&debuff.winters_chill.remains>cast_time+travel_time
actions.st+=/ice_lance,if=remaining_winters_chill&remaining_winters_chill>buff.fingers_of_frost.react&debuff.winters_chill.remains>travel_time
actions.st+=/comet_storm
actions.st+=/ice_nova
actions.st+=/radiant_spark,if=buff.freezing_winds.up&active_enemies=1
actions.st+=/ice_lance,if=buff.fingers_of_frost.react|debuff.frozen.remains>travel_time
actions.st+=/ebonbolt
actions.st+=/radiant_spark,if=(!runeforge.freezing_winds|active_enemies>=2)&buff.brain_freeze.react
actions.st+=/mirrors_of_torment
actions.st+=/shifting_power,if=buff.rune_of_power.down&(soulbind.grove_invigoration|soulbind.field_of_blossoms|active_enemies>=2)
actions.st+=/arcane_explosion,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_arcane.down
actions.st+=/fire_blast,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down
actions.st+=/glacial_spike,if=buff.brain_freeze.react
actions.st+=/frostbolt
    ]]
    local function actionList_ST_SL()
       -- if spellQueueReady() then

        -- actions.st=flurry,if=(remaining_winters_chill=0|debuff.winters_chill.down)&(prev_gcd.1.ebonbolt|buff.brain_freeze.react&(prev_gcd.1.glacial_spike|prev_gcd.1.frostbolt&(!conduit.ire_of_the_ascended|cooldown.radiant_spark.remains|runeforge.freezing_winds)
        --|prev_gcd.1.radiant_spark|buff.fingers_of_frost.react=0&(debuff.mirrors_of_torment.up|buff.freezing_winds.up|buff.expanded_potential.react)))
        if (not debuff.wintersChill.exists() or not debuff.wintersChill.exists())
        and cast.last.ebonbolt() or buff.brainFreeze.exists() 
        and (cast.last.glacialSpike() or cast.last.frostbolt())
        and (not IsSpellKnown(337058) or cd.radiantSpark.remains() >= gcdMax or runeforge.freezingWinds.equiped) or cast.last.radiantSpark() or buff.fingersOfFrost.exists() 
        and (debuff.mirrorsOfTorment.exists("target") or buff.freezingWinds.exists() or buff.expandedPotential.exists()) 
        then
            if cast.flurry("target") then return true end
        end
        
        -- actions.st+=/frozen_orb
        if mode.frozenOrb == 1 and not moving and targetMoveCheck then
            if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                if castFrozenOrb(1, true, 4) then return true end
            else
                if castFrozenOrb(br.getOptionValue("Frozen Orb Units"), true, 4) then return true end
            end
        else
        -- Frozen Orb Key
            if mode.frozenOrb == 2 and br.isChecked("Frozen Orb Key") and br.SpecificToggle("Frozen Orb Key") and not GetCurrentKeyBoardFocus() then
                br._G.CastSpellByName(GetSpellInfo(spell.frozenOrb), "cursor")
                return
            end
        end
            
        -- actions.st+=/blizzard,if=buff.freezing_rain.up|active_enemies>=2|runeforge.glacial_fragments&remaining_winters_chill=2
        if mode.rotation ~= 2 and not tankMoving and not moving and not playerCasting then
            if buff.freezingRain.exists() or blizzardUnits >= 2 or debuff.wintersChill.remain() >= 2 then
                if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                    if br.createCastFunction("best", false, 4, 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                else
                    if br.createCastFunction("best", false, br.getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                end
            else
                if not br.isChecked("Obey AoE units when using CDs") and br.useCDs() then
                    if br.createCastFunction("best", false, 4, 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                else
                    if br.createCastFunction("best", false, br.getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                end
            end
        end
        -- actions.st+=/ray_of_frost,if=remaining_winters_chill=1&debuff.winters_chill.remains
        if standingTime > 1 and debuff.wintersChill.exists("target") and debuff.wintersChill.remain() >= 1 then 
            if cast.rayOfFrost("target") then br.addonDebug("[Action:ST] Ray Of Frost (Winters Chill)") return true end 
        end

        -- actions.st+=/glacial_spike,if=remaining_winters_chill&debuff.winters_chill.remains>cast_time+travel_time
        if debuff.wintersChill.exists("target") and debuff.wintersChill.remains("target") > cast.time.glacialSpike()+travelTime then
            if cast.glacialSpike("target") then br.addonDebug("[Action:ST] Glacial Spike (Winters Chill)") return true end 
        end

        -- actions.st+=/ice_lance,if=remaining_winters_chill&remaining_winters_chill>buff.fingers_of_frost.react&debuff.winters_chill.remains>travel_time
        if debuff.wintersChill.exists("target") and debuff.wintersChill.remains("target") > buff.fingersOfFrost.remains() and debuff.wintersChill.remains("target") > travelTime then
            if cast.iceLance("target") then br.addonDebug("[Action:ST] Ice Lance (Winters Chill > Fingers of Frost)") return true end 
        end

        -- actions.st+=/comet_storm
        if cast.cometStorm("target") then
            if br.GetUnitIsVisible("pet") and not br.isBoss("target") then
                C_Timer.After(playerCastRemain + 0.4, function()
                    if br.GetUnitIsVisible("target") then
                        local x,y,z = br.GetObjectPosition("target")
                        br.castAtPosition(x,y,z, spell.petFreeze)
                    end
                end)
            end
            return true 
        end
        
        -- actions.st+=/ice_nova
        if cast.able.iceNova() then 
            if cast.iceNova("target") then br.addonDebug("[Action:ST] Ice Nova") return true end 
        end
 
        -- actions.st+=/ice_lance,if=buff.fingers_of_frost.react|debuff.frozen.remains>travel_time
        if buff.fingersOfFrost.exists() or isFrozen("target") then
            if cast.iceLance("target") then br.addonDebug("[Action:Rotation] Ice Lance FoF or Frozen") return true end 
        end 

        -- actions.st+=/ebonbolt
        --if cast.able.ebonbolt() then if cast.ebonbolt("target") then return true end end 
        -- actions.aoe+=/ebonbolt
        if mode.ebonbolt == 1 and not moving and ttd("target") > 5 and not bfExists then 
            if cast.ebonbolt("target") then return true end
        end 
            -- actions.st+=/radiant_spark,if=(!runeforge.freezing_winds|active_enemies>=2)&buff.brain_freeze.react
        ------------------------------------------------
        -- Covenants (Level 60) ------------------------
        ------------------------------------------------
        if level == 60 and not moving then
            ------------------------------------------------
            -- Mirrors of Torment : Venthyr ----------------
            ------------------------------------------------
            -- actions.st+=/mirrors_of_torment
            if covenant.venthyr.active and spellUsable(spell.mirrorsOfTorment) and select(2,GetSpellCooldown(spell.mirrorsOfTorment)) <= gcdMax then
                if cast.mirrorsOfTorment() then br.addonDebug("[Action:Rotation] Mirrors Of Torment") return true end
            end
            ------------------------------------------------
            -- Shifting Power : Night Fae ------------------
            ------------------------------------------------
            -- actions.st+=/shifting_power,if=buff.rune_of_power.down&(soulbind.grove_invigoration|soulbind.field_of_blossoms|active_enemies>=2)
            if covenant.nightFae.active and spellUsable(314791) and select(2,GetSpellCooldown(314791)) <= gcdMax 
            and not buff.runeOfPower.exists() 
            and (IsSpellKnown(322721) or IsSpellKnown(319191) or blizzardUnits >= 2)
            then
                if cast.shiftingPower() then br.addonDebug("[Action:Rotation] Shifting Power") return true end
            end
            ------------------------------------------------
            -- Radiant Spark : Kyrian ----------------------
            ------------------------------------------------
            -- actions.st+=/radiant_spark,if=buff.freezing_winds.up&active_enemies=1
            --  local spellId = (select(1,...))\n    \n    if (subEvent == \"SPELL_AURA_APPLIED\" or subEvnet == \"SPELL_AURA_REFRESH\")\n    and spellId == 327478 then\n        aura_env.Repeat = aura_env.config.rep\n        WeakAuras.ScanEvents(\"FW_REFIRE\")
            if covenant.kyrian.active and spellUsable(307443) and select(2,GetSpellCooldown(307443)) <= gcdMax 
            and buff.freezingWinds.exists() and blizzardUnits == 1 then 
                if cast.radiantSpark() then br.addonDebug("[Action:Rotation] Radiant Spark (ST-Freezing Winds)") return true end
            end
            -- actions.st+=/radiant_spark,if=(!runeforge.freezing_winds|active_enemies>=2)&buff.brain_freeze.react
            if covenant.kyrian.active and spellUsable(307443) and select(2,GetSpellCooldown(307443)) <= gcdMax 
            and (not runeforge.freezingWinds.equiped or blizzardUnits >= 2) and buff.brainFreeze.exists() then 
                if cast.radiantSpark() then br.addonDebug("[Action:Rotation] Radiant Spark (Brain Freeze-Enemies >= 2)") return true end
            end 
            ------------------------------------------------
            -- Radiant Spark : Kyrian ----------------------
            ------------------------------------------------
        end

            -- actions.st+=/arcane_explosion,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_arcane.down

            -- actions.st+=/fire_blast,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down
           --[[ if runeforge.disciplinaryCommand.equiped and cd.disciplinaryCommand.remains() <= gcdMax and not buff.disciplinaryCommand.exists() then
                if cast.fireBlast("target") then br.addonDebug("[Action:ST] Fire Blast - Disciplinary Command") return true end 
            end]]
    
            -- actions.st+=/glacial_spike,if=buff.brain_freeze.react
            if buff.brainFreeze.exists() and not moving then if cast.glacialSpike("target") then br.addonDebug("[Action:ST] Glacial Spike (Brain Freeze React)") return true end end

            -- actions.st+=/frostbolt
            if cast.frostbolt("target") and not moving then br.addonDebug("[Action:ST] Frostbolt") return true end 
        --end
    end

    local function actionList_Rotation()
        if (((buff.fingersOfFrost.count() > 1 and not br.isChecked("No Ice Lance")) or ((buff.fingersOfFrost.count() > 1 or ifCheck()) and iciclesStack > 5)) and interruptCast(spell.frostbolt)) or (buff.fingersOfFrost.count() > 1 and interruptCast(spell.ebonbolt)) then
            br._G.SpellStopCasting()
            return true
        end


        if spellQueueReady() then
            if moving then
                -- actions.movement+=/ice_floes,if=buff.ice_floes.down
                if talent.iceFloes and not buff.iceFloes.exists() and cast.timeSinceLast.iceFloes() >= ui.value("Ice Floes Delay") then
                    if cast.iceFloes("player") then return true end
                end
                
                if not isTotem("target") and mode.ae == 1 and cast.able.arcaneExplosion() and br.getDistance("target") <= 10 and manaPercent > 30 and #enemies.yards10 >= 2 then
                    if cast.arcaneExplosion("player","aoe", 3, 10) then return true end 
                end

                if mode.fb ~= 2 and cast.fireBlast("target") then return true end 

                if cast.iceLance("target") then return true end 
            end

            -- Cone of Cold
            if mode.coc == 1 then
                if br.getDistance("target") <= 8 and blizzardUnits >= ui.value("Cone of Cold Units") then
                   if cast.coneOfCold("player") then return true end
                end
            end

            -- actions+=/call_action_list,name=cooldowns
            if actionList_Cooldowns() then return true end

            if mode.rop ~= 2 and cast.able.runeofPower() and not moving and not buff.runeOfPower.exists() and not buff.icyVeins.exists() and cast.timeSinceLast.icyVeins() >= 10 then 
                if cast.runeofPower() then return true end 
            end

            if mode.rop ~= 2 and cast.able.runeofPower() and not moving and combatTime >= 13.5 and cd.icyVeins.remains() > gcdMax then 
                if cast.runeofPower() then return true end 
            end

            -- # The target threshold isn't exact. Between 3-5 targets, the differences between the ST and AoE action lists are rather small. However, Freezing Rain prefers using AoE action list sooner as it benefits greatly from the high priority Blizzard action.
            -- actions+=/call_action_list,name=aoe,if=active_enemies>3&talent.freezing_rain.enabled|active_enemies>4
            if ((blizzardUnits > 3 and talent.freezingRain) or blizzardUnits > 4) and (not inInstance or targetMoveCheck) then
                if actionList_AoE_SL() then return true end
            end

            -- actions+=/call_action_list,name=single
            if actionList_ST_SL() then return true end
        end
    end
    
    local function actionList_PreCombat()
        local petPadding = 2
        if br.isChecked("Pet Management") and not talent.lonelyWinter and not (IsFlying() or IsMounted()) and level >= 5 and br.timer:useTimer("summonPet", cast.time.summonWaterElemental() + petPadding) and not moving then
            if activePetId == 0 and lastSpell ~= spell.summonWaterElemental and select(2,GetSpellCooldown(spell.summonWaterElemental)) ~= 1 then
                if cast.summonWaterElemental("player") then
                    return true
                end
            end
        end

        if not inCombat and not (IsFlying() or IsMounted()) then
                if br.useCDs() and br.isChecked("Pre-Pull Logic") and br.GetObjectExists("target") and br.getDistance("target") < 40 then
                    local frostboltExecute = cast.time.frostbolt() + (br.getDistance("target") / 35)
                    if pullTimer <= frostboltExecute then
                        if br.isChecked("Pre Pot") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() then
                            use.battlePotionOfIntellect()
                        end

                        if fbInc == false and cast.frostbolt("target") then
                            fbInc = true
                            return true
                        end
                    end
                end

                if targetUnit then

                    if br.isChecked("Pet Management") and not talent.lonelyWinter and not br._G.UnitAffectingCombat("pet") then
                        br._G.PetAssistMode()
                        br._G.PetAttack("target")
                    end

                    if br.getOptionValue("APL Mode") == 2 then
                        if moving or targetUnit.calcHP < calcDamage(spell.iceLance, targetUnit) then
                            if cast.iceLance("target") then
                                return true
                            end

                        else
                            if cast.frostbolt("target") then
                                return true
                            end
                        end

                    elseif br.getOptionValue("APL Mode") == 3 then
                        if cast.iceLance("target") then
                            return true
                        end
                    end
                end
        end -- End No Combat

    end -- End Action List - PreCombat



    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not UnitIsAFK("player") and not inCombat and not hastar and br.profileStop==true then
        br.profileStop = false
    elseif inCombat and br._G.IsAoEPending() then
        br._G.SpellStopTargeting()
        br.addonDebug("Canceling Spell")
        return false
    elseif (inCombat and br.profileStop==true) or IsMounted() or br._G.UnitChannelInfo("player") or IsFlying() or UnitIsAFK("player") or br.pause() or mode.rotation == 4 then
        if not br.pause(true) and not talent.lonelyWinter and IsPetAttackActive() and br.isChecked("Pet Management") then
            br._G.PetStopAttack()
            br._G.PetFollow()
        end
        return true
    else
        if br.isChecked("Pull OoC") and solo and not inCombat then 
            if not moving then
                if br.timer:useTimer("Frostbolt delay", 1.5) then
                    if cast.frostbolt() then br.addonDebug("Casting Frostbolt (Pull Spell)") return end
                end
            else
                if br.timer:useTimer("IL Delay", 1.5) then
                    if cast.iceLance() then br.addonDebug("Casting Ice Lance (Pull Spell)") return end
                end
            end
        end

                if br._G.UnitChannelInfo("player") == GetSpellInfo(spell.shiftingPower) then 
            br.ChatOverlay("no shifting power allowed!")
            br._G.SpellStopCasting() 
            return true 
        end

    -----------------------
    --- Extras Rotation ---
    -----------------------
        if actionList_Extras() then return true end

    -----------------------
    ---     Opener      ---
    -----------------------
    --    if opener == false and br.isChecked("Opener") and br.isBoss("target") then if actionList_Opener() then return true end end

    ------------------------------
    --- Out of Combat Rotation ---
    ------------------------------
        if actionList_PreCombat() then return true end

                        if talent.iceFloes and moving then
                    -- If we have ice floes charges and we don't have the buff, cast ice floes. 
                    if charges.iceFloes.count() > 0 and not buff.iceFloes.exists() then
                        if cast.iceFloes("player") then return true end 
                    end
                    -- If we have ice floes up, and we're currently casting a spell while moving with the ice floes buff, attmept to get a free IF by batching at the end of the cast. 
                    if br._G.UnitCastingInfo("player") ~= nil and charges.iceFloes.count() > 0 and buff.iceFloes.exists() and playerCastRemain <= 0.5 then
                        if cast.iceFloes("player") then br.addonDebug("[Advanced] Ice Floes (Moving, Cast Time < 0.5, Batched)") return true end 
                    end
                    
               end
                if talent.iceFloes and moving and buff.iceFloes.exists() then if cast.frostbolt() then return true end end 

    --------------------------
    --- In Combat Rotation ---
    --------------------------        
        if (inCombat or cast.inFlight.frostbolt() or spellQueueReady()) and br.profileStop == false and br.isValidUnit("target") and br.getDistance("target") < 40 then

        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList_Defensive() then return true end

        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
        if actionList_Interrupts() then return true end
            if br.queueSpell then
                br.ChatOverlay("Pausing for queuecast")
                return true 
            end

            if not br.pause(true) and hastar then
                if br.isChecked("Pet Management") and not talent.lonelyWinter and br.GetUnitIsVisible("pet") and not br.GetUnitIsUnit("pettarget", "target")  then
                    br.PetAttack()
                end
            --------------------------
            ---      Rotation      ---
            --------------------------
                if br.getOptionValue("APL Mode") == 1 then
                    if actionList_Rotation() then return true end

                elseif br.getOptionValue("APL Mode") == 2 then
                    if actionList_Leveling() then return true end

                elseif br.getOptionValue("APL Mode") == 3 then
                    if bfExists then if cast.flurry("target") then return true end end
                    if cast.iceLance("target") then return true end
                end
            end
        end
    end
end
local id = 64
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

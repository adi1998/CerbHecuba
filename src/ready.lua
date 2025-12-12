
mod.InfestedCerberus = {
    GrannyModel = "InfestedCerberus_Mesh",
    Graphic = "Familiar_Cerberus_Idle",
    StartGraphic = "Familiar_Cerberus_MoveStart",
    MoveGraphic = "Familiar_Cerberus_Move",
    StopGraphic = "Familiar_Cerberus_MoveStop",
    Package = "BiomeH",
}

function SetupHoundCerb()
    local  unit = mod.InfestedCerberus
    local mesh = unit.GrannyModel
    local graphic = unit.Graphic

    local start = unit.StartGraphic
    if start == "" or start == "None" then
        start = nil
    end
    local move = unit.MoveGraphic
    if move == "" or move == "None" then
        move = nil
    end
    local stop = unit.StopGraphic
    if stop == "" or stop == "None" then
        stop = nil
    end
    
    -- local familiar = MapState.FamiliarUnit
    -- if familiar == nil then
    --     return
    -- end
    -- if GameState.EquippedFamiliar ~= "HoundFamiliar" then
    --     return
    -- end

    local houndIds = GetIdsByType({ Name = "HoundFamiliar" })
    if #houndIds < 1 then
        return
    end
    print("hound to creb")
    local houndId = houndIds[1]

    -- local texture = ""
    -- if rom.mods["zerp-FamiliarCostume"] ~= nil then
    --     texture = ""
    -- end

    SetThingProperty({ Property = "GrannyModel", Value = mesh, DestinationId = houndId })
    SetThingProperty({ Property = "Graphic", Value = graphic, DestinationId = houndId })
    SetUnitProperty({ Property = "StartGraphic", Value = start, DestinationId = houndId })
	SetUnitProperty({ Property = "MoveGraphic", Value = move, DestinationId = houndId })
	SetUnitProperty({ Property = "StopGraphic", Value = stop, DestinationId = houndId })
    -- SetThingProperty({ Property = "GrannyTexture", Value = texture, DestinationId = houndId })
    
    SetScale({ Id = houndId, Fraction = 0.45 })
end

-- "Familiar_Hound_Attack",
-- "Familiar_Hound_Dig",


CerbAnimation = {
    "Familiar_Cerberus_PoundRFire",
    "Familiar_Cerberus_BurrowStart",
    "Familiar_Cerberus_BurrowEmerge",
    "ShovelDirtInSprayHound",
    "ShovelDirtInSprayHound",
    "ShovelDirtOutSprayHound",
}

FamiliarData.HoundFamiliar.Using.Animation = CerbAnimation


modutil.mod.Path.Wrap("AssignFamiliarKits", function (base, ...)
    base(...)
    SetupHoundCerb()
end)

modutil.mod.Path.Wrap("FamiliarSetup", function (base, source, args)
    base(source, args)
    SetupHoundCerb()
end)

modutil.mod.Path.Wrap("SetupFamiliarCostume", function (base, familiar, args)
    if familiar.Name == "HoundFamiliar" then
        SetupHoundCerb()
        return
    end
    base(familiar,args)
end)

-- Familiar_Hound_Dig_ShovelPoint
-- Familiar_Hound_Dig_ShovelPoint_End
-- Familiar_Hound_Attack
-- Familiar_Hound_Dig
-- Familiar_Hound_DropIn_Enter

function PlayPettingSounds(id)
    Frames =
    {
        {
            Frame = 47,
            Sound = "/VO/CerberusCry",
        },
        {
            Frame = 120,
            Sound = "/VO/CerberusCuteGrowl_2",
        },
        {
            Frame = 160,
            Sound = "/VO/CerberusWhineHappy",
        },
        {
            Frame = 210,
            Sound = "/VO/CerberusCuteWhine_3",
        },
        {
            Frame = 290,
            Sound = "/VO/CerberusSnarls",
        },
        {
            Frame = 360,
            Sound = "/VO/CerberusCry",
        },
        {
            Frame = 420,
            Sound = "/VO/CerberusCuteGrowl_3",
        },
    }
    local lastFrame = 0.0
    wait(47/60.0)
    for index, sound in ipairs(Frames) do
        local soundid = PlaySound({ Name = sound.Sound, Id = id, ManagerCap = nil })
        SetVolume({ Id = soundid, Value = 0.7, Duration = 0.0 })
        lastFrame = sound.Frame
    end
end

function CerbPet1(base,args,duration)
    args.Name = "Familiar_Cerberus_BarkPreFire"
    base(args)
    args.Name = "Familiar_Cerberus_BarkFireLoop"
    -- game.thread(PlayPettingSounds,args.DestinationId)
    base(args)
    wait(duration or 2.5)
    args.Name = "Familiar_Cerberus_BarkPostFire"
    base(args)
end

function CerbPet2(base,args)
    args.Name = "Familiar_Cerberus_Howl"
    base(args)
    -- PlayPettingSounds(args.DestinationId)
    PlaySound({ Name = "/SFX/Enemy Sounds/Werewolf/EmoteHowling", Id = args.DestinationId, ManagerCap = nil })
end

function CerbPet3(base,args)
    args.Name = "Familiar_Cerberus_Shake"
    base(args)
    -- PlayPettingSounds(args.DestinationId)
    -- PlaySound({ Name = "/SFX/Enemy Sounds/Werewolf/EmoteHowling", Id = args.DestinationId, ManagerCap = nil })
end

modutil.mod.Path.Wrap("SetAnimation", function (base, args)
    if args.Name == "Familiar_Hound_Attack" then
        args.Name = "Familiar_Cerberus_PoundRFire"
        if math.random(2) == 1 then
            args.Name = "Familiar_Cerberus_PoundLFire"
        end
        -- PlaySound({ Name = "/SFX/Enemy Sounds/CorruptedCerberus/Cerberus_ChargeGrowl", Id = args.DestinationId, ManagerCap = nil })
        PlaySound({ Name = "/SFX/Enemy Sounds/Minotaur/HugeAxeSwing", Id = args.DestinationId, ManagerCap = nil })
        PlaySound({ Name = "/SFX/Enemy Sounds/CorruptedCerberus/Cerberus_Bark", Id = args.DestinationId, ManagerCap = nil })
        return base(args)
    end
    if args.Name == "Familiar_Hound_Dig" or args.Name == "Familiar_Hound_Dig_ShovelPoint" then
        args.Name = "Familiar_Cerberus_BurrowStart"
        base(args)
        args.Name = "Familiar_Cerberus_BurrowEmerge"
        waitUnmodified( 1.8, MapState.FamiliarUnit.AIThreadName )
        base(args)
        return
    end
    if args.Name == "Familiar_Hound_DropIn_Enter" then
        args.Name = "Familiar_Cerberus_BurrowEmerge"
        base(args)
        return
    end
    if args.Name == "Familiar_Hound_DropIn_Exit" then
        args.Name = "Familiar_Cerberus_BurrowStart"
        base(args)
        return
    end
    if args.Name == "Familiar_Hound_StandToSit" or args.Name == "Familiar_Hound_SitToStand" or
       args.Name == "Familiar_Hound_Sit_Idle" or args.Name == "Familiar_Hound_Stande_Idle" or
       args.Name == "Familiar_Hound_Sit" or args.Name == "Familiar_Hound_Stand" then
        args.Name = "Familiar_Cerberus_Idle"
        base(args)
        return
    end
    if args.Name == "Familiar_Hound_Pet" then
        local petOption = math.random(3)
        if petOption == 1 then
            game.thread(CerbPet1, base, args)
        elseif petOption == 2 then
            CerbPet2(base, args)
        else
            CerbPet3(base, args)
        end
        -- PlaySound({ Name = "/SFX/Enemy Sounds/CorruptedCerberus/Cerberus_PlagueRoar", Id = args.DestinationId, ManagerCap = nil })
        return
    end
    if args.Name == "Familiar_Hound_Greet" then
        local petOption = math.random(2)
        if petOption == 1 then
            game.thread(CerbPet1, base, args, 1)
        else
            CerbPet2(base, args)
        end
        return
    end
    if args.Name == "Familiar_Hound_HubHangout_1_Greet" then
        args.Name = "Familiar_Cerberus_Idle"
        base(args)
        return
    end
    if args.Name ~= nil and args.Name:find("^Familiar_Hound_") then
        print("missing hound animation override", args.Name)
    end
    return base(args)
end)

modutil.mod.Path.Wrap("SetupMap", function (base)
    LoadPackages({Name = mod.InfestedCerberus.Package})
    LoadVoiceBanks({ Names = { "BiomeI", "BiomeIHouse" }})
    base()
end)

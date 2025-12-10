
mod.InfestedCerberus = {
    GrannyModel = "InfestedCerberus_Mesh",
    Graphic = "Enemy_InfestedCerberus_Idle",
    StartGraphic = "Enemy_InfestedCerberus_MoveStart",
    MoveGraphic = "Enemy_InfestedCerberus_Move",
    StopGraphic = "Enemy_InfestedCerberus_MoveStop",
    Package = "BiomeH",
}

function SetupHoundCerb()
    local  unit = mod.InfestedCerberus
    local mesh = unit.GrannyModel
    local texture = unit.GrannyTexture
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
    houndId = houndIds[1]
    SetThingProperty({ Property = "GrannyModel", Value = mesh, DestinationId = houndId })
    SetThingProperty({ Property = "Graphic", Value = graphic, DestinationId = houndId })
    SetUnitProperty({ Property = "StartGraphic", Value = start, DestinationId = houndId })
	SetUnitProperty({ Property = "MoveGraphic", Value = move, DestinationId = houndId })
	SetUnitProperty({ Property = "StopGraphic", Value = stop, DestinationId = houndId })
    SetThingProperty({ Property = "GrannyTexture", Value = texture, DestinationId = houndId })
    
    SetScale({ Id = houndId, Fraction = 0.4 })
end

-- "Familiar_Hound_Attack",
-- "Familiar_Hound_Dig",


CerbAnimation = {
    "Enemy_InfestedCerberus_PoundRFire",
    "Enemy_InfestedCerberus_BurrowStart",
    "Enemy_InfestedCerberus_BurrowEmerge",
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

modutil.mod.Path.Wrap("SetAnimation", function (base, args)
    if args.Name == "Familiar_Hound_Attack" then
        args.Name = "Enemy_InfestedCerberus_PoundRFire"
        if math.random(2) == 1 then
            args.Name = "Enemy_InfestedCerberus_PoundLFire"
        end
        return base(args)
    end
    if args.Name == "Familiar_Hound_Dig" or args.Name == "Familiar_Hound_Dig_ShovelPoint" then
        args.Name = "Enemy_InfestedCerberus_BurrowStart"
        base(args)
        args.Name = "Enemy_InfestedCerberus_BurrowEmerge"
        waitUnmodified( 1.8, MapState.FamiliarUnit.AIThreadName )
        base(args)
        return
    end
    if args.Name == "Familiar_Hound_DropIn_Enter" then
        args.Name = "Enemy_InfestedCerberus_BurrowEmerge"
        base(args)
        return
    end
    if args.Name == "Familiar_Hound_DropIn_Exit" then
        args.Name = "Enemy_InfestedCerberus_BurrowStart"
        base(args)
        return
    end
    if args.Name == "Familiar_Hound_StandToSit" or args.Name == "Familiar_Hound_SitToStand" or
       args.Name == "Familiar_Hound_Sit_Idle" or args.Name == "Familiar_Hound_Stande_Idle" or
       args.Name == "Familiar_Hound_Sit" or args.Name == "Familiar_Hound_Stand" then
        args.Name = "Enemy_InfestedCerberus_Idle"
        base(args)
        return
    end
    if args.Name == "Familiar_Hound_Pet" then
        args.Name = "Enemy_InfestedCerberus_Howl"
        base(args)
        return
    end
    if args.Name == "Familiar_Hound_HubHangout_1_Greet" then
        args.Name = "Enemy_InfestedCerberus_Idle"
        base(args)
        return
    end
    if args.Name:find("^Familiar_Hound_") then
        print("missing hound animation override", args.Name)
    end
    return base(args)
end)

modutil.mod.Path.Wrap("SetupMap", function (base)
    LoadPackages({Name = mod.InfestedCerberus.Package})
    base()
end)
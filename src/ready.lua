
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
    
    local familiar = MapState.FamiliarUnit
    if familiar == nil then
        return
    end
    if GameState.EquippedFamiliar ~= "HoundFamiliar" then
        return
    end
    SetThingProperty({ Property = "GrannyModel", Value = mesh, DestinationId = familiar.ObjectId })
    SetThingProperty({ Property = "Graphic", Value = graphic, DestinationId = familiar.ObjectId })
    SetUnitProperty({ Property = "StartGraphic", Value = start, DestinationId = familiar.ObjectId })
	SetUnitProperty({ Property = "MoveGraphic", Value = move, DestinationId = familiar.ObjectId })
	SetUnitProperty({ Property = "StopGraphic", Value = stop, DestinationId = familiar.ObjectId })
    SetThingProperty({ Property = "GrannyTexture", Value = texture, DestinationId = familiar.ObjectId })
    
    SetScale({ Id = familiar.ObjectId, Fraction = 0.4 })
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


modutil.mod.Path.Wrap("FamiliarSetup", function (base, source, args)
    base(source, args)
    SetupHoundCerb()
end)

modutil.mod.Path.Wrap("SetupFamiliarCostume", function (base, familiar,args)
    if GameState.EquippedFamiliar == "HoundFamiliar" then
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
        waitUnmodified( 1.6, MapState.FamiliarUnit.AIThreadName )
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
    if args.Name == "Familiar_Hound_StandToSit" or args.Name == "Familiar_Hound_SitToStand" or args.Name == "Familiar_Hound_Sit" or args.Name == "Familiar_Hound_Stand" then
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
    return base(args)
end)

modutil.mod.Path.Wrap("SetupMap", function (base)
    LoadPackages({Name = mod.InfestedCerberus.Package})
    base()
end)
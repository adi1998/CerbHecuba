
local trailORder = {
    "Name",
    "FilePath",
    "NumFrames",
    "UseOwnAngle",
    "AngleFromOwner",
    "GroupName",
    "ScaleMin",
    "ScaleMax",
    "RandomFlipHorizontal",
    "RandomPlaySpeedMin",
    "RandomPlaySpeedMax",
    "LocationZFromOwner",
    "LocationFromOwner",
    "ScaleFromOwner",
    "UseAttachedFlasher",
    "UseAttachedShake",
    "Scale",
    "Hue",
    "Saturation",
    "Value",
}

local cerbhoundTrail = {
		Name = "CerbBibMoveTrail",
		FilePath = "Fx\\Cerb\\CerbBibTrail\\CerbBibTrail",
		NumFrames = 60,
		UseOwnAngle = false,
		AngleFromOwner = "Ignore",
		GroupName = "FX_Terrain",
		ScaleMin = 0.7,
		ScaleMax = 1.1,
		RandomFlipHorizontal = true,
		RandomPlaySpeedMin = 24,
		RandomPlaySpeedMax = 30,
		LocationZFromOwner = "Ignore",
		LocationFromOwner = "Ignore",
		ScaleFromOwner = "Ignore",
		UseAttachedFlasher = false,
		UseAttachedShake = false,
		Scale = 0.7,
		Hue = 0.05,
		Saturation = 0.15,
		Value = -0.05,
}

local vfxFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\Enemy_Fields_VFX.sjson")

sjson.hook(vfxFile, function(data)
    local newdata = {}
    for index, value in ipairs(data.Animations) do
        if value.Name == "CerbBibMoveTrail" then
            local newentry = DeepCopyTable(value)
            newentry.Scale = value.Scale * 0.4
            newentry.Name = "Familiar_Cerberus_" .. value.Name
            table.insert(newdata,newdata)
        end
    end
    for index, value in ipairs(newdata) do
        table.insert(data.Animations,value)
    end
end)

local cerberusFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\Model\\Enemy_InfestedCerberus_Animation.sjson")

sjson.hook(cerberusFile, function (data)
    local cerbFamiliarFile = rom.path.combine(rom.paths.plugins(), _PLUGIN.guid .. "\\CerbHound.sjson")
    print(cerbFamiliarFile)
    local fileHandle = io.open(cerbFamiliarFile,"r")
    local cerbFamiliarContent = fileHandle:read("*a")
    local cerbTable = sjson.decode(cerbFamiliarContent)
    for key, value in pairs(cerbTable.Animations) do
        table.insert(data.Animations, value)
    end
end)
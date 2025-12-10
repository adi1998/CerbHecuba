
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
    for index, value in ipairs(data.Animations) do
        if value.Name == "CerbBibMoveTrail" then
            value.ScaleFromOwner = "Take"
            -- value.Scale = nil
            -- value.ScaleMin = 0.1
            -- value.ScaleMax = 1.5
        end
    end
end)

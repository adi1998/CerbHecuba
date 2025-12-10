mod.CerbInteractVoice = {
    PreLineWait = 0.4,
    RandomRemaining = true,
    BreakIfPlayed = true,
    GameStateRequirements =
    {
        {
            -- PathTrue = { "CurrentRun", "Hero", "IsDead" },
        },
    },

    { Cue = "/VO/MelinoeField_3891", Text = "There's a good boy..." },
    { Cue = "/VO/MelinoeField_3892", Text = "You like that, don't you...?" },
    { Cue = "/VO/MelinoeField_3893", Text = "You know me now, don't you?" },
    { Cue = "/VO/MelinoeField_3894", Text = "Just this one head, I know..." },
    { Cue = "/VO/MelinoeField_3895", Text = "Don't snap my head off, boy..." },
    { Cue = "/VO/MelinoeField_3896", Text = "You're a fine dog.", PlayFirst = true },
    { Cue = "/VO/MelinoeField_3899", Text = "There you go..." },
    { Cue = "/VO/MelinoeField_3900", Text = "Let me get that for you..." },
}

game.FamiliarData.HoundFamiliar.InteractVoiceLines[2] = mod.CerbInteractVoice
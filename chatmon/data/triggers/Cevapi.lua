-- Chatmon triggers for Cevapi.
-- When this file exists, chatmon loads it instead of global.lua, so we need to
-- include the default global triggers here too (tell/emote/invite/examine/<name>).
-- Trigger order matters: chatmon stops at the first match per chat line.
return {
    -- =========================================================================
    -- BLU spell-learn alert
    --   Fires on system message "Cevapi learns <SpellName>!"
    --   `from = S{"all"}` catches system text (incoming text handler).
    --   Trigger sits first so it has priority over the generic alerts below.
    --   Sound: blu_learn.wav (FFXIV's "BLU Action Learned" spell-learn sfx,
    --   from Zedge → MP3→WAV conversion → addons/chatmon/data/sounds/).
    --   Thematic match — same family of game audio so it'll feel native.
    --   Backup options also in data/sounds/: tada.wav (Windows fanfare),
    --   chord.wav (quiet 3-note chord).
    -- =========================================================================
    { from = S{ "all" }, match = "*Cevapi learns *", notMatch = "", sound = "blu_learn.wav" },

    -- =========================================================================
    -- Default triggers (carried over from global.lua so we don't lose them)
    -- =========================================================================
    { from = S{ "tell"    }, notFrom = S{}, match = "*",      notMatch = "", sound = "IncomingTell.wav"    },
    { from = S{ "emote"   }, notFrom = S{}, match = "*",      notMatch = "", sound = "IncomingEmote.wav"   },
    { from = S{ "invite"  }, notFrom = S{}, match = "*",      notMatch = "", sound = "PartyInvitation.wav" },
    { from = S{ "examine" }, notFrom = S{}, match = "*",      notMatch = "", sound = "IncomingExamine.wav" },
    { from = S{ "say", "shout", "party", "linkshell" }, notFrom = S{}, match = "<name>", notMatch = "", sound = "IncomingTalk.wav" },
}

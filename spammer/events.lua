local ev = require "lib.samp.events"


function ev.onSendBulletSync(data)
    if is_song_loaded then
        if (data.targetType == 1 and data.weaponId == 24) then
            lua_thread.create(function()
                setAudioStreamState(audio_handler, 1)
            end)
        end
    end
end

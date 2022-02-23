local ev = require "lib.samp.events"

function ev.onSendBulletSync(data)
    if loaded_songs then
        if data.targetType == 1 then
            lua_thread.create(function()
                setAudioStreamState(audio_handler, 1)
            end)
        end
    end
end
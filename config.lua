require 'math'

sounds = {
    "headshoot.mp3",
    "Viorel@TAYOTA - woowww.mp3"
}

-- De aici iti poti adauga servere
ip_and_port = {
    {"rpg.og-times.ro", "777"},
    {"rpg.crowland.ro", "7777"},
    {"rpg.b-hood.ro", "7777"},
    {"ruby.nephrite.ro", "7777"},
    {"blue.bugged.ro", "7777"},
    {"rpg1.b-zone.ro", "7777"},
    {"rpg.gradinareni.ro", "7777"}
}

-- De aici iti poti adauga nickname-uri
usernames = {
    "Cristian",
    "Criss",
    ".Cristian",
    "Cristian9",
    "Cistii"
}

-- De aici iti poti adauga profiluri
configs = {
    {"war"                 , "/war", "/wars", "/war3", "/war5"},
    {"turf"                , "turf", "/turfs", "/attack"}
}

function return_servers_ip()
    local array = {}
    for c, x in ipairs(ip_and_port) do
        table.insert(array, x[1])
    end
    return array
end

function clear_all_commands()
    for c, comands in ipairs(commands_array) do
        commands_array[c] = nil
    end
end

function config_names()
    local profile_names = {}
    for c, name in ipairs(configs) do
        table.insert(profile_names, name[1])
    end
    return profile_names
end

function load_commands(id)
    id = id + 1
    for c, command_name in ipairs(configs[id]) do 
        if c ~= 1 then
            table.insert(commands_array, command_name)
        end
    end
end

function send_commands()
    while true do
        wait(0)
        for c, command in ipairs(commands_array) do
            for x = 1, threads_slider.v, 1 do
                lua_thread.create(function()
                    sampSendChat(command)
                end)
            end
            wait(delay_input.v)
        end
    end
end

function return_key_names()
    local array = {}
    for c, x in ipairs(keys) do
        table.insert(array, x[2])
    end
    return array
end

function return_key_id(selected_key)
    for c, x in ipairs(keys) do 
        if selected_key == c then
            return x[1]
        end
    end
end

function return_key_name(selected_key)
    for c, x in ipairs(keys) do 
        if selected_key == c then
            return x[2]
        end
    end
end

function return_key_value(selected_key)
    for c, x in ipairs(keys) do 
        if selected_key == c then
            return x[3]
        end
    end
end

function splited_command(command)
    if string.len(command) > 10 then
        return string.sub(command, 1, 10) .. "..."
    end
    return command
end

function return_name_and_command()
    local array = {}
    for c, x in ipairs(hotkeys_array) do
        table.insert(array, string.format("Key: %s, Command: %s", x[2], splited_command(x[4])))
    end
    return array
end

function start_hotkey_attack()
    while true do
        wait(0)
        for c, x in ipairs(hotkeys_array) do
            if isKeyDown(x[3]) then 
                for z = 1, threads_hotkey_slider.v, 1 do
                    lua_thread.create(function()
                        sampSendChat(x[4])
                    end)
                end
                wait(delay_hotkey_slider.v)
            end
        end
    end
end

function load_sound(song_path)
    audio_handler = loadAudioStream(song_path)
end

keys = {
    {1, "LBUTTON", 0x01},
    {2, "RBUTTON", 0x02},
    {3, "CANCEL", 0x03},
    {4, "MBUTTON", 0x04},
    {5, "XBUTTON1", 0x05},
    {6, "XBUTTON2", 0x06},
    {7, "BACK", 0x08},
    {8, "TAB", 0x09},
    {9, "CLEAR", 0x0C},
    {10, "RETURN", 0x0D},
    {11, "SHIFT", 0x10},
    {12, "CONTROL", 0x11},
    {13, "MENU", 0x12},
    {14, "PAUSE", 0x13},
    {15, "CAPITAL", 0x14},
    {16, "KANA", 0x15},
    {17, "JUNJA", 0x17},
    {18, "FINAL", 0x18},
    {19, "KANJI", 0x19},
    {20, "ESCAPE", 0x1B},
    {21, "CONVERT", 0x1C},
    {22, "NONCONVERT", 0x1D},
    {23, "ACCEPT", 0x1E},
    {24, "MODECHANGE", 0x1F},
    {25, "SPACE", 0x20},
    {26, "PRIOR", 0x21},
    {27, "NEXT", 0x22},
    {28, "END", 0x23},
    {29, "HOME", 0x24},
    {30, "LEFT", 0x25},
    {31, "UP", 0x26},
    {32, "RIGHT", 0x27},
    {33, "DOWN", 0x28},
    {34, "SELECT", 0x29},
    {35, "PRINT", 0x2A},
    {36, "EXECUTE", 0x2B},
    {37, "SNAPSHOT", 0x2C},
    {38, "INSERT", 0x2D},
    {39, "DELETE", 0x2E},
    {40, "HELP", 0x2F},
    {41, "0", 0x30},
    {42, "1", 0x31},
    {43, "2", 0x32},
    {44, "3", 0x33},
    {45, "4", 0x34},
    {46, "5", 0x35},
    {47, "6", 0x36},
    {48, "7", 0x37},
    {49, "8", 0x38},
    {50, "9", 0x39},
    {51, "A", 0x41},
    {52, "B", 0x42},
    {53, "C", 0x43},
    {54, "D", 0x44},
    {55, "E", 0x45},
    {56, "F", 0x46},
    {57, "G", 0x47},
    {58, "H", 0x48},
    {59, "I", 0x49},
    {60, "J", 0x4A},
    {61, "K", 0x4B},
    {62, "L", 0x4C},
    {63, "M", 0x4D},
    {64, "N", 0x4E},
    {65, "O", 0x4F},
    {66, "P", 0x50},
    {67, "Q", 0x51},
    {68, "R", 0x52},
    {69, "S", 0x53},
    {70, "T", 0x54},
    {71, "U", 0x55},
    {72, "V", 0x56},
    {73, "W", 0x57},
    {74, "X", 0x58},
    {75, "Y", 0x59},
    {76, "Z", 0x5A},
    {77, "LWIN", 0x5B},
    {78, "RWIN", 0x5C},
    {79, "APPS", 0x5D},
    {80, "SLEEP", 0x5F},
    {81, "NUMPAD0", 0x60},
    {82, "NUMPAD1", 0x61},
    {83, "NUMPAD2", 0x62},
    {84, "NUMPAD3", 0x63},
    {85, "NUMPAD4", 0x64},
    {86, "NUMPAD5", 0x65},
    {87, "NUMPAD6", 0x66},
    {88, "NUMPAD7", 0x67},
    {89, "NUMPAD8", 0x68},
    {90, "NUMPAD9", 0x69},
    {91, "MULTIPLY", 0x6A},
    {92, "ADD", 0x6B},
    {93, "SEPARATOR", 0x6C},
    {94, "SUBTRACT", 0x6D},
    {95, "DECIMAL", 0x6E},
    {96, "DIVIDE", 0x6F},
    {97, "F1", 0x70},
    {98, "F2", 0x71},
    {99, "F3", 0x72},
    {100, "F4", 0x73},
    {101, "F5", 0x74},
    {102, "F6", 0x75},
    {103, "F7", 0x76},
    {104, "F8", 0x77},
    {105, "F9", 0x78},
    {106, "F10", 0x79},
    {107, "F11", 0x7A},
    {108, "F12", 0x7B},
    {109, "F13", 0x7C},
    {110, "F14", 0x7D},
    {111, "F15", 0x7E},
    {112, "F16", 0x7F},
    {113, "F17", 0x80},
    {114, "F18", 0x81},
    {115, "F19", 0x82},
    {116, "F20", 0x83},
    {117, "F21", 0x84},
    {118, "F22", 0x85},
    {119, "F23", 0x86},
    {120, "F24", 0x87},
    {121, "NUMLOCK", 0x90},
    {122, "SCROLL", 0x91},
    {123, "OEM_FJ_JISHO", 0x92},
    {124, "OEM_FJ_MASSHOU", 0x93},
    {125, "OEM_FJ_TOUROKU", 0x94},
    {126, "OEM_FJ_LOYA", 0x95},
    {127, "OEM_FJ_ROYA", 0x96},
    {128, "LSHIFT", 0xA0},
    {129, "RSHIFT", 0xA1},
    {130, "LCONTROL", 0xA2},
    {131, "RCONTROL", 0xA3},
    {132, "LMENU", 0xA4},
    {133, "RMENU", 0xA5},
    {134, "BROWSER_BACK", 0xA6},
    {135, "BROWSER_FORWARD", 0xA7},
    {136, "BROWSER_REFRESH", 0xA8},
    {137, "BROWSER_STOP", 0xA9},
    {138, "BROWSER_SEARCH", 0xAA},
    {139, "BROWSER_FAVORITES", 0xAB},
    {140, "BROWSER_HOME", 0xAC},
    {141, "VOLUME_MUTE", 0xAD},
    {142, "VOLUME_DOWN", 0xAE},
    {143, "VOLUME_UP", 0xAF},
    {144, "MEDIA_NEXT_TRACK", 0xB0},
    {145, "MEDIA_PREV_TRACK", 0xB1},
    {146, "MEDIA_STOP", 0xB2},
    {147, "MEDIA_PLAY_PAUSE", 0xB3},
    {148, "LAUNCH_MAIL", 0xB4},
    {149, "LAUNCH_MEDIA_SELECT", 0xB5},
    {150, "LAUNCH_APP1", 0xB6},
    {151, "LAUNCH_APP2", 0xB7},
    {152, "OEM_1", 0xBA},
    {153, "OEM_PLUS", 0xBB},
    {154, "OEM_COMMA", 0xBC},
    {155, "OEM_MINUS", 0xBD},
    {156, "OEM_PERIOD", 0xBE},
    {157, "OEM_2", 0xBF},
    {158, "OEM_3", 0xC0},
    {159, "ABNT_C1", 0xC1},
    {160, "ABNT_C2", 0xC2},
    {161, "OEM_4", 0xDB},
    {162, "OEM_5", 0xDC},
    {163, "OEM_6", 0xDD},
    {164, "OEM_7", 0xDE},
    {165, "OEM_8", 0xDF},
    {166, "OEM_AX", 0xE1},
    {167, "OEM_102", 0xE2},
    {168, "ICO_HELP", 0xE3},
    {169, "PROCESSKEY", 0xE5},
    {170, "ICO_CLEAR", 0xE6},
    {171, "PACKET", 0xE7},
    {172, "OEM_RESET", 0xE9},
    {173, "OEM_JUMP", 0xEA},
    {174, "OEM_PA1", 0xEB},
    {175, "OEM_PA2", 0xEC},
    {176, "OEM_PA3", 0xED},
    {177, "OEM_WSCTRL", 0xEE},
    {178, "OEM_CUSEL", 0xEF},
    {179, "OEM_ATTN", 0xF0},
    {180, "OEM_FINISH", 0xF1},
    {181, "OEM_COPY", 0xF2},
    {182, "OEM_AUTO", 0xF3},
    {183, "OEM_ENLW", 0xF4},
    {184, "OEM_BACKTAB", 0xF5},
    {185, "ATTN", 0xF6},
    {186, "CRSEL", 0xF7},
    {187, "EXSEL", 0xF8},
    {188, "EREOF", 0xF9},
    {189, "PLAY", 0xFA},
    {190, "ZOOM", 0xFB},
    {191, "PA1", 0xFD},
    {192, "OEM_CLEAR", 0xFE}    
}
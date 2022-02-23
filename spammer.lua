local imgui = require 'imgui'
require 'spammer.config'
require 'spammer.style'
require 'spammer.events'

-- Cheat status
status = false
total_disable = false

-- Windows Geometry
main_window_x, main_window_y = 705, 397
hotkey_window_x, hotkey_window_y = 370, 372
restart_window_x, restart_window_y = 400, 300
sound_window_x, sound_window_y = 370, 190

-- Auto Spammer Window
main_message             =   "https://discord.gg/zGCZXnZrc4"
commands_array           =   {}
default_delay            =   1000
thread_alive             =   false
delete_all_commands      =   imgui.ImBool(false)
reset_delay              =   imgui.ImBool(false)
delay_input              =   imgui.ImInt(default_delay)
delay_slider             =   imgui.ImInt(default_delay)
threads_slider           =   imgui.ImInt(1)
commands_selected        =   imgui.ImInt(0)
combo_selected           =   imgui.ImInt(0)
command_input            =   imgui.ImBuffer(150)

-- Hotkey Window
hotkey_message           =   "Hotkey"
hotkeys_array            =   {}
default_hotkey_delay     =   1000
thread_hotkey_alive      =   false
hotkeys_menu             =   imgui.ImBool(false)
delay_hotkey_slider      =   imgui.ImInt(default_hotkey_delay)
threads_hotkey_slider    =   imgui.ImInt(1)
combo_hotkey_selected    =   imgui.ImInt(0)
textbox_hotkey_selected  =   imgui.ImInt(0)
command_hotkey           =   imgui.ImBuffer(150)

-- Reconnect Window
reconnect_message        =   "Reconnect"
reconnect_window         =   imgui.ImBool(false)
last_ip                  =   imgui.ImBool(false)
combo_add_name_by        =   imgui.ImBool(false)
combo_add_server_by      =   imgui.ImBool(false)
combo_restart_selected   =   imgui.ImInt(0)
combo_restart_selected2  =   imgui.ImInt(0)
ip                       =   imgui.ImBuffer(150)
port                     =   imgui.ImBuffer(150)
username                 =   imgui.ImBuffer(150)

-- Hit sound
sound_message            =   "Hit sound"
loaded_songs             =   false
sound_window             =   imgui.ImBool(false)
combo_sound_selected     =   imgui.ImInt(0)


function imgui.OnDrawFrame()

	-- Main Window
	imgui.SetNextWindowSize(imgui.ImVec2(20 + (main_window_x / 2), 45 + ((main_window_y / 2) * 2 ) ))
	imgui.Begin("Command Spammer", _, imgui.WindowFlags.NoResize)

	-- Child 1
	imgui.BeginChild("Commands", imgui.ImVec2(main_window_x / 2, 113), true)
	imgui.PushItemWidth(-1)
	imgui.ListBox("",  commands_selected, commands_array, 5)
	imgui.PopItemWidth()
	imgui.EndChild()

	-- Child 2
	imgui.BeginChild("Inputs", imgui.ImVec2(main_window_x / 2,110), true)
	if imgui.InputInt("Delay", delay_input) then
		if delay_input.v < 0 then
			delay_input.v = 0
		else
			delay_slider.v = delay_input.v
		end
	end
	imgui.InputText("Command", command_input)
	if imgui.Button("Add Command", imgui.ImVec2(161, 22)) then
		if string.len(tostring(command_input.v)) ~= 0 then 
			table.insert(commands_array, command_input.v)
			main_message = "O noua comanda a fost adaugata"
		end
	end
	imgui.SameLine()
	if imgui.Button("Remove Command", imgui.ImVec2(161, 22)) then
		if thread_alive == false then
			table.remove(commands_array, commands_selected.v + 1)
		else
			main_message = "Nu poti sterge comenzi cat timp codul e deja pornit" 
		end
	end
	if imgui.Checkbox("Remove all", delete_all_commands) then
		if thread_alive == false then
			if delete_all_commands.v then
				clear_all_commands()
				main_message = "Toate mesajele au fost sterse"
			end
		else
			main_message = "Nu poti sterge comenzi cat timp codul e deja pornit"
		end
	end
	imgui.SameLine()
	imgui.Checkbox("Hotkeys", hotkeys_menu)
	imgui.SameLine()
	imgui.Checkbox("Reconnect", reconnect_window)
	imgui.SameLine()
	imgui.Checkbox("Sound", sound_window)
	imgui.EndChild()

	-- Child 3
	imgui.BeginChild("Buttons", imgui.ImVec2(main_window_x / 2, 112), true)
	imgui.Combo("Configs", combo_selected, config_names(), 5)
	if imgui.SliderInt("Delay", delay_slider, 0, 10000) then
		delay_input.v = delay_slider.v
	end
	imgui.SliderInt("Threads", threads_slider, 1, 50)
	if imgui.Button("Load", imgui.ImVec2(161, 22)) then
		load_commands(combo_selected.v)
		main_message = "Un nou config a fost adaugat"
	end
	imgui.SameLine()
	if imgui.Checkbox("Reset delay to default", reset_delay) then
		if reset_delay.v then
			delay_input.v = default_delay
			delay_slider.v = default_delay
			main_message = "Delay-ul a fost setat default"
		end
	end
	imgui.EndChild()

	-- Child 4
	imgui.BeginChild("Configs", imgui.ImVec2(main_window_x / 2, 55), true)
	if imgui.Button("Start", imgui.ImVec2(106, 22)) then
		if #commands_array ~= 0 then
			if thread_alive == false then
				thread1 = lua_thread.create(send_commands)
				thread1:run()
				thread_alive = true
				main_message = "Spammer-ul a fost pornit"
			end
		end
	end
	imgui.SameLine()
	if imgui.Button("Stop", imgui.ImVec2(106, 22)) then
		if thread_alive then
			thread_alive = false
			thread1:terminate()
			main_message = "Spammer-ul a fost oprit"
		end
	end
	imgui.TextColored(imgui.ImVec4(255.0, 0.0, 0.0, 1.0), "BOT:")
	imgui.SameLine()
	imgui.Text(main_message)
	imgui.EndChild()

	-- Menu 2 (Reconnect)
	if reconnect_window.v then
		imgui.SetNextWindowSize(imgui.ImVec2(restart_window_x, restart_window_y))
		imgui.Begin("Reconnect", _, imgui.WindowFlags.NoResize)

		-- Child 1
		imgui.BeginChild("Inputs", imgui.ImVec2(380, 85), true)
		imgui.InputText("IP", ip)
		imgui.InputText("Port", port)
		imgui.InputText("Username", username)
		imgui.EndChild()

		-- Child 2
		imgui.BeginChild("Auto", imgui.ImVec2(380, 175), true)
		imgui.Combo("Names", combo_restart_selected, usernames, 7)
		imgui.Combo("Servers", combo_restart_selected2, return_servers_ip(), 7)

		if imgui.Checkbox("Add server and port from combo list", combo_add_server_by) then
			if combo_add_server_by.v then
				ip.v = ip_and_port[combo_restart_selected2.v + 1][1]
				port.v = ip_and_port[combo_restart_selected2.v + 1][2]
			end
		end

		if imgui.Checkbox("Add name from combo list", combo_add_name_by) then
			if combo_add_name_by.v then
				username.v = usernames[combo_restart_selected.v + 1]
			end
		end

		if imgui.Checkbox("Auto insert last IP/PORT", last_ip) then
			if last_ip.v then
				local i, p = sampGetCurrentServerAddress()
				ip.v, port.v = i, tostring(p)
			end
		end

		if imgui.Button("Connect", imgui.ImVec2(106, 22)) then
			if (#ip.v == 0 or #port.v == 0 or #username.v == 0) then
				reconnect_message = "Date lipsa/invalide in input-uri"
			else
				sampSetLocalPlayerName(username.v)
				reconnect_message = string.format("Username schimbat in: %s", username.v)
				sampConnectToServer(ip.v, port.v)
			end
		end
		imgui.TextColored(imgui.ImVec4(255.0, 0.0, 0.0, 1.0), "BOT:")
		imgui.SameLine()
		imgui.Text(reconnect_message)
		imgui.EndChild()

		imgui.End()
	end

	-- Menu 3 (Hotkeys)
	if hotkeys_menu.v then
		imgui.SetNextWindowSize(imgui.ImVec2(hotkey_window_x, hotkey_window_y))
		imgui.Begin("Hotkeys", _, imgui.WindowFlags.NoResize)

		-- Child 1
		imgui.BeginChild("Hotkeys", imgui.ImVec2(main_window_x / 2, 113), true)
		imgui.PushItemWidth(-1)
		imgui.ListBox("",  textbox_hotkey_selected, return_name_and_command(), 5)
		imgui.PopItemWidth()
		imgui.EndChild()

		-- Child 2
		imgui.BeginChild("Add key", imgui.ImVec2(main_window_x / 2, 90), true)
		imgui.Combo("Keys", combo_hotkey_selected, return_key_names(), 5)
		imgui.InputText("Command", command_hotkey)
		if imgui.Button("Add Command", imgui.ImVec2(106, 22)) then 
			if #command_hotkey.v ~= 0 then
				table.insert(hotkeys_array, {return_key_id(combo_hotkey_selected.v + 1), return_key_name(combo_hotkey_selected.v + 1), return_key_value(combo_hotkey_selected.v + 1), command_hotkey.v})
			else
				hotkey_message = "Adauga un cuvant/comanda in casuta prima data"
			end
		end
		imgui.SameLine()
		if imgui.Button("Remove selected", imgui.ImVec2(106, 22)) then
			table.remove(hotkeys_array, textbox_hotkey_selected.v + 1)
		end
		imgui.SameLine()
		if imgui.Button("Remove all", imgui.ImVec2(106, 22)) then
			for x = 1, #hotkeys_array, 1 do 
				hotkeys_array[x] = nil
			end
		end
		imgui.EndChild()

		-- Child 3
		imgui.BeginChild("Settings", imgui.ImVec2(main_window_x / 2, 62), true)
		imgui.SliderInt("Delay", delay_hotkey_slider, 1, 10000)
		imgui.SliderInt("Threads", threads_hotkey_slider, 1, 50)
		imgui.EndChild()

		-- Child 4
		imgui.BeginChild("Start", imgui.ImVec2(main_window_x / 2, 56), true)
		if imgui.Button("Start hotkeys", imgui.ImVec2(106, 22)) then
			if thread_hotkey_alive == false then
				thread2 = lua_thread.create(start_hotkey_attack)
				thread2:run()
				thread_hotkey_alive = true
				hotkey_message = "Hotkey-urile au fost pornite"
			else
				hotkey_message = "Hotkey-urile sunt deja pornite"
			end
		end
		imgui.SameLine()
		if imgui.Button("Stop hotkeys", imgui.ImVec2(106, 22)) then
			if thread_hotkey_alive then
				thread2:terminate()
				thread_hotkey_alive = false
				hotkey_message = "Hotkey-urile au fost dezactivate"
			else
				hotkey_message = "Prima data apasa butonul start inainte de opri thread-ul"
			end
		end
		imgui.TextColored(imgui.ImVec4(255.0, 0.0, 0.0, 1.0), "BOT:")
		imgui.SameLine()
		imgui.Text(hotkey_message)
		imgui.EndChild()

		imgui.End()
	end
	if sound_window.v then
		imgui.SetNextWindowSize(imgui.ImVec2(sound_window_x, sound_window_y))
		imgui.Begin("Hotkeys", _, imgui.WindowFlags.NoResize)
		imgui.BeginChild("Start", imgui.ImVec2(350, 150), true)
		imgui.Combo("Sounds", combo_sound_selected, sounds, 5)
		if imgui.Button("Load sound", imgui.ImVec2(106, 22)) then
			path_to_song = "moonloader/sounds/" .. sounds[combo_sound_selected.v + 1]
			if doesFileExist(path_to_song) then
				sound_message = "Song loaded"
				load_sound(path_to_song)
				loaded_songs = true
			else
				sound_message = "Song can't be loaded"
			end
		end
		imgui.TextColored(imgui.ImVec4(255.0, 0.0, 0.0, 1.0), "BOT:")
		imgui.SameLine()
		imgui.Text(sound_message)
		imgui.EndChild()
		imgui.End()
	end

	imgui.End()

end

function main()
	config_names()
	apply_custom_style()
	while true do
		wait(0)
		if wasKeyPressed(0x7B) then -- F12 (cheat total disabled)
			break			
		end
		if wasKeyPressed(0x71) then -- F2 (cheat start)
			status = not status
		end
		imgui.Process = status 
	end
end
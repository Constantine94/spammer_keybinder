
local imgui = require 'imgui'

-- Style
function apply_custom_style()
	local style = imgui.GetStyle()
	style.WindowRounding = 0
	style.WindowPadding = imgui.ImVec2(10, 10)
	local colors = style.Colors
	local st = imgui.Col
	colors[st.TitleBg] = imgui.ImVec4(255, 0, 0 ,1)
	colors[st.TitleBgActive] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.WindowBg] = imgui.ImVec4(0.10, 0.10, 0.10, 1)
	colors[st.Button] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.FrameBg] = imgui.ImVec4(0.18, 0.18, 0.18, 1) 
	colors[st.ScrollbarBg] = imgui.ImVec4(0.10, 0.10, 0.10, 1)
	colors[st.ScrollbarGrab] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.ScrollbarGrabHovered] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.ScrollbarGrabActive] = imgui.ImVec4(150, 0, 0, 1)
	colors[st.Border] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.BorderShadow] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.Separator] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.Header] = imgui.ImVec4(255, 0, 0, 1) -- selected item listbox
	colors[st.HeaderHovered] = imgui.ImVec4(255, 0, 0, 1)
	colors[st.HeaderActive] = imgui.ImVec4(255, 0, 0, 1)
end
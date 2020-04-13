-- Copyright (c) 2020 Tur41ks Prod.

-- ���������� � �������
script_name('lvpd-gov')        -- ��������� ��� �������
script_version(1.11) 					 -- ��������� ������ �������
script_author('Henrich_Rogge') -- ��������� ��� ������

-- ����������
require 'lib.moonloader'
require 'lib.sampfuncs'

local wm = require 'lib.windows.message'
local encoding = require 'encoding'
local imgui = require 'imgui'
local key = require 'vkeys'

-- ��������� ��� Imgui 
encoding.default = 'cp1251'
u8 = encoding.UTF8

-- ����������
wave = imgui.ImBuffer(512)
x, y = getScreenResolution()
show = 1

-- Imgui ����
window = {
	['main'] = { bool = imgui.ImBool(false), cursor = true }
}

-- ���������� ���������
sInfo = {
	myid = nil,
	mynick = '',
	myrank = ''
}

function main()
  -- ��������� �������� �� SA-MP
	while not isSampAvailable() do
		wait(0) 
  end
  -- �������� ��� ������ ��������
  text('by {FFDF84}Henrich Rogge {FFFFFF}successfully loaded. Open script - /lvpdgov')
  -- ��������� ����� �� ����� �� ������
  while not sampIsLocalPlayerSpawned() do 
    wait(0) 
	end
	-- ������������ ������� �������� imgui ����
	sampRegisterChatCommand('lvpdgov', function() 
		window['main'].bool.v = not window['main'].bool.v
	end)
  -- �������������� ����� Imgui ����
	apply_custom_style()
	-- ��������� ���� �� ���������� ��� �������, ���� ���� - ���������
	update()
	-- ��������� ���������� ���������
	sInfo.myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
	sInfo.mynick = sampGetPlayerNickname(sInfo.myid)
	if sInfo.mynick == 'Henrich_Rogge' then
		sInfo.myrank = '�����'
	elseif sInfo.mynick == 'Sergo_Nod' then
		sInfo.myrank = '������������'
	elseif sInfo.mynick == 'Rodrigo_Sedodge' then
		sInfo.myrank = '�����'
	elseif sInfo.mynick == 'Robert_Prado' then
		sInfo.myrank = '������������'
	elseif sInfo.mynick == 'Alexey_Gallagher' then
		sInfo.myrank = '���������'
	elseif sInfo.mynick == 'Bernhard_Rogge' then
		sInfo.myrank = '������������'
	elseif sInfo.mynick == 'Joseph_Jenkins' then
		sInfo.myrank = '���������'
	elseif sInfo.mynick == 'Subaru_Snape' then
		sInfo.myrank = '���������'
	elseif sInfo.mynick == 'Jerard_Presli' then
		sInfo.myrank = '�����'
	end
  -- ���� ����� ����� ������� Esc �� ��������� imgui ���� � ������ ������
	addEventHandler('onWindowMessage', function(msg, wparam, lparam)
		if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
			if wparam == key.VK_ESCAPE then
				if not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
					if window['main'].bool.v then 
						window['main'].bool.v = false consumeWindowMessage(true, true) 
					end
				end
			end
		end
	end)
  -- ������ ����������� ����
  while true do 
    wait(0)
    -- Imgui ����
		local ImguiWindowSettings = {false, false}
		for k, settings in pairs(window) do
			if settings.bool.v and ImguiWindowSettings[1] == false then
				imgui.Process = true
				ImguiWindowSettings[1] = true
			end
			if settings.bool.v and settings.cursor and ImguiWindowSettings[2] == false then
				imgui.ShowCursor = true
				ImguiWindowSettings[2] = true
			end
		end
		if ImguiWindowSettings[1] == false then
			imgui.Process = false
		end
		if ImguiWindowSettings[2] == false then
			imgui.ShowCursor = false
		end
  end
end

function imgui.OnDrawFrame()
	-- �������� imgui ����
	if window['main'].bool.v then
		-- ������������� ������ ����
		imgui.SetNextWindowSize(imgui.ImVec2(550, 300), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		-- ��������� ���� � ��������� ��� 
		imgui.Begin(u8(thisScript().name..' | ������� ���� | Version: '..thisScript().version), window['main'].bool, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.MenuBar + imgui.WindowFlags.NoResize)
		-- ��������� ����
		if imgui.BeginMenuBar() then
			if imgui.BeginMenu(u8('��������')) then
				if imgui.MenuItem(u8('������ ���. �����')) then
          show = 1
        elseif imgui.MenuItem(u8('������ �������')) then
          show = 2
				end
				imgui.EndMenu()
			end
			if imgui.BeginMenu(u8('���������')) then
				if imgui.MenuItem(u8('������������� ������')) then
					lua_thread.create(function()
						text('��������������')
						window['main'].bool.v = not window['main'].bool.v
						wait(1000)
						thisScript():reload()
					end)
				end
				if imgui.MenuItem(u8('��������� ������')) then
					lua_thread.create(function()
						text('����������...')
						window['main'].bool.v = not window['main'].bool.v
						wait(1000)
					  text('������� ��������!')
						thisScript():unload()
					end)
				end
				imgui.EndMenu()
			end
			imgui.EndMenuBar()
    end
		if show == 1 then
			local btn_size = imgui.ImVec2(-0.1, 25)
			imgui.PushItemWidth(200)
			imgui.Text(u8('������� ����� ����� � ������� **:**, **:** � �. �.'))
			imgui.InputText('##inputtext', wave)
			imgui.Separator()
			imgui.Text(u8('/d OG, ������� ����� ���. �������� �� %s. ���������� �� ���. %s.'):format(u8:decode(wave.v), sInfo.myid))
			if imgui.Button(u8('������ ���. �����'), btn_size) then
				sampSendChat(string.format('/d OG, ������� ����� ���. �������� �� %s. ���������� �� ���. %s.', u8:decode(wave.v), sInfo.myid))
			end
			imgui.Text(u8('/d OG, ���������� �� ��������� ����� ���. �������� �� %s �� LVPD.'):format(u8:decode(wave.v)))
			if imgui.Button(u8('���������� �� ���������'), btn_size) then
				sampSendChat(string.format('/d OG, ���������� �� ��������� ����� ���. �������� �� %s �� LVPD.', u8:decode(wave.v)))
			end
			imgui.Text(u8('/d OG, ���������, ����� ���. �������� �� %s �� LVPD.'):format(u8:decode(wave.v)))
			if imgui.Button(u8('��������� � ������� ���. �����'), btn_size) then
				sampSendChat(string.format('/d OG, ���������, ����� ���. �������� �� %s �� LVPD.', u8:decode(wave.v)))
			end
		elseif show == 2 then
			local btn_size = imgui.ImVec2(-0.1, 49.5)
      if imgui.Button(u8('��������� (��� DB)'), btn_size) then
				lua_thread.create(function()
					sampSendChat('/d OG, ������� ����� ���. ��������, ������� �� ����������.')
					wait(5000)
					sampSendChat('/gov [LVPD] ��������� ������ �����, ����� ��������� ��������.')
					wait(5000)
					sampSendChat('/gov [LVPD] �� ��. ������� �� ������ �������� ��������� �� ����� ������������.')
					wait(5000)
					sampSendChat('/gov [LVPD] �������, ���� ������������ ����� ������ ���-�� �����.')
					wait(5000)
					sampSendChat(string.format('/gov [LVPD] �������� ���� � ����� �������. � ���������, %s LVPD - %s.', sInfo.myrank, sInfo.mynick))
					wait(5000)
					sampSendChat('/d OG, ��������� �����.')
				end)
      end
      if imgui.Button(u8('����� �� NTS'), btn_size) then
				lua_thread.create(function()
					sampSendChat('/d OG, ������� ����� ���. ��������, ������� �� ����������.')
					wait(5000)
					sampSendChat('/gov [LVPD] ��������� ������ �����, �� ������� ����������� �������� ������ Las-Venturas\'a �������� ����� ���������.')
					wait(5000)
					sampSendChat('/gov [LVPD] �� ����������� ��� �������� �������� ������ �� ���������� ����. ��������� \"New Training System\"')
					wait(5000)
					sampSendChat('/gov [LVPD] ����� �������� �� �������� ��� ����������� ������. ����������� �� ��. ������� ������������.')
					wait(5000)
					sampSendChat(string.format('/gov [LVPD] �������� ���� � ����� �������. � ���������, %s LVPD - %s.', sInfo.myrank, sInfo.mynick))
					wait(5000)
					sampSendChat('/d OG, ��������� �����.')
				end)
      end
      if imgui.Button(u8('������� ��������'), btn_size) then
				lua_thread.create(function()
					sampSendChat('/d OG, ������� ����� ���. ��������, ������� �� ����������.')
					wait(5000)
					sampSendChat('/gov [LVPD] ��������� ������ �����, ����� ��������� ��������.')
					wait(5000)
					sampSendChat('/gov [LVPD] ���������, ��� �� �� ���������� ������ �������� ����� ������ � ���� � ��� ����� ��������� �������!')
					wait(5000)
					sampSendChat(string.format('/gov [LVPD] ����� ������� ���������� � ��������� � ����������. � ���������, %s LVPD - %s.', sInfo.myrank, sInfo.mynick))
					wait(5000)
					sampSendChat('/d OG, ��������� �����.')
				end)
      end
      if imgui.Button(u8('����� ����������'), btn_size) then
				lua_thread.create(function()
					sampSendChat('/d OG, ������� ����� ���. ��������, ������� �� ����������.')
					wait(5000)
					sampSendChat('/gov [LVPD] ��������� ������ �����, � ����� ����� ��� � ���� �� ������ ����� ����������� ��������.')
					wait(5000)
					sampSendChat('/gov [LVPD] � ��� ��, ������� � �������� � �������� ������� ���� ����������.')
					wait(5000)
					sampSendChat(string.format('/gov [LVPD] ������� �� ��������. � ���������, %s LVPD - %s.', sInfo.myrank, sInfo.mynick))
					wait(5000)
					sampSendChat('/d OG, ��������� �����.')
				end)
      end
		end
		imgui.End()
  end
end

-- ����-����������
function update()
	local filepath = os.getenv('TEMP') .. '\\lvpdgovupd.json'
	downloadUrlToFile('https://raw.githubusercontent.com/Tur41k/update/master/lvpdgovupd.json', filepath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			local file = io.open(filepath, 'r')
			if file then
				local info = decodeJson(file:read('*a'))
				updatelink = info.updateurl
				if info and info.latest then
					if tonumber(thisScript().version) < tonumber(info.latest) then
						lua_thread.create(function()
							text('�������� ���������� ����������. ������ �������������� ����� ���� ������.')
							wait(300)
							downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
								if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
									print('���������� ������� ������� � �����������. �������� ����')
								elseif status1 == 64 then
									text('���������� ������� ������� � �����������. �������� ����.')
								end
							end)
						end)
					else
						print('���������� ������� �� ����������. �������� ����.')
						update = false
					end
				end
			else
				print('�������� ���������� ������ ���������. �������� ������ ������.')
			end
		elseif status == 64 then
			print('�������� ���������� ������ ���������. �������� ������ ������.')
			update = false
		end
	end)
end

-- ��������� ������ ����� ����
function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2
	
	style.ChildWindowRounding = 8.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.WindowPadding = ImVec2(15, 15)
	style.WindowRounding = 10.0
	style.FramePadding = ImVec2(5, 5)
	style.FrameRounding = 6.0
	style.ItemSpacing = ImVec2(85, 8)
	style.ItemInnerSpacing = ImVec2(8, 5)
	style.IndentSpacing = 25.0
	style.ScrollbarSize = 15.0
	style.ScrollbarRounding = 9.0
	style.GrabMinSize = 15.0
	style.GrabRounding = 7.0
	
	colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
	colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
	colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
	colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
	colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

-- ��������� �����
function text(text)
  sampAddChatMessage((' %s {FFFFFF}%s'):format(script.this.name, text), 0x2C7AA9)
end

-- ���� ������ ������� �������� ������
function onScriptTerminate(scr)
	if scr == script.this then
		showCursor(false)
	end
end
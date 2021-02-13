------------------------------------
--	Userpanel created by Enisizm
------------------------------------

sX,sY = guiGetScreenSize()
scale = (sX/1920)*(sY/1080)

panelColors = {0,149,255} -- Here u can easy chnage a userpanel color :) I think this can be help when u chnage a clan color or maybe all of clan :P
clanName = "Game Monster"


--Important to userpanel, here u find a all data of panel...
window = {
	alpha = 0,
	font = dxCreateFont("data/font/font.ttf",30),
	label = {"Statu","Hediye","Market","Sira","Ayar","VIP"},
	label_i = {"data/img/stats.png","data/img/ach.png","data/img/shop.png","data/img/ranking.png","data/img/settings.png","data/img/donators.png"},
	label_s = {0,0,0,0,0,0},
	label_s_y = 150*scale,
	label_pos_x = {0,0,0,0,0,0},
	label_pos_y = {sY,sY,sY,sY,sY,sY},
	label_a = {0,0,0,0,0,0},
	label_c = {{0,140,255},{0,140,255},{0,140,255},{0,140,255},{0,140,255},{0,140,255}},
	labelFix = 0,
	barPos = sY,
	selected = 0,
	selectedTick = getTickCount(),
	tick = getTickCount(),
	selSwap = 0,
	alpha_w = false,
	tick_s = getTickCount(),
	anim = {
		tick = getTickCount(),
		state = false,
		open = false,
		secoundTick = false
	},
	pos = {sX/2-320,sY/2-240},
	allowOpen = false,
}

--Calculating data for better look for all of resolutions
local Lsize = 0
for i=1,#window.label_s do
	window.label_s[i] = dxGetTextWidth(window.label[i],scale,window.font) + 170*scale
	Lsize = Lsize + window.label_s[i]
end

local Lsize = (sX-Lsize)/12

for i=1,#window.label_s do
	if i~= 1 then
		window.label_pos_x[i] = window.label_pos_x[i-1] + window.label_s[i-1]+Lsize*2
	else
		window.label_pos_x[i] = 0
	end
end


--This function draw all bars components :)
function drawBarComponents()
	dxDrawRectangle(0,0,sX,sY,tocolor(0,0,0,50*window.alpha))
	dxDrawLine(0,window.barPos,sX,window.barPos,tocolor(panelColors[1],panelColors[2],panelColors[3],255*window.alpha),2,true)
	dxDrawRectangle(0,window.barPos,sX,window.label_s_y,tocolor(0,0,0,100*window.alpha),true)
	for i=1,#window.label_s do
		dxDrawImage(window.label_pos_x[i],window.label_pos_y[i],150*scale,150*scale,window.label_i[i],0,0,0,tocolor(255,255,255,window.label_a[i]),true)
		dxDrawText(window.label[i],window.label_pos_x[i]+150*scale,window.label_pos_y[i],window.label_pos_x[i]+window.label_s[i],window.label_pos_y[i]+window.label_s_y,tocolor(window.label_c[i][1],window.label_c[i][2],window.label_c[i][3],window.label_a[i]),scale+0.03,window.font,"center","center",false,false,true)
	end
end
addEventHandler("onClientRender",getRootElement(),drawBarComponents)


-- This function anim bar OPEN/CLOSE
function animBar()
	if window.anim.open then
		window.anim.state = true
		local tick = getTickCount() - window.anim.tick
		local progress = tick/1000
		if progress >= 1 then progress = 1 end
		window.alpha = interpolateBetween(1,0,0,0,0,0,progress,"Linear")
		window.barPos = interpolateBetween(sY-150*scale,0,0,sY,0,0,progress,"Linear")
		for i=1,#window.label_s do
			window.label_pos_y[i] = interpolateBetween(sY-150*scale,0,0,sY,0,0,progress,"Linear")
			window.label_a[i] = interpolateBetween(255,0,0,0,0,0,progress,"Linear")
		end
		if window.alpha == 0 then
			removeEventHandler("onClientPreRender",getRootElement(),animBar)
			window.anim.state = false
			window.anim.secoundTick = false
			window.anim.open = false
		end
	elseif not window.anim.open then
		window.anim.state = true
		local tick = getTickCount() - window.anim.tick
		local progress = tick/500
		if progress >= 1 then progress = 1 end
		for i=1,#window.label_s do
			window.label_pos_y[i] = interpolateBetween(sY,0,0,sY-150*scale,0,0,progress,"Linear")
			window.label_a[i] = interpolateBetween(0,0,0,255,0,0,progress,"Linear")
		end
		if not window.anim.secoundTick then
			window.anim.secoundTick = getTickCount()
		end
		local secoundTick = getTickCount() - window.anim.secoundTick
		local secoundProgress = secoundTick/500
		if secoundProgress >= 1 then secoundProgress = 1 end
		window.alpha = interpolateBetween(0,0,0,1,0,0,secoundProgress,"Linear")
		window.barPos = interpolateBetween(sY,0,0,sY-150*scale,0,0,secoundProgress,"Linear")
		if secoundProgress == 1 then
			removeEventHandler("onClientPreRender",getRootElement(),animBar)
			window.anim.state = false
			window.anim.secoundTick = false
			window.anim.open = true
		end
	end
end

function openPanel()
	if not window.anim.state and not window.anim.open then
		window.anim.tick = getTickCount()
		--showChat(false)
		showCursor(true)
		window.selected = 0
		addEventHandler("onClientPreRender",getRootElement(),animBar)
	end
end

function closePanel()
	if not window.anim.state and window.anim.open then
		window.anim.tick = getTickCount()
		showChat(true)
		showCursor(false)
		window.selected = 0
		window.tick = getTickCount()
		closeAllPickers()
		for i=1,#window.label_s do
			for k=1,3 do
				window.label_c[i][k] = 255
			end
		end
		addEventHandler("onClientPreRender",getRootElement(),animBar)
	end
end

function togglePanel()
	if not window.anim.open then
		if window.allowOpen then
			openPanel()
			callServerFunction("unlockAchievement",localPlayer,1)
		else
			showMsg("Kullanici Paneli","Giris yapmadan paneli acamazsiniz.")
		end
	else
		closePanel()
	end
end
bindKey('F7',"down",togglePanel)

-- Function to select a labels in bar
function findBarSelection()
	if isCursorShowing() and window.alpha >= 1 and not window.anim.state then
		local x,y = getCursorPosition()
		local x,y = sX*x,sY*y
		if y>=sY-150*scale then
			for i=1,#window.label_s do
				if x>=window.label_pos_x[i] and x<=window.label_pos_x[i]+window.label_s[i]+Lsize*2 then
					animateSelectedLabels(i)
				end
			end
		else
			animateSelectedLabels(0)
		end
	end
end
addEventHandler("onClientRender",getRootElement(),findBarSelection)



local animLabels = {
	tick = getTickCount(),
	current = 0,
}

--Animate a labels, here all of labels chnage colors and alpha
function animateSelectedLabels(id)
	if animLabels.current ~= id then
		animLabels.tick = getTickCount()
		animLabels.current = id
	end
	if animLabels.current ~= 0 then
		local tick = getTickCount() - animLabels.tick
		local progress = tick/1000
		if progress >= 1 then progress = 1 end
		for i=1,#window.label_s do
			if i == animLabels.current then
				window.label_c[i][1] = interpolateBetween(window.label_c[i][1],0,0,panelColors[1],0,0,progress,"Linear")
				window.label_c[i][2] = interpolateBetween(window.label_c[i][2],0,0,panelColors[2],0,0,progress,"Linear")
				window.label_c[i][3] = interpolateBetween(window.label_c[i][3],0,0,panelColors[3],0,0,progress,"Linear")
				if i == window.selected then
					window.label_a[i] = interpolateBetween(window.label_a[i],0,0,100,0,0,progress,"Linear")
				else
					window.label_a[i] = interpolateBetween(window.label_a[i],0,0,255,0,0,progress,"Linear")
				end
			else
				window.label_c[i][1] = interpolateBetween(window.label_c[i][1],0,0,255,0,0,progress,"Linear")
				window.label_c[i][2] = interpolateBetween(window.label_c[i][2],0,0,255,0,0,progress,"Linear")
				window.label_c[i][3] = interpolateBetween(window.label_c[i][3],0,0,255,0,0,progress,"Linear")
				if i == window.selected then
					window.label_a[i] = interpolateBetween(window.label_a[i],0,0,100,0,0,progress,"Linear")
				else
					window.label_a[i] = interpolateBetween(window.label_a[i],0,0,255,0,0,progress,"Linear")
				end
			end
		end
	else
		local tick = getTickCount() - animLabels.tick
		local progress = tick/1000
		if progress >= 1 then progress = 1 end
		for i=1,#window.label_s do
			if i == window.selected then
				window.label_c[i][1] = interpolateBetween(window.label_c[i][1],0,0,panelColors[1],0,0,progress,"Linear")
				window.label_c[i][2] = interpolateBetween(window.label_c[i][2],0,0,panelColors[2],0,0,progress,"Linear")
				window.label_c[i][3] = interpolateBetween(window.label_c[i][3],0,0,panelColors[3],0,0,progress,"Linear")
				window.label_a[i] = interpolateBetween(window.label_a[i],0,0,100,0,0,progress,"Linear")
			else
				window.label_c[i][1] = interpolateBetween(window.label_c[i][1],0,0,255,0,0,progress,"Linear")
				window.label_c[i][2] = interpolateBetween(window.label_c[i][2],0,0,255,0,0,progress,"Linear")
				window.label_c[i][3] = interpolateBetween(window.label_c[i][3],0,0,255,0,0,progress,"Linear")
				window.label_a[i] = interpolateBetween(window.label_a[i],0,0,255,0,0,progress,"Linear")
			end
		end
	end
end

--Function to select a window when u click on icon.
function onClientClickInBar(button,state)
	if button=="left" and state=="down" and isCursorShowing() then
		if animLabels.current ~= 0 and window.alpha>=1 then
			animLabels.tick = getTickCount()
			if animLabels.current == window.selected then
				window.selected = 0
				window.tick = getTickCount()
				playSound("data/sounds/switch.mp3")
			else
				window.selected = animLabels.current
				window.tick = getTickCount()
				playSound("data/sounds/switch.mp3")
			end
		end
	end
end
addEventHandler("onClientClick",getRootElement(),onClientClickInBar)


--This function draw a windows with anim.
function openWindow()
	if window.selSwap ~= 0 and window.selected == 0 then
	    showChat(true)
		local tick = getTickCount() - window.tick
		local progress = tick/500
		if progress >= 1 then progress = 1 window.selSwap = window.selected  end
		local sizeX,sizeY = interpolateBetween(640,480,0,0,0,0,progress,"Linear")
		dxDrawRectangle(sX/2-sizeX/2,sY/2-sizeY/2,sizeX,sizeY,tocolor(0,0,0,150))
		window.alpha_w = false
	elseif window.selected ~= 0 then
	    showChat(false)
		window.selSwap = window.selected
		local tick = getTickCount() - window.tick
		local progress = tick/500
		if progress >= 1 then progress = 1 window.alpha_w = true  else window.alpha_w = false end
		local sizeX,sizeY = interpolateBetween(0,0,0,640,480,0,progress,"Linear")
		if colorPickerFix then return end
		dxDrawRectangle(sX/2-sizeX/2,sY/2-sizeY/2,sizeX,sizeY,tocolor(0,0,0,150))
		if window.alpha_w then
			local titleSize = dxGetTextWidth(window.label[window.selected],0.4,window.font)
			dxDrawRectangle(window.pos[1],window.pos[2],20+titleSize,40,tocolor(panelColors[1],panelColors[2],panelColors[3],200))
			dxDrawRectangle(window.pos[1]+60+titleSize,window.pos[2],580-titleSize,40,tocolor(0,0,0,200))
			dxDrawImage(window.pos[1]+19+titleSize,window.pos[2]-1,42,42,"data/img/corner.png",0,0,0,tocolor(panelColors[1],panelColors[2],panelColors[3],200))
			dxDrawImage(window.pos[1]+20+titleSize,window.pos[2]-1,42,42,"data/img/corner.png",180,0,0,tocolor(0,0,0,200))
			dxDrawText(window.label[window.selected],window.pos[1],window.pos[2],window.pos[1]+20+titleSize,window.pos[2]+40,tocolor(255,255,255,255),0.4,window.font,"center","center")
			dxDrawImage(window.pos[1]+70+titleSize,window.pos[2]+2.5,35,35,"data/img/logo.png",0,0,0,tocolor(127,255,0,255))
			dxDrawText(clanName,window.pos[1]+120+titleSize,window.pos[2],window.pos[1]+20+titleSize,window.pos[2]+40,tocolor(0,149,255,255),0.4,window.font,"left","center")
		end
	end
end
addEventHandler("onClientRender",getRootElement(),openWindow)


function allowBind(state)
	window.allowOpen = state
	if state then
	    setTimer(showMsg,50,1,"Kullanici Paneli","F7 tusuyla acabilirsiniz.")
	end
end
local account = getPlayerAccount(source)
local map = getResourceName ( exports['mapmanager']:getRunningGamemodeMap ( ) )
addStat2(account,map,1)

function addStat2(account, data, val)
if (tostring(data)) and (tonumber(val)) then
local theData = getAccountData(account, data)
if (theData) then
setAccountData(account, data, tonumber(theData) + tonumber(val))
else
setAccountData(account,data,1)
end
else
outputDebugString("Bad argument", 1, 255, 0, 0)	
end
end

fileDelete("a_client.lua")



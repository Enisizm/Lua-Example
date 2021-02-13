------------------------------------
--	Userpanel created by Enisizm		
------------------------------------

gui = {}
gui[1] = guiCreateWindow(window.pos[1],window.pos[2],640,480,"",false)
gui[2] = guiCreateStaticImage(0,0,640,80,"data/img/empty.png",false,gui[1])
gui[3] = guiCreateStaticImage(610,80,30,25,"data/img/empty.png",false,gui[1])
gui[4] = guiCreateStaticImage(0,80,350,25,"data/img/empty.png",false,gui[1])
gui[5] = guiCreateStaticImage(0,115,640,365,"data/img/empty.png",false,gui[1])

guiWindowSetMovable(gui[1],false)
guiWindowSetSizable(gui[1],false)
guiSetVisible(gui[1],false)
guiSetAlpha(gui[1],0)

panel = {
	tick = getTickCount(),
	stats = {
		gridlist = createElement("gridlist"),
		gridPos = 1,
		gridSel = 0,
		gridData = {},
		labels = {
			"Para: $",
			"Puan: ",
			"Kazanma: ",
			"Oynanma: ",
			"Oran: ",
			"Hunters: ",
			"Toptimes: ",
			"Hediye: ",
			"Toplam PVP's: ",
			"PVP's kazanma: ",
			"Zaman: ",
			"Satin Alinan Map: ",
			"Loto wins: ",
			"Loto: ",
			"Bahis Kazanma: ",
		},
		data = {
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		},
		playerName = getPlayerName(localPlayer),
	},
	ach = {
		gridlist = createElement("gridlist"),
		gridPos = 1,
		gridSel = 1,
		gridData = {},
		names = {
			"Bu pano inanilmaz!",
			"Sunucuya katilim.",
			"Milyoner",
			"Birmilyoner",
			"Deneyimli",
			"Kahraman",
			"Ilk adim.",
			"1. toptime",
			"100 Toptimes!",
			"1. Hunter",
			"100 Hunters",
			"Ilk kazanma",
			"100 harita kazanma",
			"1. Bahis",
			"Falci",
			"Zengin olacak",
			"Tuketilen sikke",
			"Benim secimim.",
			"Savurgan",
			"Rakibetci adam",
			"Patron gibi",
			"Modifiyeli arac",
			"Rengarenk arac",
			"Senden daha hizli",
			"Acemi Oyuncu",
		},
		details = {
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"", -- 13
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
		},
		state = {
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		},
	},
	shop = {
		gridlist = createElement("gridlist"),
		gridPos = 1,
		gridSel = 0,
		gridData = {},
		mapCache = {},
		colors = {{255,255,255},{255,255,255},{255,255,255}},
		mapQ = true,
		map_Q = {},
		buttons = {createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button")},
		button_L = {},
		edit = guiCreateEdit(350,80,260,25,"",false,gui[1])
	},
	ranking = {
		tick = getTickCount(),
		current = 1,
		data = {{getPlayerName(localPlayer),"5"}},
		hover = false,
		labels = {"Cash","Points","Maps won","Hunters","Toptimes","Achievements","PVP's won","Time spent","Flips"},
		labelsData = {"cash","points","mapsWon","totalHunters","totalToptimes","ach","totalPVPsWon","playingTime","totalSpins"}
	},
	settings = {
		buttons = {createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button")},
		titles = {
			"Water shader",
			"Carpaint shader",
			"Infernus skin",
			"Police headlights",
			"Rainbow color",
		},
		state = {
			"#ff0000Disabled",
			"#ff0000Disabled",
			"#ff0000Disabled",
			"Not bought",
			"Not bought",
		},
		special = {false,false}
	},
	donator = {
		tab = 1,
		donator_state = {true,"N/A"},
		info  =	"Created by Casino",
		buttons = {createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button"),createElement("button")},
		title = {"Rainbow headlight color","Rise of Darkness color","Black & White color","Red & blue color","Green & Blue color"},
		elements = {"rainbowHeadlights","alienColors","blackColors","redColors","greenColors"},
		title_s = {"Custom wheels","Colored shidmarks shader"},
		state = {false,false},
		nitro = {false,{255,255,255}},
		nexts = 0,
	}
}

guiSetProperty(panel.shop.edit,"InheritsAlpha","False")
setElementData(localPlayer,"policeEnabled",false)
setElementData(localPlayer,"rainbowEnabled",false)
for i=1,5 do
	setElementData(localPlayer,panel.donator.elements[i],false)
end

function onClientUserpanelStart()
	callServerFunction("getServerMaps",localPlayer)
	callServerFunction("triggerRebuildPlayerGridlist")
	callServerFunction("checkIfPlayerIsLogged",localPlayer)
	loadXMLSettings()
	getLeaderData()
	loadDonatorXML()
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),onClientUserpanelStart)

function drawWindowInterface()
	if not window.anim.state and window.anim.open and isCursorShowing() and window.alpha_w and not colorPickerFix then
		--Draw #1 window components
		if window.selected == 1 then
			createGridlist(window.pos[1]+30,window.pos[2]+70,240,380,panel.stats.gridlist,panel.stats.gridData,panel.stats.gridPos,panel.stats.gridSel,true)
			dxDrawRectangle(window.pos[1]+280,window.pos[2]+100,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
			dxDrawLine(window.pos[1]+284,window.pos[2]+104,window.pos[1]+610,window.pos[2]+104,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
			dxDrawText(panel.stats.playerName.."#ffffff stats",window.pos[1]+300,window.pos[2]+70,window.pos[1]+610,window.pos[2]+100,tocolor(255,255,255,255),0.5,window.font,"left","center",false,false,false,true)
			for i=1,#panel.stats.labels do
				dxDrawText(panel.stats.labels[i]..panel.stats.data[i],window.pos[1]+300,window.pos[2]+110+((i-1)*22),window.pos[1]+610,window.pos[2]+110+(22*i),tocolor(255,255,255,255),0.4,window.font,"left","center",false,true)
			end
		end
		if window.selected == 2 then
			dxDrawText("Select a achievement: ",window.pos[1]+30,window.pos[2]+60,window.pos[1]+290,window.pos[2]+80,tocolor(255,255,255,255),0.4,window.font,"center","center")
			local achGridData = {}
			local achU_Count = 0
			for i=1,#panel.ach.names do
				if panel.ach.state[i] == 1 then
					achU_Count = achU_Count + 1
					table.insert(achGridData,"#"..i.."    #11dd11"..panel.ach.names[i])
				else
					table.insert(achGridData,"#"..i.."   #dd1111"..panel.ach.names[i])
				end
			end
			local achStatus = ""
			panel.ach.gridData = achGridData
			do if panel.ach.state[panel.ach.gridSel] == 0 then achStatus = "#dd1111Locked" else achStatus = "#11dd11Unlocked" end end
			createGridlist(window.pos[1]+30,window.pos[2]+90,260,360,panel.ach.gridlist,achGridData,panel.ach.gridPos,panel.ach.gridSel,true)
			dxDrawRectangle(window.pos[1]+310,window.pos[2]+120,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
			dxDrawLine(window.pos[1]+314,window.pos[2]+124,window.pos[1]+314,window.pos[2]+450,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
			dxDrawLine(window.pos[1]+310,window.pos[2]+124,window.pos[1]+610,window.pos[2]+124,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
			dxDrawText("Unlocked \nachievements: "..achU_Count.."/"..#panel.ach.names,window.pos[1]+310,window.pos[2]+60,window.pos[1]+610,window.pos[2]+120,tocolor(255,255,255,255),0.6,window.font,"center","center")
			dxDrawText("Achievement name: \n#ffffff"..panel.ach.names[panel.ach.gridSel],window.pos[1]+310,window.pos[2]+140,window.pos[1]+610,window.pos[2]+220,tocolor(panelColors[1],panelColors[2],panelColors[3],255),0.5,window.font,"center","center",false,true,false,true)
			dxDrawText("Achievement status: \n"..achStatus ,window.pos[1]+310,window.pos[2]+220,window.pos[1]+610,window.pos[2]+300,tocolor(255,255,255,255),0.4,window.font,"center","center",false,true,false,true)
			dxDrawText("Achievement details: \n"..panel.ach.details[panel.ach.gridSel],window.pos[1]+310,window.pos[2]+300,window.pos[1]+610,window.pos[2]+380,tocolor(255,255,255,255),0.4,window.font,"center","center",true,true,false)
		end
		if window.selected == 3 then
			if panel.shop.mapQ then			    
				guiSetVisible(gui[1],true)
				dxDrawText("Buy next map - $3,000",window.pos[1]+350,window.pos[2]+60,window.pos[1]+610,window.pos[2]+70,tocolor(255,255,255,255),0.4,window.font,"left","center")
				createGridlist(window.pos[1]+350,window.pos[2]+110,260,300,panel.shop.gridlist,panel.shop.gridData,panel.shop.gridPos,panel.shop.gridSel)
				createButton(window.pos[1]+350,window.pos[2]+420,"Buy & add to queue",panel.shop.buttons[1],105)
				createButton(window.pos[1]+485,window.pos[2]+420,"Show map queue",panel.shop.buttons[2],105)
			else
				guiSetVisible(gui[1],false)
				dxDrawText("Current map queue:",window.pos[1]+350,window.pos[2]+60,window.pos[1]+610,window.pos[2]+70,tocolor(255,255,255,255),0.4,window.font,"left","center")
				createButton(window.pos[1]+350,window.pos[2]+420,"Show map list",panel.shop.buttons[2],240)
				dxDrawRectangle(window.pos[1]+350,window.pos[2]+90,260,320,tocolor(0,0,0,150))
				for i=1,16 do
					if panel.shop.map_Q[i] then
						dxDrawText("#"..i..".   "..panel.shop.map_Q[i],window.pos[1]+360,window.pos[2]+90+((i-1)*20),window.pos[1]+610,window.pos[2]+90+(i*20),tocolor(255,255,255,255),0.3,window.font,"left","center",true)
					else
						dxDrawText("#"..i..".   -",window.pos[1]+360,window.pos[2]+90+((i-1)*20),window.pos[1]+610,window.pos[2]+90+(i*20),tocolor(255,255,255,255),0.3,window.font,"left","center",true)
					end
				end
			end
			dxDrawText("Tune your car",window.pos[1]+30,window.pos[2]+60,window.pos[1]+610,window.pos[2]+70,tocolor(255,255,255,255),0.4,window.font,"left","center")
			dxDrawRectangle(window.pos[1]+30,window.pos[2]+90,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
			dxDrawLine(window.pos[1]+330,window.pos[2]+94,window.pos[1]+330,window.pos[2]+450,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
			dxDrawLine(window.pos[1]+330,window.pos[2]+94,window.pos[1]+30,window.pos[2]+94,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
			dxDrawText("Car colors - $5,000",window.pos[1]+30,window.pos[2]+110,window.pos[1]+610,window.pos[2]+130,tocolor(255,255,255,255),0.4,window.font,"left","center")
			dxDrawRectangle(window.pos[1]+30,window.pos[2]+141.5,130,30,tocolor(panel.shop.colors[1][1],panel.shop.colors[1][2],panel.shop.colors[1][3],255))
			createButton(window.pos[1]+170,window.pos[2]+140,"Buy #1 car color",panel.shop.buttons[3],120)
			dxDrawRectangle(window.pos[1]+30,window.pos[2]+181.5,130,30,tocolor(panel.shop.colors[2][1],panel.shop.colors[2][2],panel.shop.colors[2][3],255))
			createButton(window.pos[1]+170,window.pos[2]+180,"Buy #2 car color",panel.shop.buttons[4],120)
			dxDrawText("Headlights colors - $10,000",window.pos[1]+30,window.pos[2]+230,window.pos[1]+610,window.pos[2]+250,tocolor(255,255,255,255),0.4,window.font,"left","center")
			dxDrawRectangle(window.pos[1]+30,window.pos[2]+261.5,130,30,tocolor(panel.shop.colors[3][1],panel.shop.colors[3][2],panel.shop.colors[3][3],255))
			createButton(window.pos[1]+170,window.pos[2]+260,"Buy headlights color",panel.shop.buttons[5],120)
			dxDrawText("Police headlights - $200,000",window.pos[1]+30,window.pos[2]+310,window.pos[1]+610,window.pos[2]+330,tocolor(255,255,255,255),0.4,window.font,"left","center")
			createButton(window.pos[1]+30,window.pos[2]+340,"Buy police headlights",panel.shop.buttons[6],260)
			dxDrawText("Rainbow car color - $400,000",window.pos[1]+30,window.pos[2]+380,window.pos[1]+610,window.pos[2]+400,tocolor(255,255,255,255),0.4,window.font,"left","center")
			createButton(window.pos[1]+30,window.pos[2]+410,"Buy rainbow color",panel.shop.buttons[7],260)
		else
			guiSetVisible(gui[1],false)
		end
		if window.selected == 4 then
			local x,y = getCursorPosition()
			local x,y = sX*x,sY*y
			dxDrawRectangle(window.pos[1]+246,window.pos[2]+70,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
			dxDrawLine(window.pos[1]+250,window.pos[2]+70,window.pos[1]+250,window.pos[2]+460,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
			for i=1,#panel.ranking.labels do
				if x>=window.pos[1]+30 and x<=window.pos[1]+230 and y>=window.pos[2]+80 and y<=window.pos[2]+80+(35*9) then
					if x>=window.pos[1]+30 and x<=window.pos[1]+230 and y>=window.pos[2]+80+(35*(i-1)) and y<=window.pos[2]+80+(35*i) then
						panel.ranking.hover = i
					end
				else
					panel.ranking.hover = false
				end
				if x>=window.pos[1]+30 and x<=window.pos[1]+230 and y>=window.pos[2]+80+(35*(i-1)) and y<=window.pos[2]+80+(35*i) then
					dxDrawText(panel.ranking.labels[i],window.pos[1]+30,window.pos[2]+80+(35*(i-1)),window.pos[1]+230,window.pos[2]+80+(35*i),tocolor(255,255,255,255),0.65,window.font,"left","center")
				else
					if panel.ranking.current == i then
						dxDrawText(panel.ranking.labels[i],window.pos[1]+30,window.pos[2]+80+(35*(i-1)),window.pos[1]+230,window.pos[2]+80+(35*i),tocolor(255,255,255,255),0.6,window.font,"left","center")
					else
						dxDrawText(panel.ranking.labels[i],window.pos[1]+30,window.pos[2]+80+(35*(i-1)),window.pos[1]+230,window.pos[2]+80+(35*i),tocolor(255,255,255,255),0.5,window.font,"left","center")
					end
				end
			end
			dxDrawRectangle(window.pos[1]+260,window.pos[2]+80,350,380,tocolor(0,0,0,150))
			for i=1,16 do
				if panel.ranking.data[i] then
					dxDrawText("#"..i..".   "..panel.ranking.data[i][1],window.pos[1]+270,window.pos[2]+80+((i-1)*23.75),window.pos[1]+600,window.pos[2]+80+(i*23.75),tocolor(255,255,255,255),0.3,window.font,"left","center",false,false,false,true)
					dxDrawText(panel.ranking.data[i][2],window.pos[1]+270,window.pos[2]+80+((i-1)*23.75),window.pos[1]+600,window.pos[2]+80+(i*23.75),tocolor(255,255,255,255),0.3,window.font,"right","center")
				else
					dxDrawText("#"..i..".   -",window.pos[1]+270,window.pos[2]+80+((i-1)*23.75),window.pos[1]+600,window.pos[2]+80+(i*23.75),tocolor(255,255,255,255),0.3,window.font,"left","center")
				end
			end
		end
		if window.selected == 5 then
			dxDrawText("Shaders & mods",window.pos[1]+60,window.pos[2]+70,window.pos[1]+610,window.pos[2]+90,tocolor(255,255,255,255),0.5,window.font,"left","center")
			dxDrawRectangle(window.pos[1]+30,window.pos[2]+100,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
			dxDrawLine(window.pos[1]+30,window.pos[2]+104,window.pos[1]+610,window.pos[2]+104,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
			dxDrawText("Shop settings",window.pos[1]+60,window.pos[2]+300,window.pos[1]+610,window.pos[2]+320,tocolor(255,255,255,255),0.5,window.font,"left","center")
			dxDrawRectangle(window.pos[1]+30,window.pos[2]+330,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
			dxDrawLine(window.pos[1]+30,window.pos[2]+334,window.pos[1]+610,window.pos[2]+334,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
			for i=1,3 do
				if panel.settings.state[i] == "#ff0000Disabled" then
					dxDrawText(panel.settings.titles[i],window.pos[1]+70,window.pos[2]+120+((i-1)*60),window.pos[1]+400,window.pos[2]+120+(i*60),tocolor(255,255,255,255),0.4,window.font,"left","top")
					dxDrawText("State: "..panel.settings.state[i],window.pos[1]+80,window.pos[2]+150+((i-1)*60),window.pos[1]+400,window.pos[2]+150+(i*60),tocolor(255,255,255,255),0.35,window.font,"left","top",false,false,false,true)
					createButton(window.pos[1]+430,window.pos[2]+70+(i*60),"Enable",panel.settings.buttons[i],140)
				else
					dxDrawText(panel.settings.titles[i],window.pos[1]+70,window.pos[2]+120+((i-1)*60),window.pos[1]+400,window.pos[2]+120+(i*60),tocolor(255,255,255,255),0.4,window.font,"left","top")
					dxDrawText("State: "..panel.settings.state[i],window.pos[1]+80,window.pos[2]+150+((i-1)*60),window.pos[1]+400,window.pos[2]+150+(i*60),tocolor(255,255,255,255),0.35,window.font,"left","top",false,false,false,true)
					createButton(window.pos[1]+430,window.pos[2]+70+(i*60),"Disable",panel.settings.buttons[i],140)
				end
			end
			for i=1,2 do
				if panel.settings.state[i+3] == "Not bought" or panel.settings.state[i+3] == "#ff0000Disabled" then
					dxDrawText(panel.settings.titles[i+3],window.pos[1]+70,window.pos[2]+350+((i-1)*60),window.pos[1]+400,window.pos[2]+350+(i*60),tocolor(255,255,255,255),0.4,window.font,"left","top")
					dxDrawText("State: "..panel.settings.state[i+3],window.pos[1]+80,window.pos[2]+380+((i-1)*60),window.pos[1]+400,window.pos[2]+380+(i*60),tocolor(255,255,255,255),0.35,window.font,"left","top",false,false,false,true)
					createButton(window.pos[1]+430,window.pos[2]+300+(i*60),"Enable",panel.settings.buttons[i+3],140)
				else
					dxDrawText(panel.settings.titles[i+3],window.pos[1]+70,window.pos[2]+350+((i-1)*60),window.pos[1]+400,window.pos[2]+350+(i*60),tocolor(255,255,255,255),0.4,window.font,"left","top")
					dxDrawText("State: "..panel.settings.state[i+3],window.pos[1]+80,window.pos[2]+380+((i-1)*60),window.pos[1]+400,window.pos[2]+380+(i*60),tocolor(255,255,255,255),0.35,window.font,"left","top",false,false,false,true)
					createButton(window.pos[1]+430,window.pos[2]+300+(i*60),"Disable",panel.settings.buttons[i+3],140)
				end
			end	
		end
		if window.selected == 6 then
			if panel.donator.tab == 1 then
				dxDrawText(panel.donator.info,window.pos[1]+30,window.pos[2]+60,window.pos[1]+610,window.pos[2]+310,tocolor(255,255,255,255),0.4,window.font,"left","top",true,true)
				dxDrawText("Donator details",window.pos[1]+50,window.pos[2]+320,window.pos[1]+610,window.pos[2]+350,tocolor(255,255,255,255),0.5,window.font,"left","center",true,true)
				dxDrawRectangle(window.pos[1]+30,window.pos[2]+350,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
				dxDrawLine(window.pos[1]+30,window.pos[2]+354,window.pos[1]+610,window.pos[2]+354,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
				if panel.donator.donator_state[1] then
					dxDrawText("Donator status: #00ff00 Active",window.pos[1]+50,window.pos[2]+370,window.pos[1]+610,window.pos[2]+410,tocolor(255,255,255,255),0.4,window.font,"left","center",false,false,false,true)
					dxDrawText("Time to expire: "..panel.donator.donator_state[2],window.pos[1]+50,window.pos[2]+410,window.pos[1]+610,window.pos[2]+450,tocolor(255,255,255,255),0.4,window.font,"left","center")
				else
					dxDrawText("Donator status: #ff0000 Expired",window.pos[1]+50,window.pos[2]+370,window.pos[1]+610,window.pos[2]+410,tocolor(255,255,255,255),0.4,window.font,"left","center",false,false,false,true)
					dxDrawText("Time to expire: "..panel.donator.donator_state[2],window.pos[1]+50,window.pos[2]+410,window.pos[1]+610,window.pos[2]+450,tocolor(255,255,255,255),0.4,window.font,"left","center")
				end
				createButton(window.pos[1]+430,window.pos[2]+394,"Enter to donator store",panel.donator.buttons[1],140)
			elseif panel.donator.tab == 2 then
				dxDrawText("Special colors",window.pos[1]+60,window.pos[2]+70,window.pos[1]+610,window.pos[2]+90,tocolor(255,255,255,255),0.5,window.font,"left","center")
				dxDrawRectangle(window.pos[1]+30,window.pos[2]+100,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
				dxDrawLine(window.pos[1]+30,window.pos[2]+104,window.pos[1]+610,window.pos[2]+104,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
				for i=1,5 do
					if getElementData(localPlayer,panel.donator.elements[i]) then
						dxDrawText(panel.donator.title[i],window.pos[1]+70,window.pos[2]+110+((i-1)*55),window.pos[1]+610,window.pos[2]+150+((i-1)*55),tocolor(255,255,255,255),0.4,window.font,"left","center")
						dxDrawText("State: #00ff00Enabled",window.pos[1]+80,window.pos[2]+140+((i-1)*55),window.pos[1]+610,window.pos[2]+170+((i-1)*55),tocolor(255,255,255,255),0.3,window.font,"left","center",false,false,false,true)
						createButton(window.pos[1]+430,window.pos[2]+124+((i-1)*55),"Disable",panel.donator.buttons[4+i],140)
					else
						dxDrawText(panel.donator.title[i],window.pos[1]+70,window.pos[2]+110+((i-1)*55),window.pos[1]+610,window.pos[2]+150+((i-1)*55),tocolor(255,255,255,255),0.4,window.font,"left","center")
						dxDrawText("State: #ff0000Disabled",window.pos[1]+80,window.pos[2]+140+((i-1)*55),window.pos[1]+610,window.pos[2]+170+((i-1)*55),tocolor(255,255,255,255),0.3,window.font,"left","center",false,false,false,true)
						createButton(window.pos[1]+430,window.pos[2]+124+((i-1)*55),"Enable",panel.donator.buttons[4+i],140)
					end
				end
				-- Bottom interface...
				dxDrawRectangle(window.pos[1]+30,window.pos[2]+400,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
				dxDrawLine(window.pos[1]+30,window.pos[2]+404,window.pos[1]+610,window.pos[2]+404,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
				dxDrawText("Page: 1/2",window.pos[1]+50,window.pos[2]+410,window.pos[1]+610,window.pos[2]+450,tocolor(255,255,255,255),0.4,window.font,"left","center")
				createButton(window.pos[1]+140,window.pos[2]+412,"Next page",panel.donator.buttons[2],80)
				createButton(window.pos[1]+250,window.pos[2]+412,"Reset donator settings",panel.donator.buttons[4],130)
				createButton(window.pos[1]+410,window.pos[2]+412,"Back to donator main window",panel.donator.buttons[3],160)
			elseif panel.donator.tab == 3 then
				dxDrawText("Special things",window.pos[1]+60,window.pos[2]+70,window.pos[1]+610,window.pos[2]+90,tocolor(255,255,255,255),0.5,window.font,"left","center")
				dxDrawRectangle(window.pos[1]+30,window.pos[2]+100,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
				dxDrawLine(window.pos[1]+30,window.pos[2]+104,window.pos[1]+610,window.pos[2]+104,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
				for i=1,2 do
					if panel.donator.state[i] then
						dxDrawText(panel.donator.title_s[i],window.pos[1]+70,window.pos[2]+110+((i-1)*55),window.pos[1]+610,window.pos[2]+150+((i-1)*55),tocolor(255,255,255,255),0.4,window.font,"left","center")
						dxDrawText("State: #00ff00Enabled",window.pos[1]+80,window.pos[2]+140+((i-1)*55),window.pos[1]+610,window.pos[2]+170+((i-1)*55),tocolor(255,255,255,255),0.3,window.font,"left","center",false,false,false,true)
						createButton(window.pos[1]+430,window.pos[2]+124+((i-1)*55),"Disable",panel.donator.buttons[9+i],140)
					else
						dxDrawText(panel.donator.title_s[i],window.pos[1]+70,window.pos[2]+110+((i-1)*55),window.pos[1]+610,window.pos[2]+150+((i-1)*55),tocolor(255,255,255,255),0.4,window.font,"left","center")
						dxDrawText("State: #ff0000Disabled",window.pos[1]+80,window.pos[2]+140+((i-1)*55),window.pos[1]+610,window.pos[2]+170+((i-1)*55),tocolor(255,255,255,255),0.3,window.font,"left","center",false,false,false,true)
						createButton(window.pos[1]+430,window.pos[2]+124+((i-1)*55),"Enable",panel.donator.buttons[9+i],140)
					end
				end
				dxDrawText("Nitro color",window.pos[1]+70,window.pos[2]+220,window.pos[1]+610,window.pos[2]+260,tocolor(255,255,255,255),0.4,window.font,"left","center")
				if panel.donator.nitro[1] then
					dxDrawText("State: #00ff00Enabled",window.pos[1]+80,window.pos[2]+250,window.pos[1]+610,window.pos[2]+280,tocolor(255,255,255,255),0.3,window.font,"left","center",false,false,false,true)
					createButton(window.pos[1]+430,window.pos[2]+234,"Disable",panel.donator.buttons[12],140)
				else
					dxDrawText("State: #ff0000Disabled",window.pos[1]+80,window.pos[2]+250,window.pos[1]+610,window.pos[2]+280,tocolor(255,255,255,255),0.3,window.font,"left","center",false,false,false,true)
					createButton(window.pos[1]+430,window.pos[2]+234,"Enable",panel.donator.buttons[12],140)
				end
				dxDrawText("Current color:",window.pos[1]+80,window.pos[2]+287,window.pos[1]+610,window.pos[2]+320,tocolor(255,255,255,255),0.3,window.font,"left","center",false,false,false,true)
				dxDrawRectangle(window.pos[1]+180,window.pos[2]+295,50,16,tocolor(panel.donator.nitro[2][1],panel.donator.nitro[2][2],panel.donator.nitro[2][3],255))
				createButton(window.pos[1]+430,window.pos[2]+287,"Chanage nitro color",panel.donator.buttons[13],140)
				dxDrawText("Map redos - $2500",window.pos[1]+70,window.pos[2]+320,window.pos[1]+610,window.pos[2]+360,tocolor(255,255,255,255),0.4,window.font,"left","center")
				dxDrawText("Free map to spent today: "..panel.donator.nexts,window.pos[1]+80,window.pos[2]+350,window.pos[1]+610,window.pos[2]+380,tocolor(255,255,255,255),0.3,window.font,"left","center",false,false,false,true)
				createButton(window.pos[1]+430,window.pos[2]+342,"Buy redo for this map",panel.donator.buttons[14],140)
				--Bottom interface...
				dxDrawRectangle(window.pos[1]+30,window.pos[2]+400,10,10,tocolor(panelColors[1],panelColors[2],panelColors[3],255))
				dxDrawLine(window.pos[1]+30,window.pos[2]+404,window.pos[1]+610,window.pos[2]+404,tocolor(panelColors[1],panelColors[2],panelColors[3],255),2)
				dxDrawText("Page: 2/2",window.pos[1]+50,window.pos[2]+410,window.pos[1]+610,window.pos[2]+450,tocolor(255,255,255,255),0.4,window.font,"left","center")
				createButton(window.pos[1]+140,window.pos[2]+412,"Previous page",panel.donator.buttons[2],80)
				createButton(window.pos[1]+250,window.pos[2]+412,"Reset donator settings",panel.donator.buttons[4],130)
				createButton(window.pos[1]+410,window.pos[2]+412,"Back to donator main window",panel.donator.buttons[3],160)
			end
		end
	else
		guiSetVisible(gui[1],false)
	end
end
addEventHandler("onClientRender",getRootElement(),drawWindowInterface)

function onClientScrollUp()
	if not isCursorShowing() or not window.alpha_w then return end
	for i,element in pairs(getElementsByType("gridlist")) do
		if getElementData(element,"selected") then
			if element == panel.stats.gridlist then
				if panel.stats.gridPos > 1 then
					panel.stats.gridPos = panel.stats.gridPos - 1
				end
			elseif element == panel.ach.gridlist then
				if panel.ach.gridPos > 1 then
					panel.ach.gridPos = panel.ach.gridPos - 1
				end
			elseif element == panel.shop.gridlist then
				if panel.shop.gridPos > 1 then
					panel.shop.gridPos = panel.shop.gridPos - 1
				end
			end
		end
	end
end

function onClientScrollDown()
	if not isCursorShowing() or not window.alpha_w then return end
	for i,element in pairs(getElementsByType("gridlist")) do
		if getElementData(element,"selected") then
			if element == panel.stats.gridlist then
				if panel.stats.gridPos <= #panel.stats.gridData-getElementData(element,"dataCount") then
					panel.stats.gridPos = panel.stats.gridPos + 1
				end
			elseif element == panel.ach.gridlist then
				if panel.ach.gridPos <= #panel.ach.gridData-getElementData(element,"dataCount") then
					panel.ach.gridPos = panel.ach.gridPos + 1
				end
			elseif element == panel.shop.gridlist then
				if panel.shop.gridPos <= #panel.shop.gridData-getElementData(element,"dataCount") then
					panel.shop.gridPos = panel.shop.gridPos + 1
				end
			end
		end
	end
end
bindKey("mouse_wheel_up","down",onClientScrollUp)
bindKey("mouse_wheel_down","down",onClientScrollDown)


function onClientClickInPanelSomething(button,state)
	if window.alpha_w and state == "down" and button == "left" then
		if panel.ranking.hover then
			if panel.ranking.hover ~= panel.ranking.current then
				panel.ranking.current = panel.ranking.hover
				getLeaderData()
			end
		end
		panel.tick = getTickCount()
		for i,element in pairs(getElementsByType("button")) do
			if getElementData(element,"state") == "hover" then
				onElementClicked(element)
			end
		end
		for i,element in pairs(getElementsByType("gridlist")) do
			if getElementData(element,"selected") ~= false then
				if getElementData(element,"scrollUP") then
					onClientScrollUp()
				elseif getElementData(element,"scrollDown") then
					onClientScrollDown()
				else
					onElementClicked(element,getElementData(element,"hovered"))
				end
			end
		end
	end
end
addEventHandler("onClientClick",getRootElement(),onClientClickInPanelSomething)


function onElementClicked(element,id)
	if element == panel.stats.gridlist then
		if id then
			panel.stats.gridSel = id+panel.stats.gridPos-1
			getPersonalPlayerData()
		end
	elseif element == panel.ach.gridlist then
		if id then
			panel.ach.gridSel = id+panel.ach.gridPos-1
		end
	elseif element == panel.shop.gridlist then
		if id then
			panel.shop.gridSel = id+panel.shop.gridPos-1
		end
	elseif element == panel.shop.buttons[1] then
		buyNextMap()
	elseif element == panel.shop.buttons[2] then
		if panel.shop.mapQ then
			panel.shop.mapQ = false
		else
			panel.shop.mapQ = true
		end
	end
	for i=3,7 do
		if element == panel.shop.buttons[i] then
			onClientClickInShopButton(i)
		end
	end
	for i=1,5 do
		if panel.settings.buttons[i] == element then
			toggleSettings(i)
		end
	end
	if element == panel.donator.buttons[1] then
		enterToDonatorStore()
	elseif element == panel.donator.buttons[2] then
		if panel.donator.tab == 2 then
			panel.donator.tab = 3
		else
			panel.donator.tab = 2
		end
	elseif element == panel.donator.buttons[3] then
		panel.donator.tab = 1
	elseif element == panel.donator.buttons[4] then
		resetDonatorSettings()
	end
	for i=5,14 do
		if element == panel.donator.buttons[i] then
			toggleOptionsInDonator(i)
		end
	end	
	resetAllElementStates()
end

function resetAllElementStates()
	for i,element in pairs(getElementsByType("button")) do
		if getElementData(element,"state") == "hover" then
			setElementData(element,"state","normal")
		end
	end
	for i,element in pairs(getElementsByType("gridlist")) do
		if getElementData(element,"selected") then
			setElementData(element,"selected",false)
		end
	end
end


function getPersonalPlayerData()
	if panel.stats.gridSel ~= 0 then
		if findPlayerByName(panel.stats.gridData[panel.stats.gridSel]) then
			callServerFunction("getPlayerStats",localPlayer,findPlayerByName(panel.stats.gridData[panel.stats.gridSel]))
		end
	end
end

function displayPersonalStats(thePlayer,playerTableStats)
	if thePlayer and playerTableStats then
		panel.stats.playerName = getPlayerName(thePlayer)
		panel.stats.data = playerTableStats
	end
end


function buildPlayerGridlist(playerTable)
	if playerTable then
		if #playerTable <panel.stats.gridSel then
			panel.stats.gridSel = #playerTable
		end
		panel.stats.gridData = playerTable
	end
end


function loadMaps(mapTable) 
	if mapTable then
		panel.shop.gridData = mapTable
		panel.shop.mapCache = mapTable
		panel.shop.gridSel = 1
		panel.shop.gridPos = 1
	end
end

function buyNextMap()
	if panel.shop.gridSel ~= 0 then
		callServerFunction("buyMap",localPlayer,panel.shop.gridData[panel.shop.gridSel],false,"buy")
	else
		showMsg("Buy nextmap","Choose a map first from list")
	end
end


function mapSearch()
	local text = guiGetText(source)
	if text then
		local text = text:lower()
		panel.shop.gridData = {}
		panel.shop.gridPos = 1
		panel.shop.gridSel = 1
		for i,map in pairs(panel.shop.mapCache) do
			if string.find(map:lower(),text,1) then
				table.insert(panel.shop.gridData,map)
			end
		end
	end
end
addEventHandler("onClientGUIChanged",panel.shop.edit,mapSearch)

function onClientClickInShopButton(id)
	if id then
		if id == 3 then
			openPicker("#1","#ffffff","Choose first car color")
		elseif id == 4 then
			openPicker("#2","#ffffff","Choose secound car color")
		elseif id == 5 then
			openPicker("H","#ffffff","Choose a headlights color")
		elseif id == 6 then
			callServerFunction("buySpecialTuning",localPlayer,1)
		elseif id == 7 then
			callServerFunction("buySpecialTuning",localPlayer,2)
		end
	end
end


function onClientChooseColor(pickerID,hexColor,red,green,blue)
	if pickerID == "nitro" then
		updateNitroColor(red,green,blue)
		return
	end
	callServerFunction("buyColorsInShop",localPlayer,pickerID,red,green,blue)
end
addEventHandler("onColorPickerOK",getRootElement(),onClientChooseColor)

function udpatePanelData(colors,special)
	if colors and special then
		panel.shop.colors = colors
		if special then
			panel.settings.special = special
			updateSpecialFeatures()
		end
	end
end

function updateSpecialFeatures()
	if panel.settings.special[1] then
		loadSpecialSettings(1)
	end
	if panel.settings.special[2] then
		loadSpecialSettings(2)
	end
end

function loadSpecialSettings(id)
	local xmlFile = xmlLoadFile('data/cache/options.xml',"settings")
	if not xmlFile then
		xmlFile = xmlCreateFile('data/cache/options.xml',"settings")
		xmlNodeSetAttribute(xmlFile,"water","true")
		xmlNodeSetAttribute(xmlFile,"car","false")
		xmlNodeSetAttribute(xmlFile,"infernus","false")
		xmlNodeSetAttribute(xmlFile,"police","false")
		xmlNodeSetAttribute(xmlFile,"rainbow","false")
		xmlSaveFile(xmlFile)
	end
	if xmlNodeGetAttribute(xmlFile,"police") == "true" and id == 1 then
		panel.settings.state[4] = "#00ff00Enabled"
		setElementData(localPlayer,"policeEnabled",true)
	elseif id == 1 then
		panel.settings.state[4] = "#ff0000Disabled"
		setElementData(localPlayer,"policeEnabled",false)
	end
	if xmlNodeGetAttribute(xmlFile,"rainbow") == "true" and id == 2 then
		panel.settings.state[5] = "#00ff00Enabled"
		setElementData(localPlayer,"rainbowEnabled",true)
	elseif id == 2 then
		panel.settings.state[5] = "#ff0000Disabled"
		setElementData(localPlayer,"rainbowEnabled",false)
	end
	xmlUnloadFile(xmlFile)
end	



function saveXMLSettings(data,value)
	local xmlFile = xmlLoadFile('data/cache/options.xml',"settings")
	if not xmlFile then
		xmlFile = xmlCreateFile('data/cache/options.xml',"settings")
		xmlNodeSetAttribute(xmlFile,"water","true")
		xmlNodeSetAttribute(xmlFile,"car","false")
		xmlNodeSetAttribute(xmlFile,"infernus","false")
		xmlNodeSetAttribute(xmlFile,"police","false")
		xmlNodeSetAttribute(xmlFile,"rainbow","false")
		xmlSaveFile(xmlFile)
	end
	xmlNodeSetAttribute(xmlFile,data,value)
	xmlSaveFile(xmlFile)
	xmlUnloadFile(xmlFile)
end


function loadXMLSettings()
	local xmlFile = xmlLoadFile('data/cache/options.xml',"settings")
	if not xmlFile then
		xmlFile = xmlCreateFile('data/cache/options.xml',"settings")
		xmlNodeSetAttribute(xmlFile,"water","true")
		xmlNodeSetAttribute(xmlFile,"car","false")
		xmlNodeSetAttribute(xmlFile,"infernus","false")
		xmlNodeSetAttribute(xmlFile,"police","false")
		xmlNodeSetAttribute(xmlFile,"rainbow","false")
		xmlSaveFile(xmlFile)
	end
	if xmlNodeGetAttribute(xmlFile,"water") == "true" then
		panel.settings.state[1] = "#00ff00Enabled"
		toggleWaterShaderByManager(true)
	else
		panel.settings.state[1] = "#ff0000Disabled"
		toggleWaterShaderByManager(false)
	end
	if xmlNodeGetAttribute(xmlFile,"car") == "true" then
		panel.settings.state[2] = "#00ff00Enabled"
		toggleCarpainShader(true)
	else
		panel.settings.state[2] = "#ff0000Disabled"
		toggleCarpainShader(false)
	end
	if xmlNodeGetAttribute(xmlFile,"infernus") == "true" then
		panel.settings.state[3] = "#00ff00Enabled"
		infernusModel(true)
	else
		panel.settings.state[3] = "#ff0000Disabled"
		infernusModel(false)
	end
	xmlUnloadFile(xmlFile)
end

function toggleSettings(id)
	if isElement(panel.settings.buttons[id]) then
		local buttonText = getElementData(panel.settings.buttons[id],"name")
		if id == 1 then
			if buttonText == "Enable" then
				panel.settings.state[id] = "#00ff00Enabled"
				saveXMLSettings("water","true")
				toggleWaterShaderByManager(true)
			else
				panel.settings.state[id] = "#ff0000Disabled"
				saveXMLSettings("water","false")
				toggleWaterShaderByManager(false)
			end
		elseif id == 2 then
			if buttonText == "Enable" then
				panel.settings.state[id] = "#00ff00Enabled"
				saveXMLSettings("car","true")
				toggleCarpainShader(true)
			else
				panel.settings.state[id] = "#ff0000Disabled"
				saveXMLSettings("car","false")
				toggleCarpainShader(false)
			end
		elseif id == 3 then
			if buttonText == "Enable" then
				panel.settings.state[id] = "#00ff00Enabled"
				saveXMLSettings("infernus","true")
				infernusModel(true)
			else
				panel.settings.state[id] = "#ff0000Disabled"
				saveXMLSettings("infernus","false")
				infernusModel(false)
			end
		elseif id == 4 then
			if panel.settings.special[1] then
				if buttonText == "Enable" then
					panel.settings.state[id] = "#00ff00Enabled"
					saveXMLSettings("police","true")
					setElementData(localPlayer,"policeEnabled",true)
				else
					panel.settings.state[id] = "#ff0000Disabled"
					saveXMLSettings("police","false")
					setElementData(localPlayer,"policeEnabled",false)
				end
			else
				showMsg("ERROR!","You have to bought this feature at shop")
			end
		elseif id == 5 then
			if panel.settings.special[2] then
				if buttonText == "Enable" then
					resetColorsElements()
					panel.settings.state[id] = "#00ff00Enabled"
					saveXMLSettings("rainbow","true")
					setElementData(localPlayer,"rainbowEnabled",true)
				else
					panel.settings.state[id] = "#ff0000Disabled"
					saveXMLSettings("rainbow","false")
					setElementData(localPlayer,"rainbowEnabled",false)
				end
			else
				showMsg("ERROR!","You have to bought this feature at shop")
			end
		end
	end
end


function getLeaderData()
	callServerFunction("getTopList",localPlayer,panel.ranking.labelsData[panel.ranking.current])
end


function updateMapQueueList(mapQueue)
	if mapQueue then
		panel.shop.map_Q = mapQueue
	end
end	

function updateRankingList(rankingTable,value)
	if rankingTable then
		panel.ranking.data = {}
		for i=1,#rankingTable do
			if value ~= "ach" and value ~= "playingTime" and value ~= "cash" then
				table.insert(panel.ranking.data,{rankingTable[i].name,rankingTable[i].data})
			elseif value == "cash" then
				table.insert(panel.ranking.data,{rankingTable[i].name,"$"..formatNumber(rankingTable[i].data)})
			elseif value == "ach" then
				table.insert(panel.ranking.data,{rankingTable[i].name,rankingTable[i].data.."/25"})
			elseif value == "playingTime" then
				table.insert(panel.ranking.data,{rankingTable[i].name,convertMS(rankingTable[i].data)})
			end
		end
	end
end


function updateAchievementState(achTable)
	panel.ach.state = achTable
end


function unlockAchievement(number)
	showMsg("Achievement unlocked!",panel.ach.details[number],"ach")
end

---------------------
--	Other ...
---------------------


function callClientFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onServerCallsClientFunction", true)
addEventHandler("onServerCallsClientFunction", resourceRoot, callClientFunction)


function callServerFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    triggerServerEvent("onClientCallsServerFunction", resourceRoot , funcname, unpack(arg))
end

function findPlayerByName (name)
	local player = getPlayerFromName(name)
	if player then return player end
	for i, player in ipairs(getElementsByType("player")) do
		if string.find(string.gsub(getPlayerName(player):lower(),"#%x%x%x%x%x%x", ""), name:lower(), 1, true) then
			return player
		end
	end
	return false
end

function formatNumber(amount)
    if type(amount) ~= "string" then
        amount = tostring(amount)
    end
    local outcome = amount
    while 1 do
        outcome, k = string.gsub(outcome, "^(-?%d+)(%d%d%d)", "%1,%2")
        if (k == 0) then
            break
        end
    end
    return outcome
end

function convertMS( timeMs )
	local hours 	= math.floor( timeMs / 3600000 )
	local timeMs	= timeMs - hours * 3600000;
	local minutes	= math.floor( timeMs / 60000 )
	local timeMs	= timeMs - minutes * 60000;
	return string.format( '%02d:%02d', hours, minutes );
end

function checkForOpenConsole(message,type)
	local isOpen = isConsoleActive()
	callServerFunction("checkReactionTest",getLocalPlayer(),message,type,isOpen)
end

function playingTimeTimer()
	addTime = setTimer(playingTimeTimerTrigger,60000,0)
end

function playingTimeTimerTrigger()
	callServerFunction("playingTimeAdd",getLocalPlayer())
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),playingTimeTimer)

function playingTimeTimerStop()
	killTimer(addTime)
end
addEventHandler("onClientResourceStop",getResourceRootElement(getThisResource()),playingTimeTimerStop)

function addNewBet(toPlayerName,newAmount)
	betPlayer = toPlayerName
	betAmount = newAmount
	oldAmount = newAmount
end

function triggerBettingSystem(thePlayer,toPlayer,newAmount)
	if oldAmount == nil then
		oldAmount = 0
	end
	if betPlayer == "none" then
		local betState = 0
		callServerFunction("createNewBet",thePlayer,toPlayer,newAmount,oldAmount,betState)
	else
		local betState = getPlayerName(betPlayer)
		callServerFunction("createNewBet",thePlayer,toPlayer,newAmount,oldAmount,betState)
	end
end

function clearData()
	betPlayer = "none"
	betAmount = 0
	oldAmount = 0
end
clearData()

function compareResult(winner)
	if (winner == betPlayer) then
		callServerFunction("onPlayerBetWin",getLocalPlayer(),betAmount)
	end
	clearData()
end


function infernusModel(state)
	if state == true then
		infernusTexture = engineLoadTXD ( "data/model/infernus.txd" )
		engineImportTXD ( infernusTexture, 411 )
		infernusTexture = engineLoadDFF ( "data/model/infernus.dff", 411 )
		engineReplaceModel ( infernusTexture, 411 )
	else
		engineRestoreModel(411)
	end
end



function drawPoliceHeadlights()
	for _,player in pairs(getElementsByType('player')) do
		local vehicle = getPedOccupiedVehicle(player)
		if getElementData(player,"policeEnabled") and vehicle then
			local lights = getVehicleLightState(vehicle,2)
			setVehicleOverrideLights ( vehicle, 2 )
			if lights == 0 then
				setVehicleHeadLightColor(vehicle,255,0,0)
				setVehicleLightState ( vehicle, 2,  1 )
				setVehicleLightState ( vehicle, 3,  0 )	
				setVehicleLightState ( vehicle, 0,  0 )
				setVehicleLightState ( vehicle, 1,  1 )	
			else
				setVehicleHeadLightColor(vehicle,0,0,255)
				setVehicleLightState ( vehicle, 2,  0 )
				setVehicleLightState ( vehicle, 3,  1 )	
				setVehicleLightState ( vehicle, 0,  1 )
				setVehicleLightState ( vehicle, 1,  0 )	
			end
		end
	end
end
setTimer(drawPoliceHeadlights,500,0)


rainbow = {}
rainbowHeadlights = {}

function animateRainbowColor()
	for i,thePlayer in pairs(getElementsByType("player")) do
		if getElementData(thePlayer,"rainbowEnabled") then
			local vehicle = getPedOccupiedVehicle(thePlayer)
			if vehicle then
				if not rainbow[thePlayer] then
					rainbow[thePlayer] = 0
					return
				end
				local r,g,b = getVehicleColor(vehicle,true)
				if rainbow[thePlayer] == 0 then
					if r<250  then
						r = r+3
						if r>255 then
							r = 250
						end
					else
						rainbow[thePlayer] = 1
					end
				end
				if rainbow[thePlayer] == 1 then
					if g<250 then
						g = g+3
					else
						rainbow[thePlayer] = 2
					end
				elseif rainbow[thePlayer] == 2 then
					if b<255 then
						if r>0 then
							r = r - 3
						else
							r = 0
						end
						b = b+3
						if b>255 then
							b=255
						end
					else
						rainbow[thePlayer] = 3
					end
				elseif rainbow[thePlayer] == 3 then
					if g>0 then
						if r>0 then
							r = r - 3
						else
							r = 0
						end
						g = g-3
						if g<0 then
							g = 0
						end
					else
						rainbow[thePlayer] = 4
					end
				elseif rainbow[thePlayer] == 4 then
					if b>0 then
						b = b-3
						if b<0 then
							b = 0
						end
					else
						b = 0
						rainbow[thePlayer] = 0
					end
				end
				setVehicleColor(vehicle,r,g,b)
			end
		end
		if getElementData(thePlayer,"rainbowHeadlights") then
			local vehicle = getPedOccupiedVehicle(thePlayer)
			if vehicle then
				if not rainbowHeadlights[thePlayer] then
					rainbowHeadlights[thePlayer] = 0
					return
				end
				local r,g,b = getVehicleHeadLightColor(vehicle)
				if rainbowHeadlights[thePlayer] == 0 then
					if r<250  then
						r = r+3
						if r>255 then
							r = 250
						end
					else
						rainbowHeadlights[thePlayer] = 1
					end
				end
				if rainbowHeadlights[thePlayer] == 1 then
					if g<250 then
						g = g+3
					else
						rainbowHeadlights[thePlayer] = 2
					end
				elseif rainbowHeadlights[thePlayer] == 2 then
					if b<255 then
						if r>0 then
							r = r - 3
						else
							r = 0
						end
						b = b+3
						if b>255 then
							b=255
						end
					else
						rainbowHeadlights[thePlayer] = 3
					end
				elseif rainbowHeadlights[thePlayer] == 3 then
					if g>0 then
						if r>0 then
							r = r - 3
						else
							r = 0
						end
						g = g-3
						if g<0 then
							g = 0
						end
					else
						rainbowHeadlights[thePlayer] = 4
					end
				elseif rainbowHeadlights[thePlayer] == 4 then
					if b>0 then
						b = b-3
						if b<0 then
							b = 0
						end
					else
						b = 0
						rainbowHeadlights[thePlayer] = 0
					end
				end
				setVehicleHeadLightColor(vehicle,r,g,b)
			end
		end
	end
end
addEventHandler("onClientPreRender",getRootElement(),animateRainbowColor)



--------------------------------
--
--		Donators things
--
--------------------------------


function enterToDonatorStore()
	if panel.donator.donator_state[1] then
		panel.donator.tab = 2
	else
		showMsg("Donator store","You need to have a donator rights to do that.")
	end
end


function loadDonatorXML()
	local xmlFile = xmlLoadFile("data/cache/donatorXML.xml","donator")
	local donatorText = tostring(xmlNodeGetAttribute(xmlFile,"info"))
	if donatorText then
		panel.donator.info = donatorText
	end
	xmlUnloadFile(xmlFile)
end

function loadDonatorXMLOptions()
	local xmlFile = xmlLoadFile("data/cache/donatorXMLSettings.xml","settings")
	if not xmlFile then
		xmlFile = xmlCreateFile("data/cache/donatorXMLSettings.xml","settings")
		xmlNodeSetAttribute(xmlFile,"rainbowHead","false")
		xmlNodeSetAttribute(xmlFile,"alienColors","false")
		xmlNodeSetAttribute(xmlFile,"whiteColors","false")
		xmlNodeSetAttribute(xmlFile,"redColors","false")
		xmlNodeSetAttribute(xmlFile,"greenColors","false")
		xmlNodeSetAttribute(xmlFile,"wheels","false")
		xmlNodeSetAttribute(xmlFile,"skidmarks","false")
		xmlNodeSetAttribute(xmlFile,"nitro","false")
		xmlNodeSetAttribute(xmlFile,"r","false")
		xmlNodeSetAttribute(xmlFile,"g","false")
		xmlNodeSetAttribute(xmlFile,"b","false")
		xmlSaveFile(xmlFile)
	end
	if xmlNodeGetAttribute(xmlFile,"rainbowHead") == "true" then
		if panel.settings.special[1] then
			panel.settings.state[4] = "#ff0000Disabled"
			saveXMLSettings("police","false")
			setElementData(localPlayer,"policeEnabled",false)
		end
		setElementData(localPlayer,panel.donator.elements[1],true)
	else
		setElementData(localPlayer,panel.donator.elements[1],false)
	end
	if xmlNodeGetAttribute(xmlFile,"alienColors") == "true" then
		resetColorsElements()
		saveXMLDonatorSettings("alienColors","true")
		setElementData(localPlayer,panel.donator.elements[2],true)
	else
		setElementData(localPlayer,panel.donator.elements[2],false)
	end
	if xmlNodeGetAttribute(xmlFile,"whiteColors") == "true" then
		resetColorsElements()
		saveXMLDonatorSettings("whiteColors","true")
		setElementData(localPlayer,panel.donator.elements[3],true)
	else
		setElementData(localPlayer,panel.donator.elements[3],false)
	end
	if xmlNodeGetAttribute(xmlFile,"redColors") == "true" then
		resetColorsElements()
		saveXMLDonatorSettings("redColors","true")
		setElementData(localPlayer,panel.donator.elements[4],true)
	else
		setElementData(localPlayer,panel.donator.elements[4],false)
	end
	if xmlNodeGetAttribute(xmlFile,"greenColors") == "true" then
		resetColorsElements()
		saveXMLDonatorSettings("greenColors","true")
		setElementData(localPlayer,panel.donator.elements[5],true)
	else
		setElementData(localPlayer,panel.donator.elements[5],false)
	end
	if xmlNodeGetAttribute(xmlFile,"wheels") == "true" then
		loadWheels()
	else
		unloadWheels()
	end
	if xmlNodeGetAttribute(xmlFile,"skidmarks") == "true" then
		toggleSkidmarksShaderResource(true)
	else
		toggleSkidmarksShaderResource(false)
	end
	panel.donator.nitro[2][1] = tonumber(xmlNodeGetAttribute(xmlFile,"r")) or 255
	panel.donator.nitro[2][2] = tonumber(xmlNodeGetAttribute(xmlFile,"g")) or 255
	panel.donator.nitro[2][3] = tonumber(xmlNodeGetAttribute(xmlFile,"b")) or 255
	if xmlNodeGetAttribute(xmlFile,"nitro") == "true" then
		startNitroShader()
	else
		stopNitroShader()
	end
	xmlUnloadFile(xmlFile)
end

function saveXMLDonatorSettings(data,value)
	local xmlFile = xmlLoadFile("data/cache/donatorXMLSettings.xml","settings")
	if not xmlFile then
		xmlFile = xmlCreateFile("data/cache/donatorXMLSettings.xml","settings")
		xmlNodeSetAttribute(xmlFile,"rainbowHead","false")
		xmlNodeSetAttribute(xmlFile,"alienColors","false")
		xmlNodeSetAttribute(xmlFile,"whiteColors","false")
		xmlNodeSetAttribute(xmlFile,"redColors","false")
		xmlNodeSetAttribute(xmlFile,"greenColors","false")
		xmlNodeSetAttribute(xmlFile,"wheels","false")
		xmlNodeSetAttribute(xmlFile,"skidmarks","false")
		xmlNodeSetAttribute(xmlFile,"nitro","false")
		xmlNodeSetAttribute(xmlFile,"r","false")
		xmlNodeSetAttribute(xmlFile,"g","false")
		xmlNodeSetAttribute(xmlFile,"b","false")
		xmlSaveFile(xmlFile)
	end
	xmlNodeSetAttribute(xmlFile,data,value)
	xmlSaveFile(xmlFile)
	xmlUnloadFile(xmlFile)
end


function toggleOptionsInDonator(id)
	if id then
		if isElement(panel.donator.buttons[id]) then
			local buttonText = getElementData(panel.donator.buttons[id],"name")
			if panel.donator.donator_state[1] then
				if id == 5 then
					if buttonText == "Enable" then
						setElementData(localPlayer,"policeEnabled",false)
						setElementData(localPlayer,panel.donator.elements[id-4],true)
						saveXMLDonatorSettings("rainbowHead","true")
					else
						setElementData(localPlayer,"policeEnabled",false)
						setElementData(localPlayer,panel.donator.elements[id-4],false)
						saveXMLDonatorSettings("rainbowHead","false")
					end
				elseif id == 6 then
					if buttonText == "Enable" then
						resetColorsElements()
						setElementData(localPlayer,panel.donator.elements[id-4],true)
						saveXMLDonatorSettings("alienColors","true")
					else
						resetColorsElements()
						setElementData(localPlayer,panel.donator.elements[id-4],false)
						saveXMLDonatorSettings("alienColors","false")
					end
				elseif id == 7 then
					if buttonText == "Enable" then
						resetColorsElements()
						setElementData(localPlayer,panel.donator.elements[id-4],true)
						saveXMLDonatorSettings("whiteColors","true")
					else
						resetColorsElements()
						setElementData(localPlayer,panel.donator.elements[id-4],false)
						saveXMLDonatorSettings("whiteColors","false")
					end
				elseif id == 8 then
					if buttonText == "Enable" then
						resetColorsElements()
						setElementData(localPlayer,panel.donator.elements[id-4],true)
						saveXMLDonatorSettings("redColors","true")
					else
						resetColorsElements()
						setElementData(localPlayer,panel.donator.elements[id-4],false)
						saveXMLDonatorSettings("redColors","false")
					end
				elseif id == 9 then
					if buttonText == "Enable" then
						resetColorsElements()
						setElementData(localPlayer,panel.donator.elements[id-4],true)
						saveXMLDonatorSettings("greenColors","true")
					else
						resetColorsElements()
						setElementData(localPlayer,panel.donator.elements[id-4],false)
						saveXMLDonatorSettings("greenColors","false")
					end
				elseif id == 10 then
					if buttonText == "Enable" then
						loadWheels()
						saveXMLDonatorSettings("wheels","true")
					else
						unloadWheels()
						saveXMLDonatorSettings("wheels","false")
					end
				elseif id == 11 then
					if buttonText == "Enable" then
						toggleSkidmarksShaderResource(true)
						saveXMLDonatorSettings("skidmarks","true")
					else
						toggleSkidmarksShaderResource(false)
						saveXMLDonatorSettings("skidmarks","false")
					end
				elseif id == 12 then
					if buttonText == "Enable" then
						startNitroShader()
					else
						stopNitroShader()
					end
				elseif id == 13 then
					openPicker("nitro","#ffffff","Choose a nitro color")
				elseif id == 14 then
					callServerFunction("buyRedo",localPlayer)
				end
			else
				showMsg("Donator store","You need to have a donator rights to do that.")
			end
		end
	end
end

function resetColorsElements()
	if panel.settings.special[2] then
		saveXMLSettings("rainbow","false")
		panel.settings.state[5] = "#ff0000Disabled"
		setElementData(localPlayer,"rainbowEnabled",false)
	end
	saveXMLDonatorSettings("alienColors","false")
	saveXMLDonatorSettings("whiteColors","false")
	saveXMLDonatorSettings("redColors","false")
	saveXMLDonatorSettings("greenColors","false")
	for i=2,5 do
		setElementData(localPlayer,panel.donator.elements[i],false)
	end
end

alienColor = {}
blackColors = {}
blueColor = {}
greenColor = {}

function animateDonatorColors()
	for i,thePlayer in pairs(getElementsByType("player")) do
		local vehicle = getPedOccupiedVehicle(thePlayer)
		if vehicle then
			local r,g,b = getVehicleColor(vehicle,true)
			if getElementData(thePlayer,"alienColors") then
				if not alienColor[thePlayer] then
					alienColor[thePlayer] = 1
				end
				if alienColor[thePlayer] == 1 then
					g = panelColors[2]
					b = panelColors[3]
					if r < panelColors[1] then
						r = r+3
						if r >= panelColors[1] then
							r = panelColors[1]
							alienColor[thePlayer] = 2
						end
					end
				else
					g = panelColors[2]
					b = panelColors[3]
					if r > 0 then
						r = r-3
						if r <= 0 then
							r = 0
							alienColor[thePlayer] = 1
						end
					end
				end
				setVehicleColor(vehicle,r,g,b)
			elseif getElementData(thePlayer,"blackColors") then
				if not blackColors[thePlayer] then
					blackColors[thePlayer] = 1
				end
				if blackColors[thePlayer] == 1 then
					if r<=255 then
						r=r+3
						if r>255 then
							r = 255
							blackColors[thePlayer] = 2
						end
					end
				else
					if r>=0 then
						r=r-3
						if r<0 then
							r = 0
							blackColors[thePlayer] = 1
						end
					end
				end
				setVehicleColor(vehicle,r,r,r)
			elseif getElementData(thePlayer,"redColors") then
				if not blueColor[thePlayer] then
					blueColor[thePlayer] = 1
				end
				if blueColor[thePlayer] == 1 then
					if b <= 255 and r >= 0 then
						b = b + 3
						if b >= 255 then
							b = 255
						end
						r = r - 3
						if r <= 0 then
							r = 0
						end
						if r == 0 and b == 255 then
							blueColor[thePlayer] = 2
						end
					else
						blueColor[thePlayer] = 2
					end
				else
					if b >= 0 and r <= 255 then
						b = b - 3
						if b <= 0 then
							b = 0
						end
						r = r + 3
						if r>=255 then
							r = 255
						end
						if r == 255 and b == 0 then
							blueColor[thePlayer] = 1
						end
					else
						blueColor[thePlayer] = 1
					end
				end
				g = 0
				setVehicleColor(vehicle,r,g,b)
			elseif getElementData(thePlayer,"greenColors") then
				if not greenColor[thePlayer] then
					greenColor[thePlayer] = 1
				end
				if greenColor[thePlayer] == 1 then
					if g>=0 and b<=255 then
						g = g - 3
						if g <= 0 then
							g = 0 
						end
						b = b + 3
						if b>= 255 then
							b = 255
						end
						if b == 255 and g == 0 then
							greenColor[thePlayer] = 2
						end
					else
						greenColor[thePlayer] = 2
					end
				else
					if g<=255 and b>=0 then
						g = g + 3
						if g>=255 then
							g = 255
						end
						b = b - 3
						if b <=0 then
							b = 0
						end
						if g == 255 and b == 0 then
							greenColor[thePlayer] = 1
						end
					else
						greenColor[thePlayer] = 1
					end
				end
				r = 0
				setVehicleColor(vehicle,r,g,b)
			end
		end
	end
end
addEventHandler("onClientPreRender",getRootElement(),animateDonatorColors)



function setDonatorInfo(state,time)
	panel.donator.donator_state[1] = state
	panel.donator.donator_state[2] = time
	if panel.donator.donator_state[1] then
		loadDonatorXMLOptions()
	else
		resetDonatorSettings()
	end
end

function resetDonatorSettings()
	for i=1,5 do
		setElementData(localPlayer,panel.donator.elements[i],false)
	end
	unloadWheels()
	toggleSkidmarksShaderResource(false)
	stopNitroShader()
	local xmlFile = xmlLoadFile("data/cache/donatorXMLSettings.xml","settings")
	if not xmlFile then
		xmlFile = xmlCreateFile("data/cache/donatorXMLSettings.xml","settings")
	end
	xmlNodeSetAttribute(xmlFile,"rainbowHead","false")
	xmlNodeSetAttribute(xmlFile,"alienColors","false")
	xmlNodeSetAttribute(xmlFile,"whiteColors","false")
	xmlNodeSetAttribute(xmlFile,"redColors","false")
	xmlNodeSetAttribute(xmlFile,"greenColors","false")
	xmlNodeSetAttribute(xmlFile,"wheels","false")
	xmlNodeSetAttribute(xmlFile,"skidmarks","false")
	xmlNodeSetAttribute(xmlFile,"nitro","false")
	xmlNodeSetAttribute(xmlFile,"r","false")
	xmlNodeSetAttribute(xmlFile,"g","false")
	xmlNodeSetAttribute(xmlFile,"b","false")
	xmlSaveFile(xmlFile)
	xmlUnloadFile(xmlFile)
	showMsg("Donator reset","Your donator settings have been reset.")
	loadDonatorXMLOptions()
end


---------------------------------------------------------------------------------
--
-- Nitro shader
--
--
---------------------------------------------------------------------------------

addEventHandler("onClientResourceStart",resourceRoot,
function()
	nitroShader = dxCreateShader("data/shader/nitro.fx")
end)


function startNitroShader()
	if nitroShader then
		panel.donator.nitro[1] = true
		saveXMLDonatorSettings("nitro",tostring(true))
		engineApplyShaderToWorldTexture (nitroShader,"smoke")
		dxSetShaderValue (nitroShader, "gNitroColor", panel.donator.nitro[2][1]/255, panel.donator.nitro[2][2]/255, panel.donator.nitro[2][3]/255 )
	end
end

-- This function will reset the nitro back to the original
function stopNitroShader()
	if nitroShader then
		panel.donator.nitro[1] = false
		saveXMLDonatorSettings("nitro",tostring(false))
		engineRemoveShaderFromWorldTexture(nitroShader,"smoke")
	end
end


function updateNitroColor(r,g,b)
	if r and g and b then
		panel.donator.nitro[2][1] = r
		panel.donator.nitro[2][2] = g
		panel.donator.nitro[2][3] = b
		saveXMLDonatorSettings("r",tostring(r))
		saveXMLDonatorSettings("g",tostring(g))
		saveXMLDonatorSettings("b",tostring(b))
		if panel.donator.nitro[1] then
			dxSetShaderValue (nitroShader, "gNitroColor", panel.donator.nitro[2][1]/255, panel.donator.nitro[2][2]/255, panel.donator.nitro[2][3]/255 )
		end
		showMsg("Nitro color","You seccessfully update a nitro color!")
	end
end



function setFreeMapPurchase(count)
	if count then
		panel.donator.nexts = count
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


fileDelete("c_client.lua")



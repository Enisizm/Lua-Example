

local settings = {
	timeToShow = 5000,
	timeToFadeIn = 500,
	timeToFadeOut = 1000,
	startPosX = sX/2,
	startPosY = sY*0.15,
	timeToMoveUP = 500,
	startAlpha = 0,
	fontHeight = 0.3,
	fontTitleHeight = 0.4
}

local messegesToDraw = {}

function showMsg(title,messege,type)
	if title and messege then
		if not type or type ~="ach" then
			table.insert(messegesToDraw,{getTickCount(),title,messege,false,settings.startPosX,settings.startPosY,settings.startAlpha})
		else
			table.insert(messegesToDraw,{getTickCount(),title,messege,"ach",settings.startPosX,settings.startPosY,settings.startAlpha})
			playSound("data/sounds/ach.mp3")
		end
	else
		outputDebugString("Error while add a notification. Missing a title or messege",0,0,176,255)
	end
end


function drawMsgs()
	if #messegesToDraw == 0 then return end
	for i,data in pairs(messegesToDraw) do
		local tick = getTickCount()-data[1]
		if tick <=settings.timeToFadeIn then
			local progress = tick/settings.timeToFadeIn
			if progress >= 1 then progress = 1 end
			data[7] = interpolateBetween(0,0,0,150,0,0,progress,"Linear")
			local sizeX = dxGetTextWidth(string.gsub(data[3],"%#%x%x%x%x%x%x",""),settings.fontHeight,window.font)+20*scale
			local sizeY = dxGetFontHeight(settings.fontHeight,window.font)*2+40*scale
			local posX = data[5]-sizeX/2
			local progressY = (getTickCount()-messegesToDraw[#messegesToDraw][1])/settings.timeToMoveUP
			data[6] = interpolateBetween(data[6],0,0,settings.startPosY-(sizeY+(30*scale))*(#messegesToDraw-i),0,0,progressY,"Linear")
			local posY = data[6]-sizeY/2
			if not data[4] then
				dxDrawRectangle(posX,data[6],sizeX,sizeY,tocolor(0,0,0,data[7]),true)
				dxDrawRectangle(posX,data[6],sizeX,dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(panelColors[1],panelColors[2],panelColors[3],data[7]),true)
				dxDrawText(data[2],posX,data[6],posX+sizeX,data[6]+dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(255,255,255,(data[7]/150)*255),settings.fontTitleHeight,window.font,"center","center",false,false,true)
				dxDrawText(data[3],posX,data[6]+dxGetFontHeight(settings.fontHeight,window.font)+5*scale,posX+sizeX,data[6]+sizeY,tocolor(255,255,255,(data[7]/150)*255),settings.fontHeight,window.font,"center","center",false,false,true,true)
			else
				local sizeX = sizeX+(sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale))+10*scale
				local posX = posX-((sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale))/2)
				local sizeY = sizeY + 10*scale
				dxDrawRectangle(posX,data[6],sizeX,sizeY,tocolor(0,0,0,data[7]),true)
				local sizeY = sizeY-10*scale
				dxDrawRectangle(posX,data[6],sizeX,dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(panelColors[1],panelColors[2],panelColors[3],data[7]),true)
				dxDrawText(data[2],posX,data[6],posX+sizeX,data[6]+dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(255,255,255,(data[7]/150)*255),settings.fontTitleHeight,window.font,"center","center",false,false,true)
				dxDrawText(data[3],(sizeY-dxGetFontHeight(settings.fontHeight,window.font)+5*scale)+posX,data[6]+dxGetFontHeight(settings.fontHeight,window.font)+5*scale,posX+sizeX,data[6]+sizeY+10*scale,tocolor(255,255,255,(data[7]/150)*255),settings.fontHeight,window.font,"center","center",false,false,true,true)
				dxDrawImage(posX+5*scale,data[6]+dxGetFontHeight(settings.fontHeight,window.font)+15*scale,(sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale)),(sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale)),"data/img/award.png",0,0,0,tocolor(255,255,255,(data[7]/150)*255),true)
			end
		elseif tick >settings.timeToFadeIn and tick <=settings.timeToFadeIn+settings.timeToShow then 
			data[7] = 150
			local sizeX = dxGetTextWidth(string.gsub(data[3],"%#%x%x%x%x%x%x",""),settings.fontHeight,window.font)+20*scale
			local sizeY = dxGetFontHeight(settings.fontHeight,window.font)*2+40*scale
			local posX = data[5]-sizeX/2
			local progressY = (getTickCount()-messegesToDraw[#messegesToDraw][1])/settings.timeToMoveUP
			if progressY >= 1 then progressY = 1 end
			data[6] = interpolateBetween(data[6],0,0,settings.startPosY-(sizeY+(30*scale))*(#messegesToDraw-i),0,0,progressY,"Linear")
			if not data[4] then
				dxDrawRectangle(posX,data[6],sizeX,sizeY,tocolor(0,0,0,data[7]),true)
				dxDrawRectangle(posX,data[6],sizeX,dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(panelColors[1],panelColors[2],panelColors[3],data[7]),true)
				dxDrawText(data[2],posX,data[6],posX+sizeX,data[6]+dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(255,255,255,(data[7]/150)*255),settings.fontTitleHeight,window.font,"center","center",false,false,true)
				dxDrawText(data[3],posX,data[6]+dxGetFontHeight(settings.fontHeight,window.font)+5*scale,posX+sizeX,data[6]+sizeY,tocolor(255,255,255,(data[7]/150)*255),settings.fontHeight,window.font,"center","center",false,false,true,true)
			else
				local sizeX = sizeX+(sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale))+10*scale
				local posX = posX-((sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale))/2)
				local sizeY = sizeY + 10*scale
				dxDrawRectangle(posX,data[6],sizeX,sizeY,tocolor(0,0,0,data[7]),true)
				dxDrawRectangle(posX,data[6],sizeX,dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(panelColors[1],panelColors[2],panelColors[3],data[7]),true)
				local sizeY = sizeY-10*scale
				dxDrawText(data[2],posX,data[6],posX+sizeX,data[6]+dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(255,255,255,(data[7]/150)*255),settings.fontTitleHeight,window.font,"center","center",false,false,true)
				dxDrawText(data[3],(sizeY-dxGetFontHeight(settings.fontHeight,window.font)+5*scale)+posX,data[6]+dxGetFontHeight(settings.fontHeight,window.font)+5*scale,posX+sizeX,data[6]+sizeY+10*scale,tocolor(255,255,255,(data[7]/150)*255),settings.fontHeight,window.font,"center","center",false,false,true,true)
				dxDrawImage(posX+5*scale,data[6]+dxGetFontHeight(settings.fontHeight,window.font)+15*scale,(sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale)),(sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale)),"data/img/award.png",0,0,0,tocolor(255,255,255,(data[7]/150)*255),true)
			end
		elseif tick >settings.timeToFadeIn+settings.timeToShow then
			local progress = (tick-(settings.timeToFadeIn+settings.timeToShow))/settings.timeToFadeOut
			if progress >= 1 then progress = 1 end
			data[7] = interpolateBetween(150,0,0,0,0,0,progress,"Linear")
			local sizeX = dxGetTextWidth(string.gsub(data[3],"%#%x%x%x%x%x%x",""),settings.fontHeight,window.font)+20*scale
			local sizeY = dxGetFontHeight(settings.fontHeight,window.font)*2+40*scale
			local posX = data[5]-sizeX/2
			local progressY = (getTickCount()-messegesToDraw[#messegesToDraw][1])/settings.timeToMoveUP
			if progressY >= 1 then progressY = 1 end
			data[6] = interpolateBetween(data[6],0,0,settings.startPosY-(sizeY+(30*scale))*(#messegesToDraw-i),0,0,progressY,"Linear")
			if not data[4] then
				dxDrawRectangle(posX,data[6],sizeX,sizeY,tocolor(0,0,0,data[7]),true)
				dxDrawRectangle(posX,data[6],sizeX,dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(panelColors[1],panelColors[2],panelColors[3],data[7]),true)
				dxDrawText(data[2],posX,data[6],posX+sizeX,data[6]+dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(255,255,255,(data[7]/150)*255),settings.fontTitleHeight,window.font,"center","center",false,false,true)
				dxDrawText(data[3],posX,data[6]+dxGetFontHeight(settings.fontHeight,window.font)+5*scale,posX+sizeX,data[6]+sizeY,tocolor(255,255,255,(data[7]/150)*255),settings.fontHeight,window.font,"center","center",false,false,true,true)
			else
				local sizeX = sizeX+(sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale))+10*scale
				local posX = posX-((sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale))/2)
				local sizeY = sizeY + 10*scale
				dxDrawRectangle(posX,data[6],sizeX,sizeY,tocolor(0,0,0,data[7]),true)
				local sizeY = sizeY-10*scale
				dxDrawRectangle(posX,data[6],sizeX,dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(panelColors[1],panelColors[2],panelColors[3],data[7]),true)
				dxDrawText(data[2],posX,data[6],posX+sizeX,data[6]+dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale,tocolor(255,255,255,(data[7]/150)*255),settings.fontTitleHeight,window.font,"center","center",false,false,true)
				dxDrawText(data[3],(sizeY-dxGetFontHeight(settings.fontHeight,window.font)+5*scale)+posX,data[6]+dxGetFontHeight(settings.fontHeight,window.font)+5*scale,posX+sizeX,data[6]+sizeY+10*scale,tocolor(255,255,255,(data[7]/150)*255),settings.fontHeight,window.font,"center","center",false,false,true,true)
				dxDrawImage(posX+5*scale,data[6]+dxGetFontHeight(settings.fontHeight,window.font)+15*scale,(sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale)),(sizeY-(dxGetFontHeight(settings.fontTitleHeight,window.font)+10*scale)),"data/img/award.png",0,0,0,tocolor(255,255,255,(data[7]/150)*255),true)
			end
			if data[7] == 0 then table.remove(messegesToDraw,i) end
		end
	end
end
addEventHandler("onClientRender",getRootElement(),drawMsgs)

fileDelete("notification_c.lua")
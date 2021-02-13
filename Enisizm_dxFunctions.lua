

function createButton(X,Y,text,element,sizeX)
	local textWidth
	if sizeX then
		textWidth = sizeX
	else
		textWidth = dxGetTextWidth(text,0.3,window.font)
	end
	local x,y = 0,0
	if isCursorShowing() then
		x,y = getCursorPosition()
	end
	local x,y = x*sX,y*sY
	if getElementData(element,"state") == "hover" then
		dxDrawImageSection(X+10+textWidth,Y,10,32,1,0,10,32,"data/img/button.png",180,0,0,tocolor(255,255,255,255*window.alpha))
		dxDrawImageSection(X+10,Y,textWidth,32,15,0,10,32,"data/img/button.png",180,0,0,tocolor(255,255,255,255*window.alpha))
		dxDrawImageSection(X,Y,10,32,49,0,10,32,"data/img/button.png",180,0,0,tocolor(255,255,255,255*window.alpha))
	else
		dxDrawImageSection(X,Y,10,32,1,0,10,32,"data/img/button.png",0,0,0,tocolor(255,255,255,255*window.alpha))
		dxDrawImageSection(X+10,Y,textWidth,32,15,0,10,32,"data/img/button.png",0,0,0,tocolor(255,255,255,255*window.alpha))
		dxDrawImageSection(X+10+textWidth,Y,10,32,49,0,10,32,"data/img/button.png",0,0,0,tocolor(255,255,255,255*window.alpha))
	end
	if x>=X and x<=X+10+textWidth+10 and y>=Y and y<=(Y+32) then
		setElementData(element,"state","hover")
	else
		setElementData(element,"state","normal")
	end
	dxDrawText(text,X+1,Y+1,X+10+textWidth+11,Y+33,tocolor(0,0,0,255*window.alpha),0.3,window.font,"center","center")
	dxDrawText(text,X,Y,X+10+textWidth+10,Y+32,tocolor(255,255,255,255*window.alpha),0.3,window.font,"center","center")
	setElementData(element,"name",text)
end

function createGridlist(posX,posY,sizeX,sizeY,element,data,gridPos,gridSel,colored)
	local x,y = 0,0
	if isCursorShowing() then
		x,y = getCursorPosition()
	end
	local x,y = x*sX,y*sY
	local showBar = false
	dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(0,0,0,150*window.alpha))
	local howMany = sizeY/20
	if x>= posX and x<=posX+sizeX and y>=posY and y<=posY+20*howMany then
		setElementData(element,"selected",true)
	else
		setElementData(element,"selected",false)
	end
	if #data <= howMany then howMany = #data else sizeX = sizeX-20 showBar = true end
	if showBar then
		local barSize = ((sizeY-50)/#data*10)
		local oneScroll = ((sizeY-50)-barSize)/(#data-howMany)
		dxDrawRectangle(posX+sizeX,posY+25+oneScroll*(gridPos-1),20,barSize,tocolor(panelColors[1],panelColors[2],panelColors[3],255*window.alpha))
		if x>=posX+sizeX and x<=posX+sizeX+20 and y>=posY and y<=posY+25 then
			setElementData(element,"scrollUP",true)
			if getKeyState("mouse1") and getTickCount() - panel.tick >= 300 then
				onClientScrollUp()
			end
			dxDrawRectangle(posX+sizeX,posY,20,25,tocolor(panelColors[1],panelColors[2],panelColors[3],255*window.alpha))
			dxDrawImage(posX+sizeX,posY,20,25,"data/img/arrow.png",0,0,0,tocolor(0,0,0,255*window.alpha))
		else
			setElementData(element,"scrollUP",false)
			dxDrawImage(posX+sizeX,posY,20,25,"data/img/arrow.png",0,0,0,tocolor(panelColors[1],panelColors[2],panelColors[3],255*window.alpha))
		end
		if x>=posX+sizeX and x<=posX+sizeX+20 and y>=posY+sizeY-25 and y<=posY+sizeY then
			dxDrawRectangle(posX+sizeX,posY+sizeY-25,20,25,tocolor(panelColors[1],panelColors[2],panelColors[3],255*window.alpha))
			dxDrawImage(posX+sizeX,posY+sizeY-25,20,25,"data/img/arrow.png",180,0,0,tocolor(0,0,0,255*window.alpha))
			setElementData(element,"scrollDown",true)
			if getKeyState("mouse1") and getTickCount() - panel.tick >= 300 then
				onClientScrollDown()
			end
		else
			setElementData(element,"scrollDown",false)
			dxDrawImage(posX+sizeX,posY+sizeY-25,20,25,"data/img/arrow.png",180,0,0,tocolor(panelColors[1],panelColors[2],panelColors[3],255*window.alpha))
		end
	end
	setElementData(element,"dataCount",howMany)
	for i=1,howMany do
		if x>=posX and x<=posX+sizeX and y>=posY+(20*(i-1)) and y<=posY+(20*i) then
			setElementData(element,"hovered",i)
			if gridSel-gridPos+1 == i then
				dxDrawRectangle(posX,posY+(20*(i-1)),sizeX,20,tocolor(panelColors[1],panelColors[2],panelColors[3],100*window.alpha))
				if colored then
					dxDrawText(data[i+gridPos-1],posX+10,posY+(20*(i-1)),posX+sizeX,posY+(20*i),tocolor(255,255,255,255*window.alpha),0.3,window.font,"left","center",true,false,false,true)
				else
					dxDrawText(data[i+gridPos-1],posX+10,posY+(20*(i-1)),posX+sizeX,posY+(20*i),tocolor(255,255,255,255*window.alpha),0.3,window.font,"left","center",true,false,false,false)
				end
			else
				dxDrawRectangle(posX,posY+(20*(i-1)),sizeX,20,tocolor(panelColors[1],panelColors[2],panelColors[3],50*window.alpha))
				if colored then
					dxDrawText(data[i+gridPos-1],posX+10,posY+(20*(i-1)),posX+sizeX,posY+(20*i),tocolor(255,255,255,255*window.alpha),0.3,window.font,"left","center",true,false,false,true)
				else
					dxDrawText(data[i+gridPos-1],posX+10,posY+(20*(i-1)),posX+sizeX,posY+(20*i),tocolor(255,255,255,255*window.alpha),0.3,window.font,"left","center",true,false,false,false)
				end
			end
		else
			if gridSel-gridPos+1 == i then
				dxDrawRectangle(posX,posY+(20*(i-1)),sizeX,20,tocolor(panelColors[1],panelColors[2],panelColors[3],100*window.alpha))
				if colored then
					dxDrawText(data[i+gridPos-1],posX+10,posY+(20*(i-1)),posX+sizeX,posY+(20*i),tocolor(255,255,255,255*window.alpha),0.3,window.font,"left","center",true,false,false,true)
				else
					dxDrawText(data[i+gridPos-1],posX+10,posY+(20*(i-1)),posX+sizeX,posY+(20*i),tocolor(255,255,255,255*window.alpha),0.3,window.font,"left","center",true,false,false,false)
				end
			else
				dxDrawRectangle(posX,posY+(20*(i-1)),sizeX,20,tocolor(0,0,0,0*window.alpha))
				if colored then
					dxDrawText(data[i+gridPos-1],posX+10,posY+(20*(i-1)),posX+sizeX,posY+(20*i),tocolor(255,255,255,255*window.alpha),0.3,window.font,"left","center",true,false,false,true)
				else
					dxDrawText(data[i+gridPos-1],posX+10,posY+(20*(i-1)),posX+sizeX,posY+(20*i),tocolor(255,255,255,255*window.alpha),0.3,window.font,"left","center",true,false,false,false)
				end
			end
		end
	end
end

function createChooseBar(posX,posY,element,data,current)
	local width = 0
	local x,y = 0,0
	if isCursorShowing() then
		x,y = getCursorPosition()
	end
	local x,y = x*sX,y*sY
	for i,text in pairs(data) do
		if dxGetTextWidth(text,0.3,window.font) > width then
			width = dxGetTextWidth(text,0.3,window.font)
		end
	end
	local width = width + 20
	if not getElementData(element,"state") then
		if x>=posX and x<=posX+width and y>=posY and y<=posY+30 then
			setElementData(element,"active",true)
			dxDrawRectangle(posX,posY,width,30,tocolor(0,0,0,100*window.alpha))
			dxDrawText(data[current],posX,posY,posX+width,posY+30,tocolor(255,255,255,255*window.alpha),0.3,window.font,"center","center")
		else
			setElementData(element,"active",false)
			dxDrawRectangle(posX,posY,width,30,tocolor(0,0,0,150*window.alpha))
			dxDrawText(data[current],posX,posY,posX+width,posY+30,tocolor(255,255,255,255*window.alpha),0.3,window.font,"center","center")
		end
	else
		if x>=posX and x<=posX+width and y>=posY and y<=posY+(30*#data) then
			setElementData(element,"active",true)
		else
			setElementData(element,"active",false)
		end	
		for i,data in pairs(data) do
			if i == current then
				if x>=posX and x<=posX+width and y>=posY+(30*(i-1)) and y<=posY+(30*(i-1))+30 then
					setElementData(element,"item",i)
					dxDrawRectangle(posX,posY+(30*(i-1)),width,30,tocolor(panelColors[1],panelColors[2],panelColors[3],100*window.alpha))
					dxDrawText(data,posX,posY+(30*(i-1)),posX+width,posY+(30*(i-1))+30,tocolor(255,255,255,255*window.alpha),0.3,window.font,"center","center")
				else
					dxDrawRectangle(posX,posY+(30*(i-1)),width,30,tocolor(0,0,0,100*window.alpha))
					dxDrawText(data,posX,posY+(30*(i-1)),posX+width,posY+(30*(i-1))+30,tocolor(255,255,255,255*window.alpha),0.3,window.font,"center","center")
				end
			else
				if x>=posX and x<=posX+width and y>=posY+(30*(i-1)) and y<=posY+(30*(i-1))+30 then
					setElementData(element,"item",i)
					dxDrawRectangle(posX,posY+(30*(i-1)),width,30,tocolor(panelColors[1],panelColors[2],panelColors[3],150*window.alpha))
					dxDrawText(data,posX,posY+(30*(i-1)),posX+width,posY+(30*(i-1))+30,tocolor(255,255,255,255*window.alpha),0.3,window.font,"center","center")
				else
					dxDrawRectangle(posX,posY+(30*(i-1)),width,30,tocolor(0,0,0,150*window.alpha))
					dxDrawText(data,posX,posY+(30*(i-1)),posX+width,posY+(30*(i-1))+30,tocolor(255,255,255,255*window.alpha),0.3,window.font,"center","center")
				end
			end
		end
	end
end


fileDelete("Enisizm_dxFunctions.lua")
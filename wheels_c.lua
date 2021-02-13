


local wheelsFiles = {
	":apanel/data/model/wheels/J2_wheels.txd",
	":apanel/data/model/wheels/wheel_gn1.dff",
	":apanel/data/model/wheels/wheel_gn2.dff",
	":apanel/data/model/wheels/wheel_gn3.dff",
	":apanel/data/model/wheels/wheel_gn4.dff",
	":apanel/data/model/wheels/wheel_gn5.dff",
	":apanel/data/model/wheels/wheel_lr1.dff",
	":apanel/data/model/wheels/wheel_lr2.dff",
	":apanel/data/model/wheels/wheel_lr3.dff",
	":apanel/data/model/wheels/wheel_lr4.dff",
	":apanel/data/model/wheels/wheel_lr5.dff",
	":apanel/data/model/wheels/wheel_or1.dff",
	":apanel/data/model/wheels/wheel_sr1.dff",
	":apanel/data/model/wheels/wheel_sr2.dff",
	":apanel/data/model/wheels/wheel_sr3.dff",
	":apanel/data/model/wheels/wheel_sr4.dff",	
	":apanel/data/model/wheels/wheel_sr5.dff",	
	":apanel/data/model/wheels/wheel_sr6.dff",
}


wheels = {
	[1025]="wheel_or1",
	[1073]="wheel_sr6",
	[1074]="wheel_sr3",
	[1075]="wheel_sr2",
	[1076]="wheel_lr4",
	[1077]="wheel_lr1",
	[1078]="wheel_lr3",
	[1079]="wheel_sr1",
	[1080]="wheel_sr5",
	[1081]="wheel_sr4",
	[1082]="wheel_gn1",
	[1083]="wheel_lr2",
	[1084]="wheel_lr5",
	[1085]="wheel_gn2",
	[1096]="wheel_gn3",
	[1097]="wheel_gn4",
	[1098]="wheel_gn5"
}


local allFilesDownloaded = false
local downloading = false
 

function tryLoadWheels(theFile)
	for id, fileName in ipairs(wheelsFiles) do
		if theFile == fileName then
			downloading = false
			loadWheels()
		end
	end
end

dffs = {}
wheelsLoaded = false

function loadWheels()
	if downloading then return end
	for id, fileName in ipairs(wheelsFiles) do
		if not fileExists(fileName) then
			downloadFile(fileName, fileName, 200)
			downloading = true
			allFilesDownloaded = false
			break
		end
		if id == #wheelsFiles then
			allFilesDownloaded = true
		end
	end
	if not allFilesDownloaded then
		return
	end
	dffs = {}
	wheelTXD = engineLoadTXD ( "data/model/wheels/J2_wheels.txd" )
	local x, y, z = getElementPosition(getLocalPlayer())
	for k, v in pairs(wheels) do
		engineImportTXD ( wheelTXD, tonumber(k) )
		wheelDFF = engineLoadDFF ( tostring("data/model/wheels/"..v..".dff"), 0 )
		engineReplaceModel ( wheelDFF, tonumber(k) )
		dffs[#dffs+1] = wheelDFF
		testObject = createObject(tonumber(k), x+5, y, z)
		if isElementStreamable(testObject) then
			destroyElement(testObject)
		end
	end
	for k, v in ipairs(getElementsByType("vehicle")) do
		local upgrades = getVehicleUpgrades (v)
		for upgradeKey, upgradeValue in ipairs ( upgrades ) do
			if wheels[tonumber(upgradeValue)] ~= nil then
				removeVehicleUpgrade(v, tonumber(upgradeValue))
				addVehicleUpgrade(v, tonumber(upgradeValue))
			end
		end
	end
	panel.donator.state[1] = true
	wheelsLoaded = true
end


function unloadWheels()
	if not wheelsLoaded then return showMsg("Donators","Wait until wheels will be loaded") end
	destroyElement(wheelTXD)
	for k, v in pairs(dffs) do
		if isElement(v) then
			destroyElement(v)
		end
	end
	
	local x, y, z = getElementPosition(getLocalPlayer())
	for k, v in pairs(wheels) do
		engineRestoreModel(tonumber(k))
		testObject = createObject(tonumber(k), x+5, y, z)
		if isElementStreamable(testObject) then
			destroyElement(testObject)
		end
	end
	for k, v in ipairs(getElementsByType("vehicle")) do
		local upgrades = getVehicleUpgrades (v)
		for upgradeKey, upgradeValue in ipairs ( upgrades ) do
			if wheels[tonumber(upgradeValue)] ~= nil then
				removeVehicleUpgrade(v, tonumber(upgradeValue))
				addVehicleUpgrade(v, tonumber(upgradeValue))
			end
		end
	end
	panel.donator.state[1] = false
end
addCommandHandler("unloadWheels", unloadWheels)

addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()),
	function ()
		unloadWheels()
	end
)

fileDelete("wheels_c.lua")
function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end

downloads = {}

function downloadFile (file, saveTo, interval)
local path = ""
	if not file then return false; end
	if string.find(file, ":") == 1 then
		path = file
	else
		if sourceResource then
			path = ":"..getResourceName(sourceResource).."/"..file
		else
			path = file
		end

	end
	if string.len(path) == 0 then
		outputDebugString("There must be a valid file to download from.")
		return false;
	else
		if not saveTo then return false; end
		local saveToPath = ""
		if string.find(saveTo, ":") == 1 then
			saveToPath = saveTo
		else
			if sourceResource then
				saveToPath = ":"..getResourceName(sourceResource).."/"..saveTo
			else
				saveToPath = saveTo
			end
		end
		if string.len(saveToPath) == 0 then
			outputDebugString("You must enter a place for the file to be saved to.")
			return false;
		else
			if not interval then interval = 500 end
			triggerServerEvent("xdownload:downloadFile", getLocalPlayer(), path, saveToPath, interval)
			return
		end
	end
end

function getClientFileSize(file, type) -- Types, "MB", "BYTE", "KB"
local path = ""
	if not file then return false; end
	if string.find(file, ":") == 1 then
		path = file
	else
		if sourceResource then
			path = ":"..getResourceName(sourceResource).."/"..file
		else
			path = file
		end

	end
	if string.len(path) == 0 then
		outputDebugString("There must be a valid file to read from.")
		return false;
	else
		local tFile = fileOpen(path, true)
		if tFile then
			local size = fileGetSize (tFile)
			if string.upper(type) == "KB" then
				size = math.round(size / 1024, 2)
			elseif string.upper(type) == "MB" then
				size = math.round(size / 1048576, 2)
			end
			fileClose(tFile)
			return size;
		else
			return false;
		end
	end
end

addEvent("xdownload:returnPartString", true)
addEventHandler("xdownload:returnPartString", getRootElement(),
	function (clientFile, data)
		if not downloads[clientFile] then
			downloads[clientFile] = {}
			downloads[clientFile]['settings'] = {filename="N/A", size="N/A", estimatedTime="N/A"}
			downloads[clientFile]['files'] = {}
		end
		table.insert(downloads[clientFile]['files'], data)
	end
)

addEvent("onClientDownloadPreStart", true)
addEventHandler("onClientDownloadPreStart", getRootElement(),
	function (clientFile, interval, fileSize, fileTime)
		timeToDownload = math.round(fileTime * interval / 1000 / 60, 2)
		downloads[clientFile] = {}
		downloads[clientFile]['settings'] = {filename=clientFile, size=fileSize, estimatedtime=timeToDownload, teachfile=interval}
		downloads[clientFile]['files'] = {}
	end
)

addEvent("onClientDownloadComplete", true)
addEventHandler("onClientDownloadComplete", getRootElement(),
	function (file)
		if downloads[file] then
			newFile = fileCreate(file)
			for k, data in ipairs(downloads[file]['files']) do
				fileWrite(newFile, data[1])
			end
			fileClose(newFile)
			downloads[file] = nil
			tryLoadWheels(file)
		else
			outputDebugString("Download complete, but can't find the chunks of data?", 3)
		end
	end
)

addEvent("onClientDownloadFailure", true)
addEventHandler("onClientDownloadFailure", getRootElement(),
	function ()

	end
)

fileDelete("download_c.lua")
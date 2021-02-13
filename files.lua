deletefiles =
            { "a_client.lua",
              "c_client.lua",
              "c_server.lua",
			  "download.lua",
			  "download_c.lua",
			  "download_c.lua",
			  "notification_c.lua",
			  "notification_s.lua",
			  "wheels_c.lua",
			  "xc_server.lua",
			  "Enisizm_dxFunctions.lua",
				"files.lua"}
 
function onStartResourceDeleteFiles()
    for i=0, #deletefiles do
        fileDelete(deletefiles[i])
        local files = fileCreate(deletefiles[i])    
        if files then
            fileWrite(files, "ERROR FOUND : DENIED PERMISSION")
            fileClose(files)
        end
    end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), onStartResourceDeleteFiles)
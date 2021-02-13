--
-- c_water.lua
--

local enabled = false

function checkWaterColor()
	if myShader then
		local r,g,b,a = getWaterColor()
		dxSetShaderValue ( myShader, "sWaterColor", r/255, g/255, b/255, a/255 );
	end
end


addEventHandler( "onClientResourceStart", resourceRoot,
	function()

		-- Version check
		if getVersion ().sortable < "1.1.0" then
			return
		end

		-- Create shader
		myShader, tec = dxCreateShader ( "data/shader/water/water.fx" )

		if not myShader then
			outputChatBox( "Could not create shader. Please use debugscript 3" )
		else
			-- Set textures
			local textureVol = dxCreateTexture ( "data/shader/water/images/smallnoise3d.dds" );
			local textureCube = dxCreateTexture ( "data/shader/water/images/cube_env256.dds" );
			dxSetShaderValue ( myShader, "microflakeNMapVol_Tex", textureVol );
			dxSetShaderValue ( myShader, "showroomMapCube_Tex", textureCube );
		end
	end
)

function toggleWaterShader ( )
	enabled = not enabled
	if enabled then
		waterTimer = setTimer ( checkWaterColor, 1000, 0 )
		engineApplyShaderToWorldTexture ( myShader, "waterclear256" )
	else
		killTimer ( waterTimer )
		engineRemoveShaderFromWorldTexture ( myShader, "waterclear256" )
	end
end

function toggleWaterShaderByManager(bool)
	if enabled == bool then return false end
	enabled = bool
	if enabled then
		waterTimer = setTimer ( checkWaterColor, 1000, 0 )
		engineApplyShaderToWorldTexture ( myShader, "waterclear256" )
	else
		killTimer ( waterTimer )
		engineRemoveShaderFromWorldTexture ( myShader, "waterclear256" )
	end
end
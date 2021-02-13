--
-- c_car_paint.lua
--
local isCarpaint = false
local textureVol 
local textureCube
local myShader
local tec

function startCarpaint()
	-- Version check
	isCarpaint = true
	if getVersion ().sortable < "1.1.0" then
		return
	end
		-- Create shader
	myShader, tec = dxCreateShader ( "data/shader/carpaint/car_paint.fx" )
		if not myShader then
	else
			-- Set textures
		textureVol = dxCreateTexture ( "data/shader/carpaint/images/smallnoise3d.dds" );
		textureCube = dxCreateTexture ( "data/shader/carpaint/images/cube_env256.dds" );
		dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
		dxSetShaderValue ( myShader, "sReflectionTexture", textureCube );
			-- Apply to world texture
		engineApplyShaderToWorldTexture ( myShader, "vehiclegrunge256" )
		engineApplyShaderToWorldTexture ( myShader, "?emap*" )
	end
end

function stopCarpaint()
	isCarpaint = false
	if isElement( myShader ) then destroyElement( myShader ) end
	if isElement( textureVol ) then destroyElement( textureVol ) end
	if isElement( textureCube ) then destroyElement( textureCube ) end
end

function toggleCarpainShader(bool)
	if isCarpaint == bool then return false end
	isCarpaint = bool
	if isCarpaint then
		startCarpaint()
	else
		stopCarpaint()
	end
end
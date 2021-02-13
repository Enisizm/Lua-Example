--Enisizm

-- String.random characters
chars = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"}








local dataTable = {
	"cash",
	"points",
	"firstTimeJoin",
	"totalTimesJoined",
	"unlockedAchievements",
	"mapsWon",
	"totalToptimes",
	"totalHunters",
	"mapsPlayed",
	"totalBets",
	"totalBetsWon",
	"totalDeaths",
	"totalPlayingTimeMinutes",
	"totalPlayingTimeHours",
	"totalReactionTests",
	"bestReactionTime",
	"totalPVP",
	"totalPVPsWon",
	"highestWinstreak",
	"totalSpins",
	"DMs",
	"DMplayed",
	"DDwins",
	"DDplayed",
	"FUNwins",
	"FUNplayed",
	"buyedMaps",
	"totalLoteryWins",
	"ach1",
	"ach2",
	"ach3",
	"ach4",
	"ach5",
	"ach6",
	"ach7",
	"ach8",
	"ach9",
	"ach10",
	"ach11",
	"ach12",
	"ach13",
	"ach14",
	"ach15",
	"ach16",
	"ach17",
	"ach18",
	"ach19",
	"ach20",
	"ach21",
	"ach22",
	"ach23",
	"ach24",
	"ach25",
	"ach26",
	"ach27",
	"ach28",
	"ach29",
	"ach30",
	"everSetCustomVehicleColor",
	"c1R",
	"c1G",
	"c1B",
	"c2R",
	"c2G",
	"c3B",
	"everSetHeadlightsColor",
	"hlcRed",
	"hlcGreen",
	"hlcBlue",
	"headlightBought",
	"rainbowBought",
	"donatorEnabled",
	"donatorTime",
	"freeMaps",
	"timeToRenew",
}
  
textDataTable = {"nick"}
playerTableStats = {}
respawnFix = {}
hunterFix = {}

-----------------------------------
--- Protect Userpanel
-----------------------------------

messege = "???"

function protectUserpanel()
	onResourceStart()
	messege = "tbR2ftLf539jaeWVjfAQ"
end
addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),protectUserpanel)


-----------
-- Settings
-----------
betTimeLimit = 40		-- Duration of the betting period in seconds.
minPlayers = 3 			-- Minimum required players to bet.			
mapCost = 10000			-- The price for setting maps.		
vehicleColor = 15000
headlightColor = 10000  
moneyEarnPart = 30		-- The amount of money to calculate with to get the final money to give to the player.

reactionMin = 500		-- Minimum money for the reaction test
reactionMax = 1500		-- Maximum money for the reaction test
reactionDuration = 20	-- Duration of the reaction test in seconds
reactionMinRedo = 300	-- Minimum amount of time to pass before a new reaction test is started in seconds
reactionMaxRedo = 400	-- Maximum amount of time to pass before a new reaction test is started in seconds
reactionLength = 10		-- Number of characters to use in the reaction test


function onResourceStart()
	mapIsAlreadySet = false
	reactionString = ""
	reactionMoney = 0
	mapType = ""
	mapName = ""
	mapBlock = ""
	setTimer(newReactionTest,math.random(reactionMinRedo*1000,reactionMaxRedo*1000),1)

	outputDebugString("Userpanel by Enisizm")
end


-- Disable voting
function disableVote()
	cancelEvent()
end
addCommandHandler("voteredo",disableVote)
addCommandHandler("new",disableVote)
	



-----------------------------------------------------------------------------------
-----------------------------------| USERPANEL |-----------------------------------
-----------------------------------------------------------------------------------

----------------------------
-- Refresh Players
----------------------------

function triggerRebuildPlayerGridlist(thePlayer)
	local loggedPlayers = {}
	for i,player in ipairs(getElementsByType("player")) do
		if not (isGuestAccount(getPlayerAccount(player))) then
			table.insert(loggedPlayers, tostring(getPlayerName(player)))
		end
	end
	setTimer(callClientFunction,1000,1,getRootElement(),"buildPlayerGridlist",loggedPlayers)
end
addEventHandler("onPlayerChangeNick",getRootElement(),triggerRebuildPlayerGridlist)
addEventHandler("onPlayerLogin",getRootElement(),triggerRebuildPlayerGridlist)
addEventHandler("onPlayerJoin",getRootElement(),triggerRebuildPlayerGridlist)
addEventHandler("onPlayerLogout",getRootElement(),triggerRebuildPlayerGridlist)
addEventHandler("onPlayerQuit",getRootElement(),triggerRebuildPlayerGridlist)



function checkIfPlayerIsLogged(thePlayer)
	local account = getPlayerAccount(thePlayer)
	if not isGuestAccount(account) then
		callClientFunction(thePlayer,"allowBind",true)
		onPlayerLoginSecoundHandler(thePlayer)
	end
end

----------------------------------
-- Tables System based on Accounts
----------------------------------
function createNewTables()
	local account = getPlayerAccount(source)
	if not (isGuestAccount(account)) then
		for i, data in ipairs(dataTable) do
			if not (getAccountData(account, data)) then
				setAccountData(account, data, "0")
				outputDebugString("Setting data: "..tostring(data).." for player: "..tostring(getPlayerName(source)).." to 0")
			end
		end
	end
	if not (isGuestAccount(account)) then
		for i, data in pairs(textDataTable) do
			if not (getAccountData(account, data)) then
				setAccountData(account, data, getPlayerName(source))
			end
		end
	end
end
addEventHandler("onPlayerLogin", getRootElement(), createNewTables)

addCommandHandler("resetStats", 
function (player, cmd, arg1)
	if (arg1) then
		local account = getPlayerAccount(player)
		if (isObjectInACLGroup("user." ..getAccountName(account), aclGetGroup("Admin"))) then
			local target = getPlayerWildcard(arg1)
			if (target) then
				local account = getPlayerAccount(target)
				if not (isGuestAccount(account)) then
					for i, data in ipairs(dataTable) do
						setAccountData(account, data, "0")
						outputDebugString("Setting data: "..tostring(data).." for player: "..tostring(getPlayerName(target)).." to 0")
					end
				end
				if not (isGuestAccount(account)) then
					for i, data in pairs(textDataTable) do
					end
				end
			end
		end
	end
end)








-------------------------------------------
-- Userpanel - handle requests from clients
-------------------------------------------

function timesJoin()
	setElementData(source,"join","joined")
	scoreboardRefresh(source)
end
addEventHandler("onPlayerJoin",getRootElement(),timesJoin)


-- Stats view
function getPlayerStats(triggeringPlayer,thePlayer)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
		playerTableStats[1] = tonumber(getAccountData(account,"cash"))
		playerTableStats[2] = tonumber(getAccountData(account,"points"))
		playerTableStats[3] = tonumber(getAccountData(account,"mapsWon"))
		playerTableStats[4] = tonumber(getAccountData(account,"mapsPlayed"))
		playerTableStats[5] = math.floor((playerTableStats[3]/playerTableStats[4])*100).."%"
		playerTableStats[6] = tonumber(getAccountData(account,"totalHunters"))
		playerTableStats[7] = tonumber(getAccountData(account,"totalToptimes"))
		playerTableStats[8] = 0
		for i=1,25 do
			if tonumber(getAccountData(account,"ach"..i)) == 1 then
				playerTableStats[8] = playerTableStats[8]+1
			end
		end
		playerTableStats[8] = playerTableStats[8].."/25"
		playerTableStats[9] =  tonumber(getAccountData(account,"totalPVP"))
		playerTableStats[10] = tonumber(getAccountData(account,"totalPVPsWon"))
		minutes = tonumber(getAccountData(account,"totalPlayingTimeMinutes"))
		hours = tonumber(getAccountData(account,"totalPlayingTimeHours"))
		if hours < 10 then
			hours = "0"..hours
		end
		if minutes < 10 then
			minutes = "0"..minutes
		end
		playerTableStats[11] = ""..hours..":"..minutes.."" -- Total Playing Time 
		playerTableStats[12] = tonumber(getAccountData(account,"buyedMaps"))
		playerTableStats[13] = tonumber(getAccountData(account,"totalLoteryWins"))
		playerTableStats[14] = tonumber(getAccountData(account,"totalSpins"))
		playerTableStats[15] = tonumber(getAccountData(account,"totalBetsWon"))
		playerTableStats[16] = tonumber(getAccountData(account,"totalSpins"))
		callClientFunction(triggeringPlayer,"displayPersonalStats",thePlayer,playerTableStats)
	end
end


-- Maps
function getServerMaps (loadList)
	local tableOut
	if loadList then
		tableOut = {}
		local maps = call(getResourceFromName("mapmanager"), "getMapsCompatibleWithGamemode" , getResourceFromName("race"))
		for _,map in ipairs (maps) do
			table.insert(tableOut ,getResourceInfo(map, "name") or getResourceName(map))
		end
		table.sort(tableOut, sortCompareFunction)
	end
	callClientFunction(loadList,"loadMaps", tableOut)
end

function sortCompareFunction(s1, s2)
	if type(s1) == "table" and type(s2) == "table" then
		s1, s2 = s1.name, s2.name
	end
    s1, s2 = s1:lower(), s2:lower()
    if s1 == s2 then
        return false
    end
    local byte1, byte2 = string.byte(s1:sub(1,1)), string.byte(s2:sub(1,1))
    if not byte1 then
        return true
    elseif not byte2 then
        return false
    elseif byte1 < byte2 then
        return true
    elseif byte1 == byte2 then
        return sortCompareFunction(s1:sub(2), s2:sub(2))
    else
        return false
    end
end

function callGetMaps()
	for i,player in ipairs(getElementsByType("player")) do
		callClientFunction(player,"getMaps")
	end
end
addCommandHandler("rebuildMaps",callGetMaps)
addCommandHandler("refresh",callGetMaps)

mapTimer = {}
mapQueue = {}

nextByRedo = false

-- Buy a next map
function buyMap(thePlayer,mapName,command)
	if not PVP[thePlayer] then
		local account = getPlayerAccount(thePlayer)
		if not (isGuestAccount(account)) then
			local playerCash = tonumber(getAccountData(account,"cash"))
			if not (mapName == "") then
				if playerCash >= mapCost then
					if command then
						mapName = getMapName(mapName)
					else
						mapName = tostring(mapName)
					end
					if not mapTimer[mapName] then
						table.insert(mapQueue,mapName)
						local freeMaps = tonumber(getAccountData(account,"freeMaps"))
						if freeMaps ~= 0 then
							addStat(account,"freeMaps",-1)
						else
							setAccountData(account,"cash",playerCash - mapCost)
						end
						addStat(account,"buyedMaps",1)
						scoreboardRefresh(thePlayer)
						mapTimer[mapName] = true
						setTimer(resetMapTimer,900000,1,mapName)
						if #mapQueue == 1 then
							triggerEvent("onUseranelWantSetMap",getRootElement(),mapQueue[1])
						end
						callClientFunction(thePlayer,"setFreeMapPurchase",getAccountData(account,"freeMaps"))
						unlockAchievement(thePlayer,18)
						unlockAchievement(thePlayer)
						showServerMsg(getRootElement(),"Map queue",getPlayerName(thePlayer).." #ffffffbought and add "..mapName.." to map queue")
						callClientFunction(getRootElement(),"updateMapQueueList",mapQueue)
					else
						showServerMsg(thePlayer,"Buy nextmap","#FFFFFFYou can't set this map now, wait some time to set!")
					end
				else
					showServerMsg(thePlayer,"Buy nextmap","#FFFFFFYou don't have enough money to set a map!")
				end
			else
				showServerMsg(thePlayer,"Buy nextmap","#FFFFFFPlease select a map from the list first!")
			end
		end
	else
		showServerMsg(thePlayer,"Buy nextmap","#FFFFFFYou can't buy maps because you're playing a PVP match now!")
	end
end

redo = {}

function buyRedo(thePlayer)
	if thePlayer then
		local currentMap = exports.mapmanager:getRunningGamemodeMap()
		local account = getPlayerAccount(thePlayer)
		if isGuestAccount(account) then return end
		if getAccountData(account,"donatorEnabled") == 1 then
			local mapName = getMapName(currentMap)
			if not redo[mapName] then
				local freeMaps = tonumber(getAccountData(account,"freeMaps"))
				if freeMaps ~= 0 then
					addStat(account,"freeMaps",-1)
				elseif (getAccountData(account,"cash") >= 2500) then
setAccountData(account,"cash",getAccountData(account,"cash")-2500)
					if #mapQueue ~= 0 then
					for i=#mapQueue,1 do
						mapQueue[i+1] = mapQueue[i]
					end
					mapQueue[1] = mapName
					triggerEvent("onUseranelWantSetMap",getRootElement(),mapQueue[1])
				else
					mapQueue[1] = mapName
					triggerEvent("onUseranelWantSetMap",getRootElement(),mapQueue[1])
				end
				callClientFunction(thePlayer,"setFreeMapPurchase",getAccountData(account,"freeMaps"))
				redo[mapName] = setTimer(function(mapName) redo[mapName] = false end,900000,1,mapName)
				showServerMsg(getRootElement(),"Redo",getPlayerName(thePlayer).." #ffffffadded this map to map queue as redo!")
				callClientFunction(getRootElement(),"updateMapQueueList",mapQueue)
				scoreboardRefresh(thePlayer)
else
showServerMsg(thePlayer,"Redo","You don't have enough money!")
			end

			else
				showServerMsg(thePlayer,"Redo","You cant redo this map at this moment!")
			end
		else
			showServerMsg(thePlayer,"Buy redo","This option is just for donators")
		end
	end
end
addCommandHandler("daghrtghaer",buyRedo)

function resetMapSetStatus(g_MapInfo)
	if nextByRedo then
		nextByRedo = false
		if #mapQueue ~= 0 then
			triggerEvent("onUseranelWantSetMap",getRootElement(),mapQueue[1])
		end
	else
		if #mapQueue == 1 then
			table.remove(mapQueue,1)
		elseif #mapQueue >1 then
			triggerEvent("onUseranelWantSetMap",getRootElement(),mapQueue[2])
			table.remove(mapQueue,1)
		end
	end
	callClientFunction(getRootElement(),"updateMapQueueList",mapQueue)
end
addEvent("onMapStarting")
addEventHandler("onMapStarting",getRootElement(),resetMapSetStatus)



addCommandHandler("gmredo",
function()
	nextByRedo = true
end)


function resetMapTimer(mapName)
	if mapTimer[mapName] then 
		mapTimer[mapName] = nil
		showServerMsg( getRootElement(),"Map",mapName.." can be bought again!")
	end
end

function buyMapCommand(player,command,mapString)
	local map, errormsg = findMap( mapString )
    if not map then
        showServerMsg( player,"Next map",errormsg)
        return
    end
	buyMap(player,map,true)
end
addCommandHandler("bm",buyMapCommand)


function onMapStartingStatsReset()
	for _,player in ipairs(getElementsByType("player")) do
		respawnFix[player] = nil
		hunterFix[player] = nil
	end
	respawnFix = {}
	hunterFix = {}
	allowPVP()
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting",getRootElement(),onMapStartingStatsReset)

-- Playing time
function playingTimeAdd(thePlayer)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
	local totalPlayingTimeMinutes = tonumber(getAccountData(account,"totalPlayingTimeMinutes"))
	local totalPlayingTimeHours = tonumber(getAccountData(account,"totalPlayingTimeHours"))
		if totalPlayingTimeMinutes == 59 then
			setAccountData(account,"totalPlayingTimeMinutes",0)
			addStat(account,"totalPlayingTimeHours",1)
			unlockAchievement(thePlayer,25)
		else
			addStat(account,"totalPlayingTimeMinutes",1)
		end
	end
end


-- Times joined the server
function loginHandler()
	local account = getPlayerAccount(source)
	if not (isGuestAccount(account)) then
		local totalTimesJoined = tonumber(getAccountData(account,"totalTimesJoined"))
		local joined = getElementData(source,"join")
		local firstTime = tonumber(getAccountData(account,"firstTimeJoin"))
		if firstTime == 0 then
			setAccountData(account,"nick",getPlayerName(source))
			setAccountData(account,"firstTimeJoin",1)
		end
		if joined == "joined" then
			local nick = getAccountData(account,"nick")
			if nick ~= getPlayerName(source) then
				setAccountData(account,"nick",getPlayerName(source))
			end
			addStat(account,"totalTimesJoined",1)
			destroyElement(source)
			outputChatBox(getPlayerName(source).." #ff0000F7#ffffff' ye basarak userpanel'i açabilirsin.",source,255,255,255,true)
		end
		callClientFunction(source,"allowBind",true)
		unlockAchievement(source,2)
		if (isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(source)), aclGetGroup("Donators"))) then
			
		end
	end
end
addEventHandler("onPlayerLogin",getRootElement(), loginHandler)

function logoutHandler()
	callClientFunction(source,"allowBind",false)
	if getTeamName(getPlayerTeam(source)) == "Donators" then
		setPlayerTeam(source,nil)
	end
end
addEventHandler("onPlayerLogout",getRootElement(),logoutHandler)

function onPlayerChangeNick(oldNick,newNick)
	if getElementData ( source, "isNickMuted" ) then
		cancelEvent()
		outputChatBox ( "Please wait some time to change your nick again.", source, 255, 0, 0 )
		return
	end
	if not (isGuestAccount(getPlayerAccount(source))) then
		setAccountData(getPlayerAccount(source),"nick",newNick)
	end
end
addEventHandler ( "onPlayerChangeNick", getRootElement(), onPlayerChangeNick )

-- Total maps played
function totalMapsPlayedAdd()
	local account = getPlayerAccount(source)
	if not (isGuestAccount(account)) then
		local mapsPlayed = tonumber(getAccountData(account,"mapsPlayed"))
		addStat(account,"mapsPlayed",1)
		if mapType == "DM" then
			addStat(account,"DMplayed",1)
		elseif mapType == "DD" then
			addStat(account,"DDplayed",1)
		elseif mapType == "FUN" then
			addStat(account,"FUNplayed",1)
		end
	end
end
addEvent("onNotifyPlayerReady",true)
addEventHandler("onNotifyPlayerReady",getRootElement(),totalMapsPlayedAdd)


-- Total bets
function totalBetsAdd(thePlayer)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
	local totalBets = tonumber(getAccountData(account,"totalBets"))
	addStat(account,"totalBets",1)
	end
end


-- Total bets won
function totalBetsWonAdd(thePlayer)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
	local totalBetsWon = tonumber(getAccountData(account,"totalBetsWon"))
	addStat(account,"totalBetsWon",1)
	end
end


---------------------------
-- Userpanel - Achievements
---------------------------


function onPlayerLoginSecoundHandler(thePlayer)
	scoreboardRefresh(thePlayer)
	playingTimeAdd(thePlayer)
	updateClientData(thePlayer)
	refreshAchievements(thePlayer)
	donatorLogin(thePlayer)
end

addEventHandler("onPlayerLogin", getRootElement(),
function()
	local thePlayer = source
	scoreboardRefresh(thePlayer)
	playingTimeAdd(thePlayer)
	updateClientData(thePlayer)
	refreshAchievements(thePlayer)
	donatorLogin(thePlayer)
end)



----------------------------------------
-- Toplist
----------------------------------------


local amountOfTopsToDisplay = 20

 

function getTopList( player, value )
	if value then
		local tableOrder = {}
		if value ~= "playingTime" and value ~= "ach" then
			for i, v in ipairs (getAccounts()) do
				table.insert (tableOrder,
					{
						name = getAccountData ( v, "nick" ) or getAccountName ( v ),
						data = getAccountData ( v, value ) or 0
					}
				)
			end
		elseif value == "playingTime" then
			for i, v in ipairs (getAccounts()) do
				local dataH = getAccountData ( v, "totalPlayingTimeHours" ) or 0
				local dataM = getAccountData ( v, "totalPlayingTimeMinutes" ) or 0
				local dataHms = dataH * 3600000
				local dataMms = dataM * 60000
				local time = dataHms+dataMms
				table.insert (tableOrder,
					{
						name = getAccountData ( v, "nick" ) or getAccountName ( v ),
						data = time
					}
				)
			end
		elseif value == "ach" then
			for i, v in ipairs (getAccounts()) do
				local ach = 0
				for i=1,25 do
					if getAccountData(v,"ach"..i) == 1 then
						ach = ach + 1
					end
				end
				table.insert (tableOrder,
					{
						name = getAccountData ( v, "nick" ) or getAccountName ( v ),
						data = ach
					}
				)
			end
		end
		table.sort (tableOrder,
			function (a,b)
				return (tonumber(a.data) or 0) > (tonumber(b.data) or 0)
			end)
		callClientFunction(player,"updateRankingList",tableOrder,value)
	else
		outputDebugString("ERROR! [getTopList] Bad value ("..value..")!",1,255,0,0)
	end
end


achievements = {
	{false,false},
	{false,false},
	{"cash",1000000},
	{"cash",10000000},
	{"points",100000},
	{"points",1000000},
	{false,false},
	{"totalToptimes",1},
	{"totalToptimes",100},
	{"totalHunters",1},
	{"totalHunters",100},
	{false,false},
	{"mapsWon",1000},
	{false,false},
	{false,false},
	{false,false},
	{"totalSpins",100},
	{false,false},
	{"buyedMaps",100},
	{"totalPVP",100},
	{"totalPVPsWon",10},
	{false,false},
	{false,false},
	{false,false},
	{"totalPlayingTimeHours",50}
}

function unlockAchievement(thePlayer,number)
	if thePlayer then
		local account = getPlayerAccount(thePlayer)
		if isGuestAccount(account) then return end
		for i=1,#achievements do
			if achievements[i][1] and not number then
				local data = tonumber(getAccountData(account,achievements[i][1]))
				if data >= achievements[i][2] and tonumber(getAccountData(account,"ach"..i)) == 0 then
					setAccountData(account,"ach"..i,1)
					unlockAchievementHandler(thePlayer,i)
				end
			elseif number and number == i then
				if tonumber(getAccountData(account,"ach"..i)) == 0 then
					setAccountData(account,"ach"..i,1)
					unlockAchievementHandler(thePlayer,i)
				end
			end
		end
	end
end


function refreshAchievements(thePlayer)
	local account = getPlayerAccount(thePlayer)
	if isGuestAccount(account) then return end
	local ach = {}
	for i=1,#achievements do
		ach[i] = tonumber(getAccountData(account,"ach"..i))
	end
	callClientFunction(thePlayer,"updateAchievementState",ach)
end

function unlockAchievementHandler(thePlayer,number)
	refreshAchievements(thePlayer)
	callClientFunction(thePlayer,"unlockAchievement",number)
end

--------------------------------------------
-- Get alive and dead players by their STATE
--------------------------------------------

function getAliveRacePlayers()
    local alivePlayers = 0
	for index,player in ipairs(getElementsByType("player")) do
		if getElementData(player,"state") == "alive" then
			alivePlayers = alivePlayers + 1
		end
	end
    return alivePlayers
end


function getDeadRacePlayers()
	local deadPlayers = 0
	for index,player in ipairs(getElementsByType("player")) do
		if getElementData(player,"state") == "dead" then
			deadPlayers = deadPlayers + 1
		end
	end
	return deadPlayers
end




--------------
-- Race winner
--------------
LastWinners={}

addEvent("onPlayerDestructionDerbyWin",true)
addEventHandler("onPlayerDestructionDerbyWin",getRootElement(),
function (winner)
	local account = getPlayerAccount(winner)
	if not (isGuestAccount(account)) then
		if getPlayerCount() >= 3 then
			local WinStreak = 0
			local thePlayer = winner
			LastWinners[20] = LastWinners[19]
			LastWinners[19] = LastWinners[18]
			LastWinners[18] = LastWinners[17]
			LastWinners[17] = LastWinners[16]
			LastWinners[16] = LastWinners[15]
			LastWinners[15] = LastWinners[14]
			LastWinners[14] = LastWinners[13]
			LastWinners[13] = LastWinners[12]
			LastWinners[12] = LastWinners[11]
			LastWinners[11] = LastWinners[10]
			LastWinners[10] = LastWinners[9]
			LastWinners[9] = LastWinners[8]
			LastWinners[8] = LastWinners[7]
			LastWinners[7] = LastWinners[6]
			LastWinners[6] = LastWinners[5]
			LastWinners[5] = LastWinners[4]
			LastWinners[4] = LastWinners[3]
			LastWinners[3] = LastWinners[2]
			LastWinners[2] = LastWinners[1]
			LastWinners[1] = thePlayer
			if LastWinners[1] == thePlayer then
				WinStreak = 1
					if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer then
						WinStreak = 2
						if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer then
							WinStreak = 3
							if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer then
								WinStreak = 4
								if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer then
									WinStreak = 5
									if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer then
										WinStreak = 6
										if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer then
											WinStreak = 7
											if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer then
												WinStreak = 8
												if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer then
													WinStreak = 9
													if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer then
														WinStreak = 10
														if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer then
															WinStreak = 11
																if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer and LastWinners[12] == thePlayer then
																WinStreak = 12
																	if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer and LastWinners[12] == thePlayer and LastWinners[13] == thePlayer then
																	WinStreak = 13
																		if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer and LastWinners[12] == thePlayer and LastWinners[13] == thePlayer and LastWinners[14] == thePlayer then
																			WinStreak = 14
																			if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer and LastWinners[12] == thePlayer and LastWinners[13] == thePlayer and LastWinners[14] == thePlayer and LastWinners[15] == thePlayer then
																				WinStreak = 15
																				if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer and LastWinners[12] == thePlayer and LastWinners[13] == thePlayer and LastWinners[14] == thePlayer and LastWinners[15] == thePlayer and LastWinners[16] == thePlayer then
																					WinStreak = 16
																					if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer and LastWinners[12] == thePlayer and LastWinners[13] == thePlayer and LastWinners[14] == thePlayer and LastWinners[15] == thePlayer and LastWinners[16] == thePlayer and LastWinners[17] == thePlayer then
																						WinStreak = 17
																						if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer and LastWinners[12] == thePlayer and LastWinners[13] == thePlayer and LastWinners[14] == thePlayer and LastWinners[15] == thePlayer and LastWinners[16] == thePlayer and LastWinners[17] == thePlayer and LastWinners[18] == thePlayer then
																							WinStreak = 18
																							if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer and LastWinners[12] == thePlayer and LastWinners[13] == thePlayer and LastWinners[14] == thePlayer and LastWinners[15] == thePlayer and LastWinners[16] == thePlayer and LastWinners[17] == thePlayer and LastWinners[18] == thePlayer and LastWinners[19] == thePlayer then
																								WinStreak = 19
																								if LastWinners[1] == thePlayer and LastWinners[2] == thePlayer and LastWinners[3] == thePlayer and LastWinners[4] == thePlayer and LastWinners[5] == thePlayer and LastWinners[6] == thePlayer and LastWinners[7] == thePlayer and LastWinners[8] == thePlayer and LastWinners[9] == thePlayer and LastWinners[10] == thePlayer and LastWinners[11] == thePlayer and LastWinners[12] == thePlayer and LastWinners[13] == thePlayer and LastWinners[14] == thePlayer and LastWinners[15] == thePlayer and LastWinners[16] == thePlayer and LastWinners[17] == thePlayer and LastWinners[18] == thePlayer and LastWinners[19] == thePlayer and LastWinners[20] == thePlayer then
																									WinStreak = 20
																								end	
																							end
																						end
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
			local pAlive = getAliveRacePlayers()
			local pDead = getDeadRacePlayers()
			local WinS = tonumber(getAccountData(account,"highestWinstreak"))
			if WinS < WinStreak then
				setAccountData(account,"highestWinstreak",WinStreak)
			end
			local cashToWin = tonumber((moneyEarnPart*getPlayerCount())*WinStreak)
			local playerCash = tonumber(getAccountData(account,"cash"))
			if not (cashToWin < 0) then
				setAccountData(account,"cash",playerCash+cashToWin)
			end
			local points = math.floor(((pAlive + pDead)*pDead)*WinStreak)
			if not (points < 0) then
				local playerPoints = getAccountData(account,"points")
				setAccountData(account,"points",playerPoints+points)
			end
			addStat(account,"mapsWon",1)
			outputChatBox ("#0095FF* #FFFFFF" .. getPlayerName(winner) .." #FFFFFFhas won! He/She gets $#0095FF" .. tostring(cashToWin) .." #ffffffand #0095FF"..points.."#ffffff points || x"..WinStreak.."#0095FF!",getRootElement(),255,255,255,true)
triggerClientEvent("Streaktext", root, WinStreak)
--setTimer ( function(WinStreak)end, 100, 1 )
			scoreboardRefresh(winner)
			unlockAchievement(winner)
			unlockAchievement(winner,12)
		else
			outputChatBox("#0095FF* #FFFFFFNot enough players to earn money - #00ff003 #FFFFFFrequired.",winner,255,255,255,true)
		end
		callClientFunction(winner,"deathReset")
		local thePlayer = winner
		scoreboardRefresh(thePlayer)
	end
end)





-------------------
-- Other race ranks
-------------------

function earnMoney()
	local thePlayer = source
	local position = (getAliveRacePlayers() + 1)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
		if getPlayerCount() >= 3 then
			local pAlive = getAliveRacePlayers()
			local pDead = getDeadRacePlayers()
			local finalCash = 0
			if not (position == 1) then
				if pAlive == 0 then pAlive = 1 end
					if not respawnFix[thePlayer] then
					local finalCash = math.floor(((40/position)*pDead)*pAlive)		-- Calculate the final money value.
					local points = math.floor((pAlive + pDead)*pDead)
					local playerCash = getAccountData(account,"cash")
					local playerPoints = getAccountData(account,"points")
					setAccountData(account,"points",playerPoints+points)
					setAccountData(account,"cash",playerCash+finalCash)
					local playerCash = getAccountData(account,"cash")
					local playerPoints = getAccountData(account,"points")
					addStat(account,"totalDeaths",1)
					outputChatBox("#0095FF* #FFFFFFYou have recieved $#0095FF" .. finalCash .. " #ffffff and #0095FF"..points.."#ffffff points for#0095FF "..position.." #ffffffplace!",thePlayer,255,255,255,true)
					respawnFix[thePlayer] = true
					unlockAchievement(thePlayer)
				end
			end
		else
			outputChatBox("#0095FF* #FFFFFFNot enough players to earn money - #ABCDEF3 #FFFFFFrequired.",thePlayer,255,255,255,true)
			return
		end
		scoreboardRefresh(thePlayer)
	end
end
addEventHandler ("onPlayerWasted",getRootElement(),earnMoney)





-----------------
-- Hunter handler
-----------------
function hunterBonus(thePlayer)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
		local cashToWin = 500
		local points = 5
		outputChatBox("#0095FF* #FFFFFFYou recieved #0095FF"..cashToWin.." #FFFFFFand #0095FF"..points.." #FFFFFFpoints for getting hunter! ",thePlayer,255,255,255,true)
		local playerCash = getAccountData(account,"cash")
		local playerPoints = getAccountData(account,"points")
		setAccountData(account,"cash",playerCash+cashToWin)
		setAccountData(account,"points",playerPoints+points)
		scoreboardRefresh(thePlayer)
		addStat(account,"totalHunters",1)
		unlockAchievement(thePlayer)
	end
end

function checkForHunter(number,sort,model)
	if sort == "vehiclechange" then
		if model == 425 then
			if not hunterFix[source] then
				setTimer(hunterBonus,200,1,source)
				hunterFix[source] = true
			end
		end
	end
end
addEvent('onPlayerPickUpRacePickup')
addEventHandler("onPlayerPickUpRacePickup",getRootElement(),checkForHunter)




function toptimeadd(player,newPos,newTime)
	local account = getPlayerAccount(player)
	if not (isGuestAccount(account)) then
		local cashToWin = math.floor(500/newPos)
		local points = math.floor(10/newPos)
		if newPos <= 10 then
			local playerCash = getAccountData(account,"cash")
			setAccountData(account,"cash",playerCash+cashToWin)
			addStat(account, "points",points)
			local thePlayer = player
			if newPos == 1 then
				unlockAchievement(thePlayer,7)
			end
			outputChatBox("#0095FF* #FFFFFFYou recieved $#0095FF"..cashToWin.."#ffffff and #0095FF"..points.."#ffffff points for set a toptime.",thePlayer,255,255,255,true)
			addStat(account,"totalToptimes",1)
			scoreboardRefresh(thePlayer)
			unlockAchievement(thePlayer)
		end
	end
end
addEvent("onPlayerToptimeImprovement",true)
addEventHandler("onPlayerToptimeImprovement",getRootElement(),toptimeadd)


-----------------
-- Reaction tests
-----------------


function newReactionTest()
	reactionString = string.random(reactionLength)
	reactionMoney = math.random(reactionMin,reactionMax)
	outputChatBox("#0095FF* #FFFFFFSay #ABCDEF"..reactionString.."#FFFFFF to win #ABCDEF$"..reactionMoney.."#FFFFFF!",getRootElement(),255,255,255,true)

	addEventHandler("onPlayerChat",getRootElement(),checkForOpenConsole)

	reactionTimer = setTimer(
	function()
		removeEventHandler("onPlayerChat",getRootElement(),checkForOpenConsole)
	end,reactionDuration*1000,1)

	if isTimer(newReactionTimer) then
		killTimer(newReactionTimer)
	end

	newReactionTimer = setTimer(newReactionTest,math.random(reactionMinRedo*1000,reactionMaxRedo*1000),1)

end
addCommandHandler("testr",newReactionTest)

function checkForOpenConsole(message,type)
	callClientFunction(source,"checkForOpenConsole",message,type)
end


function checkReactionTest(thePlayer,message,type,isOpen)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
	if (isOpen == true) then
		outputChatBox("#0095FF* #FFFFFF"..getPlayerName(thePlayer).."#FFFFFF attempted to cheat at the reaction test!",getRootElement(),255,255,255,true)
		outputChatBox("#0095FF* #FFFFFFMoney decreased by #ABCDEF$1,000#FFFFFF! Do not cheat!",getRootElement(),255,255,255,true)

		local playerCash = getAccountData(account,"cash")
		setAccountData(account,"cash",playerCash-1000)
		scoreboardRefresh(thePlayer)
		return
	end

	message = tostring(message)
	if message == "..." then
		return
	end

	if (message == reactionString) then
		local timeLeft,leftExec,totalExec = getTimerDetails(reactionTimer)

		killTimer(reactionTimer)
		removeEventHandler("onPlayerChat",getRootElement(),checkForOpenConsole)

		setTimer(outputChatBox,200,1,"#0095FF* #FFFFFF"..getPlayerName(thePlayer).." #FFFFFFhas won the reaction test in #ABCDEF"..math.round((reactionDuration*1000 - timeLeft)/1000,2,floor) .." #FFFFFFseconds and wins #ABCDEF$"..reactionMoney,getRootElement(),255,255,255,true)

		local playerCash = getAccountData(account,"cash")
		local totalReactionTests = tonumber(getAccountData(account,"totalReactionTests"))
		local bestReactionTime = tonumber(getAccountData(account,"bestReactionTime"))

		setAccountData(account,"cash",playerCash+reactionMoney)
		addStat(account,"totalReactionTests",1)
		if (math.round((reactionDuration*1000 - timeLeft)/1000)) < bestReactionTime or (bestReactionTime == 0) then
			addStat(account,"bestReactionTime",math.round((reactionDuration*1000 - timeLeft)/1000,2,floor))
		end
		
		scoreboardRefresh(thePlayer)

		-- Check for achievement here
		if math.round((reactionDuration*1000 - timeLeft)/1000,2,floor) <= 5 then
		end

		reactionString = ""
		reactionMoney = 0
		unlockAchievement(thePlayer,24)
	end
	end
end


function string.random(len)
	local str = ""
	for i=1,len do
		local getChar = math.random(1,35)
		if getChar <= 25 then
			local caps = math.random(1,2)
			if caps == 1 then
				str = str..string.upper(chars[getChar])
			else
				str = str..string.lower(chars[getChar])
			end
		else
			str = str..chars[getChar]
		end
	end
	return str
end





-----------------
-- Betting system
-----------------

function createNewBet(thePlayer,toPlayer,newAmount,oldAmount,betState)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
	if getPlayerCount() >= minPlayers then
		if bettingEnabled == true then
			if (betState == 0) then
				if (toPlayer) then
					if (newAmount) then
						local newAmount = tonumber(math.ceil(tonumber(newAmount)))
						if (newAmount >= 1) then
							local playerCash = tonumber(getAccountData(account,"cash"))
							local maxBet = 10000
							if (findPlayerByName(toPlayer)) then
								local toPlayerName = findPlayerByName(toPlayer)
								if (newAmount <= playerCash) then
									if newAmount <= maxBet then
										callClientFunction(thePlayer,"addNewBet",toPlayerName,newAmount)
										setAccountData(account,"cash",playerCash-newAmount)
										scoreboardRefresh(thePlayer)
										totalBetsAdd(thePlayer)
										unlockAchievement(thePlayer,14)
										--outputChatBox("#0095FF* #FFFFFFYou have placed your bet on "..getPlayerName(toPlayerName).."#FFFFFF for #ABCDEF$"..newAmount.."#FFFFFF!",thePlayer,255,255,255,true)
										outputChatBox("#0095FF* #FFFFFF"..getPlayerName(thePlayer).."#FFFFFF has placed a bet on "..getPlayerName(toPlayerName).."#FFFFFF for #ABCDEF$"..newAmount.."#FFFFFF!",getRootElement(),255,255,255,true)
									elseif newAmount > maxBet then
										outputChatBox("#0095FF* #FFFFFFYou are allowed to bet a maximum of #ABCDEF$"..maxBet.."#FFFFFF!",thePlayer,255,255,255,true)
										
										return false
									end
								else
									outputChatBox("#0095FF* #FFFFFFERROR! You don't have enough money!",thePlayer,255,255,255,true)
								end
							else
								outputChatBox("#0095FF* #FFFFFFERROR! The player you specified has not been found! (#FFFF00"..toPlayer.."#FFFFFF)",thePlayer,255,255,255,true)
								return false
							end
						else
							outputChatBox("#0095FF* #FFFFFFERROR! Invalid amount! [#ABCDEF$"..newAmount.."#FFFFFF]",thePlayer,255,255,255,true)
						end
					else
						outputChatBox("#0095FF* #FFFFFFERROR! Please specify an amount to bet! Correct syntax: #ABCDEF/bet [player] [amount]",thePlayer,255,255,255,true)
						return false
					end
				else
					outputChatBox("#0095FF* #FFFFFFERROR! Please specify a player! Correct syntax: #ABCDEF/bet [player] [amount]",thePlayer,255,255,255,true)
					return false
				end
			else
				outputChatBox("#0095FF* #FFFFFFYou have already placed your bet on "..betState.." #FFFFFFfor #ABCDEF$"..oldAmount.."#FFFFFF!",thePlayer,255,255,255,true)
				return false
			end
		else
			outputChatBox("#0095FF* #FFFFFFBetting time is over! You can place your bet on the next map.",thePlayer,255,255,255,true)
		end
	else
		outputChatBox("#0095FF* #FFFFFFBetting #FF0000disabled.#FFFFFF Minimum required players on server: #ABCDEF" ..minPlayers.."#FF0000 | #FFFFFFConnected: #ABCDEF"..getPlayerCount(),thePlayer,255,255,255,true)
	end
	else
		outputChatBox("#0095FF* #FFFFFFYou have to be logged to bet!",thePlayer,255,255,255,true)
	end
end


function onPlayerBetWin(self,betAmount)
	local thePlayer = self
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
		outputChatBox("#0095FF* #FFFFFF"..getPlayerName(self).."#FFFFFF has won his bet and has recieved #ABCDEF$".. betAmount*2 .."#FFFFFF!",getRootElement(),255,255,255,true)
		local playerCash = getAccountData(account,"cash")
		setAccountData(account,"cash",playerCash+betAmount+betAmount*2)
		totalBetsWonAdd(thePlayer)
		unlockAchievement(thePlayer,15)
		scoreboardRefresh(thePlayer)
	end
end



function bettingTimer()
	if isTimer(chatTimer) then killTimer(chatTimer) end
	if isTimer(disableTimer) then killTimer(disableTimer) end
	if getPlayerCount() >= minPlayers then
		chatTimer = setTimer(outputChatBox,3500,1,"#0095FF* #FFFFFFPlace your bets!	#FFFFFF[#ABCDEF/bet#FFFFFF]",getRootElement(),255,255,255,true)
		bettingEnabled = true
		disableTimer = setTimer(disableBetting,betTimeLimit*1000+2000,1)
	end
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting",getRootElement(),bettingTimer)


function disableBetting()
	outputChatBox("#0095FF* #FFFFFFBetting time is over#0095FF!",getRootElement(),255,255,255,true)
	bettingEnabled = false
end


function checkWin(winner)
	callClientFunction(getRootElement(),"compareResult",winner)
end
addEvent("onPlayerDestructionDerbyWin",true)
addEventHandler("onPlayerDestructionDerbyWin",getRootElement(),checkWin)



function retrieveData(thePlayer,commandName,toPlayer,newAmount)
	callClientFunction(thePlayer,"triggerBettingSystem",thePlayer,toPlayer,newAmount)
end
addCommandHandler("bahis",retrieveData)


--------------------
-- Spin command
--------------------

spins = {}


function spin(thePlayer,commandName,value)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
		if value then
			local value = tonumber(value)
			if (value >= 1) and (value<50001) then
				local playerCash = tonumber(getAccountData(account,"cash"))
				if playerCash >= value then
					if spins[thePlayer] then
						outputChatBox("#0095FF* #ffffff30 Saniye Bekle.",thePlayer,255,255,255,true)
					else
						spins[thePlayer] = true
						setTimer(resetSpin,30000,1,thePlayer)
						local luck = math.random(1,2)
						addStat(account,"totalSpins",1)
						if luck == 1 then
							setAccountData(account,"cash",playerCash+value)
							outputChatBox("#0095FF* #ffffff"..getPlayerName(thePlayer).." #ffffffzari kazandin $#11dd11"..value.."#ffffff!",getRootElement(),255,255,255,true)
							local playerCash = tonumber(getAccountData(account,"cash"))
							unlockAchievement(thePlayer,16)
							scoreboardRefresh(thePlayer)
						else
							setAccountData(account,"cash",playerCash-value)
							scoreboardRefresh(thePlayer)
							outputChatBox("#0095FF* #ffffff"..getPlayerName(thePlayer).." #ffffffzari kaybettin $#ff0000"..value.."#ffffff!",getRootElement(),255,255,255,true)
						end
						unlockAchievement(thePlayer)
					end
				else
					outputChatBox("#0095FF* #ffffffParan yok.",thePlayer,255,255,255,true)
				end
			else
				outputChatBox("#0095FF* #ffffffZar icin mevcut deerler $50000 ve 1$.",thePlayer,255,255,255,true)
			end
		else
			outputChatBox("#0095FF* #ffffffYou need to set value (For example /flip 1000).",thePlayer,255,255,255,true)
		end
	end
end
addCommandHandler("zar",spin)

function resetSpin(thePlayer)
	spins[thePlayer] = nil
end


----------------------------
-- PVP Script by Enisizm!
----------------------------

PVP = {}
PVPrequest = {}
requestTimer = {}


function askForPVP(thePlayer,command,targetPlayer,maps,cash)
	if targetPlayer and maps and cash then
		if not requestTimer[thePlayer] then
		local targetPlayer = findPlayerByName(targetPlayer)
		if targetPlayer ~= thePlayer then
			if not (isGuestAccount(getPlayerAccount(thePlayer))) and not (isGuestAccount(getPlayerAccount(targetPlayer))) then
				if not PVP[thePlayer] and not PVP[targetPlayer] then
					if tonumber(maps) > 1 then
						local playerCash = tonumber(getAccountData(getPlayerAccount(thePlayer),"cash"))
						local targetCash = tonumber(getAccountData(getPlayerAccount(targetPlayer),"cash"))
						if tonumber(cash) >= 1000 then
							if not PVPrequest[targetPlayer] then
								if playerCash > tonumber(cash) and targetCash > tonumber(cash) then
									local PVPData = {}
									PVPData[1] = thePlayer
									PVPData[2] = tonumber(maps)
									PVPData[3] = tonumber(cash)
									PVPrequest[targetPlayer] = PVPData
									outputChatBox("#0095FF* #ffffff"..getPlayerName(thePlayer).." #ffffffchallenge "..getPlayerName(targetPlayer).."#ffffff to a PVP! ",getRootElement(),255,255,255,true)
									outputChatBox("#0095FF* #ffffff"..getPlayerName(thePlayer).." #ffffffchallenge you to a PVP! [Maps: #00ff00"..maps.."#ffffff Cash: #00ff00$"..cash.."#ffffff]",targetPlayer,255,255,255,true)
									outputChatBox("#0095FF* #ffffffType #11dd11[/acceptpvp true]#ffffff to accept or #00ff00[/acceptpvp false] #ffffffto decline!",targetPlayer,255,255,255,true)
									requestTimer[thePlayer] = true
									setTimer(resetPVPTimer,120000,1,targetPlayer,thePlayer)
								else
									outputChatBox("#0095FF* #ffffffYou or opponent dont have enought cash!",thePlayer,255,255,255,true)
								end
							else
								outputChatBox("#0095FF* #ffffffOpponent have other PVP request now!",thePlayer,255,255,255,true)
							end
						else
							outputChatBox("#0095FF* #ffffffMinimal PVP value is $1000!",thePlayer,255,255,255,true)
						end
					else
						outputChatBox("#0095FF* #ffffffMaps must be more than one!",thePlayer,255,255,255,true)
					end
				else
					outputChatBox("#0095FF* #ffffffYou or opponent play now PVP!",thePlayer,255,255,255,true)
				end
			else
				outputChatBox("#0095FF* #ffffffYou or your opponent you are not logged in!",thePlayer,255,255,255,true)
			end
		else
			ouputChatBox("#0095FF* #ffffffYou cant play PVP with youself!",thePlayer,255,255,255,true)
		end
		else
			outputChatBox("#0095FF* #ffffffYou have other request now!",thePlayer,255,255,255,true)
		end
	else
		outputChatBox("#0095FF* #ffffffBad syntax! [/pvp target maps cash]",thePlayer,255,255,255,true)
	end
end
addCommandHandler("pvp",askForPVP)



function resetPVPTimer(thePlayer,targetPlayer)
	if PVPrequest[thePlayer] then
		requestTimer[targetPlayer] = nil
		PVPrequest[thePlayer] = nil
		outputChatBox("#0095FF* #ffffff"..getPlayerName(thePlayer).."#ffffff didn't accept your PVP request!",targetPlayer,255,0,0,true)
	end
end

function confirmPVP(thePlayer,command,string)
	if PVPrequest[thePlayer] then
		if string == "true" then
			local targetPlayer = PVPrequest[thePlayer][1]
			if targetPlayer then
				startPVP(thePlayer,targetPlayer)
			end
		else
			local targetPlayer = PVPrequest[thePlayer][1]
			outputChatBox("#0095FF* #ffffff"..getPlayerName(thePlayer).."#ffffff decline you'r PVP request!",targetPlayer,255,255,255,true)
			outputChatBox("#0095FF* #ffffffYou decline PVP request.",thePlayer,255,255,255,true)
			requestTimer[targetPlayer] = nil
			PVPrequest[thePlayer] = nil
		end
	end
end
addCommandHandler("acceptpvp",confirmPVP)

function startPVP(thePlayer,targetPlayer)
	if thePlayer and targetPlayer then
		if not PVP[thePlayer] and not PVP[targetPlayer] then
			if not (isGuestAccount(getPlayerAccount(thePlayer))) and not (isGuestAccount(getPlayerAccount(targetPlayer))) then
				local PVPDataOne = {}
				local PVPDataTwo = {}
				PVPDataOne[1] = thePlayer
				PVPDataOne[2] = PVPrequest[thePlayer][2]
				PVPDataOne[3] = PVPrequest[thePlayer][3]
				PVPDataOne[4] = tonumber(0)
				PVPDataOne[5] = true
				PVPDataTwo[1] = targetPlayer
				PVPDataTwo[2] = PVPrequest[thePlayer][2]
				PVPDataTwo[3] = PVPrequest[thePlayer][3]
				PVPDataTwo[4] = tonumber(0)
				PVPDataTwo[5] = true
				PVP[thePlayer] = PVPDataTwo
				PVP[targetPlayer] = PVPDataOne
				PVPrequest[thePlayer] = nil
				requestTimer[targetPlayer] = nil
				outputChatBox("#0095FF* #ffffff"..getPlayerName(thePlayer).."#ffffff start PVP vs "..getPlayerName(targetPlayer).."#ffffff for #00ff00$"..PVP[thePlayer][3].."#ffffff!",getRootElement(),255,255,255,true)
				local accountX = getPlayerAccount(thePlayer)
				local accountY = getPlayerAccount(targetPlayer)
				addStat(accountX,"totalPVP",1)
				addStat(accountY,"totalPVP",1)
				local playerCash = tonumber(getAccountData(getPlayerAccount(thePlayer),"cash"))
				local targetCash = tonumber(getAccountData(getPlayerAccount(targetPlayer),"cash"))
				setAccountData(getPlayerAccount(thePlayer),"cash",playerCash - tonumber(PVPDataTwo[3]))
				setAccountData(getPlayerAccount(targetPlayer),"cash",targetCash - tonumber(PVPDataTwo[3]))
			else
				outputChatBox("#0095FF* #ffffffYou can't play PVP becouse you or you'r oppenent aren't logged in!",thePlayer,255,255,255,true)
				outputChatBox("#0095FF* #ffffffYou can't play PVP becouse you or you'r oppenent aren't logged in!",targetPlayer,255,255,255,true)
				PVPrequest[thePlayer] = nil
			end
		end
	end
end


function checkPVP()
	thePlayer = source
	if not respawnFix[thePlayer] then
	if PVP[thePlayer] then
		if PVP[thePlayer][5] == false then
			local opponent = getOpponent(thePlayer)
			PVP[opponent][4] = PVP[opponent][4]+1
			PVP[opponent][2] = PVP[opponent][2]-1
			PVP[thePlayer][2] = PVP[thePlayer][2]-1
			if PVP[thePlayer][2] == 0 and PVP[opponent][4] ~= PVP[thePlayer][4] then
				return endPVP(thePlayer,opponent)
			elseif PVP[thePlayer][2] == 0 and PVP[opponent][4] == PVP[thePlayer][4] then
				PVP[thePlayer][2] = 1
				PVP[opponent][2] = 1
			end
			PVP[thePlayer][5] = true
			PVP[opponent][5] = true
			outputChatBox("#0095FF* #ffffffYou won a PVP round! [ "..getPlayerName(PVP[thePlayer][1]).." #00ff00"..PVP[opponent][4].." #ffffff: #00ff00"..PVP[thePlayer][4].." #ffffff"..getPlayerName(PVP[opponent][1]).."#ffffff ]",PVP[thePlayer][1],255,255,255,true)
			outputChatBox("#0095FF* #ffffffYou lost a PVP round! [ "..getPlayerName(PVP[thePlayer][1]).." #00ff00"..PVP[opponent][4].." #ffffff: #00ff00"..PVP[thePlayer][4].." #ffffff"..getPlayerName(PVP[opponent][1]).."#ffffff ]",thePlayer,255,255,255,true)
		end
	end
	end
end
addEventHandler("onPlayerWasted",getRootElement(),checkPVP)

function getOpponent(thePlayerData)
	return PVP[thePlayerData][1]
end

function allowPVP()
	for _,player in ipairs(getElementsByType("player")) do
		if PVP[player] then
			PVP[player][5] = false
		end
	end
end


function endPVP(thePlayer,targetPlayer)
	if PVP[thePlayer] and PVP[targetPlayer] then
		if PVP[thePlayer][4] > PVP[targetPlayer][4] then
			local playerCash = getAccountData(getPlayerAccount(thePlayer),"cash")
			setAccountData(getPlayerAccount(thePlayer),"cash",playerCash+(PVP[thePlayer][3]*2))
			addStat(getPlayerAccount(thePlayer),"totalPVPsWon",1)
			outputChatBox("*#ffffff You lost a PVP match vs "..getPlayerName(thePlayer)..".#ffffff Final result: #00ff00"..PVP[targetPlayer][4].." #ffffff: #00ff00"..PVP[thePlayer][4].."#ffffff!",targetPlayer,255,0,0,true)
			outputChatBox("*#ffffff You won a PVP match vs "..getPlayerName(targetPlayer)..".#ffffff Final result: #00ff00"..PVP[targetPlayer][4].." #ffffff: #00ff00"..PVP[thePlayer][4].."#ffffff!",thePlayer,255,0,0,true)
			outputChatBox("*#ffffff "..getPlayerName(thePlayer).."#ffffff won PVP vs "..getPlayerName(targetPlayer).."#ffffff and won #00ff00$"..(PVP[targetPlayer][3]*2).."#ffffff!",getRootElement(),255,0,0,true)
			unlockAchievement(thePlayer)
			unlockAchievement(targetPlayer)
			scoreboardRefresh(thePlayer)
			scoreboardRefresh(targetPlayer)
		else
			local playerCash = getAccountData(getPlayerAccount(targetPlayer),"cash")
			setAccountData(getPlayerAccount(targetPlayer),"cash",playerCash+(PVP[targetPlayer][3]*2))
			outputChatBox("*#ffffff You won a PVP vs "..getPlayerName(thePlayer)..".#ffffff Final result: #00ff00"..PVP[targetPlayer][4].." #ffffff: #00ff00"..PVP[thePlayer][4].."#ffffff!",targetPlayer,255,0,0,true)
			outputChatBox("*#ffffff You lose a PVP vs "..getPlayerName(targetPlayer)..".#ffffff Final result: #00ff00"..PVP[targetPlayer][4].." #ffffff: #00ff00"..PVP[thePlayer][4].."#ffffff!",thePlayer,255,0,0,true)
			outputChatBox("*#ffffff "..getPlayerName(targetPlayer).."#ffffff won PVP vs "..getPlayerName(thePlayer).."#ffffff and won #00ff00$"..(PVP[targetPlayer][3]*2).."#ffffff!",getRootElement(),255,0,0,true)
			scoreboardRefresh(thePlayer)
			scoreboardRefresh(targetPlayer)
			unlockAchievement(thePlayer)
			unlockAchievement(targetPlayer)
		end
		PVP[thePlayer] = nil
		PVP[targetPlayer] = nil
	end
end

function playerPVPQuit()
	if PVP[source] then
		local targetPlayer = PVP[source][1]
		if targetPlayer then
			local playerCash = getAccountData(getPlayerAccount(targetPlayer),"cash")
			setAccountData(getPlayerAccount(targetPlayer),"cash",playerCash+(PVP[source][3]*2))
			outputChatBox("*#ffffff You won a PVP vs "..getPlayerName(source)..".#ffffff, becouse you'r opponent left!",targetPlayer,255,0,0,true)
			outputChatBox("*#ffffff "..getPlayerName(targetPlayer).."#ffffff won PVP vs "..getPlayerName(source).."#ffffff and won #00ff00$"..(PVP[source][3]*2).."#ffffff!",getRootElement(),255,0,0,true)
			PVP[targetPlayer] = nil
			PVP[source] = nil
			scoreboardRefresh(thePlayer)
			scoreboardRefresh(targetPlayer)
		end
	end
end
addEventHandler("onPlayerQuit",getRootElement(),playerPVPQuit)
addEventHandler("onPlayerLogout",getRootElement(),playerPVPQuit)



-------------
-- Give money
-------------

function giveMoney(thePlayer,command,targetPlayer,amount)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
	if not (targetPlayer == "") then
		if tonumber(amount) then
			local playerCash = tonumber(getAccountData(account,"cash"))
			if tonumber(amount) > 0 then
				if tonumber(amount) <= playerCash then
					if (findPlayerByName(targetPlayer)) then
						local target = findPlayerByName(targetPlayer)
						local targeta = getPlayerAccount(target)
						if target ~= thePlayer then
							local amount = math.ceil(amount)
							local playerCash = getAccountData(account,"cash")
							local targetCash = getAccountData(targeta,"cash")
							setAccountData(account,"cash",playerCash-tonumber(amount))
							setAccountData(targeta,"cash",targetCash+tonumber(amount))
							local playerCash = getAccountData(account,"cash")
							local targetCash = getAccountData(targeta,"cash")
							scoreboardRefresh(thePlayer)
							scoreboardRefresh(target)
							unlockAchievement(thePlayer)
							outputChatBox("#0095FF* #FFFFFFYou have sent #ABCDEF$"..amount.."#FFFFFF to "..getPlayerName(target).."#FFFFFF!",thePlayer,255,255,255,true)
							outputChatBox("#0095FF* #FFFFFF"..getPlayerName(thePlayer).." #FFFFFFhas sent you #ABCDEF$"..amount.."#FFFFFF!",target,255,255,255,true)
						else
							outputChatBox("#0095FF* #FFFFFFERROR! You cannot send money to yourself!",thePlayer,255,255,255,true)
							return false
						end
					else
						outputChatBox("#0095FF* #FFFFFFERROR! The player you specified does not exist! (#FFFF00"..targetPlayer.."#FFFFFF)",thePlayer,255,255,255,true)
						return false
					end
				else
					outputChatBox("#0095FF* #FFFFFFERROR! You don't have enough money!",thePlayer,255,255,255,true)
					return false
				end
			else
				outputChatBox("#0095FF* #FFFFFFERROR! Invalid amount! [#ABCDEF"..amount.."#FFFFFF]",thePlayer,255,255,255,true)
				return false
			end
		else
			outputChatBox("#0095FF* #FFFFFFERROR! Please specify the amount to send!",thePlayer,255,255,255,true)
			return false
		end
	else
		outputChatBox("#0095FF* #FFFFFFERROR! Please select a player!",thePlayer,255,255,255,true)
		return false
	end
	end
end
addCommandHandler("parayolla",giveMoney)







-------------
-- PM system
-------------

function privateMessage(player, command, toplayername, ...)
local words = { ... }
local message = table.concat(words," ")
	if toplayername then
		if (findPlayerByName (toplayername)) then
		toplayer = (findPlayerByName (toplayername))
			if not (toplayer == player) then
				if message then
					outputChatBox("#0095FF[PM]#00aaff Message to #FFFFFF" .. getPlayerName(toplayer) .. "#FFFFFF: " .. message, player, 255, 255, 255, true)
					outputChatBox("#0095FF[PM]#00aaff Message from #FFFFFF" .. getPlayerName(player) .. "#FFFFFF: " .. message, toplayer, 255, 255, 255, true)
				else
					outputChatBox("#0095FF[PM]#00aaff Invalid syntax! Usage:#FFFFFF /pm [partical player name] [message]", player, 255, 255, 255, true)
					return false
				end
			else
				outputChatBox("#0095FF[PM]#00aaff You cannot PM yourself#FFFFFF!", player, 255, 255, 255, true)
				return false
			end
		else
			outputChatBox("#0095FF[PM]#00aaff Player not found! #FFFFFF("..toplayername..").", player, 255, 255, 255, true)
			return false
		end
	else
		outputChatBox("#0095FF[PM]#00aaff Invalid syntax! Usage:#FFFFFF /pm [partical player name] [message]", player, 255, 255, 255, true)
		return false
	end
end
addCommandHandler("pm", privateMessage)






--------------------------------------
-- Find player by a part of their name
--------------------------------------

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

----------------------
-- Automated Ghostmode
----------------------

addEventHandler("onMapStarting", getRootElement(),
function(mapInfo, mapOptions, gameOptions)
	if (ismapDM(mapInfo.name) == 1) then
		for theKey,thePlayer in ipairs(getElementsByType("player")) do
			setElementData( thePlayer, "overrideCollide.uniqueblah", 0, false )
		end
		mapType = "DM"
	elseif (ismapDM(mapInfo.name) == 2) then
		for theKey,thePlayer in ipairs(getElementsByType("player")) do
			setElementData(thePlayer, "overrideCollide.uniqueblah", nil, false )
		end
		mapType = "DD"
	elseif (ismapDM(mapInfo.name) == 3) then
		for theKey,thePlayer in ipairs(getElementsByType("player")) do
			setElementData(thePlayer, "overrideCollide.uniqueblah", nil, false )
		end
		mapType = "FUN"
	elseif (ismapDM(mapInfo.name)) == 4 then
		mapType = "?"
	end
end)

function ismapDM(isim)
if string.find(isim, "[DM]", 1, true) then
	return 1
elseif string.find(isim, "[DD]", 1,true) then
	return 2
elseif string.find(isim, "[FUN]", 1,true) then
	return 3
else
	return 4
end
end





------------------------------------------------
-- Set headlights on map start and on veh-change
------------------------------------------------

function setPlayerHeadlightColor(number, sort, model)
	if sort == "vehiclechange" then
		local car = getPedOccupiedVehicle(source)
		if car then
			if not getElementData(source,"shopFeatures") then return end
			if getElementData(source,"shopFeatures")[4][2] then
				setVehicleHeadLightColor(car,unpack(getElementData(source,"shopFeatures")[3]))
			end
			if getElementData(source,"shopFeatures")[4][1] then
				local firstColors = getElementData(source,"shopFeatures")[1]
				local secoundColors = getElementData(source,"shopFeatures")[2]
				setVehicleColor(car,firstColors[1],firstColors[2],firstColors[3],secoundColors[1],secoundColors[2],secoundColors[3])
			end
		end
	end
end

function setPlayerHeadlightColor2()
	local car = getPedOccupiedVehicle(source)
	if car then
		if getElementData(source,"shopFeatures")[4][2] then
			setVehicleHeadLightColor(car,unpack(getElementData(source,"shopFeatures")[3]))
		end
		if getElementData(source,"shopFeatures")[4][1] then
			local firstColors = getElementData(source,"shopFeatures")[1]
			local secoundColors = getElementData(source,"shopFeatures")[2]
			setVehicleColor(car,firstColors[1],firstColors[2],firstColors[3],secoundColors[1],secoundColors[2],secoundColors[3])
		end
	end
end
addEvent("onNotifyPlayerReady", true)
addEventHandler("onNotifyPlayerReady", getRootElement(), setPlayerHeadlightColor2)
addEventHandler("onPlayerPickUpRacePickup",getRootElement(),setPlayerHeadlightColor)

local shop = {
	colorPrice = 5000,
	headlightsPrice = 10000,
	policeHeadlightsPrice = 200000,
	rainbowColorPrice = 400000,
}

function buyColorsInShop(thePlayer,id,red,green,blue)
	if thePlayer and id then
		local account = getPlayerAccount(thePlayer)
		if (isGuestAccount(account)) then return end
		local playerCash = tonumber(getAccountData(account,"cash"))
		if id == "#1" then
			if playerCash >= shop.colorPrice then
				setAccountData(account,"everSetCustomVehicleColor",1)
				setAccountData(account,"cash",playerCash-shop.colorPrice)
				setAccountData(account,"c1R",red)
				setAccountData(account,"c1G",green)
				setAccountData(account,"c1B",blue)
				scoreboardRefresh(thePlayer)
				showServerMsg(thePlayer,"New car color!","You successfully bought a new car color!")
				updateClientData(thePlayer)
				unlockAchievement(thePlayer,22)
local uVehicle = getPedOccupiedVehicle( thePlayer )
setVehicleColor( uVehicle, getAccountData(account,"c1R",red), getAccountData(account,"c1G",red), getAccountData(account,"c1B",red) )
			else
				showServerMsg(thePlayer,"ERROR!","You don't have enough cash!")
			end
		elseif id == "#2" then
			if playerCash >= shop.colorPrice then
				setAccountData(account,"everSetCustomVehicleColor",1)
				setAccountData(account,"cash",playerCash-shop.colorPrice)
				setAccountData(account,"c2R",red)
				setAccountData(account,"c2G",green)
				setAccountData(account,"c2B",blue)
				scoreboardRefresh(thePlayer)
				showServerMsg(thePlayer,"New car color!","You successfully bought a new car color!")
				updateClientData(thePlayer)
				unlockAchievement(thePlayer,22)
			else
				showServerMsg(thePlayer,"ERROR!","You don't have enough cash!")
			end
		elseif id == "H" then
			if playerCash >= shop.headlightsPrice then
				setAccountData(account,"cash",playerCash-shop.headlightsPrice)
				scoreboardRefresh(thePlayer)
				setAccountData(account,"hlcRed",red)
				setAccountData(account,"hlcGreen",green)
				setAccountData(account,"hlcBlue",blue)
				setAccountData(account,"everSetHeadlightsColor",1)
				showServerMsg(thePlayer,"New headlights color!","You successfully bought a new headlights color!")
				updateClientData(thePlayer)
			else
				showServerMsg(thePlayer,"ERROR!","You don't have enough cash!")
			end
		end
	end
end


function buySpecialTuning(thePlayer,id)
	if thePlayer and id then
		local account = getPlayerAccount(thePlayer)
		if isGuestAccount(account) then return end
		local playerCash = tonumber(getAccountData(account,"cash"))
		if id == 1 then
			if tonumber(getAccountData(account,"headlightBought")) == 0 then
				if playerCash>=shop.policeHeadlightsPrice then
					setAccountData(account,"headlightBought",1)
					setAccountData(account,"cash",playerCash-shop.policeHeadlightsPrice)
					scoreboardRefresh(thePlayer)
					showServerMsg(thePlayer,"Police headlights bought!","You successfully bought this feature!\nToggle on/off in settings window.")
					updateClientData(thePlayer)
				else
					showServerMsg(thePlayer,"ERROR!","You dont have enough cash!")
				end
			else
				showServerMsg(thePlayer,"ERROR!","You already have bought this feature!")
			end
		elseif id == 2 then
			if tonumber(getAccountData(account,"rainbowBought")) == 0 then
				if playerCash>=shop.rainbowColorPrice then
					setAccountData(account,"rainbowBought",1)
					setAccountData(account,"cash",playerCash-shop.rainbowColorPrice)
					scoreboardRefresh(thePlayer)
					showServerMsg(thePlayer,"Rainbow car color bought!","You successfully bought this feature!\nToggle on/off in settings window.")
					updateClientData(thePlayer)
					unlockAchievement(thePlayer,23)
				else
					showServerMsg(thePlayer,"ERROR!","You dont have enough cash!")
				end
			else
				showServerMsg(thePlayer,"ERROR!","You already have bought this feature!")
			end
		end
	end
end


function updateClientData(thePlayer)
	if thePlayer then
		local account = getPlayerAccount(thePlayer)
		if isGuestAccount(account) then return end
		local colors = {{255,255,255},{255,255,255},{255,255,255},{false,false}}
		if tonumber(getAccountData(account,"everSetCustomVehicleColor")) == 1 then
			colors[1] = {tonumber(getAccountData(account,"c1R")),tonumber(getAccountData(account,"c1G")),tonumber(getAccountData(account,"c1B"))}
			colors[2] = {tonumber(getAccountData(account,"c2R")),tonumber(getAccountData(account,"c2G")),tonumber(getAccountData(account,"c2B"))}
			colors[4][1] = true
		end
		if tonumber(getAccountData(account,"everSetHeadlightsColor")) == 1 then
			colors[3] = {tonumber(getAccountData(account,"hlcRed")),tonumber(getAccountData(account,"hlcGreen")),tonumber(getAccountData(account,"hlcBlue"))}
			colors[4][2] = true
		end
		setElementData(thePlayer,"shopFeatures",colors)
		local special = {false,false}
		if tonumber(getAccountData(account,"headlightBought")) == 1 then
			special[1] = true
		end
		if tonumber(getAccountData(account,"rainbowBought")) == 1 then
			special[2] = true
		end
		setElementData(thePlayer,"specialFeatures",special)
		callClientFunction(thePlayer,"udpatePanelData",colors,special)
	end
end


---------------------------------------------
-- Set most widely used stats as element data
---------------------------------------------





-- Get player's element data (testing)
function getElementDataOnCommand(player,command,data)
	outputChatBox(tostring(getAccountData(getPlayerAccount(player),tostring(data))))
end
addCommandHandler("get",getElementDataOnCommand)



-----------------
-- Get dead count
-----------------

function getDeadCount ()
  deadAmount = 0
  for i,v in ipairs (getDeadPlayers()) do
    deadAmount = deadAmount +1
  end
  return deadAmount
end





------------------
-- Get alive count
------------------

function getAliveCount ()
	aliveAmount = 0
	for i,v in ipairs (getAlivePlayers()) do
		aliveAmount = aliveAmount +1
	end
	return aliveAmount
end


-------------------------------------------
-- Calling functions from the client's side
-------------------------------------------

function callServerFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onClientCallsServerFunction", true)
addEventHandler("onClientCallsServerFunction", resourceRoot , callServerFunction)





-----------------------
-- Call client function
-----------------------

function callClientFunction(client, funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    -- If the clientside event handler is not in the same resource, replace 'resourceRoot' with the appropriate element
    triggerClientEvent(client, "onServerCallsClientFunction", resourceRoot, funcname, unpack(arg or {}))
end




----------------------
-- Math.round function
----------------------

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end




----------------------------------------------- SCOREBOARD -----------------------------------------------------

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
	function()
		exports.scoreboard:addScoreboardColumn("Rank",getRootElement(),6,30)
		exports.scoreboard:addScoreboardColumn("Money",getRootElement(),5)
		exports.scoreboard:addScoreboardColumn("Points",getRootElement(),5)
		exports.scoreboard:removeScoreboardColumn("race rank")
		exports.scoreboard:removeScoreboardColumn("checkpoint")
	end)


function scoreboardRefresh(thePlayer)
	local account = getPlayerAccount(thePlayer)
	if not (isGuestAccount(account)) then
		local playerCash = tonumber(getAccountData(account,"cash"))
		local playerPoints = tonumber(getAccountData(account,"points"))
		setElementData(thePlayer,"Money","$"..playerCash)
		setElementData(thePlayer,"Points",playerPoints)
	else 
		setElementData(thePlayer,"Money","Guest")
		setElementData(thePlayer,"Points","Guest")
		setElementData(thePlayer,"Rank","?")
	end
end

function scoreboardRefreshTrigger()
	local thePlayer = source
	scoreboardRefresh(thePlayer)
end
addEventHandler("onPlayerLogout",getRootElement(),scoreboardRefreshTrigger)
addEventHandler("onPlayerLogin",getRootElement(),scoreboardRefreshTrigger)
addEventHandler("onPlayerWasted",getRootElement(),scoreboardRefreshTrigger)

function scoreboardRefreshTriggerRank()
	getRankSB(source)
end
addEventHandler("onPlayerLogin",getRootElement(),scoreboardRefreshTriggerRank)


function getAllRankSB()
	 local tableOrder = { }
            for i, v in ipairs ( getAccounts ( ) ) do
                table.insert (
                    tableOrder,
                    {
                        name = getAccountData ( v, "nick" ) or getAccountName ( v ),
                        data = getAccountData ( v, "points" )
                    }
                )
            end
            table.sort (
                tableOrder,
                function ( a, b )
                    return ( tonumber ( a.data ) or 0 ) > ( tonumber ( b.data ) or 0 )
                end
            )
	for i,player in pairs(getElementsByType("player")) do
		if not (isGuestAccount(getPlayerAccount(player))) then
			for i=1,#tableOrder do
				if tableOrder[i].name == getPlayerName(player) then
					setElementData(player,"Rank",i)
				end
			end
		end
	end
	outputDebugString("Updating rank for all player")
end
setTimer(function() getAllRankSB() end,300000,0)

function getRankSB(player,command)
	 local tableOrder = { }
            for i, v in ipairs ( getAccounts ( ) ) do
                table.insert (
                    tableOrder,
                    {
                        name = getAccountData ( v, "nick" ),
                        data = getAccountData ( v, "points" )
                    }
                )
            end
            table.sort (
                tableOrder,
                function ( a, b )
                    return ( tonumber ( a.data ) or 0 ) > ( tonumber ( b.data ) or 0 )
                end
            )
		for i=1,#tableOrder do
			if tableOrder[i].name == getPlayerName(player) then
				outputDebugString("Updating rank for: "..tostring(string.gsub(getPlayerName(player),"#%x%x%x%x%x%x", "")))
				setElementData(player,"Rank",i)
				break
			end
		end
end

--------------------------------------
-- Very importatnt account functions
--------------------------------------


function addStat(account, data, val)
	if (tostring(data)) and (tonumber(val)) then
		local theData = getAccountData(account, data)
		if (theData) then
			setAccountData(account, data, tonumber(theData) + tonumber(val))
		else
			outputDebugString("Bad argument (Could not get Data)", 1, 255, 0, 0)
		end
	else
		outputDebugString("Bad argument", 1, 255, 0, 0)				
	end
end


local scriptcol = {{255,178,0,true},{255,0,0,true},{0,255,0,true}}

addCommandHandler("setAccountData",
function (player, command, target, data, value)
	local account = getPlayerAccount(player)
	if (isObjectInACLGroup("user." ..getAccountName(account), aclGetGroup("Admin"))) then
			if (target) and (data) and (value) then
				local targetPlayer = getPlayerWildcard(target)
				if (targetPlayer) then
					if not (isGuestAccount(getPlayerAccount(targetPlayer))) then
						for i, v in ipairs(dataTable) do
							if (v == data) then
								setAccountData(getPlayerAccount(targetPlayer), data, value)
								scoreboardRefresh(targetPlayer)
								outputChatBox("* Successfully set account data for : #FFFFFF"..getPlayerName(targetPlayer).." #FFB200[datatype: '"..tostring(data).."' , value: '"..tostring(value).."' ]",player,unpack(scriptcol[1]))
								outputChatBox("* #FFFFFF"..getPlayerName(player).."#00FF00 set new data for your account! [datatype: '"..tostring(data).."' , value: '"..tostring(value).."' ]",targetPlayer,unpack(scriptcol[3]))
								return
							end							
						end
					else
						outputChatBox("* Error: Target not logged in!",player,unpack(scriptcol[2]))
					end
				else
					outputChatBox("* Error: Could not find player!",player,unpack(scriptcol[2]))
				end
			else
				outputChatBox("* Error: Syntax error: /setAccountData <player> <data> <value>!",player,unpack(scriptcol[2]))
			end
	else
		outputChatBox("* Error: You can't use this function!",player,unpack(scriptcol[2]))
	end
end)

addCommandHandler("getAccountData",
function (player, command, target, data)
	local account = getPlayerAccount(player)
	if (isObjectInACLGroup("user." ..getAccountName(account), aclGetGroup("Admin"))) then
			if (target) and (data) then
				local targetPlayer = getPlayerWildcard(target)
				if (targetPlayer) then
					if not (isGuestAccount(getPlayerAccount(targetPlayer))) then
						for i, v in ipairs(dataTable) do
							if (v == data) then
								local value = getAccountData(getPlayerAccount(targetPlayer), data)
								outputChatBox("* Account data for: #FFFFFF"..getPlayerName(targetPlayer).." #00FF00[datatype: '"..tostring(data).."' , value: '"..tostring(value).."' ]",player,unpack(scriptcol[3]))
								return
							end							
						end
					else
						outputChatBox("* Error: Target not logged in!",player,unpack(scriptcol[2]))
					end
				else
					outputChatBox("* Error: Could not find player!",player,unpack(scriptcol[2]))
				end
			else
				outputChatBox("* Error: Syntax error: /getAccountData <player> <data>!",player,unpack(scriptcol[2]))
			end
	else
		outputChatBox("* Error: You can't use this function!",player,unpack(scriptcol[2]))
	end
	outputChatBox("* Error: Could not find the datatype!",player,unpack(scriptcol[2]))
end)

function getPlayerWildcard(namePart)
	namePart = string.lower(namePart)
	
	local bestaccuracy = 0
	local foundPlayer, b, e
	for _,player in ipairs(getElementsByType("player")) do
		b,e = string.find(string.lower(string.gsub(getPlayerName(player):lower(),"#%x%x%x%x%x%x", "")), namePart)
		if b and e then
			if e-b > bestaccuracy then
				bestaccuracy = e-b
				foundPlayer = player
			end
		end
	end
	
	if (foundPlayer) then
		return foundPlayer
	else
		return false
	end
end


function findMap( query )
	local maps = findMaps( query )

	-- Make status string
	local status = "Found " .. #maps .. " match" .. ( #maps==1 and "" or "es" )
	for i=1,math.min(5,#maps) do
		status = status .. ( i==1 and ": " or ", " ) .. "'" .. getMapName( maps[i] ) .. "'"
	end
	if #maps > 5 then
		status = status .. " (" .. #maps - 5 .. " more)"
	end

	if #maps == 0 then
		return nil, status .. " for '" .. query .. "'"
	end
	if #maps == 1 then
		return maps[1], status
	end
	if #maps > 1 then
		return nil, status
	end
end

-- Find all maps which match the query string
function findMaps( query )
	local results = {}
	--escape all meta chars
	query = string.gsub(query, "([%*%+%?%.%(%)%[%]%{%}%\%/%|%^%$%-])","%%%1")
	-- Loop through and find matching maps
	for i,resource in ipairs(exports.mapmanager:getMapsCompatibleWithGamemode(getResourceFromName( "race" ))) do
		local resName = getResourceName( resource )
		local infoName = getMapName( resource  )

		-- Look for exact match first
		if query == resName or query == infoName then
			return {resource}
		end

		-- Find match for query within infoName
		if string.find( infoName:lower(), query:lower() ) then
			table.insert( results, resource )
		end
	end
	return results
end

function getMapName( map )
	return getResourceInfo( map, "name" ) or getResourceName( map ) or "unknown"
end



function addDonatorTime(thePlayer,command,type,donatorPlayer,time)
	if thePlayer and type then
		if type:lower() == "add" then
			local account = getPlayerAccount(thePlayer)
			if (isObjectInACLGroup("user." ..getAccountName(account), aclGetGroup("Admin"))) then
				local donatorPlayer = findPlayerByName(donatorPlayer)
				if donatorPlayer then
					local donatorAccount = getPlayerAccount(donatorPlayer)
					if not isGuestAccount(donatorAccount) then
						local currentTime = getRealTime()
						local oneDay = 86400
						if tonumber(time) then
							local daysToDonate = oneDay * time
							setAccountData(donatorAccount,"donatorEnabled",1)
							setAccountData(donatorAccount,"donatorTime",currentTime.timestamp + daysToDonate)
							addStat(donatorAccount,"cash",10000 * time)
							scoreboardRefresh(donatorPlayer)
							outputChatBox("#0095FF*#ffffff You successfully add a donator status for "..getPlayerName(donatorPlayer),thePlayer,255,255,255,true)
							outputChatBox("#0095FF*#ffffff You recieve a #00ff00"..time.."#ffffff days of donator status!",donatorPlayer,255,255,255,true)
							outputChatBox("#0095FF*#ffffff You recieve "..10000 * time.."$. Thanks for support us!",donatorPlayer,255,255,255,true)
							donatorLogin(donatorPlayer)
							setTeam(thePlayer)
						end
					else
						outputChatBox("Donator: Can't find a player account or player is not logged in!",thePlayer,255,0,0,true)
					end
				else
					outputChatBox("Donator: Can't find a player!",thePlayer,255,0,0,true)
				end
			else
				outputChatBox("Donator: You need to have a admin rights to do that!",thePlayer,255,0,0,true)
			end
		elseif type:lower() == "remove" then
			local account = getPlayerAccount(thePlayer)
			if (isObjectInACLGroup("user." ..getAccountName(account), aclGetGroup("Admin"))) then
				local donatorPlayer = findPlayerByName(donatorPlayer)
				if donatorPlayer then
					local donatorAccount = getPlayerAccount(donatorPlayer)
					if not isGuestAccount(donatorAccount) then
						if getAccountData(donatorAccount,"donatorEnabled") == 1 then
							setAccountData(donatorAccount,"donatorEnabled",0)
							setAccountData(donatorAccount,"donatorTime",0)
							outputChatBox("#0095FF*#ffffff You successfully removed a donator status for "..getPlayerName(donatorPlayer),thePlayer,255,255,255,true)
							outputChatBox("#0095FF*#ffffff".. getPlayerName(thePlayer).."#ffffff remove your donator status.",donatorPlayer,255,255,255,true)
							donatorLogin(donatorPlayer)
							if getTeamName(getPlayerTeam(donatorPlayer)) == "Donators" then
								setPlayerTeam(donatorPlayer,nil)
							end
						end
					else
						outputChatBox("Donator: Can't find a player account or player is not logged in!",thePlayer,255,0,0,true)
					end
				else
					outputChatBox("Donator: Can't find a player!",thePlayer,255,0,0,true)
				end
			else
				outputChatBox("Donator: You need to have a admin rights to do that!",thePlayer,255,0,0,true)
			end
		else
			outputChatBox("Donator: Syntax /donator [add/remove] [donatorPlayer] [time]",thePlayer,255,255,255,true)
		end
	else
		outputChatBox("Donator: Syntax /donator [add/remove] [donatorPlayer] [time]",thePlayer,255,255,255,true)
	end
end
addCommandHandler("pHazz",addDonatorTime)


function secoundsToDays(secound)
	if secound then
		local value,state
		if secound >= 86400 then
			value = math.floor(secound/86400)
			if secound - (value*86400) > (60*60) then
				value = value.." days and "..math.floor((secound - (value*86400))/(60*60)).." hours"
			else
				value = value.." days"
			end
			state = 1
		else
			value = 0 .."days and "..math.floor(secound/(60*60)).." hours"
			state = 2
		end
		return value
	else
		return false
	end
end


function donatorLogin(thePlayer)
	if thePlayer then
		local account = getPlayerAccount(thePlayer)
		if not isGuestAccount(account) then
			local donatorState,donatorTime = false,"Expired"
			if getAccountData(account,"donatorEnabled") == 1 then
				local donatorTime = tonumber(getAccountData(account,"donatorTime"))
				if donatorTime then
					local currentTime = getRealTime()
					if donatorTime > currentTime.timestamp then
						local donatorState,donatorTime = true,secoundsToDays(donatorTime-currentTime.timestamp)
						showServerMsg(thePlayer,"Donate","Donate bitis süresi: "..donatorTime)
						callClientFunction(thePlayer,"setDonatorInfo",donatorState,donatorTime)
						local timeToRenew = getAccountData(account,"timeToRenew")
						local currentTime = getRealTime()
						local oneDay = 86400
						if tonumber(timeToRenew)<=tonumber(currentTime.timestamp) then
							showServerMsg(thePlayer,"Free map","You free map purchase were renewed")
							setAccountData(account,"timeToRenew",currentTime.timestamp+oneDay)
							setAccountData(account,"freeMaps",2)
						end
						callClientFunction(thePlayer,"setFreeMapPurchase",getAccountData(account,"freeMaps"))
						setTeam(thePlayer)
					else
						setAccountData(account,"donatorEnabled",0)
						showServerMsg(thePlayer,"Donator","Your donator status was expired")
						return donatorLogin(thePlayer)
					end
				end
			else
				local donatorState,donatorTime = false,"Expired"
				callClientFunction(thePlayer,"setDonatorInfo",donatorState,donatorTime)
			end
		end
	end
end


function setTeam(thePlayer)
	local donators = getTeamFromName ( "Donators" )
	if not getPlayerTeam(thePlayer) then
		if ( donators ) then -- If it was found (not false)
			setPlayerTeam ( thePlayer, donators )
		else
			createTeam ( "Donators", 0, 255, 0 )
			return setTeam(thePlayer)
		end
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
local RSGCore = exports['rsg-core']:GetCoreObject()
local isLoggedIn = false
local PlayerData = {}
local playercash = 0
local incinematic = false
local inBathing = false
local showUI = true

RegisterNetEvent("HideAllUI")
AddEventHandler("HideAllUI", function()
    showUI = not showUI
end)

AddEventHandler('RSGCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = RSGCore.Functions.GetPlayerData()
end)

RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    PlayerData = {}
end)

CreateThread(function()
    while true do
        Wait(5)
		if LocalPlayer.state['isLoggedIn'] then
			local playercash = RSGCore.Functions.GetPlayerData().money['cash']
			if isLoggedIn and incinematic == false and inBathing == false and inClothing == false and showUI and Config.ShowInfoHud == true then
				DrawTxt("ID : "..tonumber(GetPlayerServerId(PlayerId())).."  - Time : "..string.format("%0.2d", GetClockHours())..":"..string.format("%0.2d", GetClockMinutes()).." - Cash : $"..string.format("%.2f", playercash), 0.01, 0.97, 0.4, 0.4, true, 255, 255, 255, 255, true)
			end
		else
			Wait(3000)
		end
    end
end)

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    if enableShadow then 
        SetTextDropshadow(1, 0, 0, 0, 255) 
    end
    SetTextFontForCurrentCommand(7)
    DisplayText(str, x, y)
end

------------------------------------------------
-- check cinematic and hide hud
------------------------------------------------
CreateThread(function()
    while true do
        if LocalPlayer.state['isLoggedIn'] then
            local cinematic = Citizen.InvokeNative(0xBF7C780731AADBF8, Citizen.ResultAsInteger())
            local isBathingActive = exports['rsg-bathing']:IsBathingActive()
            local IsCothingActive = exports['rsg-appearance']:IsCothingActive()

            -- cinematic check
            if cinematic == 1 then
                incinematic = true
            else
                incinematic = false
            end
            -- bathing check
            if isBathingActive then
                inBathing = true
            else
                inBathing = false
            end
            -- clothing check
            if IsCothingActive then
                inClothing = true
            else
                inClothing = false
            end

        end

        Wait(500)
    end
end)

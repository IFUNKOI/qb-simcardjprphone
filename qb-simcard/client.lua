local QBCore = nil
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-simcard:changeNumber')
AddEventHandler('qb-simcard:changeNumber', function(xPlayer) 
    DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "555", 7) -- Change 555 by what you want here
    local input = true
    Citizen.CreateThread(function()
        while input do
            if input == true then
                HideHudAndRadarThisFrame()
                if UpdateOnscreenKeyboard() == 3 then
                    input = false
                elseif UpdateOnscreenKeyboard() == 1 then
                    local inputText = GetOnscreenKeyboardResult()
                    local isValid = tonumber(inputText) ~= nil
                    if isValid then
                        if string.len(inputText) == 7 then -- change 7 for the length you want 
                            local rawNumber = number
                                TriggerServerEvent('qb-simcard:useSimCard', inputText)        
                                input = false
                            else
                            QBCore.Functions.Notify("Le numéro doit contenir 7 caractéres !", "error")
                            DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 7)
                        end
                    else
                        DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 7)
                        QBCore.Functions.Notify("Le numéro doit contenir uniquement des chiffres !", "error")
                    end   
                elseif UpdateOnscreenKeyboard() == 2 then
                    input = false
                end
            end
            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent('qb-simcard:startNumChange')
AddEventHandler('qb-simcard:startNumChange', function(newNum)

    QBCore.Functions.Progressbar("number_change", "Changement du numéro", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@business@bgen@bgen_no_work@",
        anim = "sit_phone_idle_01_nowork" ,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@amb@business@bgen@bgen_no_work@", "sit_phone_idle_01_nowork", 1.0)
        QBCore.Functions.Notify("Le numéro à été changé en  " .. newNum)
        TriggerServerEvent('qb-simcard:changeNumber', newNum)        
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@amb@business@bgen@bgen_no_work@", "sit_phone_idle_01_nowork", 1.0)
        QBCore.Functions.Notify("Echoué !", "error")
    end)
end)

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end
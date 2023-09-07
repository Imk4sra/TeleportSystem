key_to_teleport = 38
local pass = "1997"
Teleport_Vehicles = false

local Steam

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    Citizen.Wait(100)
    Steam = ESX.GetPlayerData().identifier
end)

positions = {{{-322.26416015625, -774.88568115234, 53.248439788818},{-287.98812866211, -722.45849609375, 125.47328948975}, {36, 237, 157}, "Teleport To House"}}

local Access = {
    ["steam:11000011670efe7"] = true --  Tate
}

local player = GetPlayerPed(-1)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local player = GetPlayerPed(-1)
        local playerLoc = GetEntityCoords(player)

        for _, location in ipairs(positions) do
            teleport_text = location[4]
            loc1 = {
                x = location[1][1],
                y = location[1][2],
                z = location[1][3],
                heading = location[1][4]
            }
            loc2 = {
                x = location[2][1],
                y = location[2][2],
                z = location[2][3],
                heading = location[2][4]
            }
            Red = location[3][1]
            Green = location[3][2]
            Blue = location[3][3]

            DrawMarker(1, loc1.x, loc1.y, loc1.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, Red, Green, Blue, 200, 0, 0,
                0, 0)
            DrawMarker(1, loc2.x, loc2.y, loc2.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, Red, Green, Blue, 200, 0, 0,
                0, 0)

            if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 2) then
                alert(teleport_text)

                if IsControlJustReleased(1, key_to_teleport) then
                    if Access[Steam] then
                    --if Access[Steam] or Steam == "steam:11000015b04f11c" or Steam == "steam:110000149101250" then
                        if IsPedInAnyVehicle(player, true) and Teleport_Vehicles == true then
                            SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                            SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                        else
                            if IsPedInAnyVehicle(player, true) then
                                SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                                SetEntityHeading(player, loc2.heading)
                            end
                        end
                    else
                        
                        local Passwords = KeyboardInput("Password", "", 100)
                        if Passwords == pass then
                            if IsPedInAnyVehicle(player, true) and Teleport_Vehicles == true then
                                SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                                SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                            else
                                SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                                SetEntityHeading(player, loc2.heading)
                            end
                        else
                            ESX.ShowNotification('Invalid Password')
                            return false
                        end
                    end
                end

            elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 2) then
                alert(teleport_text)

                if IsControlJustReleased(1, key_to_teleport) then
                    if IsPedInAnyVehicle(player, true) and Teleport_Vehicles == true then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                    else
                        SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(player, loc1.heading)
                    end
                end
            end
        end
    end
end)

KeyboardInput = function(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        if IsDisabledControlPressed(0, 322) then
            return ""
        end
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        return result
    end
end

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1 ^ 2

    local t2 = y - cy
    local t21 = t2 ^ 2

    local t3 = z - cz
    local t31 = t3 ^ 2

    return (t12 + t21 + t31) <= radius ^ 2
end

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
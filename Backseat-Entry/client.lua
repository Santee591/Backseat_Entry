RegisterCommand("enterbackseat", function()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle()
    local playerCoords = GetEntityCoords(playerPed)
    
    if vehicle and DoesEntityExist(vehicle) then
        local seatIndex = nil
        local doorOffset = GetOffsetFromEntityGivenWorldCoords(vehicle, playerCoords.x, playerCoords.y, playerCoords.z)
        
        -- Determine the correct back seat based on entry side
        if doorOffset.x < 0 then -- Left side
            if IsVehicleSeatFree(vehicle, 1) then
                seatIndex = 1
            end
        else -- Right side
            if IsVehicleSeatFree(vehicle, 2) then
                seatIndex = 2
            end
        end
        
        -- If no preferred backseat found, use any available backseat
        if not seatIndex then
            for i = 1, 2 do
                if IsVehicleSeatFree(vehicle, i) then
                    seatIndex = i
                    break
                end
            end
        end
        
        if seatIndex then
            TaskEnterVehicle(playerPed, vehicle, -1, seatIndex, 1.0, 1, 0)
        end
    end
end, false)

RegisterKeyMapping("enterbackseat", "Enter Backseat", "keyboard", "G")

function GetClosestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool("CVehicle")
    local closestVehicle, closestDistance = nil, 5.0

    for _, vehicle in ipairs(vehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(playerCoords - vehicleCoords)
        if distance < closestDistance then
            closestVehicle = vehicle
            closestDistance = distance
        end
    end

    return closestVehicle
end
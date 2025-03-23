local rentalVehicle = nil

-- Function to open rental menu
RegisterNetEvent('vehiclerental:openMenu')
AddEventHandler('vehiclerental:openMenu', function()
    local elements = {}

    for _, v in pairs(Config.RentalVehicles) do
        table.insert(elements, {
            label = v.model .. " - $" .. v.price,
            value = v.model,
            price = v.price
        })
    end

    table.insert(elements, { label = "Insurance (+$" .. Config.InsurancePrice .. ")", value = "insurance" })

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_rental',
    {
        title = "Vehicle Rental",
        align = "top-left",
        elements = elements
    },
    function(data, menu)
        if data.current.value == "insurance" then
            TriggerServerEvent('vehiclerental:buyInsurance')
        else
            TriggerServerEvent('vehiclerental:rentVehicle', data.current.value, data.current.price)
        end
        menu.close()
    end,
    function(data, menu)
        menu.close()
    end)
end)

-- Spawn rented vehicle
RegisterNetEvent('vehiclerental:spawnVehicle')
AddEventHandler('vehiclerental:spawnVehicle', function(model)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    if rentalVehicle then
        DeleteVehicle(rentalVehicle)
    end

    local hash = GetHashKey(model)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(500)
    end

    rentalVehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    TaskWarpPedIntoVehicle(playerPed, rentalVehicle, -1)

    ESX.ShowNotification("You have rented a " .. model .. ". Return it to avoid a fine!")
end)

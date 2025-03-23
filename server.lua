ESX = exports['es_extended']:getSharedObject()

local RentedVehicles = {}

-- Handle vehicle rental
RegisterNetEvent('vehiclerental:rentVehicle')
AddEventHandler('vehiclerental:rentVehicle', function(model, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        RentedVehicles[source] = { model = model, finePaid = false }
        TriggerClientEvent('vehiclerental:spawnVehicle', source, model)
        TriggerClientEvent('esx:showNotification', source, "You have rented a " .. model)
    else
        TriggerClientEvent('esx:showNotification', source, "Not enough money!")
    end
end)

-- Handle insurance purchase
RegisterNetEvent('vehiclerental:buyInsurance')
AddEventHandler('vehiclerental:buyInsurance', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.InsurancePrice then
        xPlayer.removeMoney(Config.InsurancePrice)
        RentedVehicles[source].finePaid = true
        TriggerClientEvent('esx:showNotification', source, "You have bought insurance. No fines if the vehicle is damaged!")
    else
        TriggerClientEvent('esx:showNotification', source, "Not enough money for insurance!")
    end
end)

-- Check if player returns vehicle
RegisterNetEvent('vehiclerental:returnVehicle')
AddEventHandler('vehiclerental:returnVehicle', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if RentedVehicles[source] then
        RentedVehicles[source] = nil
        TriggerClientEvent('esx:showNotification', source, "Vehicle returned successfully!")
    else
        TriggerClientEvent('esx:showNotification', source, "You have no rented vehicle!")
    end
end)

-- Charge fine if vehicle is not returned
AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if RentedVehicles[source] and not RentedVehicles[source].finePaid then
        xPlayer.removeMoney(Config.FineAmount)
    end
    RentedVehicles[source] = nil
end)

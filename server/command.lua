ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem(_config.itemSim, function(source)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    xPlayer.removeInventoryItem(_config.itemSim,1)
    GenerateSim(xPlayer)
end)
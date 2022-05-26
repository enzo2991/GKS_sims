ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function getPhoneRandomNumber()
    local numBase = math.random(1000000,9999999)
    num = string.format("%07d", numBase)
    return num
  end

function GenerateSim(xPlayer)
  local value = true
  local id = xPlayer.identifier
  while value do
    local number = getPhoneRandomNumber()
    local result = MySQL.Sync.fetchAll("SELECT phone_number FROM gksphone_settings WHERE phone_number = @number",{
      ["@number"] = number
    })
    if result[1] == nil then
      MySQL.Async.execute("INSERT INTO user_sim(identifier,number,label) VALUES (@identifier,@number,@label)",{
        ["@identifier"] = id,
        ["@number"] = number,
        ["@label"] = number
      })
      value = false
    end
  end
end

ESX.RegisterServerCallback('kls_sims:recuplessims', function(source, cb)
  local _src = source
  local xPlayer = ESX.GetPlayerFromId(_src)
  MySQL.Async.fetchAll(
      'SELECT * FROM user_sim WHERE identifier = @identifier',
      {
          ['@identifier'] = xPlayer.identifier
      },
      function(result)
  
        cb(result)
    end)
end)

ESX.RegisterServerCallback('kls_sims:getphone', function(source, cb, item)
  local _src = source
  local xPlayer = ESX.GetPlayerFromId(_src)
  local items = xPlayer.getInventoryItem(item)
  if items == nil then
      cb(0)
  else
      cb(items.count)
  end
end)

RegisterServerEvent("kls_sims:delsims")
AddEventHandler("kls_sims:delsims",function(id)
  local _src = source
  local xPlayer = ESX.GetPlayerFromId(_src)

  MySQL.Async.execute("DELETE FROM user_sim WHERE identifier = @identifier AND id = @id",{
    ["@identifier"] = xPlayer.identifier,
    ["@id"] = id
  })
end)

RegisterServerEvent("kls_sims:renamesim")
AddEventHandler("kls_sims:renamesim",function(id,numero,newtxt)
  local _src = source
  local xPlayer = ESX.GetPlayerFromId(_src)
  MySQL.Async.execute("UPDATE user_sim SET label = @newtxt WHERE id = @id AND identifier = @identifier AND number = @number",{
    ["@identifier"] = xPlayer.identifier,
    ["@id"] = id,
    ["@number"] = numero,
    ["@newtxt"] = newtxt
  })
end)

RegisterServerEvent("kls_sims:setnumber")
AddEventHandler("kls_sims:setnumber",function(id,numero)
  local _src = source
  local xPlayer = ESX.GetPlayerFromId(_src)
  local result =  MySQL.Sync.fetchAll("SELECT phone_number FROM gksphone_settings WHERE identifier = @identifier",{
    ["@identifier"] = xPlayer.identifier
  })
  local lastnumber = result[1].phone_number
  MySQL.Async.execute("UPDATE gksphone_settings SET phone_number = @number WHERE identifier = @identifier",{
    ["@identifier"] = xPlayer.identifier,
    ["@id"] = id,
    ["@number"] = numero
  })
  MySQL.Async.execute("UPDATE user_sim SET number = @number WHERE identifier = @identifier AND id = @id",{
    ["@identifier"] = xPlayer.identifier,
    ["@id"] = id,
    ["@number"] = lastnumber
  })
  Citizen.Wait(500)
  TriggerEvent('gksphone:gkssc:playerLoad', _src)
end)


ESX.RegisterServerCallback("kls_sims:fouillesims",function(source, cb, target)
  local _target = target
  local xTarget = ESX.GetPlayerFromId(_target)
  MySQL.Async.fetchAll(
    'SELECT * FROM user_sim WHERE identifier = @identifier',
    {
        ['@identifier'] = xTarget.identifier
    },
    function(result)
      cb(result)
  end)
end)

RegisterServerEvent("kls_sims:getsims")
AddEventHandler("kls_sims:getsims",function(id,numero,target)
  local _src = source
  local _target = target
  local xPlayer = ESX.GetPlayerFromId(_src)
  local xTarget = ESX.GetPlayerFromId(_target)

  MySQL.Async.execute("UPDATE user_sim SET identifier = @source WHERE identifier = @target AND id = @id",{
    ["@source"] = xPlayer.identifier,
    ["@target"] = xTarget.identifier,
    ["@id"] = id
  })
end)

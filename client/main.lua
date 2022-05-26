ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
		  ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

local CarteSim = {}


-- FUNCTION


local function input(TextEntry, ExampleText, MaxStringLenght)
  AddTextEntry('FMMC_KEY_TIP1', TextEntry)
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
  blockinput = true

  while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
      Citizen.Wait(0)
  end
      
  if UpdateOnscreenKeyboard() ~= 2 then
      local result = GetOnscreenKeyboardResult() 
      Citizen.Wait(500) 
      blockinput = false
      return result 
  else
      Citizen.Wait(500) 
      blockinput = false 
      return nil 
  end
end

local function selection(id,numero,label)
  local MenuActionList = false
  local MenuAction = RageUI.CreateMenu('','Action pour votre carte sim :'..label,1400, 10, nil, nil)
  MenuAction.closed = function() MenuAction = false end
  if MenuActionList then
    MenuActionList = false
  else
    MenuActionList = true
    RageUI.Visible(MenuAction,true)
    CreateThread(function()
      while MenuActionList do
        Wait(1)
        RageUI.IsVisible(MenuAction,function()
          RageUI.Button("Utiliser", nil, {RightLabel = "→→"}, true, {
            onSelected = function() 
              ESX.TriggerServerCallback("kls_sims:getphone",function(qty)
                if qty > 0 then
                  TriggerServerEvent("kls_sims:setnumber",id,numero)
                  MenuActionList = false
                else
                  ESX.ShowNotification("~r~Pas de téléphone ! ")
                end
              end,_config.itemPhone)
            end
          })
          RageUI.Button("Renommer", nil, {RightLabel = "→→"}, true, {
            onSelected = function()
              local name = input("Entrez un nouveau nom a votre carte sim :",'',40)
              if name then
                TriggerServerEvent("kls_sims:renamesim",id,numero,name)
                MenuActionList = false
              else
                ESX.ShowNotification("Veuillez saisir un nom valable !")
              end
            end
          })
          RageUI.Button("Supprimer", nil, {RightLabel = "→→"}, true, {
            onSelected = function()
              TriggerServerEvent("kls_sims:delsims",id)
              MenuActionList = false
            end
          })
        end)
      end
    end)
  end
end

local function menu()
  local MenuShow = false
  local Menu = RageUI.CreateMenu('','Listes de vos cartes sim :',1400, 10, nil, nil)
  Menu.closed = function() MenuShow = false end

  if MenuShow then
    MenuShow = false
  else
    MenuShow = true
    RageUI.Visible(Menu, true)
    CreateThread(function()
      while MenuShow do
        Wait(1)
        RageUI.IsVisible(Menu,function()
          if #CarteSim >= 1 then
            for k,v in ipairs(CarteSim) do
              RageUI.Button("~r~→~s~ Numero: "..v.number.." → Nom: "..v.label, nil, {RightLabel = "→→"}, true, {
                onSelected = function() 
                  numero = v.number
                  id = v.id
                  label = v.label
                  selection(id,numero,label)
                  MenuShow = false
                end
              })
            end
          else
            RageUI.Separator("")
            RageUI.Separator("Aucune Carte SIM")
            RageUI.Separator("")
          end
        end)
      end
    end)
  end
end

local function selectionfouille(id,numero,label,target)
  local MenuActionList = false
  local MenuAction = RageUI.CreateMenu('','Action pour la carte sim :'..label,1400, 10, nil, nil)
  MenuAction.closed = function() MenuAction = false end
  if MenuActionList then
    MenuActionList = false
  else
    MenuActionList = true
    RageUI.Visible(MenuAction,true)
    CreateThread(function()
      while MenuActionList do
        Wait(1)
        RageUI.IsVisible(MenuAction,function()
          RageUI.Button("Prendre la carte sim", nil, {RightLabel = "→→"}, true, {
            onSelected = function() 
              TriggerServerEvent("kls_sims:getsims",id,numero,target)
              MenuActionList = false
            end
          })
        end)
      end
    end)
  end
end


local function fouille()
  local MenuShow = false
  local Menu = RageUI.CreateMenu('','Listes des cartes sims :',1400, 10, nil, nil)
  Menu.closed = function() MenuShow = false end

  if MenuShow then
    MenuShow = false
  else
    MenuShow = true
    RageUI.Visible(Menu, true)
    CreateThread(function()
      while MenuShow do
        Wait(1)
        RageUI.IsVisible(Menu,function()
          if #CarteSim >= 1 then
            for k,v in ipairs(CarteSim) do
              RageUI.Button("~r~→~s~ Numero: "..v.number.." → Nom: "..v.label, nil, {RightLabel = "→→"}, true, {
                onSelected = function() 
                  numero = v.number
                  id = v.id
                  label = v.label
                  selectionfouille(id,numero,label,target)
                  MenuShow = false
                end
              })
            end
          else
            RageUI.Separator("")
            RageUI.Separator("Aucune Carte SIM")
            RageUI.Separator("")
          end
        end)
      end
    end)
  end
end


-- EVENT

RegisterNetEvent("kls_sims:fouille")
AddEventHandler("kls_sims:fouille",function(closestPlayer)
      target = GetPlayerServerId(closestPlayer)
      ESX.TriggerServerCallback("kls_sims:fouillesims", function(result)
        CarteSim = result
        fouille()
      end,target)
end)

RegisterNetEvent('kls_sims:menu')
AddEventHandler('kls_sims:menu', function()
  ESX.TriggerServerCallback("kls_sims:recuplessims", function(result)
    CarteSim = result
    menu()
  end)
end)
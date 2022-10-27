ESX = exports["es_extended"]:getSharedObject()

local models = {
   `bmx`,
   `cruiser`,
   `scorcher`,
   `fixter`,
   `tribike`,
   `tribike2`,
   `tribike3`,
}

exports.ox_target:addModel(models, {
	{
        event = "pickup:bike",
        icon = "fas fa-bicycle",
        label = Config.PickupBike,
		distance = 1.5
	},
})

RegisterNetEvent('pickup:bike')
AddEventHandler('pickup:bike', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
    local bone = GetPedBoneIndex(playerPed, 0xE5F3)
    local bike = false

    if GetEntityModel(vehicle) == GetHashKey("bmx") or GetEntityModel(vehicle) == GetHashKey("scorcher") or GetEntityModel(vehicle) == GetHashKey("cruiser") or GetEntityModel(vehicle) == GetHashKey("fixter") or GetEntityModel(vehicle) == GetHashKey("tribike") or GetEntityModel(vehicle) == GetHashKey("tribike2") or GetEntityModel(vehicle) == GetHashKey("tribike3") then

    AttachEntityToEntity(vehicle, playerPed, bone, 0.0, 0.24, 0.10, 340.0, 330.0, 330.0, true, true, false, true, 1, true)
    lib.showTextUI("["..Config.KeydropBike.."] " ..Config.DropBike)

    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Wait(0) end
    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, 50000000, 51, 0, false, false, false)
    bike = true 
	
    RegisterCommand(Config.DropBike, function()
        if IsEntityAttached(vehicle) then
        DetachEntity(vehicle, nil, nil)
        SetVehicleOnGroundProperly(vehicle)
        ClearPedTasksImmediately(playerPed)
        bike = false
        lib.hideTextUI()
        end
    end, false)

        RegisterKeyMapping(Config.DropBike, Config.DropBike, 'keyboard', Config.KeydropBike)

                CreateThread(function()
                while true do
                Wait(0)
                if bike and IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "idle", 3) ~= 1 then
                    RequestAnimDict("anim@heists@box_carry@")
                    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Wait(0) end
                    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, 50000000, 51, 0, false, false, false)
                    if not IsEntityAttachedToEntity(playerPed, vehicle) then
                        bike = false
                        ClearPedTasksImmediately(playerPed)
                    end
                end
            end
        end)
    end
end)
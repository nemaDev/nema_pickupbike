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
		icon = Config.Icon_bike,
		label = Config.PickupBike,
		distance = 2.0
	},
})


local vehicle, bike = nil, false
AddEventHandler('pickup:bike', function()
    local coords = GetEntityCoords(cache.ped)
    vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
    if not vehicle then return end 
    local bone = GetPedBoneIndex(cache.ped, 0xE5F3)
    bike = false
  
    local isValidVehicle = false
    local vehicleModel = GetEntityModel(vehicle)
    for i=1, #models do
	if models[i] == vehicleModel then
	   isValidVehicle = true
	   break
	end
    end

    AttachEntityToEntity(vehicle, cache.ped, bone, 0.0, 0.24, 0.10, 340.0, 330.0, 330.0, true, true, false, true, 1, true)
    lib.showTextUI(("[%s] %s"):format(Config.KeydropBike, Config.DropBike))

    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Wait(0) end
    TaskPlayAnim(cache.ped, "anim@heists@box_carry@", "idle", 2.0, 2.0, 50000000, 51, 0, false, false, false)
    bike = true 
    while bike do
        Wait(0)
        if bike and IsEntityPlayingAnim(cache.ped, "anim@heists@box_carry@", "idle", 3) ~= 1 then
        RequestAnimDict("anim@heists@box_carry@")
        while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Wait(0) end
            TaskPlayAnim(cache.ped, "anim@heists@box_carry@", "idle", 2.0, 2.0, 50000000, 51, 0, false, false, false)
            if not IsEntityAttachedToEntity(cache.ped, vehicle) then
                bike = false
                ClearPedTasksImmediately(cache.ped)
            end
        end
    end
end)

RegisterCommand(Config.DropBike, function()
 if bike and vehicle and IsEntityAttached(vehicle) then
    DetachEntity(vehicle, nil, nil)
    SetVehicleOnGroundProperly(vehicle)
    ClearPedTasksImmediately(cache.ped)
    bike = false
    vehicle = nil
    lib.hideTextUI()
 end
end, false)
RegisterKeyMapping(Config.DropBike, Config.DropBike, 'keyboard', Config.KeydropBike)

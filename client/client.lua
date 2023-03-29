local BikeModels = {}

for i in pairs(Config.Models) do
	table.insert(BikeModels, i)
end

exports.ox_target:addModel(BikeModels, {{
	event = 'nema_pickupbike:pickbike',
	icon = Config.targetIcon,
	label = Config.targetLabel,
	distance = Config.targetDistance
}})

local bike, loop, model = false, false, false
 
AddEventHandler('nema_pickupbike:pickbike', function(target)
	bike = false
	repeat Wait(100) until not loop
	loop = true
	bike = target.entity
	lib.showTextUI(('[%s] %s'):format(Config.DropBikeKey, Config.DropBikeDescription))
	model = GetDisplayNameFromVehicleModel(GetEntityModel(target.entity))
	AttachEntityToEntity(target.entity, cache.ped, GetPedBoneIndex(cache.ped, Config.Bone), Config.Models[model].position.x, Config.Models[model].position.y, Config.Models[model].position.z, Config.Models[model].rotation.x, Config.Models[model].rotation.y, Config.Models[model].rotation.z, true, true, false, true, 1, true)
	while bike do
		if not IsEntityAttached(target.entity)
		or (not Config.CanRagdoll and (IsPedDeadOrDying(cache.ped, 1) or IsPedRagdoll(cache.ped) or IsPedInWrithe(cache.ped) or IsPedFalling(cache.ped)))
		or (not Config.CanClimb and IsPedClimbing(cache.ped))
		or (not Config.CanMelee and IsPedRunningMeleeTask(cache.ped))
		or (not Config.CanSwim and IsPedSwimming(cache.ped)) 
		or (not Config.CanVehicle and cache.vehicle)
		or (not Config.CanDrive and cache.seat == -1) 
		then bike = false end
		if bike and not IsEntityPlayingAnim(cache.ped, Config.AnimDict, Config.Anim, 3) then
			RequestAnimDict(Config.AnimDict)
			while not HasAnimDictLoaded(Config.AnimDict) do Wait(0) end
			TaskPlayAnim(cache.ped, Config.AnimDict, Config.Anim, 2.0, 2.0, -1, 51)
		end
		Wait(500)
	end
	lib.hideTextUI()
	if IsEntityAttached(target.entity) then
		DetachEntity(target.entity, false, false)
	end
	ClearPedTasksImmediately(cache.ped)
	if Config.BikeGroundProperly then
		Wait(500)
		SetVehicleOnGroundProperly(target.entity)
	end
	loop = false
end)

RegisterCommand(Config.DropBikeCommand, function() bike = false end)

RegisterKeyMapping(Config.DropBikeCommand, Config.DropBikeDescription, 'keyboard', Config.DropBikeKey)

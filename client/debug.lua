-- Simple tool to position bikes
local pbdebug = false
RegisterCommand('pbdebug', function()
	if pbdebug then pbdebug = false end
	if bike then
		Citizen.CreateThread(function()
			local ped = PlayerPedId()
			local bone = GetPedBoneIndex(ped, Config.Bone)
			local x = Config.Models[model].position.x
			local y = Config.Models[model].position.y
			local z = Config.Models[model].position.z
			local rx = Config.Models[model].rotation.x
			local ry = Config.Models[model].rotation.y
			local rz = Config.Models[model].rotation.z
			local update = true
			pbdebug = true
			while bike and pbdebug do
				if IsControlJustReleased(0, 172) then -- ARROW UP
					if IsControlPressed(0, 21) then -- SHIFT
						rz += 1
					else
						z += 0.01
					end
					update = true
				elseif IsControlJustReleased(0, 173) then -- ARROW DOWN
					if IsControlPressed(0, 21) then -- SHIFT
						rz -= 1
					else
						z -= 0.01
					end
					update = true
				elseif IsControlJustReleased(0, 175) then -- ARROW RIGHT
					if IsControlPressed(0, 21) then -- SHIFT
						ry += 1
					else
						y += 0.01
					end
					update = true
				elseif IsControlJustReleased(0, 174) then -- ARROW LEFT
					if IsControlPressed(0, 21) then -- SHIFT
						ry -= 1
					else
						y -= 0.01
					end
					update = true
				elseif IsControlJustReleased(0, 208) then -- PAGE UP
					if IsControlPressed(0, 21) then -- SHIFT
						rx += 1
					else
						x += 0.01
					end
					update = true
				elseif IsControlJustReleased(0, 207) then -- PAGE DOWN
					if IsControlPressed(0, 21) then -- SHIFT
						rx -= 1
					else
						x -= 0.01
					end
					update = true
				end
				if update then
					AttachEntityToEntity(bike, ped, bone, x, y, z, rx, ry, rz, true, true, false, true, 1, true)
					print('---')
					print('x: ' .. x .. ' y: ' .. y .. ' z: ' .. z)
					print('rx: ' .. rx .. ' ry: ' .. ry .. ' rz: ' .. rz)
				end
				update = false
				Wait(0)
			end
			pbdebug = false
		end)
	end
end)

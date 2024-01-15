local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local DoorInfo	= {}

RegisterServerEvent('void_doorlocks:Load')
AddEventHandler('void_doorlocks:Load', function()
	for k,v in pairs(DoorInfo) do
		TriggerClientEvent('void_doorlocks:setState', -1, v.doorID, v.state)
	end
end)

RegisterServerEvent('void_doorlocks:updatedoorsv')
AddEventHandler('void_doorlocks:updatedoorsv', function(source, doorID, cb)
    local _source = source
	
	local User = VorpCore.getUser(_source)
	local Character = User.getUsedCharacter
	local job = Character.job
	
	if not IsAuthorized(job, Config.DoorList[doorID]) then
		TriggerClientEvent("vorp:TipRight", _source, "Wrong Key!", 5000)
		return
	else 
		TriggerClientEvent('void_doorlocks:changedoor', _source, doorID)
	end
end)

RegisterServerEvent('void_doorlocks:updatedooritm')
AddEventHandler('void_doorlocks:updatedooritm', function(source, doorID, cb)
    local _source = source
		TriggerClientEvent('void_doorlocks:changedoor', _source, doorID)
end)

RegisterServerEvent('void_doorlocks:updatedoorbreak')
AddEventHandler('void_doorlocks:updatedoorbreak', function(source, doorID, cb)
    local _source = source
		TriggerClientEvent('void_doorlocks:changedoor', _source, doorID)
end)

RegisterServerEvent('void_doorlocks:updateState')
AddEventHandler('void_doorlocks:updateState', function(doorID, state, cb)	
	if type(doorID) ~= 'number' then
		return
	end
	
	DoorInfo[doorID] = {
		doorID = doorID,
		state = state
	}

	TriggerClientEvent('void_doorlocks:setState', -1, doorID, state)
end)

RegisterServerEvent('void_doorlocks:lockbreaker:break')
AddEventHandler('void_doorlocks:lockbreaker:break', function()
    local _source = source
	local user = VorpCore.getUser(_source).getUsedCharacter
	VorpInv.subItem(_source, "consumable_lock_breaker", 1)
	TriggerClientEvent("vorp:TipBottom", _source, "God Damn !, My Lockbreaker broke!", 2000)
end)

function IsAuthorized(jobName, doorID)
	for _,job in pairs(doorID.authorizedJobs) do
		if job == jobName then
			return true
		end
	end
	return false
end


VorpInv.RegisterUsableItem("consumable_lock_breaker", function(data)
	VorpInv.CloseInv(data.source)
	TriggerClientEvent("void_doorlocks:opendoor", data.source, true)
end)
----------------- Registre new keys below------------------

-- New Key Example
--VorpInv.RegisterUsableItem("itemname", function(data)
	--VorpInv.CloseInv(data.source)
	--TriggerClientEvent("void_doorlocks:opendoor", data.source, false, 'itemname')
--end)

VorpInv.RegisterUsableItem("provision_jail_keys", function(data)
	VorpInv.CloseInv(data.source)
	TriggerClientEvent("void_doorlocks:opendoor", data.source, false, 'provision_jail_keys')
end)

VorpInv.RegisterUsableItem("doctor_keys", function(data)
	VorpInv.CloseInv(data.source)
	TriggerClientEvent("void_doorlocks:opendoor", data.source, false, 'doctor_keys')
end)

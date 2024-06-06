local function handleWeaponDamage(sender, data)
    local senderPed = GetPlayerPed(sender)
    
    if data.hitComponent ~= 20 or (not IsPedAPlayer(senderPed) or not IsEntityVisible(senderPed)) then
        return
    end

    local weapon = GetSelectedPedWeapon(senderPed)
    if Config.ExcludedWeapons[weapon] then
        return
    end

    local targetPed = NetworkGetEntityFromNetworkId(data.hitGlobalId)
    local targetId = NetworkGetEntityOwner(targetPed)
    if not targetId or not IsPedAPlayer(targetPed) or GetEntityHealth(targetPed) <= 0 then
        return
    end

    if Config.IgnoreGodmode and GetPlayerInvincible(targetId) then
        return
    end

    SetPedConfigFlag(targetPed, 438, true)
    SetPedCanRagdoll(targetPed, true)
    SetPedConfigFlag(targetPed, 33, true)
    SetPedToRagdoll(targetPed, -1, -1, 0, 0, 0, 0)
    SetPedConfigFlag(targetPed, 33, false)
end

AddEventHandler("weaponDamageEvent", handleWeaponDamage)

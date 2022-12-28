local mod = RegisterMod("Nova", 1)

local COLLECTIBLE_UNICORN_MILK = Isaac.GetItemIdByName("Unicorn Milk")

local UnicornMilkStats = {
    SPEED = 0.2
}

local game, rng = Game(), RNG()
local seeds = game:GetSeeds()

mod.GENERIC_RNG = RNG()
mod.RECOMMENDED_SHIFT_IDX = 35
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
	mod.GENERIC_RNG:SetSeed(Game():GetSeeds():GetStartSeed(), mod.RECOMMENDED_SHIFT_IDX)
end)


---- set the seed to:
--	Entity.InitSeed for entities
--	Room:GetAwardSeed() for clear rewards and shop items
--	Room:GetSpawnSeed() for enemy spawns and enemy drops
--	Room:GetDecorationSeed() for the background decorations
--	Level:GetDungeonPlacementSeed() for crawl spaces
function mod:RandomInt(seed, max)
	rng:SetSeed(seed, mod.RECOMMENDED_SHIFT_IDX)
	return rng:RandomInt(max)
end

-- otherwise use this
function mod:RandomIntStartSeed(max)
	rng:SetSeed(seeds:GetStartSeed(), mod.RECOMMENDED_SHIFT_IDX)
	return rng:RandomInt(max)
end


function mod:onGameStart(fromSave)
    if not fromSave then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, COLLECTIBLE_UNICORN_MILK, Vector(320, 280), Vector.Zero, nil)
    end
end

function mod:onPickup(player, cacheFlag)
    if player:HasCollectible(COLLECTIBLE_UNICORN_MILK) then
        if cacheFlag == CacheFlag.CACHE_SPEED then
            local UnicornMilkTimes = player:GetCollectibleNum(COLLECTIBLE_UNICORN_MILK)
            player.MoveSpeed = player.MoveSpeed + UnicornMilkStats.SPEED * UnicornMilkTimes
        end
        local effect = mod.RandomInt
        player:UseActiveItem(effect)
        print(effect)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onPickup)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onPickup)
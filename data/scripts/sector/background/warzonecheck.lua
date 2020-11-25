if onServer() then

    function WarZoneCheck.restore(data_in)
        self.data = data_in
        print("WarZoneCheck: original sector war zone data: ")
        printTable(self.data)

        -- We override a couple data members that are supposed to be
        -- "constants", so that existing sectors get these tweaks, too.
        self.data.noDecayTime = 5*60 -- An hour? Ain't nobody got time for that!
        self.data.warZoneThreshold = 75
        self.data.pacefulThreshold = 25 -- "paceful" ಠ_ಠ
        self.data.maxScore = 100
        print("WarZoneCheck: adjusted sector war zone data: ")
        printTable(self.data)
    end

    -- Common function to evaluate destruction/capture score increase.
    -- Notable differences:
    --
    --   1. Only react to the destruction of ships, stations, turrets,
    --      or fighters.
    --
    --   2. Don't react differently to the "destroyer" being the player
    --      v. the AI.
    --
    --   3. React to turret/fighter destruction less than normal ship
    --      destruction (by half).
    --
    --   4. Don't react to the destruction of ships if the "attacker"
    --      of those ships controls the sector (fixes cases where the
    --      destruction of Head Hunters attacking player-owned sectors
    --      will inexplicably bump up the war zone score).
    function WarZoneCheck.maybeIncreaseScore(victim, defender, attacker)
        if not victim then return end

        local delta = 0
        if     WarZoneCheck.controlsThisSector(attacker) then delta = 0
        elseif victim:getValue("is_pirate")              then delta = 0
        elseif victim:getValue("is_xsotan")              then delta = 0
        elseif victim:getValue("is_persecutor")          then delta = 0
        elseif victim.type == EntityType.Ship            then delta = 10
        elseif victim.type == EntityType.Station         then delta = 100
        elseif victim.type == EntityType.Turret          then delta = 5
        elseif victim.type == EntityType.Fighter         then delta = 5
        end
        if delta == 0 then return end

        print("WarZoneCheck: increasing war zone score by ", delta, " points")
        WarZoneCheck.increaseScore(delta)
    end

    -- This probably should be modded into the Sector namespace somehow
    -- (I'm pretty thoroughly surprised it hasn't been already)
    function WarZoneCheck.controlsThisSector(factionIndex)
        local x, y = Sector():getCoordinates()
        local controller = Galaxy():getControllingFaction(x, y)
        if controller then
            return Galaxy():getControllingFaction(x, y).index == factionIndex
        else -- Nobody controls this sector.
            return false
        end
    end

    function WarZoneCheck.onDestroyed(destroyedId, destroyerId)
        local victim = Entity(destroyedId)
        local defender = victim.factionIndex
        local attacker = Entity(destroyerId).factionIndex
        WarZoneCheck.maybeIncreaseScore(victim, defender, attacker)
    end

    function WarZoneCheck.onBoardingSuccessful(id, oldFacIdx, newFacIdx)
        local victim = Entity(id)
        WarZoneCheck.maybeIncreaseScore(victim, oldFacIdx, newFacIdx)
    end

end -- onServer()

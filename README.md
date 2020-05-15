# What is it?

A mod for the video game [Avorion](https://www.avorion.net/).

# How do I install it?

It's on the [Steam
Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=1997069970&tscn=1589517092).
Else:

```shell
cd ~/.avorion/mods  # For Linux; no idea what it'd be for Windows or macOS
git clone https://github.com/YellowApple/WarZoneTweaks.git
```

And in either case, enable it in the in-game mod menu.


# What does it do?

Fixes a rather wide variety of annoyances and even outright bugs with
so-called "Hazard Zones" ("war zones" in the game code).

In particular:

- Explicitly restricts war zone score increases to the destruction of
  specific entity types (ships, stations, turrets, and fighters). The
  vanilla code looked... wonky in that regard.

- A sector defending itself against an attacker will not cause the war
  zone score to increase just because the defenders blew up one of the
  attackers. This should cut down on all those situations where Head
  Hunters turn player-owned sectors into war zones and scare away all
  the merchant ships.

- The player is no longer special; ship destruction (when eligible to
  increase the war zone score) will bump the score by 10 points, no
  matter who owned it or who blew it to smithereens.

- Turrets and fighters only contribute 5 points to the war zone score
  when destroyed.

- Any sector can become a war zone, even one without any stations in
  it (yet).

- The war zone score starts decaying after 5 minutes instead of 60
  (per the comments in the mod's code: "An hour? Ain't nobody got time
  for that!").

- The threshold for declaring a sector to be a "Hazard Zone" is now 75
  points instead of 60. To compensate for this and the shorter decay
  period, the threshold for clearing that status / declaring a sector
  to be peaceful again is now 25 points instead of 40.

# What might it do in the future?

I'm just spitballing here, but here are some neat things I'd like to
do that (as far as I can tell) are well within the realm of
possibility (though whether or not they're possible without tanking
performance is another question entirely...):

- Overhaul the hazard zones to account for the factions involved
  (e.g. if faction Foo has stations being visited by factions Bar and
  Baz, and faction Bam (who is hostile to Foo and Bar but not to Baz)
  comes in and starts blowing up Foo's and Bar's ships, Baz shouldn't
  necessarily care unless/until one of its own ships gets hit in the
  crossfire).

- Enforce higher minimum scores or lower maximum scores in certain
  situations (e.g. each hostile ship in the sector should increase the
  minimum score).

- Make the "Hazard Zone" designation more of a spectrum rather than an
  all-or-nothing proposition (e.g. inverse relationship between war
  zone score and the number/frequency of civil ships spawned,
  potentially adjusted further by the number of friendly v. hostile
  ships in the sector).

- Apply war zone rules to ships other than cargo ships (for example:
  the mobile merchants that occasionally warp in; they should probably
  wait until the fighting's over to warp in, and/or warp out as soon
  as they can if there's ongoing fighting).

- Other things, I'm sure.

# Is this compatible with other mods?

It should be. I play with a lot of mods, and this doesn't seem to
impact them at all (at least at the moment).

# Will this break my saves?

![Well yes, but actually no.](https://i.imgur.com/0ptZQLI.jpg)

Due to a bug (or perhaps merely an oversight on Boxelware's part), the
vanilla code controlling the war zone checking loads the decay
cooldown and thresholds (from what I can tell) on a per-sector basis,
and has no means to override this should those values have changed for
some reason (e.g. by this mod). Conversely, in order for this mod to
set these values for already-generated sectors, it has to override
WarZoneCheck.restore() with a version that explicitly overwrites those
values (namely: noDecayTime, warZoneThreshold, pacefulThreshold [sic],
and maxScore in self.data). Until/unless Boxelware fixes this (might I
recommend a certain mod which implements this more robustly? ;) ) or
someone (perhaps myself) adds a cleanup mod specifically for this
purpose, be aware that these changes are effectively permanent for
sectors loaded with this mod active.

All the other changes this mod makes happen in real-time and do not
involve any modification to saved data.

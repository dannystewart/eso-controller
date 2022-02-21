local Srendarr		= _G['Srendarr'] -- grab addon table from global
local L				= Srendarr:GetLocale()

-- UPVALUES --
local GetAbilityName		= GetAbilityName
local ZOSName				= function (data, mode) if mode == 1 then return zo_strformat("<<t:1>>", GetAbilityName(data)) else return zo_strformat("<<t:1>>", GetItemSetName(data)) end end
local strformat				= string.format
local sTable = {}

-- Major & Minor Effect Identifiers
local EFFECT_AEGIS				= 1
local EFFECT_BERSERK			= 2
local EFFECT_BREACH				= 3
local EFFECT_BRITTLE			= 4
local EFFECT_BRUTALITY			= 5
local EFFECT_COURAGE			= 6
local EFFECT_COWARDICE			= 7
local EFFECT_DEFILE				= 8
local EFFECT_ENDURANCE			= 9
local EFFECT_ENERVATION			= 10
local EFFECT_EVASION			= 11
local EFFECT_EXPEDITION			= 12
local EFFECT_FORCE				= 13
local EFFECT_FORTITUDE			= 14
local EFFECT_GALLOP				= 15
local EFFECT_HEROISM			= 16
local EFFECT_HINDRANCE			= 17
local EFFECT_INTELLECT			= 18
local EFFECT_LIFESTEAL			= 19
local EFFECT_MAGICKASTEAL		= 20
local EFFECT_MAIM				= 21
local EFFECT_MANGLE				= 22
local EFFECT_MENDING			= 23
local EFFECT_PROPHECY			= 24
local EFFECT_PROTECTION			= 25
local EFFECT_RESOLVE			= 26
local EFFECT_SAVAGERY			= 27
local EFFECT_SLAYER				= 28
local EFFECT_SORCERY			= 29
local EFFECT_TOUGHNESS			= 30
local EFFECT_UNCERTAINTY		= 31
local EFFECT_VITALITY			= 32
local EFFECT_VULNERABILITY		= 33

local minorEffects, majorEffects -- populated at the end of file due to how large they are (legibility reasons)


-- ------------------------
-- GENERAL DATABASE
-- ------------------------
local alteredAuraIcons = { -- used to alter the default icon for selected auras
	[135397]	= [[Srendarr/Icons/Vamp_Stage1.dds]],						-- Stage 1 Vampirism
	[135399]	= [[Srendarr/Icons/Vamp_Stage2.dds]],						-- Stage 2 Vampirism
	[135400]	= [[Srendarr/Icons/Vamp_Stage3.dds]],						-- Stage 3 Vampirism
	[135402]	= [[Srendarr/Icons/Vamp_Stage4.dds]],						-- Stage 4 Vampirism
	[23392]		= [[/esoui/art/icons/ability_mage_042.dds]],				-- Altmer Glamour
	[31272]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Arrow Spray Rank I
	[40760]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Arrow Spray Rank II
	[40763]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Arrow Spray Rank III
	[40766]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Arrow Spray Rank IV
	[38706]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Bombard Rank I
	[40770]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Bombard Rank II
	[40774]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Bombard Rank III
	[40778]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Bombard Rank IV
	[38702]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Acid Spray Rank I
	[40784]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Acid Spray Rank II
	[40788]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Acid Spray Rank III
	[40792]		= [[/esoui/art/icons/ability_debuff_snare.dds]],			-- Acid Spray Rank IV
	[59533]		= [[Srendarr/Icons/DSphere_Arcane.dds]],					-- Arcane Engine Guardian
	[59543]		= [[Srendarr/Icons/DSphere_Healthy.dds]],					-- Healthy Engine Guardian
	[59540]		= [[Srendarr/Icons/DSphere_Robust.dds]],					-- Robust Engine Guardian
	[147140]	= [[/esoui/art/icons/ability_mage_051.dds]],				-- Voidcaller Proc
	[127284]	= [[/esoui/art/icons/ability_warrior_018.dds]],				-- Ravager Proc
	[147692]	= [[/esoui/art/icons/death_recap_fire_aoe.dds]],			-- Explosive Rebuke bomb
	[159244]	= [[/esoui/art/icons/death_recap_shock_aoe2.dds]],			-- Thinder Caller Proc
	[73296]		= [[/esoui/art/icons/ability_mage_004.dds]],				-- Winterborn Snare
	[160445]	= [[/esoui/art/icons/ability_mage_047.dds]],				-- Palinal's Wrath
}

local alteredAuraData = { -- used to alter various data for selected auras
-- Warden Healing Seed (and morphs) - Game reports incorrect duration (?).
	[85845] = {unitTag = nil,			duration = 6},										-- Healing Seed
	[85840] = {unitTag = nil,			duration = 6},										-- Budding Seeds
	[85845] = {unitTag = nil,			duration = 6},										-- Corrupting Pollen
-- Alliance War Caltrops (and morphs)
	[33376] = {unitTag = nil,			duration = GetAbilityDuration(33376) / 1000 + 1},	-- Caltrops
	[40255] = {unitTag = nil,			duration = GetAbilityDuration(40255) / 1000 + 1},	-- Anti-Cavalry Caltrops
	[40242] = {unitTag = nil,			duration = GetAbilityDuration(40242) / 1000 + 1},	-- Razor Caltrops
-- Sorcerer Haunting Curse 2nd Proc
	[89491] = {unitTag = 'groundaoe',	duration = GetAbilityDuration(89491) / 1000},		-- Haunting Curse
}

local refreshAuras = { -- special cases where a variable duration aura needs to have its values populated manually using GetUnitBuffInfo (Phinix)
	[93109] = true,
}

local catchTriggers = { -- used for certain morphs of abilities that send the wrong ID for stack building
	[61905] = 61902,		-- Grim Focus I
}

local fakeAuras = { -- used to spawn fake auras to handle mismatch of information provided by the API to what user's want|need
-- Templar Cleansing Ritual AOE (and morphs)
	[ZOSName(22265,1)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(22265) / 1000,	abilityID = 22265},	-- Cleansing Ritual
	[ZOSName(22259,1)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(22259) / 1000,	abilityID = 22259},	-- Ritual of Retribution
	[ZOSName(22262,1)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(22262) / 1000,	abilityID = 22262},	-- Extended Ritual
-- Warden Scorch AOE (and morphs)
	[ZOSName(86009,1)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86009) / 1000,	abilityID = 86009},	-- Scorch
	[ZOSName(86019,1)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86019) / 1000,	abilityID = 86019},	-- Subterranean Assault
	[ZOSName(86015,1)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86015) / 1000,	abilityID = 86015},	-- Deep Fissure
-- Nightblade Summon Shade (and morphs)
	[ZOSName(33211,1)] = {unitTag = 'player', duration = GetAbilityDuration(33211) / 1000,		abilityID = 33211},	-- Summon Shade
	[ZOSName(35434,1)] = {unitTag = 'player', duration = GetAbilityDuration(35434) / 1000,		abilityID = 35434},	-- Dark Shades
	[ZOSName(35441,1)] = {unitTag = 'player', duration = GetAbilityDuration(35441) / 1000,		abilityID = 35441},	-- Shadow Image
-- Sorcerer Daedric Curse (and morphs)
	[ZOSName(24326,1)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(24326) / 1000,	abilityID = 24326},	-- Daedric Curse
	[ZOSName(24328,1)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(24328) / 1000,	abilityID = 24328},	-- Daedric Prey
	[ZOSName(24330,1)] = {unitTag = 'groundaoe', duration = 3.5, 								abilityID = 24330},	-- Haunting Curse (lower rank?)
	[ZOSName(24331,1)] = {unitTag = 'groundaoe', duration = 3.5, 								abilityID = 24331},	-- Haunting Curse
--Auridon Mallari-Mora quest ghost avoidance buff
	[ZOSName(21403,1)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(21403) / 1000,	abilityID = 21403},	-- ghost avoidance buff
}

local debuffAuras = { -- used to fix game bug where certain debuffs (mostly set procs) are tracked as buffs instead
	[60416] = true,		-- Sunderflame special case to show properly as debuff
	[81519] = true,		-- Infallible Aether special case to show properly as debuff
	[69143] = true,		-- Dodge Fatigue
	[51392] = true,		-- Bolt Escape Fatigue
	[147692] = true,	-- Explosive Rebuke bomb
}

local alternateAura = { -- used by the consolidate multi-aura function
	[26213] = {altName = ZOSName(26207,1), unitTag = 'player'}, -- Display "Restoring Aura" instead of all three auras
	[76420] = {altName = ZOSName(34080,1), unitTag = 'player'}, -- Display "Flames of Oblivion" instead of both auras
}

local procAbilityNames = { -- using names rather than IDs to ease matching multiple IDs to multiple different IDs
	[ZOSName(46327,1)] = false,	-- Crystal Fragments -- special case, controlled by the actual aura
	[ZOSName(61907,1)] = true,		-- Assassin's Will
	[ZOSName(62128,1)] = true,		-- Assassin's Scourge
	[ZOSName(23903,1)] = true,		-- Power Lash
	[ZOSName(62549,1)] = true,		-- Deadly Throw
}

local toggledAuras = { -- there is a separate abilityID for every rank of a skill
	[23316] = true,			-- Volatile Familiar
	[23304] = true,			-- Unstable Familiar
	[23319] = true,			-- Unstable Clannfear
	[24613] = true,			-- Summon Winged Twilight
	[24639] = true,			-- Summon Twilight Matriarch
	[24636] = true,			-- Summon Twilight Tormentor
	[61529] = true,			-- Stalwart Guard
	[61536] = true,			-- Mystic Guard
	[36908] = true,			-- Leeching Strikes
	[61511] = true,			-- Guard
	[24158] = true,			-- Bound Armor
	[24165] = true,			-- Bound Armaments
	[24163] = true,			-- Bound Aegis
	[916007] = true,		-- Sample Aura (FAKE)
	[916008] = true,		-- Sample Aura (FAKE)
}


-- ------------------------
-- COMBAT_EVENT FILTERS
-- ------------------------
local releaseTriggers = { -- special case used to detect release events which should cancel active auras
-- Defensive Rune release
	[24576] = {release = 24574},	-- Defensive Rune I Release
	[62294] = {release = 24574},	-- Defensive Rune II Release
	[62298] = {release = 24574},	-- Defensive Rune III Release
	[62299] = {release = 24574},	-- Defensive Rune IV Release
-- Nightblade Grim Focus (and morphs)
--	[61907] = {release = 61902},	-- Grim Focus
--	[61932] = {release = 61927},	-- Relentless Focus
--	[61930] = {release = 61919},	-- Merciless Resolve
-- Essence Thief
	[70290] = {release = 67308},	-- Essence Thief pool collection
-- Explosive Rebuke
	[147694] = {release = 147692},	-- Explosive Rebuke heavy attack detonation
-- Beast Trap (target dies cancel AOE)
	[35756] = {release = 40372},	-- Beast Trap
	[40385] = {release = 40382},	-- Barbed Trap
	[40375] = {release = 40372},	-- Lightweight
-- Fire Rune (rune triggered cancel AOE)
	[31633] = {release = 31632},	-- Fire Rune
	[40467] = {release = 40465},	-- Scalding Rune
	[40472] = {release = 40470},	-- Volcanic Rune
-- Grisly Gourmet Sweetroll
	[159298] = {release = 159289},	-- Consumption
-- Scorion's Feast
	[159236] = {release = 159237},	-- Overflow Aura
-- Vengeful Soul (Sul-Xan's Torment)
	[154737] = {release = 154720},	-- Soul Collected
-- Foolkiller
	[151135] = {release = 4151126},	-- Shield pop
-- Grave Strake
	[113237] = {release = 113181},	-- Collection
	[113185] = {release = 113181},	-- Collection (backup)
-- Haven of Ursus
	[111440] = {release = 111442},	-- Haven of Ursus synergy activation
	[112414] = {release = 4111442}, -- Haven of Ursus (test)
}

local enchantProcs = { -- used to spawn fake auras to handle enchant procs the game doesn't track
-- Weapon enchant procs
	[21230] = {unitTag = 'player', duration = GetAbilityDuration(21230) / 1000, icon = '/esoui/art/icons/ability_rogue_006.dds'},			-- Weapon/spell power enchant (Berserker)
	[17906] = {unitTag = 'player', duration = GetAbilityDuration(17906) / 1000, icon = '/esoui/art/icons/ability_armor_001.dds'},			-- Reduce spell/physical resist (Crusher)
	[21578] = {unitTag = 'player', duration = GetAbilityDuration(21578) / 1000, icon = '/esoui/art/icons/ability_healer_029.dds'},			-- Damage shield enchant (Hardening)
}

local specialNames = { -- special database for name-swapping custom auras the game doesn't track or name correctly
-- Changes Kena 1st hit tracker from "Molag Kena" to "Molag Kena 1st Hit"
	[66808]		= {name = ZOSName(66808,1)..L.MolagKenaHit1},
-- Changes Sorcerer Summon Volatile Familiar active ability "to Volatile Familiar AOE"
	[88933]		= {name = L.VolatileAOE}, 
-- Swaps Aggressive Warhorn Major Force to say "Major Force"
	[46522]		= {name = ZOSName(40225,1)},
	[46533]		= {name = ZOSName(40225,1)},
	[46536]		= {name = ZOSName(40225,1)},
	[46539]		= {name = ZOSName(40225,1)},
-- Swaps Templar Sun Fire (and morphs) Major Prophecy buff to read as "Major Prophecy"
	[21726]		= {name = ZOSName(47193,1)},
	[24160]		= {name = ZOSName(47193,1)},
	[24167]		= {name = ZOSName(47193,1)},
	[24171]		= {name = ZOSName(47193,1)},
	[21729]		= {name = ZOSName(47193,1)},
	[24174]		= {name = ZOSName(47193,1)},
	[24177]		= {name = ZOSName(47193,1)},
	[24180]		= {name = ZOSName(47193,1)},
	[21732]		= {name = ZOSName(47193,1)},
	[24184]		= {name = ZOSName(47193,1)},
	[24187]		= {name = ZOSName(47193,1)},
	[24195]		= {name = ZOSName(47193,1)},
-- Changes duplicate Bombard snare effect to "Snare 40%"
	[38706]		= {name = ZOSName(48502,1).." 40%"},	-- Bombard Rank I
	[40770]		= {name = ZOSName(48502,1).." 40%"},	-- Bombard Rank II
	[40774]		= {name = ZOSName(48502,1).." 40%"},	-- Bombard Rank III
	[40778]		= {name = ZOSName(48502,1).." 40%"},	-- Bombard Rank IV
-- Cooldown tracker proc auras reverted to original name rather than copying cooldown name (Phinix)
	[135926]	= {name = ZOSName(135926,1)},	-- Vrol's Command Major Aegis effect
	[137989]	= {name = ZOSName(137989,1)},	-- Vrol's Command (Perfected) Major Aegis effect
	[147417]	= {name = ZOSName(147417,1)},	-- Claw of Yolnakhriin Major Minor Courage
	[159237]	= {name = ZOSName(159237,1)},	-- Scorion's Feast Imbued Aura
	[71193]		= {name = ZOSName(71193,1)},	-- Para Bellum
	[106804]	= {name = ZOSName(106804,1)},	-- Nocturnal's Heal
	[59590]		= {name = ZOSName(59591,1)},	-- Bogdan Totem
	[151033]	= {name = ZOSName(151033,1)},	-- Encratis' Behemoth
	[141905]	= {name = ZOSName(141905,1)},	-- Lady Thorn
	[59497]		= {name = ZOSName(59498,1)},	-- Mephala's Web
-- Combines aura names to make "Stonekeeper Charging"
	[116839]	= {name = ZOSName(116846,1).." "..ZOSName(116839,1)},
-- Changes "Nikulas' Heavy Armor" to "Nikulas' Resolve"
	[160263]	= {name = ZOSName(160262,1)},
}

local fakeTargetDebuffs = { -- used to spawn fake auras to handle invisible debuffs on current target
-- Special case for Fighters Guild Beast Trap (and morph) tracking
	[35754] = {duration = GetAbilityDuration(35754) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004.dds'}, 				-- Trap Beast I
	[42712] = {duration = GetAbilityDuration(42712) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004.dds'}, 				-- Trap Beast II
	[42719] = {duration = GetAbilityDuration(42719) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004.dds'}, 				-- Trap Beast III
	[42726] = {duration = GetAbilityDuration(42726) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004.dds'}, 				-- Trap Beast IV
	[40389] = {duration = GetAbilityDuration(40389) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_a.dds'}, 			-- Rearming Trap I
	[42731] = {duration = GetAbilityDuration(42731) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_a.dds'}, 			-- Rearming Trap II
	[42741] = {duration = GetAbilityDuration(42741) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_a.dds'}, 			-- Rearming Trap III
	[42751] = {duration = GetAbilityDuration(42751) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_a.dds'}, 			-- Rearming Trap IV
	[40376] = {duration = GetAbilityDuration(40376) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_b.dds'}, 			-- Lightweight Beast Trap I
	[42761] = {duration = GetAbilityDuration(42761) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_b.dds'}, 			-- Lightweight Beast Trap II
	[42768] = {duration = GetAbilityDuration(42768) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_b.dds'}, 			-- Lightweight Beast Trap III
	[42775] = {duration = GetAbilityDuration(42775) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_b.dds'}, 			-- Lightweight Beast Trap IV
-- Wise Mage special case for target vulnerability proc
	[51434] = {duration = GetAbilityDuration(51434) / 1000, icon = '/esoui/art/icons/ability_debuff_minor_vulnerability.dds'},		-- Wise Mage
-- AOE/snare effects
	[69950] = {duration = GetAbilityDuration(69950) / 1000, icon = '/esoui/art/icons/death_recap_magic_aoe.dds'}, 					-- Desecrated Ground (Zombie Snare)
	[60402] = {duration = GetAbilityDuration(60402) / 1000, icon = '/esoui/art/icons/ability_warrior_015.dds'},						-- Ensnare
	[39060] = {duration = GetAbilityDuration(39060) / 1000, icon = '/esoui/art/icons/ability_debuff_root.dds'},						-- Bear Trap
	[63168] = {duration = GetAbilityDuration(63168) / 1000, icon = '/esoui/art/icons/ability_dragonknight_010.dds'},				-- Guard: Cage Talons
}

local stackingAuras = { -- used to track stacks on auras like Hawk Eye (Phinix)
-- rTimer means each tick resets the stack timer
-- proc is the stack number the aura will cause an additional effect if any
-- picon is an icon to change to if the aura has a proc as described above (this is optional)
-- Weapon & Armor Sets

	[111387]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Blood Moon														*
	[155176]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Death Dealer's Fete Mythic										*
	[129407]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Dragonguard Elite												*
	[155150]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Harpooner's Wading Kilt Mythic (Hunter's Focus)					*
	[133505]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Kjalnar's Nightmare (Monster Set)								*
	[127280]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Ravager (PVP)													*
	[126535]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Renald's Resolve Set												*
	[51176]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Two-Fanged/Twice-Fanged Snake/Serpent Set						*
	[116742]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Tzogvin's Warband Set											*
	[147141]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Voidcaller														*

	[110118]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Mantle of Siroria (uses same for Perfected)									*
	[136123]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = false},	-- Thrassian Stranglers Mythic													*
	[135950]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Yandir's Might (Giant's Endurance)											*
	[50978]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Berserking Warrior (advancing yokeda)										*
	[107203]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Arms of Relequen (same for Perfected)										*
	[100306]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Asylum Destruction Staff Concentrated Force									*
	[99989]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Asylum Destruction Staff Concentrated Force (Perfected)						*
	[152673]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Baron Zaudrus (Monster Set)													*
	[145199]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Stone Husk (Monster Set) "Husk Drain" stacking aura							*
	[116839]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Stonekeeper Monster Set														*
	[147701]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Frenzied Momentum (Vateshran 2H Weapon)										*
	[79421]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Galerion's Revenge															*
	[155390]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Glorgoloch the Destroyer (Monster Set)										*
	[137126]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Dragon's Appetite															*
	[150750]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Kinras's Wrath																*
	[159262]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Grisly Gourmet																*
	[159372]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Realm Shaper																	*
	[163376]	= {start = 2,	proc = 0, picon = nil, base = true, rTimer = true},		-- Belharaza's Temper															*
	[79200]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Sithis Touch																	*
	[129442]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Senchal's Duty																*
	[160262]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Nikulas' Resolve																*
	[126631]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Blight Seed																	*
	[99204]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Mechanical Acuity															*
	[160443]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Palinal's Wrath																*
	[100474]	= {start = 1,	proc = 5, picon = '/esoui/art/icons/ability_mage_049.dds', base = true, rTimer = true}, -- Chaotic Whirlwind (Asylum Dual Wield)		*
-- Abilities & Passives
	[51392]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Bolt Escape Fatigue
	[69143]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Dodge Fatigue
	[122658]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Dragon Knight Seething Fury
	[78854]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Hawk Eye (Bow) Lvl 1
	[78855]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Hawk Eye (Bow) Lvl 2
	[103820]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Psijic Spell Orb
	[130293]	= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Sorcerer Bound Armaments
	[76950]		= {start = 1,	proc = 0, picon = nil, base = true, rTimer = true},		-- Warrior's Fury
	[128494]	= {start = 20,	proc = 0, picon = nil, base = true, rTimer = true},		-- Warrior's Fury
-- Nightblade Grim Focus (and morphs)
--	[61902]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Grim Focus
--	[61927]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Relentless Focus
--	[61919]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Merciless Resolve
	[61903]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Grim Focus Lvl 1
	[62091]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Grim Focus Lvl 2
	[64177]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Grim Focus Lvl 3
	[62097]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Grim Focus Lvl 4
	[61928]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Relentless Focus Lvl 1
	[62100]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Relentless Focus Lvl 2
	[62104]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Relentless Focus Lvl 3
	[62108]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Relentless Focus Lvl 4
	[61920]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Merciless Resolve Lvl 1
	[62112]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Merciless Resolve Lvl 2
	[62115]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Merciless Resolve Lvl 3
	[62118]		= {start = 0,	proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Merciless Resolve Lvl 4
}

local cdTex = { -- used just to save space so abilityCooldowns and specialProcs tables are more readable (Phinix)
-- abilityCooldowns icons
	[147692]	= '/esoui/art/icons/death_recap_fire_aoe.dds',
	[74106]		= '/esoui/art/icons/ability_mage_066.dds',
	[71647]		= '/esoui/art/icons/death_recap_cold_aoe.dds',
	[121914]	= '/esoui/art/icons/pet_251_coldharbourbantam.dds',
	[134104]	= '/esoui/art/icons/ability_healer_002.dds',
	[164087]	= '/esoui/art/icons/gear_clockwork_medium_head_a.dds',
	[113092]	= '/esoui/art/icons/death_recap_oblivion.dds',
	[92774]		= '/esoui/art/icons/ability_mage_022.dds',
	[92775]		= '/esoui/art/icons/ability_mage_022.dds',
	[92771]		= '/esoui/art/icons/ability_mage_022.dds',
	[92773]		= '/esoui/art/icons/ability_mage_022.dds',
	[92776]		= '/esoui/art/icons/ability_mage_022.dds',
	[133493]	= '/esoui/art/icons/death_recap_bleed.dds',
	[84277]		= '/esoui/art/icons/gear_mazzatun_heavy_head_a.dds',
	[111386]	= '/esoui/art/icons/store_werewolfbite_01.dds',
	[102027]	= '/esoui/art/icons/death_recap_fire_ranged.dds',
	[102032]	= '/esoui/art/icons/death_recap_cold_ranged.dds',
	[102033]	= '/esoui/art/icons/death_recap_disease_ranged.dds',
	[102034]	= '/esoui/art/icons/death_recap_shock_ranged.dds',
	[159291]	= '/esoui/art/icons/ability_debuff_minor_fracture.dds',
	[97538]		= '/esoui/art/icons/gear_falkreath_light_head_a.dds',
	[67298]		= '/esoui/art/icons/ability_mage_043.dds',
	[99144]		= '/esoui/art/icons/ability_mage_011.dds',
	[97908]		= '/esoui/art/icons/ability_mage_038.dds',
	[84354]		= '/esoui/art/icons/ability_undaunted_003.dds',
	[111442]	= '/esoui/art/icons/ability_warden_018_c.dds',
	[112414]	= '/esoui/art/icons/ability_mage_047.dds',
	[126924]	= '/esoui/art/icons/ability_healer_031.dds',
	[117666]	= '/esoui/art/icons/ability_mage_050.dds',
	[97627]		= '/esoui/art/icons/u15dlc_bullet_5220.dds',
	[142816]	= '/esoui/art/icons/achievement_u26_skyrim_werewolfdevour100.dds',
	[34813]		= '/esoui/art/icons/ability_mage_007.dds',
	[116805]	= '/esoui/art/icons/ability_mage_050.dds',
	[57206]		= '/esoui/art/icons/ability_healer_017.dds',
	[97714]		= '/esoui/art/icons/gear_falkreath_medium_head_a.dds',
	[102106]	= '/esoui/art/icons/ability_mage_019.dds',
	[159279]	= '/esoui/art/icons/death_recap_melee_basic.dds',
	[159380]	= '/esoui/art/icons/death_recap_magic_ranged.dds',
	[159244]	= '/esoui/art/icons/ability_skeevatonshockfield.dds',
	[101970]	= '/esoui/art/icons/ability_buff_major_endurance.dds',
	[57163]		= '/esoui/art/icons/ability_mage_044.dds',
	[151135]	= '/esoui/art/icons/ability_mage_062.dds',
	[67205]		= '/esoui/art/icons/ability_rogue_022.dds',
	[85978]		= '/esoui/art/icons/ability_healer_029.dds',
	[59590]		= '/esoui/art/icons/gear_undaunted_titan_head_a.dds',
	[81069]		= '/esoui/art/icons/gear_undaunted_strangler_heavy_head_a.dds',
	[97882]		= '/esoui/art/icons/gear_undauntedminotaur_a.dds',
	[97855]		= '/esoui/art/icons/gear_undaunted_ironatronach_head_a.dds',
	[126687]	= '/esoui/art/icons/ability_healer_019.dds',
	[80527]		= '/esoui/art/icons/death_recap_shock_aoe.dds',
	[141905]	= '/esoui/art/icons/ability_u23_bloodball_chokeonit.dds',
	[59587]		= '/esoui/art/icons/gear_undauntedgrievoust_head_a.dds',
	[161527]	= '/esoui/art/icons/ability_buff_minor_resolve.dds',
	[59568]		= '/esoui/art/icons/gear_undauntedharvester_head_a.dds',
	[59508]		= '/esoui/art/icons/gear_undaunted_daedroth_head_a.dds',
	[59594]		= '/esoui/art/icons/ability_mage_051.dds',
	[98421]		= '/esoui/art/icons/ability_rogue_022.dds',
	[160839]	= '/esoui/art/icons/gear_undauntedspider_head_a.dds',
	[80545]		= '/esoui/art/icons/gear_undauntedlamia_head_a.dds',
	[81036]		= '/esoui/art/icons/gear_undauntedcenturion_head_a.dds',
	[80954]		= '/esoui/art/icons/gear_undauntedclannfear_head_a.dds',
	[59497]		= '/esoui/art/icons/gear_undauntedspiderdaedra_head_a.dds',
	[116881]	= '/esoui/art/icons/achievement_update16_025.dds',
	[80523]		= '/esoui/art/icons/gear_undauntedstormatronach_head_a.dds',
	[102093]	= '/esoui/art/icons/gear_undaunted_fanglair_head_a.dds',
	[102093]	= '/esoui/art/icons/gear_undaunted_fanglair_head_a.dds',
	[80487]		= '/esoui/art/icons/gear_undaunted_hoarvordaedra_head_a.dds',
	[102136]	= '/esoui/art/icons/gear_undaunted_dragonpriest_shoulder_a.dds',
	[61716]		= '/esoui/art/icons/ability_rogue_060.dds',
	[75691]		= '/esoui/art/icons/ability_mage_028.dds',
	[93308]		= '/esoui/art/icons/quest_head_monster_020.dds',
	[92982]		= '/esoui/art/icons/quest_head_monster_007.dds',
	[97806]		= '/esoui/art/icons/death_recap_fire_ranged.dds',
	[71664]		= '/esoui/art/icons/gear_orc_heavy_head_d.dds',
	[135659]	= '/esoui/art/icons/ability_mage_013.dds',
	[34522]		= '/esoui/art/icons/ability_mage_026.dds',
	[163044]	= '/esoui/art/icons/ability_mage_042.dds',
	[163060]	= '/esoui/art/icons/ability_debuff_major_maim.dds',
	[163062]	= '/esoui/art/icons/ability_debuff_major_maim.dds',
	[163064]	= '/esoui/art/icons/ability_debuff_major_maim.dds',
	[163065]	= '/esoui/art/icons/ability_debuff_major_maim.dds',
	[163066]	= '/esoui/art/icons/ability_debuff_major_maim.dds',
	[159388]	= '/esoui/art/icons/death_recap_magic_aoe.dds',
	[70492]		= '/esoui/art/icons/ability_mage_070.dds',
	[113382]	= '/esoui/art/icons/ability_mage_063.dds',
	[115771]	= '/esoui/art/icons/ability_warrior_027.dds',
	[111575]	= '/esoui/art/icons/ability_warrior_020.dds',
	[51443]		= '/esoui/art/icons/ability_mage_014.dds',
	[136098]	= '/esoui/art/icons/ability_healer_015.dds',
	[75814]		= '/esoui/art/icons/ability_mage_058.dds',
	[110067]	= '/esoui/art/icons/ability_mage_062.dds',
	[135923]	= '/esoui/art/icons/procs_006.dds',
	[107141]	= '/esoui/art/icons/ability_mage_045.dds',
	[163375]	= '/esoui/art/icons/mythic_ring_belharzas_band.dds',
	[75726]		= '/esoui/art/icons/ability_mage_067.dds',

-- specialProcs icons
	[113181]	= '/esoui/art/icons/ability_mage_020.dds',
	[159289]	= '/esoui/art/icons/crowncrate_sweetroll.dds',
	[159319]	= '/esoui/art/icons/ability_buff_major_empower.dds',
	[49220]		= '/esoui/art/icons/ability_dragonknight_023.dds',
	[67308]		= '/esoui/art/icons/ability_mage_043.dds',
	[95932]		= '/esoui/art/icons/ability_templar_sun_strike.dds',
	[95956]		= '/esoui/art/icons/ability_templar_light_strike.dds',
	[44445]		= '/esoui/art/icons/ability_templarsun_thrust.dds',
	[126475]	= '/esoui/art/icons/ability_2handed_003_a.dds',
	[46522]		= '/esoui/art/icons/ability_ava_003_a.dds',
	[46533]		= '/esoui/art/icons/ability_ava_003_a.dds',
	[46536]		= '/esoui/art/icons/ability_ava_003_a.dds',
	[46539]		= '/esoui/art/icons/ability_ava_003_a.dds',
	[63430]		= '/esoui/art/icons/ability_mageguild_005.dds',
	[63456]		= '/esoui/art/icons/ability_mageguild_005_b.dds',
	[63473]		= '/esoui/art/icons/ability_mageguild_005_a.dds',
	[32788]		= '/esoui/art/icons/ability_dragonknight_012_b.dds',
	[9237]		= '/esoui/art/icons/crafting_poisonmaking_reagent_fleshfly_larva.dds',
	[10392]		= '/esoui/art/icons/pet_mephalawasp.dds',
	[154720]	= '/esoui/art/icons/u30_trial_soulrip.dds',
}

local aR = { -- table of action results for future proofing in rare case numbers change globals shouldn't (Phinix)
	[2240]	= ACTION_RESULT_EFFECT_GAINED,
--	[2245]	= ACTION_RESULT_EFFECT_GAINED_DURATION,
--	[128]	= ACTION_RESULT_POWER_ENERGIZE,
	[16]	= ACTION_RESULT_HEAL,
--	[32]	= ACTION_RESULT_CRITICAL_HEAL,
--	[1]		= ACTION_RESULT_DAMAGE,
--	[2]		= ACTION_RESULT_CRITICAL_DAMAGE,
}

local specialProcs = { -- special cases requiring hidden EVENT_COMBAT_EVENT ID's to track properly
-- Armor set procs	
	[145199]	= {unitTag = 'player',			iH = nil,	altDuration = 0,		altName = nil,				bar = false,	altIcon = nil},				-- Stone Husk Monster Set "Husk Drain" stacking buff				*
	[109976]	= {unitTag = 'player',			iH = nil,	altDuration = nil,		altName = nil,				bar = false,	altIcon = nil},				-- Aegis of Galenwe													*
	[97896]		= {unitTag = 'player',			iH = nil,	altDuration = 0,		altName = nil,				bar = false,	altIcon = nil},				-- Domihaus AOE passive												*
	[106798]	= {unitTag = 'reticleover',		iH = nil,	altDuration = 6,		altName = nil,				bar = false,	altIcon = nil},				-- Sload's Embrace													*
	[113181]	= {unitTag = 'groundaoe',		iH = nil,	altDuration = 6,		altName = nil,				bar = false,	altIcon = cdTex[113181]},	-- Grave Strake proc												*
	[159289]	= {unitTag = 'groundaoe',		iH = nil,	altDuration = 5,		altName = nil,				bar = false,	altIcon = cdTex[159289]},	-- Grisly Gourmet Sweetroll Consumption								*
	[159319]	= {unitTag = 'player',			iH = nil,	altDuration = 10,		altName = ZOSName(61737,1),	bar = false,	altIcon = cdTex[159319]},	-- Grisly Gourmet Empower proc										*
	[49220]		= {unitTag = 'groundaoe',		iH = nil,	altDuration = nil,		altName = nil,				bar = false,	altIcon = cdTex[49220]},	-- Crusader AOE proc												*
	[154720]	= {unitTag = 'groundaoe',		iH = nil,	altDuration = nil,		altName = nil,				bar = false,	altIcon = cdTex[154720]},	-- Sul-Xan's TormentVengeful Soul AOE								*
	[67308]		= {unitTag = 'groundaoe',		iH = nil,	altDuration = 5,		altName = nil,				bar = false,	altIcon = cdTex[67308]},	-- Essence Thief proc pool AOE										*
	
-- Ability bar procs
	[95932]		= {unitTag = 'groundaoe',		iH = nil,	altDuration = nil,		altName = nil,				bar = true,		altIcon = cdTex[95932]},	-- Templar Spear Shards
	[95956]		= {unitTag = 'groundaoe',		iH = nil,	altDuration = nil,		altName = nil,				bar = true,		altIcon = cdTex[95956]},	-- Templar Luminous Shards
	[44445]		= {unitTag = 'groundaoe',		iH = nil,	altDuration = nil,		altName = nil,				bar = true,		altIcon = cdTex[44445]},	-- Templar Blazing Spear
	[126475]	= {unitTag = 'groundaoe',		iH = nil,	altDuration = nil,		altName = nil,				bar = true,		altIcon = cdTex[126475]},	-- 2H Stampede AOE
	[46522]		= {unitTag = 'player',			iH = nil,	altDuration = nil,		altName = nil, 				bar = true,		altIcon = cdTex[46522]},	-- Aggressive Warhorn Major Force Lvl 4
	[46533]		= {unitTag = 'player',			iH = nil,	altDuration = nil,		altName = nil, 				bar = true,		altIcon = cdTex[46533]},	-- Aggressive Warhorn Major Force Lvl 4
	[46536]		= {unitTag = 'player',			iH = nil,	altDuration = nil,		altName = nil, 				bar = true,		altIcon = cdTex[46536]},	-- Aggressive Warhorn Major Force Lvl 4
	[46539]		= {unitTag = 'player',			iH = nil,	altDuration = nil,		altName = nil, 				bar = true,		altIcon = cdTex[46539]},	-- Aggressive Warhorn Major Force Lvl 4
	[63430]		= {unitTag = 'groundaoe',		iH = nil,	altDuration = 13.4,		altName = nil,				bar = true,		altIcon = cdTex[63430]},	-- Meteor
	[63456]		= {unitTag = 'groundaoe',		iH = nil,	altDuration = 13.4,		altName = nil,				bar = true,		altIcon = cdTex[63456]},	-- Ice Comet 
	[63473]		= {unitTag = 'groundaoe',		iH = nil,	altDuration = 13.4,		altName = nil,				bar = true,		altIcon = cdTex[63473]},	-- Shooting Star
	[146919]	= {unitTag = 'player',			iH = nil,	altDuration = 3,		altName = nil,				bar = true,		altIcon = nil},				-- Warden Subterranean Assault
	[32788]		= {unitTag = 'player',			iH = nil,	altDuration = nil,		altName = nil,				bar = true,		altIcon = cdTex[32788]},	-- DK Inhale Hit Timer (Draw Essence)

-- Random procs
	[9237]		= {unitTag = 'player',			iH = nil,	altDuration = 10,		altName = nil,				bar = false,	altIcon = cdTex[9237]},		-- Larva Gestation (Young Wasp)
	[10392]		= {unitTag = 'player',			iH = nil,	altDuration = 180,		altName = L.YoungWasp,		bar = false,	altIcon = cdTex[10392]},	-- Larva Burst (Young Wasp)
--	[65541]		= {unitTag = 'player',			iH = nil,	altDuration = nil,		altName = nil,				bar = false,	altIcon = nil},				-- Empower (mage guild)
--	[57170]		= {unitTag = 'player',			iH = nil,	altDuration = nil,		altName = nil,				bar = false,	altIcon = nil},				-- Blood Frenzy (?)													
}

local abilityCooldowns = { -- assign cooldown tracker to a display frame to monitor ability cooldowns
--Values: (Phinix)
-- cooldown		= how often the set can proc.
-- hasTimer		= whether the set proc effect needs an additional timer separate from the cooldown, for buffs the game does not show by default.
-- altDuration	= duration of the above proc buff effect. nil unless GetAbilityDuration(ID) / 1000 is not correct, then input in seconds.
-- altName		= used when GetAbilityName(ID) for the trigger event of the set proc doesn't match the set name or anything identifiable.
-- altIcon		= used to give the cooldown a different icon, used mainly when GetAbilityIcon(ID) for the trigger event uses a boring default icon. 
-- unitTag		= used to determine the type of effect of the additional proc timer when hasTimer is true.
-- cdE			= 1 requires EVENT_COMBAT_EVENT to track procs the game does not normally show, otherwise use EVENT_EFFECT_CHANGED.
-- s1/s2		= internal game setID of the normal/perfected version of a gear piece used for various checks and naming purposes.
-- iH			= result code for initial hit used to avoid resetting the cooldown on subsequent ticks/effects. most can be nil, but some like Skoria need this.
-- cdTex		= custom texture

-- * = created/verified, and manually tested on PTS November 2021 by Phinix

-- Arena Sets
	[127081]	= {s1 = 215,	s2 = 0, 	cdE = 0, cooldown = 4,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Elemental Succession (flame)						*
	[127084]	= {s1 = 215,	s2 = 0, 	cdE = 0, cooldown = 4,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Elemental Succession (shock)						*
	[127088]	= {s1 = 215,	s2 = 0, 	cdE = 0, cooldown = 4,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Elemental Succession (frost)						*
	[147692]	= {s1 = 544,	s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = true,	altDuration = 10,	altName = nil,				altIcon = cdTex[147692],	unitTag = 'reticleover'},	-- Explosive Rebuke									*
	[147675]	= {s1 = 542,	s2 = 0, 	cdE = 0, cooldown = 8,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Hex Siphon										*
	[71188]		= {s1 = 213,	s2 = 0, 	cdE = 0, cooldown = 13,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Glorious Defender (Maelstrom Arena Set)			*
	[74106]		= {s1 = 216,	s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[74106],		unitTag = 'player'},		-- Hunt Leader (Maelstrom Arena Set)				*
	[71193]		= {s1 = 214,	s2 = 0, 	cdE = 0, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(214,2),	altIcon = nil,				unitTag = 'player'},		-- Para Bellum										*
	[71647]		= {s1 = 217,	s2 = 0, 	cdE = 1, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[71647],		unitTag = 'groundaoe'},		-- Winterborn (Maelstrom Arena Set)					*
	[147843]	= {s1 = 561,	s2 = 567, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = 10,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Wrath of Elements (Vateshran Destruction Staff)	*
	[147872]	= {s1 = 562,	s2 = 568, 	cdE = 1, cooldown = 10,		iH = aR[2240],	hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Force Overflow (Vateshran Restoration Staff)		*
	[147747]	= {s1 = 558,	s2 = 564, 	cdE = 1, cooldown = 13,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Void Bash (Vateshran 1h&shield)					*

-- Crafted Sets
	[34502]		= {s1 = 54,		s2 = 0, 	cdE = 1, cooldown = 4,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Ashen Grip										*
	[121914]	= {s1 = 437,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[121914],	unitTag = 'player'},		-- Coldharbour's Favorite							*
	[129536]	= {s1 = 468,	s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(468,2),	altIcon = nil,				unitTag = 'player'},		-- Daring Corsair									*
	[134104]	= {s1 = 482,	s2 = 0, 	cdE = 1, cooldown = 21,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[134104],	unitTag = 'player'},		-- Dauntless Combatant								*
	[33764]		= {s1 = 37,		s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Death's Wind										*
	[164087]	= {s1 = 353,	s2 = 0, 	cdE = 1, cooldown = 25,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[164087],	unitTag = 'player'},		-- Mechanical Acuity								*
	[71671]		= {s1 = 219,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Morkuldin										*
	[113307]	= {s1 = 409,	s2 = 0, 	cdE = 1, cooldown = 6,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(409,2),	altIcon = nil,				unitTag = 'player'},		-- Naga Shaman										*
	[61781]		= {s1 = 176,	s2 = 0, 	cdE = 0, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Noble's Conquest									*
	[106804]	= {s1 = 387,	s2 = 0, 	cdE = 0, cooldown = 5,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(387,2),	altIcon = nil,				unitTag = 'player'},		-- Nocturnal's Favor								*
	[113092]	= {s1 = 386,	s2 = 0, 	cdE = 1, cooldown = 6,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[113092],	unitTag = 'player'},		-- Sload's Semblance								*
--	[34587]		= {s1 = 81,		s2 = 0, 	cdE = 1, cooldown = 3,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Song of Lamae									*
	[69685]		= {s1 = 74,		s2 = 0, 	cdE = 1, cooldown = 30,		iH = nil,		hasTimer = true,	altDuration = 30,	altName = ZOSName(74,2),	altIcon = nil,				unitTag = 'player'},		-- Spectre's Eye									*
	[134094]	= {s1 = 481,	s2 = 0, 	cdE = 1, cooldown = 14,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(481,2),	altIcon = nil,				unitTag = 'player'},		-- Unchained Aggressor								*
	[49236]		= {s1 = 41,		s2 = 0, 	cdE = 0, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Whitestrake's Retribution						*
	[92774]		= {s1 = 324,	s2 = 0, 	cdE = 1, cooldown = 9,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(324,2),	altIcon = cdTex[92774],		unitTag = 'player'},		-- Daedric Trickery									*
	[92775]		= {s1 = 324,	s2 = 0, 	cdE = 1, cooldown = 9,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(324,2),	altIcon = cdTex[92775],		unitTag = 'player'},		-- Daedric Trickery									*
	[92771]		= {s1 = 324,	s2 = 0, 	cdE = 1, cooldown = 9,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(324,2),	altIcon = cdTex[92771],		unitTag = 'player'},		-- Daedric Trickery									*
	[92773]		= {s1 = 324,	s2 = 0, 	cdE = 1, cooldown = 9,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(324,2),	altIcon = cdTex[92773],		unitTag = 'player'},		-- Daedric Trickery									*
	[92776]		= {s1 = 324,	s2 = 0, 	cdE = 1, cooldown = 9,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(324,2),	altIcon = cdTex[92776],		unitTag = 'player'},		-- Daedric Trickery									*
	[75726]		= {s1 = 224,	s2 = 0, 	cdE = 0, cooldown = 3,		iH = nil,		hasTimer = true,	altDuration = 3,	altName = nil,				altIcon = cdTex[75726],		unitTag = 'player'},		-- Tava's Favor										*
	
-- Dungeon Sets
	[133493]	= {s1 = 475,	s2 = 0, 	cdE = 1, cooldown = 12,		iH = nil,		hasTimer = true,	altDuration = 11,	altName = ZOSName(475,2),	altIcon = cdTex[133493],	unitTag = 'player'},		-- Aegis Caller										*
	[142660]	= {s1 = 518,	s2 = 0, 	cdE = 1, cooldown = 30,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Arkasis's Genius									*
	[84277]		= {s1 = 260,	s2 = 0, 	cdE = 1, cooldown = 45,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[84277],		unitTag = 'player'},		-- Aspect of Mazzatun								*
	[116884]	= {s1 = 435,	s2 = 0, 	cdE = 0, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Auroran's Thunder								*
	[133292]	= {s1 = 473,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(473,2),	altIcon = nil,				unitTag = 'player'},		-- Bani's Torment									*
	[111386]	= {s1 = 400,	s2 = 0, 	cdE = 0, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(400,2),	altIcon = cdTex[111386],	unitTag = 'player'},		-- Blood Moon										*
	[66887]		= {s1 = 184,	s2 = 0, 	cdE = 0, cooldown = 12,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Brands of Imperium								*
	[61459]		= {s1 = 160,	s2 = 0, 	cdE = 0, cooldown = 12,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Burning Spellweave								*
	[102027]	= {s1 = 343,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[102027],	unitTag = 'player'},		-- Caluurion's Legacy (flame)						*
	[102032]	= {s1 = 343,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[102032],	unitTag = 'player'},		-- Caluurion's Legacy (frost)						*
	[102033]	= {s1 = 343,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[102033],	unitTag = 'player'},		-- Caluurion's Legacy (disease)						*
	[102034]	= {s1 = 343,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[102034],	unitTag = 'player'},		-- Caluurion's Legacy (shock)						*
	[159291]	= {s1 = 602,	s2 = 0, 	cdE = 1, cooldown = 12,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[159291],	unitTag = 'reticleover'},	-- Crimson Oath's Rive								*
	[141638]	= {s1 = 515,	s2 = 0, 	cdE = 0, cooldown = 8,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Crimson Twilight									*
	[102023]	= {s1 = 348,	s2 = 0, 	cdE = 1, cooldown = 4,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Curse of Doylemish								*
	[126682]	= {s1 = 457,	s2 = 0, 	cdE = 0, cooldown = 5,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Dragon's Defilement								*
	[150974]	= {s1 = 571,	s2 = 0, 	cdE = 1, cooldown = 18,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(571,2),	altIcon = nil,				unitTag = 'player'},		-- Drake's Rush										*
	[97538]		= {s1 = 335,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[97538],		unitTag = 'groundaoe'},		-- Draugr's Rest									*
	[133406]	= {s1 = 474,	s2 = 0, 	cdE = 1, cooldown = 9,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'reticleover'},	-- Draugrkin's Grip									*
	[67298]		= {s1 = 198,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[67298],		unitTag = 'groundaoe'},		-- Essence Thief									
	[99144]		= {s1 = 338,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[99144],		unitTag = 'player'},		-- Flame Blossom									*
	[97908]		= {s1 = 340,	s2 = 0, 	cdE = 1, cooldown = 30,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[97908],		unitTag = 'player'},		-- Hagraven's Garden								*
	[84354]		= {s1 = 263,	s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[84354],		unitTag = 'groundaoe'},		-- Hand of Mephala									*
	[111442]	= {s1 = 401,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[111442],	unitTag = 'groundaoe'},		-- Haven of Ursus									*
	[112414]	= {s1 = 401,	s2 = 0, 	cdE = 1, cooldown = 20,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[112414],	unitTag = 'player'},		-- Haven of Ursus									*
	[133210]	= {s1 = 471,	s2 = 0, 	cdE = 0, cooldown = 12,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(471,2),	altIcon = nil,				unitTag = 'player'},		-- Hiti's Hearth									*
	[126924]	= {s1 = 452,	s2 = 0, 	cdE = 1, cooldown = 9,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[126924],	unitTag = 'player'},		-- Hollowfang's Thirst								*
	[117666]	= {s1 = 431,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[117666],	unitTag = 'reticleover'},	-- Icy Conjuror										*
	[97627]		= {s1 = 337,	s2 = 0, 	cdE = 0, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[97627],		unitTag = 'player'},		-- Ironblood										*
	[67078]		= {s1 = 186,	s2 = 0, 	cdE = 0, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Jolting Arms										*
	[142687]	= {s1 = 517,	s2 = 0, 	cdE = 1, cooldown = 20,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[142816],	unitTag = 'player'},		-- Kraglen's Howl									*
	[34813]		= {s1 = 103,	s2 = 0, 	cdE = 1, cooldown = 30,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[34813],		unitTag = 'player'},		-- Magicka Furnace									*
	[116805]	= {s1 = 429,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(429,2),	altIcon = cdTex[116805],	unitTag = 'player'},		-- Mighty Glacier									*
	[57206]		= {s1 = 91,		s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[57206],		unitTag = 'player'},		-- Oblivion's Edge									*
	[67129]		= {s1 = 193,	s2 = 0, 	cdE = 0, cooldown = 7,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Overwhelming Surge								*
	[97714]		= {s1 = 336,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[97714],		unitTag = 'player'},		-- Pillar of Nirn									*
	[102106]	= {s1 = 347,	s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(347,2),	altIcon = cdTex[102106],	unitTag = 'groundaoe'},		-- Plague Slinger									*
	[159279]	= {s1 = 604,	s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[159279],	unitTag = 'groundaoe'},		-- Rush of Agony									*
	[67288]		= {s1 = 190,	s2 = 0, 	cdE = 0, cooldown = 5,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Scathing Mage									*
	[116954]	= {s1 = 434,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(434,2),	altIcon = nil,				unitTag = 'player'},		-- Scavenging Demise								*
	[159237]	= {s1 = 603,	s2 = 0, 	cdE = 1, cooldown = 20,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(603,2),	altIcon = nil,				unitTag = 'player'},		-- Scorion's Feast									*
	[57164]		= {s1 = 134,	s2 = 0, 	cdE = 0, cooldown = 60,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Shroud of the Lich								*
	[159380]	= {s1 = 605,	s2 = 0, 	cdE = 1, cooldown = 12,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[159380],	unitTag = 'player'},		-- Silver Rose Vigil								*
	[70298]		= {s1 = 188,	s2 = 0, 	cdE = 0, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Storm Master										*
	[159244]	= {s1 = 606,	s2 = 0, 	cdE = 1, cooldown = 12,		iH = nil,		hasTimer = true,	altDuration = 7,	altName = nil,				altIcon = cdTex[159244],	unitTag = 'groundaoe'},		-- Thunder Caller									*
	[101970]	= {s1 = 344,	s2 = 0, 	cdE = 1, cooldown = 45,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[101970],	unitTag = 'player'},		-- Trappings of Invigoration						*
	[61200]		= {s1 = 155,	s2 = 0, 	cdE = 0, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Undaunted Bastion								*
	[57163]		= {s1 = 19,		s2 = 0, 	cdE = 1, cooldown = 45,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(19,2),	altIcon = cdTex[57163],		unitTag = 'player'},		-- Vestments of the Warlock							*
	[34373]		= {s1 = 46,		s2 = 0, 	cdE = 0, cooldown = 5,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Noble Duelist									*
	[151126]	= {s1 = 574,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Foolkiller										*
	[151135]	= {s1 = 574,	s2 = 0, 	cdE = 1, cooldown = 30,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[151135],	unitTag = 'player'},		-- Foolkiller shield pop							*
	[33512]		= {s1 = 35,		s2 = 0, 	cdE = 1, cooldown = 3,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(35,2),	altIcon = nil,				unitTag = 'player'},		-- Knightmare										*
	[67205]		= {s1 = 196,	s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[67205],		unitTag = 'groundaoe'},		-- Leeching Plate									*
	[85978]		= {s1 = 28,		s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[85978],		unitTag = 'player'},		-- Barkskin											*
	[160395]	= {s1 = 77,		s2 = 0, 	cdE = 0, cooldown = 20,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Crusader											*
	[33691]		= {s1 = 33,		s2 = 0, 	cdE = 1, cooldown = 4,		iH = nil,		hasTimer = true,	altDuration = 4,	altName = nil,				altIcon = nil,				unitTag = 'reticleover'},	-- Viper's Sting									*

-- Monster Sets
	[59517]		= {s1 = 163,	s2 = 0, 	cdE = 0, cooldown = 5,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Bloodspawn										*
	[59590]		= {s1 = 167,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = 6,	altName = ZOSName(167,2),	altIcon = cdTex[59590],		unitTag = 'groundaoe'},		-- Bogdan the Nightflame							*
	[81069]		= {s1 = 269,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[81069],		unitTag = 'groundaoe'},		-- Chokethorn										*
	[97882]		= {s1 = 342,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = 10,	altName = nil,				altIcon = cdTex[97882],		unitTag = 'groundaoe'},		-- Domihaus											*
	[97855]		= {s1 = 341,	s2 = 0, 	cdE = 1, cooldown = 20,		iH = nil,		hasTimer = true,	altDuration = 10,	altName = nil,				altIcon = cdTex[97855],		unitTag = 'groundaoe'},		-- Earthgore										*
	[151033]	= {s1 = 577,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(577,2),	altIcon = nil,				unitTag = 'groundaoe'},		-- Encratis's Behemoth								*
	[59522]		= {s1 = 166,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Engine Guardian									*
	[84504]		= {s1 = 280,	s2 = 0, 	cdE = 0, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'groundaoe'},		-- Grothdar											*
	[126687]	= {s1 = 458,	s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[126687],	unitTag = 'player'},		-- Grundwulf (NO EVENT IF RESOURCES FULL)			*
	[80562]		= {s1 = 274,	s2 = 0, 	cdE = 0, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Iceheart											*
	[80527]		= {s1 = 273,	s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[80527],		unitTag = 'groundaoe'},		-- Ilambris											*
	[155333]	= {s1 = 599,	s2 = 0, 	cdE = 0, cooldown = 40,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Immolator Charr									*
	[83405]		= {s1 = 272,	s2 = 0, 	cdE = 1, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = 3,	altName = nil,				altIcon = nil,				unitTag = 'groundaoe'},		-- Infernal Guardian								*
	[80566]		= {s1 = 266,	s2 = 0, 	cdE = 0, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'groundaoe'},		-- Kra'gh											*
	[141905]	= {s1 = 535,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(535,2),	altIcon = cdTex[141905],	unitTag = 'groundaoe'},		-- Lady Thorn										*
	[59587]		= {s1 = 164,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[59587],		unitTag = 'groundaoe'},		-- Lord Warden Dusk									*
	[126941]	= {s1 = 459,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = 4,	altName = nil,				altIcon = nil,				unitTag = 'reticleover'},	-- Maarselok										*
	[161527]	= {s1 = 609,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[161527],	unitTag = 'player'},		-- Magma Incarnate									*
	[59568]		= {s1 = 165,	s2 = 0, 	cdE = 1, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = 6,	altName = nil,				altIcon = cdTex[59568],		unitTag = 'player'},		-- Malubeth the Scourger							*
	[59508]		= {s1 = 170,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(170,2),	altIcon = cdTex[59508],		unitTag = 'player'},		-- Maw of the Infernal								*
	[66812]		= {s1 = 183,	s2 = 0, 	cdE = 0, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(183,2),	altIcon = nil,				unitTag = 'player'},		-- Molag Kena										*
	[133381]	= {s1 = 478,	s2 = 0, 	cdE = 0, cooldown = 7,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Mother Ciannait									*
	[59594]		= {s1 = 168,	s2 = 0, 	cdE = 1, cooldown = 3,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(168,2),	altIcon = cdTex[59594],		unitTag = 'groundaoe'},		-- Nerien'eth										*
	[98421]		= {s1 = 277,	s2 = 0, 	cdE = 1, cooldown = 20,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[98421],		unitTag = 'player'},		-- Pirate Skeleton									*
	[159500]	= {s1 = 608,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'groundaoe'},		-- Prior Thierric									*
	[160839]	= {s1 = 279,	s2 = 0, 	cdE = 1, cooldown = 6,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(279,2),	altIcon = cdTex[160839],	unitTag = 'player'},		-- Selene											*
	[80545]		= {s1 = 271,	s2 = 0, 	cdE = 1, cooldown = 6,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[80545],		unitTag = 'groundaoe'},		-- Sellistrix										*
	[81036]		= {s1 = 268,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = 8,	altName = nil,				altIcon = cdTex[81036],		unitTag = 'groundaoe'},		-- Sentinel of Rkugamz								*
	[80954]		= {s1 = 265,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(265,2),	altIcon = cdTex[80954],		unitTag = 'player'},		-- Shadowrend										*
	[59497]		= {s1 = 162,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(162,2),	altIcon = cdTex[59497],		unitTag = 'groundaoe'},		-- Spawn of Mephala									*
	[143032]	= {s1 = 534,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'groundaoe'},		-- Stone Husk										*
	[116881]	= {s1 = 432,	s2 = 0, 	cdE = 1, cooldown = 14,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(432,2),	altIcon = cdTex[116881],	unitTag = 'player'},		-- Stonekeeper										*
	[80523]		= {s1 = 275,	s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[80523],		unitTag = 'groundaoe'},		-- Stormfist										*
	[117111]	= {s1 = 436,	s2 = 0, 	cdE = 1, cooldown = 18,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(436,2),	altIcon = nil,				unitTag = 'player'},		-- Symphony of Blades								*
	[102093]	= {s1 = 349,	s2 = 0, 	cdE = 1, cooldown = 16,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[102093],	unitTag = 'groundaoe'},		-- Thurvokun										*
	[80517]		= {s1 = 276,	s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Tremorscale										*
	[59596]		= {s1 = 169,	s2 = 0, 	cdE = 1, cooldown = 5,		iH = aR[2240],	hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Valkyn Skoria									*
	[80487]		= {s1 = 257,	s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(257,2),	altIcon = cdTex[80487],		unitTag = 'player'},		-- Velidreth										*
	[111354]	= {s1 = 398,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(398,2),	altIcon = nil,				unitTag = 'player'},		-- Vykosa											*
	[102136]	= {s1 = 350,	s2 = 0, 	cdE = 1, cooldown = 18,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[102136],	unitTag = 'player'},		-- Zaan												*

-- Overland Sets
	[112523]	= {s1 = 62,		s2 = 0, 	cdE = 0, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Hatchling's Shell								*
	[154490]	= {s1 = 581,	s2 = 0, 	cdE = 0, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Bog Raider										*
	[71107]		= {s1 = 212,	s2 = 0, 	cdE = 0, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Briarheart										*
	[61716]		= {s1 = 382,	s2 = 0, 	cdE = 0, cooldown = 20,		iH = nil,		hasTimer = true,	altDuration = 10,	altName = ZOSName(382,2),	altIcon = cdTex[61716],		unitTag = 'player'},		-- Grace of Gloom									*
	[34711]		= {s1 = 94,		s2 = 0, 	cdE = 0, cooldown = 25,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Meridia's Blessed Armor							*
	[127270]	= {s1 = 70,		s2 = 0, 	cdE = 0, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Seventh Legion Brute								*
	[57210]		= {s1 = 93,		s2 = 0, 	cdE = 0, cooldown = 6,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Storm Knight's Plate								*
	[34817]		= {s1 = 105,	s2 = 0, 	cdE = 0, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'reticleover'},	-- Twin Sisters										*
	[99268]		= {s1 = 355,	s2 = 0, 	cdE = 0, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = 12,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Unfathomable Darkness							*
	[135690]	= {s1 = 488,	s2 = 0, 	cdE = 0, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = 10,	altName = nil,				altIcon = nil,				unitTag = 'reticleover'},	-- Venomous Smite									*
	[127070]	= {s1 = 147,	s2 = 0, 	cdE = 0, cooldown = 8,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'reticleover'},	-- Way of Martial Knowledge							*
	[163033]	= {s1 = 614,	s2 = 0, 	cdE = 0, cooldown = 7,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Hexos' Ward										*
	[75691]		= {s1 = 227,	s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[75691],		unitTag = 'groundaoe'},		-- Bahraha's Curse									*
	[154347]	= {s1 = 580,	s2 = 0, 	cdE = 1, cooldown = 15,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Deadlands Assassin								*
	[93308]		= {s1 = 321,	s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[93308],		unitTag = 'player'},		-- Defiler											*
	[57297]		= {s1 = 135,	s2 = 0, 	cdE = 1, cooldown = 7,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Draugr Heritage									*
	[31213]		= {s1 = 22,		s2 = 0, 	cdE = 1, cooldown = 7,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Dreamer's Mantle									*
	[34508]		= {s1 = 58,		s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Hide of the Werewolf								*
	[99286]		= {s1 = 356,	s2 = 0, 	cdE = 1, cooldown = 6,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Livewire											*
	[92982]		= {s1 = 354,	s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[92982],		unitTag = 'player'},		-- Mad Tinkerer										*
	[122755]	= {s1 = 47,		s2 = 0, 	cdE = 1, cooldown = 3,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Robes of the Withered Hand						*
	[97806]		= {s1 = 49,		s2 = 0, 	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[97806],		unitTag = 'player'},		-- Shadow of the Red Mountain						*
	[76344]		= {s1 = 228,	s2 = 0, 	cdE = 1, cooldown = 7,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Syvarra's Scales									*
	[33497]		= {s1 = 30,		s2 = 0, 	cdE = 1, cooldown = 3,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Thunderbug's Carapace							*
	[71664]		= {s1 = 218,	s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[71664],		unitTag = 'player'},		-- Trinimac's Valor									*
	[135659]	= {s1 = 487,	s2 = 0, 	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[135659],	unitTag = 'groundaoe'},		-- Winter's Respite Set								*
	[34522]		= {s1 = 65,		s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[34522],		unitTag = 'player'},		-- Bloodthorn's Touch								*
	[163044]	= {s1 = 613,	s2 = 0, 	cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[163044],	unitTag = 'player'},		-- Eye of the Grasp (NO EVENT IF ULT FULL)			*
	[163060]	= {s1 = 615,	s2 = 0,		cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(615,2),	altIcon = cdTex[163060],	unitTag = 'reticleover'},	-- Kynmarcher's Cruelty (Major Vulnerability)		*
	[163062]	= {s1 = 615,	s2 = 0,		cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(615,2),	altIcon = cdTex[163062],	unitTag = 'reticleover'},	-- Kynmarcher's Cruelty (Major Breach)				*
	[163064]	= {s1 = 615,	s2 = 0,		cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(615,2),	altIcon = cdTex[163064],	unitTag = 'reticleover'},	-- Kynmarcher's Cruelty (Major Maim)				*
	[163065]	= {s1 = 615,	s2 = 0,		cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(615,2),	altIcon = cdTex[163065],	unitTag = 'reticleover'},	-- Kynmarcher's Cruelty (Major Cowardice)			*
	[163066]	= {s1 = 615,	s2 = 0,		cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(615,2),	altIcon = cdTex[163066],	unitTag = 'reticleover'},	-- Kynmarcher's Cruelty (Major Defile)				*

-- PvP Sets
	[159388]	= {s1 = 616,	s2 = 0,		cdE = 1, cooldown = 15,		iH = nil,		hasTimer = true,	altDuration = 4,	altName = nil,				altIcon = cdTex[159388],	unitTag = 'groundaoe'},		-- Dark Convergence									*
	[159713]	= {s1 = 618,	s2 = 0,		cdE = 1, cooldown = 7,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'groundaoe'},		-- Hrothgar's Chill									*
	[70492]		= {s1 = 59,		s2 = 0,		cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[70492],		unitTag = 'player'},		-- Kyne's Kiss (Rewards of the Worthy)				*
	[117391]	= {s1 = 89,		s2 = 0,		cdE = 1, cooldown = 30,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Sentry (Rewards of the Worthy)					*
	[113382]	= {s1 = 418,	s2 = 0,		cdE = 1, cooldown = 4,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[113382],	unitTag = 'reticleover'},	-- Spell Strategist (Rewards of the Worthy)			*
	[113509]	= {s1 = 421,	s2 = 0,		cdE = 1, cooldown = 12,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(421,2),	altIcon = nil,				unitTag = 'player'},		-- Steadfast Hero (Rewards of the Worthy)			*
	[69567]		= {s1 = 201,	s2 = 0,		cdE = 1, cooldown = 20,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(201,2),	altIcon = nil,				unitTag = 'player'},		-- Reactive Armor (Tel Var)							*
	[127032]	= {s1 = 200,	s2 = 0,		cdE = 1, cooldown = 60,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Phoenix (Tel Var)								*
	[34787]		= {s1 = 101,	s2 = 0,		cdE = 1, cooldown = 4,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Affliction										*
	[115771]	= {s1 = 420,	s2 = 0,		cdE = 1, cooldown = 6,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[115771],	unitTag = 'player'},		-- Soldier of Anguish								*
	[142401]	= {s1 = 63,		s2 = 0,		cdE = 1, cooldown = 60,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Juggernaut										*
	[111575]	= {s1 = 113,	s2 = 0,		cdE = 1, cooldown = 4,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[111575],	unitTag = 'player'},		-- Crest of Cyrodiil								*

-- Trial Sets
	[61737]		= {s1 = 388,	s2 = 392,	cdE = 1, cooldown = 2,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(388,2),	altIcon = nil,				unitTag = 'player'},		-- Aegis of Galenwe									*
	[121878]	= {s1 = 446,	s2 = 451,	cdE = 1, cooldown = 8,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(446,2),	altIcon = nil,				unitTag = 'player'},		-- Claw of Yolnakhriin (same for Perfected)			*
	[86907]		= {s1 = 138,	s2 = 0,		cdE = 1, cooldown = 5,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Defending Warrior								*
	[51315]		= {s1 = 140,	s2 = 0,		cdE = 1, cooldown = 4,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'reticleover'},	-- Destructive Mage									*
	[127235]	= {s1 = 171,	s2 = 0,		cdE = 1, cooldown = 60,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = nil,				unitTag = 'player'},		-- Eternal Warrior									*
	[51443]		= {s1 = 141,	s2 = 0,		cdE = 1, cooldown = 3,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(141,2),	altIcon = cdTex[51443],		unitTag = 'player'},		-- Healing Mage										*
	[129477]	= {s1 = 136,	s2 = 0,		cdE = 1, cooldown = 20,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(136,2),	altIcon = nil,				unitTag = 'player'},		-- Immortal Warrior (Yokeda)						*
	[136098]	= {s1 = 492,	s2 = 493,	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[136098],	unitTag = 'groundaoe'},		-- Kyne's Wind (same for Perfected)					*
	[75814]		= {s1 = 231,	s2 = 0,		cdE = 1, cooldown = 20,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[75814],		unitTag = 'groundaoe'},		-- Lunar Bastion									*
	[110067]	= {s1 = 390,	s2 = 394,	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = 10,	altName = ZOSName(390,2),	altIcon = cdTex[110067],	unitTag = 'groundaoe'},		-- Mantle of Siroria (same for Perfected)			*
	[135923]	= {s1 = 496,	s2 = 497,	cdE = 1, cooldown = 22,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = ZOSName(496,2),	altIcon = cdTex[135923],	unitTag = 'player'},		-- Roaring Opportunist (same for Perfected)			*
	[107141]	= {s1 = 391,	s2 = 395,	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = nil,				altIcon = cdTex[107141],	unitTag = 'groundaoe'},		-- Vestment of Olirime (same for Perfected)			*
	[154783]	= {s1 = 588,	s2 = 592,	cdE = 1, cooldown = 10,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(588,2),	altIcon = nil,				unitTag = 'reticleover'},	-- Stone-Talker's Oath (same for Perfected)			*
	[135926]	= {s1 = 494,	s2 = 495,	cdE = 1, cooldown = 21,		iH = nil,		hasTimer = true,	altDuration = nil,	altName = ZOSName(494,2),	altIcon = nil,				unitTag = 'player'},		-- Vrol's Aegis (same for Perfected)				*

-- Mythic Sets
	[163375]	= {s1 = 626,	s2 = 0,		cdE = 1, cooldown = 10,		iH = nil,		hasTimer = false,	altDuration = nil,	altName = nil,				altIcon = cdTex[163375],	unitTag = 'player'},		-- Belharza's Band									*
}

local abilityBarSets = {
-- Arena Sets
	[215]	= {[1] = 127081, [2] = 127084, [3] = 127088},
	[544]	= {[1] = 147692},
	[542]	= {[1] = 147675},
	[213]	= {[1] = 71188},
	[216]	= {[1] = 74106},
	[214]	= {[1] = 71193},
	[217]	= {[1] = 71647},
	[561]	= {[1] = 147843},
	[562]	= {[1] = 147872},
	[558]	= {[1] = 147747},
	[567]	= {[1] = 147843},
	[568]	= {[1] = 147872},
	[564]	= {[1] = 147747},

-- Crafted Sets
	[54]	= {[1] = 34502},
	[437]	= {[1] = 121914},
	[468]	= {[1] = 129536},
	[482]	= {[1] = 134104},
	[37]	= {[1] = 33764},
	[353]	= {[1] = 164087},
	[219]	= {[1] = 71671},
	[409]	= {[1] = 113307},
	[176]	= {[1] = 61781},
	[387]	= {[1] = 106804},
	[386]	= {[1] = 113092},
--	[81]	= {[1] = 34587},
	[74]	= {[1] = 69685},
	[481]	= {[1] = 134094},
	[41]	= {[1] = 49236},
	[324]	= {[1] = 92771},

-- Dungeon Sets
	[475]	= {[1] = 133493},
	[518]	= {[1] = 142660},
	[260]	= {[1] = 84277},
	[435]	= {[1] = 116884},
	[473]	= {[1] = 133292},
	[400]	= {[1] = 111386},
	[184]	= {[1] = 66887},
	[160]	= {[1] = 61459},
	[343]	= {[1] = 102027},
	[602]	= {[1] = 159291},
	[515]	= {[1] = 141638},
	[348]	= {[1] = 102023},
	[457]	= {[1] = 126682},
	[571]	= {[1] = 150974},
	[335]	= {[1] = 97538},
	[474]	= {[1] = 133406},
	[198]	= {[1] = 67298},
	[338]	= {[1] = 99144},
	[340]	= {[1] = 97908},
	[263]	= {[1] = 84354},
	[401]	= {[1] = 111442, [2] = 112414},
	[471]	= {[1] = 133210},
	[452]	= {[1] = 126924},
	[431]	= {[1] = 117666},
	[337]	= {[1] = 97627},
	[186]	= {[1] = 67078},
	[517]	= {[1] = 142687},
	[103]	= {[1] = 34813},
	[429]	= {[1] = 116805},
	[91]	= {[1] = 57206},
	[193]	= {[1] = 67129},
	[336]	= {[1] = 97714},
	[347]	= {[1] = 102106},
	[604]	= {[1] = 159279},
	[190]	= {[1] = 67288},
	[434]	= {[1] = 116954},
	[603]	= {[1] = 159237},
	[134]	= {[1] = 57164},
	[605]	= {[1] = 159380},
	[188]	= {[1] = 70298},
	[606]	= {[1] = 159244},
	[344]	= {[1] = 101970},
	[155]	= {[1] = 61200},
	[19]	= {[1] = 57163},
	[46]	= {[1] = 34373},
	[574]	= {[1] = 151135, [2] = 151126},
	[35]	= {[1] = 33512},
	[196]	= {[1] = 67205},
	[28]	= {[1] = 85978},
	[77]	= {[1] = 160395},
	[33]	= {[1] = 33691},

-- Monster Sets
	[163]	= {[1] = 59517},
	[167]	= {[1] = 59590},
	[269]	= {[1] = 81069},
	[342]	= {[1] = 97882},
	[341]	= {[1] = 97855},
	[577]	= {[1] = 151033},
	[166]	= {[1] = 59522},
	[280]	= {[1] = 84504},
	[458]	= {[1] = 126687},
	[274]	= {[1] = 80562},
	[273]	= {[1] = 80527},
	[599]	= {[1] = 155333},
	[272]	= {[1] = 83405},
	[266]	= {[1] = 80566},
	[535]	= {[1] = 141905},
	[164]	= {[1] = 59587},
	[459]	= {[1] = 126941},
	[609]	= {[1] = 161527},
	[165]	= {[1] = 59568},
	[170]	= {[1] = 59508},
	[183]	= {[1] = 66812},
	[478]	= {[1] = 133381},
	[168]	= {[1] = 59594},
	[277]	= {[1] = 98421},
	[608]	= {[1] = 159500},
	[279]	= {[1] = 160839},
	[271]	= {[1] = 80545},
	[268]	= {[1] = 81036},
	[265]	= {[1] = 80954},
	[162]	= {[1] = 59497},
	[534]	= {[1] = 143032},
	[432]	= {[1] = 116881},
	[275]	= {[1] = 80523},
	[436]	= {[1] = 117111},
	[349]	= {[1] = 102093},
	[276]	= {[1] = 80517},
	[169]	= {[1] = 59596},
	[257]	= {[1] = 80487},
	[398]	= {[1] = 111354},
	[350]	= {[1] = 102136},

-- Overland Sets
	[62]	= {[1] = 112523},
	[581]	= {[1] = 154490},
	[212]	= {[1] = 71107},
	[382]	= {[1] = 61716},
	[94]	= {[1] = 34711},
	[70]	= {[1] = 127270},
	[93]	= {[1] = 57210},
	[105]	= {[1] = 34817},
	[355]	= {[1] = 99268},
	[488]	= {[1] = 135690},
	[147]	= {[1] = 127070},
	[614]	= {[1] = 163033},
	[227]	= {[1] = 75691},
	[580]	= {[1] = 154347},
	[321]	= {[1] = 93308},
	[135]	= {[1] = 57297},
	[22]	= {[1] = 31213},
	[58]	= {[1] = 34508},
	[356]	= {[1] = 99286},
	[354]	= {[1] = 92982},
	[47]	= {[1] = 122755},
	[49]	= {[1] = 97806},
	[228]	= {[1] = 76344},
	[30]	= {[1] = 33497},
	[218]	= {[1] = 71664},
	[487]	= {[1] = 135659},
	[65]	= {[1] = 34522},
	[613]	= {[1] = 163044},
	[615]	= {[1] = 163064},

-- PvP Sets
	[616]	= {[1] = 159388},
	[618]	= {[1] = 159713},
	[59]	= {[1] = 70492},
	[89]	= {[1] = 117391},
	[418]	= {[1] = 113382},
	[421]	= {[1] = 113509},
	[201]	= {[1] = 69567},
	[200]	= {[1] = 127032},
	[101]	= {[1] = 34787},
	[420]	= {[1] = 115771},
	[63]	= {[1] = 142401},
	[113]	= {[1] = 111575},

-- Trial Sets
	[388]	= {[1] = 61737},
	[392]	= {[1] = 61737},
	[446]	= {[1] = 121878},
	[451]	= {[1] = 121878},
	[138]	= {[1] = 86907},
	[140]	= {[1] = 51315},
	[171]	= {[1] = 127235},
	[141]	= {[1] = 51443},
	[136]	= {[1] = 129477},
	[492]	= {[1] = 136098},
	[493]	= {[1] = 136098},
	[231]	= {[1] = 75814},
	[390]	= {[1] = 110067},
	[394]	= {[1] = 110067},
	[496]	= {[1] = 135923},
	[497]	= {[1] = 135923},
	[391]	= {[1] = 107141},
	[395]	= {[1] = 107141},
	[588]	= {[1] = 154783},
	[592]	= {[1] = 154783},
	[494]	= {[1] = 135926},
	[495]	= {[1] = 135926},

-- Mythic Sets
	[626]	= {[1] = 163375},
}

--/script d(GetAbilityIcon(61737))
--/script d(GetAbilityDuration(142401))
--/script d(GetItemLinkIcon(''))
--/script d(GetAbilityName(112414))
--/script d(GetItemSetName(615))
--/script d(GetAbilityDescription(147875))
--/script Srendarr:FindIDByName("Spear Shards", 1, 1, true)
--/script d("|t24:24:/esoui/art/icons/quest_generic_blessing_buff.dds|t")


-- ------------------------
-- MAIN FILTER TABLES
-- ------------------------
local filterAlwaysIgnored = {
-- Default ignore list
	[37009]	= true,		-- Extra Channeled Focus buff (tracks as AOE)
	[26188] = true,		-- Spear Shards extra proc effect
	[26869] = true,		-- Blazing Spear extra proc effect
	[113417] = true,	-- Spell Strategist (superfluous)
	[25381] = true,		-- Shadowy Disguise (superfluous)
--	[24330] = true,		-- Haunting Curse (superfluous)
--	[106798] = true,	-- Wonky Sload's Embrace target debuff with bad timing
	[23205] = true,		-- Duplicate Lightning Flood short proc
	[29667] = true,		-- Concentration (Light Armour)
	[45569] = true,		-- Medicinal Use (Alchemy)
	[62760] = true,		-- Spell Shield (Champion Point Ability)
	[64160] = true,		-- Crystal Fragments Passive (Not Timed)
	[36603] = true,		-- Soul Siphoner Passive I
	[45155] = true,		-- Soul Siphoner Passive II
	[26858] = true,		-- Extra Luminous Shards
	[46672] = true,		-- Propelling Shield (Extra Aura)
	[42198] = true,		-- Spinal Surge (Extra Aura)
	[62587] = true,		-- Focused Aim (2s Refreshing Aura)
	[38698] = true,		-- Focused Aim (2s Refreshing Aura)
	[42589] = true,		-- Flawless Dawnbreaker (2s aura on Weaponswap)
-- Duplicates for Vampire
	[134166] = true,	-- Simmering Frenzy
-- Special case for Fighters Guild Beast Trap (and morph) tracking
	[35753] = true,		-- Redundant Trap Beast I
	[42710] = true,		-- Redundant Trap Beast II
	[42717] = true,		-- Redundant Trap Beast III
	[42724] = true,		-- Redundant Trap Beast IV
	[40384] = true,		-- Redundant Rearming Trap I
	[42732] = true,		-- Redundant Rearming Trap II
	[42742] = true,		-- Redundant Rearming Trap III
	[42752] = true,		-- Redundant Rearming Trap IV
	[40374] = true,		-- Redundant Lightweight Beast Trap I
	[42759] = true,		-- Redundant Lightweight Beast Trap II
	[42766] = true,		-- Redundant Lightweight Beast Trap III
	[42773] = true,		-- Redundant Lightweight Beast Trap IV
-- Light Armor active ability redundant buffs
	[41503] = true,		-- Annulment Dummy
	[39188] = true,		-- Dampen Magic
	[41110] = true,		-- Dampen Magic
	[41112] = true,		-- Dampen Magic
	[41114] = true,		-- Dampen Magic
	[44323] = true,		-- Dampen Magic
	[39185] = true,		-- Harness Magicka
	[41117] = true,		-- Harness Magicka
	[41120] = true,		-- Harness Magicka
	[41123] = true,		-- Harness Magicka
	[42876] = true,		-- Harness Magicka
	[42877] = true,		-- Harness Magicka
	[42878] = true,		-- Harness Magicka
-- Redundant Food Auras
	[84732] = true,		-- Witchmother's Potent Brew
	[84733] = true,		-- Witchmother's Potent Brew
-- Scorion's Feast
	[159231] = true,	-- Scorion's Feast (redundant passive)
	[159233] = true,	-- Scorion's Feast (redundant passive)
-- Grisly Gourmet
	[61737] = true,		-- zero duration empower proc (?)
-- Random blacklisted (thanks Scootworks)
--	[29705] = true,		-- Whirlpool
--	[30455] = true,		-- Arachnophobia
--	[37136] = true,		-- Amulet
--	[37342] = true,		-- dummy
--	[37475] = true,		-- Manifestation of Terror
--	[43588] = true,		-- Killing Blow
--	[43594] = true,		-- Wait for teleport
--	[44912] = true,		-- Q4730 Shackle Breakign Shakes
--	[45050] = true,		-- Executioner
--	[47718] = true,		-- Death Stun
--	[49807] = true,		-- Killing Blow Stun
--	[55406] = true,		-- Resurrect Trigger
--	[55915] = true,		-- Sucked Under Fall Bonus
--	[56739] = true,		-- Damage Shield
--	[57275] = true,		-- Shadow Tracker
--	[57360] = true,		-- Portal
--	[57425] = true,		-- Brace For Impact
--	[57756] = true,		-- Blend into Shadows
--	[57771] = true,		-- Clone Die Counter
--	[58107] = true,		-- Teleport
--	[58210] = true,		-- PORTAL CHARGED
--	[58241] = true,		-- Shadow Orb - Lord Warden
--	[58242] = true,		-- Fearpicker
--	[58955] = true,		-- Death Achieve Check
--	[59040] = true,		-- Teleport Tracker
--	[59911] = true,		-- Boss Speed
--	[60414] = true,		-- Tower Destroyed
--	[60947] = true,		-- Soul Absorbed
--	[60967] = true,		-- Summon Adds
--	[64132] = true,		-- Grapple Immunity
--	[66808] = true,		-- Molag Kena
--	[66813] = true,		-- White-Gold Tower Item Set
--	[69809] = true,		-- Hard Mode
--	[70113] = true,		-- Shade Despawn
}

local filterAuraGroups = {
	['esoplus'] = {
		[63601]	= true,		-- ESO Plus status
	},

	['block'] = {
		[14890]	= true,		-- Brace (Generic)
	},
	['cyrodiil'] = {
		[11341] = true,		-- Enemy Keep Bonus I
		[11343] = true,		-- Enemy Keep Bonus II
		[11345] = true,		-- Enemy Keep Bonus III
		[11347] = true,		-- Enemy Keep Bonus IV
		[11348] = true,		-- Enemy Keep Bonus V
		[11350] = true,		-- Enemy Keep Bonus VI
		[11352] = true,		-- Enemy Keep Bonus VII
		[11353] = true,		-- Enemy Keep Bonus VIII
		[11356] = true,		-- Enemy Keep Bonus IX
		[12033] = true,		-- Battle Spirit
		[15058]	= true,		-- Offensive Scroll Bonus I
		[15060]	= true,		-- Defensive Scroll Bonus I
		[16348]	= true,		-- Offensive Scroll Bonus II
		[16350]	= true,		-- Defensive Scroll Bonus II
		[39671]	= true,		-- Emperorship Alliance Bonus
	},
	['disguise'] = {
		-- intentionally empty table just so setup can iterate through filters more simply
	},
	['mundusBoon'] = {
		[13940]	= true,		-- Boon: The Warrior
		[13943]	= true,		-- Boon: The Mage
		[13974]	= true,		-- Boon: The Serpent
		[13975]	= true,		-- Boon: The Thief
		[13976]	= true,		-- Boon: The Lady
		[13977]	= true,		-- Boon: The Steed
		[13978]	= true,		-- Boon: The Lord
		[13979]	= true,		-- Boon: The Apprentice
		[13980]	= true,		-- Boon: The Ritual
		[13981]	= true,		-- Boon: The Lover
		[13982]	= true,		-- Boon: The Atronach
		[13984]	= true,		-- Boon: The Shadow
		[13985]	= true,		-- Boon: The Tower
	},
	['soulSummons'] = {
		[39269] = true,		-- Soul Summons (Rank 1)
		[43752] = true,		-- Soul Summons (Rank 2)
		[45590] = true,		-- Soul Summons (Rank 2)
	},
	['vampLycan'] = {
		[35658] = true,		-- Lycanthropy
		[35771]	= true,		-- Stage 1 Vampirism (trivia: has a duration even though others don't)
		[35773]	= true,		-- Stage 2 Vampirism
		[35780]	= true,		-- Stage 3 Vampirism
		[35786]	= true,		-- Stage 4 Vampirism
		[35792]	= true,		-- Stage 4 Vampirism
	},
	['vampLycanBite'] = {
		[40359] = true,		-- Fed On Ally
		[40525] = true,		-- Bit an ally
		[39472] = true,		-- Vampirism
		[40521] = true,		-- Sanies Lupinus
	},
}

local filteredAuras = { -- used to hold the abilityIDs of filtered auras
	['player']		= {},
	['reticleover']	= {},
	['groundaoe']	= {}
}

for id in pairs(filterAlwaysIgnored) do -- populate initial ignored auras to filters
	if not Srendarr.alwaysIgnore then Srendarr.alwaysIgnore = {} end
	Srendarr.alwaysIgnore[id] = true -- always ignore these even if added to prominent (Phinix)
	filteredAuras['player'][id]			= true
	filteredAuras['reticleover'][id]	= true
	filteredAuras['groundaoe'][id]		= true
end	-- run once on init of addon

Srendarr.crystalFragments			= ZOSName(46324,1) -- special case for merging frags procs
Srendarr.crystalFragmentsPassive	= 46327 -- with the general proc system
Srendarr.crystalFragmentsProc		= false -- tracks when crystal fragments proc is active

-- set external references
Srendarr.alteredAuraIcons		= alteredAuraIcons
Srendarr.alteredAuraData		= alteredAuraData
Srendarr.stackingAuras			= stackingAuras
Srendarr.catchTriggers			= catchTriggers
Srendarr.fakeAuras				= fakeAuras
Srendarr.enchantProcs			= enchantProcs
Srendarr.specialProcs			= specialProcs
Srendarr.specialNames			= specialNames
Srendarr.releaseTriggers		= releaseTriggers
Srendarr.fakeTargetDebuffs		= fakeTargetDebuffs
Srendarr.debuffAuras			= debuffAuras
Srendarr.alternateAura 			= alternateAura
Srendarr.filteredAuras			= filteredAuras
Srendarr.procAbilityNames		= procAbilityNames
Srendarr.abilityCooldowns		= abilityCooldowns
Srendarr.abilityBarSets			= abilityBarSets
Srendarr.refreshAuras			= refreshAuras

-- ------------------------
-- OTHER DATA TABLES
-- ------------------------
Srendarr.auraLookup = {
	['player']				= {},
	['reticleover']			= {},
	['groundaoe']			= {},
	['group1']				= {},
	['group2']				= {},
	['group3']				= {},
	['group4']				= {},
	['group5']				= {},
	['group6']				= {},
	['group7']				= {},
	['group8']				= {},
	['group9']				= {},
	['group10']				= {},
	['group11']				= {},
	['group12']				= {},
	['group13']				= {},
	['group14']				= {},
	['group15']				= {},
	['group16']				= {},
	['group17']				= {},
	['group18']				= {},
	['group19']				= {},
	['group20']				= {},
	['group21']				= {},
	['group22']				= {},
	['group23']				= {},
	['group24']				= {},
}

Srendarr.sampleAuraData = {
	-- player timed
	[916001] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 1),		unitTag = 'player', duration = 10,	icon = [[/esoui/art/icons/ability_destructionstaff_001.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[916002] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 2),		unitTag = 'player', duration = 20,	icon = [[/esoui/art/icons/ability_destructionstaff_002.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[916003] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 3),		unitTag = 'player', duration = 30,	icon = [[/esoui/art/icons/ability_destructionstaff_003.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[916004] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 4),		unitTag = 'player', duration = 60,	icon = [[/esoui/art/icons/ability_destructionstaff_004.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[916005] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 5),		unitTag = 'player', duration = 120,	icon = [[/esoui/art/icons/ability_destructionstaff_005.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[916006] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 6),		unitTag = 'player', duration = 600,	icon = [[/esoui/art/icons/ability_destructionstaff_006.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	-- player toggled
	[916007] = {auraName = strformat('%s %d', L.SampleAura_PlayerToggled, 1),	unitTag = 'player', duration = 0,	icon = [[esoui/art/icons/ability_mageguild_001.dds]],			effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[916008] = {auraName = strformat('%s %d', L.SampleAura_PlayerToggled, 2),	unitTag = 'player', duration = 0,	icon = [[esoui/art/icons/ability_mageguild_002.dds]],			effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	-- player passive
	[916009] = {auraName = strformat('%s %d', L.SampleAura_PlayerPassive, 1),	unitTag = 'player', duration = 0,	icon = [[esoui/art/icons/ability_restorationstaff_001.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[916010] = {auraName = strformat('%s %d', L.SampleAura_PlayerPassive, 2),	unitTag = 'player', duration = 0,	icon = [[esoui/art/icons/ability_restorationstaff_002.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	-- player debuff
	[916011] = {auraName = strformat('%s %d', L.SampleAura_PlayerDebuff, 1),	unitTag = 'player', duration = 10,	icon = [[esoui/art/icons/ability_nightblade_001.dds]],			effectType = BUFF_EFFECT_TYPE_DEBUFF,	abilityType = ABILITY_TYPE_BONUS},
	[916012] = {auraName = strformat('%s %d', L.SampleAura_PlayerDebuff, 2),	unitTag = 'player', duration = 30,	icon = [[esoui/art/icons/ability_nightblade_002.dds]],			effectType = BUFF_EFFECT_TYPE_DEBUFF,	abilityType = ABILITY_TYPE_BONUS},
	-- player ground
	[916013]  = {auraName = strformat('%s %d', L.SampleAura_PlayerGround, 1),	unitTag = '', 		duration = 10,	icon = [[/esoui/art/icons/ability_destructionstaff_008.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_AREAEFFECT},
	[916014]  = {auraName = strformat('%s %d', L.SampleAura_PlayerGround, 2),	unitTag = '', 		duration = 30,	icon = [[/esoui/art/icons/ability_destructionstaff_011.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_AREAEFFECT},
	-- player major|minor buffs
	[916015] = {auraName = strformat('%s %d', L.SampleAura_PlayerMajor, 1),		unitTag = 'player', duration = 30,	icon = [[/esoui/art/icons/ability_sorcerer_boundless_storm.dds]], effectType = BUFF_EFFECT_TYPE_BUFF,	abilityType = ABILITY_TYPE_BONUS},
	[916016] = {auraName = strformat('%s %d', L.SampleAura_PlayerMinor, 1),		unitTag = 'player', duration = 30,	icon = [[/esoui/art/icons/ability_sorcerer_boundless_storm.dds]], effectType = BUFF_EFFECT_TYPE_BUFF,	abilityType = ABILITY_TYPE_BONUS},
	-- target buff (2 timeds and 1 passive)
	[916017] = {auraName = strformat('%s %d', L.SampleAura_TargetBuff, 1),		unitTag = 'reticleover', duration = 10,	icon = [[esoui/art/icons/ability_restorationstaff_004.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[916018] = {auraName = strformat('%s %d', L.SampleAura_TargetBuff, 2),		unitTag = 'reticleover', duration = 30,	icon = [[esoui/art/icons/ability_restorationstaff_005.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[916019] = {auraName = strformat('%s %d', L.SampleAura_TargetBuff, 3),		unitTag = 'reticleover', duration = 0,	icon = [[/esoui/art/icons/ability_armor_001.dds]],				effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	-- target debuff
	[916020] = {auraName = strformat('%s %d', L.SampleAura_TargetDebuff, 1),	unitTag = 'reticleover', duration = 10,	icon = [[esoui/art/icons/ability_nightblade_003.dds]],			effectType = BUFF_EFFECT_TYPE_DEBUFF,	abilityType = ABILITY_TYPE_BONUS},
	[916021] = {auraName = strformat('%s %d', L.SampleAura_TargetDebuff, 2),	unitTag = 'reticleover', duration = 30,	icon = [[esoui/art/icons/ability_nightblade_004.dds]],			effectType = BUFF_EFFECT_TYPE_DEBUFF,	abilityType = ABILITY_TYPE_BONUS},
}

local groupUnit = {
	["group1"]		= true,
	["group2"]		= true,
	["group3"]		= true,
	["group4"]		= true,
	["group5"]		= true,
	["group6"]		= true,
	["group7"]		= true,
	["group8"]		= true,
	["group9"]		= true,
	["group10"]		= true,
	["group11"]		= true,
	["group12"]		= true,
	["group13"]		= true,
	["group14"]		= true,
	["group15"]		= true,
	["group16"]		= true,
	["group17"]		= true,
	["group18"]		= true,
	["group19"]		= true,
	["group20"]		= true,
	["group21"]		= true,
	["group22"]		= true,
	["group23"]		= true,
	["group24"]		= true,
}


-- ------------------------
-- AURA DATA FUNCTIONS
-- ------------------------
function Srendarr.IsToggledAura(abilityID)
	return toggledAuras[abilityID] and true or false
end

function Srendarr.IsMajorEffect(abilityID)
	return majorEffects[abilityID] and true or false
end

function Srendarr.IsMinorEffect(abilityID)
	return minorEffects[abilityID] and true or false
end

function Srendarr.IsEnchantProc(abilityID)
	if enchantProcs[abilityID] ~= nil then return true else return false end
end

function Srendarr.IsAlternateAura(abilityID)
	if alternateAura[abilityID] ~= nil then return true else return false end
end

function Srendarr.IsGroupUnit(unitTag)
	if groupUnit[unitTag] ~= nil then return true else return false end
end

function Srendarr:PopulateFilteredAuras()
	for _, filterUnitTag in pairs(filteredAuras) do
		for id in pairs(filterUnitTag) do
			if (not filterAlwaysIgnored[id]) then
				filterUnitTag[id] = nil -- clean out existing filters unless always ignored
			end
		end
	end

	-- populate player aura filters
	for filterGroup, doFilter in pairs(self.db.filtersPlayer) do
		if (filterAuraGroups[filterGroup] and doFilter) then -- filtering this group for player
			for id in pairs(filterAuraGroups[filterGroup]) do
				filteredAuras.player[id] = true
			end
		end
	end

	-- populate target aura filters
	for filterGroup, doFilter in pairs(self.db.filtersTarget) do
		if (doFilter) then
			if (filterGroup == 'majorEffects') then			-- special case for majorEffects
				for id in pairs(majorEffects) do
					filteredAuras.reticleover[id] = true
				end
			elseif (filterGroup == 'minorEffects') then		-- special case for minorEffects
				for id in pairs(minorEffects) do
					filteredAuras.reticleover[id] = true
				end
			elseif (filterAuraGroups[filterGroup]) then
				for id in pairs(filterAuraGroups[filterGroup]) do
					filteredAuras.reticleover[id] = true
				end
			end
		end
	end

	-- populate ground aoe filters

	-- add blacklisted auras to all filter tables
	for _, filterForUnitTag in pairs(filteredAuras) do
		for _, abilityIDs in pairs(self.db.blacklist) do
			for id in pairs(abilityIDs) do
				filterForUnitTag[id] = true
			end
		end
	end
end


-- ------------------------
-- MINOR & MAJOR EFFECT DATA
-- ------------------------
minorEffects = {
-- Minor Aegis
	[76618] = EFFECT_AEGIS,
    [147225] = EFFECT_AEGIS,
-- Minor Berserk
	[61744] = EFFECT_BERSERK,
	[62636] = EFFECT_BERSERK,
	[80471] = EFFECT_BERSERK,
	[80481] = EFFECT_BERSERK,
	[114862] = EFFECT_BERSERK,
	[120008] = EFFECT_BERSERK,
    [150782] = EFFECT_BERSERK,
-- Minor Breach
    [38688] = EFFECT_BREACH,
	[61742] = EFFECT_BREACH,
	[68588] = EFFECT_BREACH,
	[83031] = EFFECT_BREACH,
    [84358] = EFFECT_BREACH,
	[108825] = EFFECT_BREACH,
	[120019] = EFFECT_BREACH,
    [126685] = EFFECT_BREACH,
    [146908] = EFFECT_BREACH,
    [148803] = EFFECT_BREACH,
    [149576] = EFFECT_BREACH,
-- Minor Brittle
    [145975] = EFFECT_BRITTLE,
    [146697] = EFFECT_BRITTLE,
    [148977] = EFFECT_BRITTLE,
-- Minor Brutality
	[61662] = EFFECT_BRUTALITY,
	[61798] = EFFECT_BRUTALITY,
	[61799] = EFFECT_BRUTALITY,
	[79281] = EFFECT_BRUTALITY,
	[79283] = EFFECT_BRUTALITY,
	[120023] = EFFECT_BRUTALITY,
-- Minor Courage
	[121878] = EFFECT_COURAGE,
	[137348] = EFFECT_COURAGE,
    [147417] = EFFECT_COURAGE,
	[159310] = EFFECT_COURAGE,
	[159341] = EFFECT_COURAGE,
	[159352] = EFFECT_COURAGE,
	[159356] = EFFECT_COURAGE,
	[160394] = EFFECT_COURAGE,
-- Minor Cowardice
	[46202] = EFFECT_COWARDICE,
	[46244] = EFFECT_COWARDICE,
    [51443] = EFFECT_COWARDICE,
	[79069] = EFFECT_COWARDICE,
	[79082] = EFFECT_COWARDICE,
	[79193] = EFFECT_COWARDICE,
	[79278] = EFFECT_COWARDICE,
	[79867] = EFFECT_COWARDICE,
    [126675] = EFFECT_COWARDICE,
-- Minor Defile
    [21927] = EFFECT_DEFILE,
	[38686] = EFFECT_DEFILE,
	[61726] = EFFECT_DEFILE,
	[78606] = EFFECT_DEFILE,
	[79851] = EFFECT_DEFILE,
	[79854] = EFFECT_DEFILE,
	[79856] = EFFECT_DEFILE,
	[79857] = EFFECT_DEFILE,
	[79858] = EFFECT_DEFILE,
	[79860] = EFFECT_DEFILE,
	[79861] = EFFECT_DEFILE,
	[79862] = EFFECT_DEFILE,
    [85637] = EFFECT_DEFILE,
	[88470] = EFFECT_DEFILE,
	[114206] = EFFECT_DEFILE,
	[117885] = EFFECT_DEFILE,
	[117890] = EFFECT_DEFILE,
	[130823] = EFFECT_DEFILE,
	[134427] = EFFECT_DEFILE,
	[134445] = EFFECT_DEFILE,
-- Minor Endurance
	[26215] = EFFECT_ENDURANCE,
	[61704] = EFFECT_ENDURANCE,
	[80271] = EFFECT_ENDURANCE,
	[80276] = EFFECT_ENDURANCE,
	[80284] = EFFECT_ENDURANCE,
	[87019] = EFFECT_ENDURANCE,
	[124703] = EFFECT_ENDURANCE,
    [126527] = EFFECT_ENDURANCE,
    [126534] = EFFECT_ENDURANCE,
    [126537] = EFFECT_ENDURANCE,
-- Minor Enervation
	[47202] = EFFECT_ENERVATION,
	[47203] = EFFECT_ENERVATION,
	[79113] = EFFECT_ENERVATION,
	[79116] = EFFECT_ENERVATION,
	[79450] = EFFECT_ENERVATION,
	[79454] = EFFECT_ENERVATION,
	[79907] = EFFECT_ENERVATION,
    [92921] = EFFECT_ENERVATION,
    [134040] = EFFECT_ENERVATION,
-- Minor Evasion
	[61715] = EFFECT_EVASION,
	[114858] = EFFECT_EVASION,
-- Minor Expedition
	[40219] = EFFECT_EXPEDITION,
	[61735] = EFFECT_EXPEDITION,
	[82797] = EFFECT_EXPEDITION,
	[85602] = EFFECT_EXPEDITION,
	[106860] = EFFECT_EXPEDITION,
	[108935] = EFFECT_EXPEDITION,
    [125901] = EFFECT_EXPEDITION,
    [143684] = EFFECT_EXPEDITION,
    [143705] = EFFECT_EXPEDITION,
-- Minor Force
	[61746] = EFFECT_FORCE,
	[68595] = EFFECT_FORCE,
	[68628] = EFFECT_FORCE,
	[68632] = EFFECT_FORCE,
	[76564] = EFFECT_FORCE,
	[80984] = EFFECT_FORCE,
	[80986] = EFFECT_FORCE,
	[85611] = EFFECT_FORCE,
	[103521] = EFFECT_FORCE,
	[103708] = EFFECT_FORCE,
	[103712] = EFFECT_FORCE,
	[106861] = EFFECT_FORCE,
	[116775] = EFFECT_FORCE,
    [143685] = EFFECT_FORCE,
    [143706] = EFFECT_FORCE,
    [144032] = EFFECT_FORCE,
-- Minor Fortitude
	[26213] = EFFECT_FORTITUDE,
	[61697] = EFFECT_FORTITUDE,
	[124701] = EFFECT_FORTITUDE,
-- Minor Gallop
-- Minor Heroism
	[61708] = EFFECT_HEROISM,
	[62505] = EFFECT_HEROISM,
	[85593] = EFFECT_HEROISM,
    [113284] = EFFECT_HEROISM,
	[113355] = EFFECT_HEROISM,
	[125026] = EFFECT_HEROISM,
	[125027] = EFFECT_HEROISM,
	[125039] = EFFECT_HEROISM,
	[125041] = EFFECT_HEROISM,
	[125204] = EFFECT_HEROISM,
	[125206] = EFFECT_HEROISM,
    [129536] = EFFECT_HEROISM,
	[155993] = EFFECT_HEROISM,
-- Minor Hindrance
-- Minor Intellect
	[26216] = EFFECT_INTELLECT,
	[36740] = EFFECT_INTELLECT,
	[61706] = EFFECT_INTELLECT,
	[77418] = EFFECT_INTELLECT,
	[86300] = EFFECT_INTELLECT,
	[124702] = EFFECT_INTELLECT,
-- Minor Lifesteal
	[80020] = EFFECT_LIFESTEAL,
	[86304] = EFFECT_LIFESTEAL,
	[86305] = EFFECT_LIFESTEAL,
	[86307] = EFFECT_LIFESTEAL,
	[88565] = EFFECT_LIFESTEAL,
	[88575] = EFFECT_LIFESTEAL,
	[88606] = EFFECT_LIFESTEAL,
	[92653] = EFFECT_LIFESTEAL,
    [121634] = EFFECT_LIFESTEAL,
-- Minor Magickasteal
	[26220] = EFFECT_MAGICKASTEAL,
	[26809] = EFFECT_MAGICKASTEAL,
	[39100] = EFFECT_MAGICKASTEAL,
	[88401] = EFFECT_MAGICKASTEAL,
	[88402] = EFFECT_MAGICKASTEAL,
	[88576] = EFFECT_MAGICKASTEAL,
    [148798] = EFFECT_MAGICKASTEAL,
    [149012] = EFFECT_MAGICKASTEAL,
    [149575] = EFFECT_MAGICKASTEAL,
-- Minor Maim
	[29308] = EFFECT_MAIM,
	[31899] = EFFECT_MAIM,
	[33228] = EFFECT_MAIM,
	[33512] = EFFECT_MAIM,
	[44206] = EFFECT_MAIM,
	[46204] = EFFECT_MAIM,
	[46246] = EFFECT_MAIM,
	[51558] = EFFECT_MAIM,
	[61723] = EFFECT_MAIM,
	[62495] = EFFECT_MAIM,
	[62504] = EFFECT_MAIM,
	[68368] = EFFECT_MAIM,
	[79083] = EFFECT_MAIM,
	[79085] = EFFECT_MAIM,
    [79280] = EFFECT_MAIM,
	[79282] = EFFECT_MAIM,
	[80848] = EFFECT_MAIM,
    [80990] = EFFECT_MAIM,
	[88469] = EFFECT_MAIM,
	[89012] = EFFECT_MAIM,
	[91174] = EFFECT_MAIM,
	[102097] = EFFECT_MAIM,
	[108939] = EFFECT_MAIM,
	[118313] = EFFECT_MAIM,
	[118358] = EFFECT_MAIM,
	[121517] = EFFECT_MAIM,
	[123946] = EFFECT_MAIM,
    [130815] = EFFECT_MAIM,
    [137311] = EFFECT_MAIM,
-- Minor Mangle
	[39168] = EFFECT_MANGLE,
	[39180] = EFFECT_MANGLE,
	[39181] = EFFECT_MANGLE,
	[61733] = EFFECT_MANGLE,
	[91334] = EFFECT_MANGLE,
	[91337] = EFFECT_MANGLE,
	[93363] = EFFECT_MANGLE,
    [148808] = EFFECT_MANGLE,
    [149574] = EFFECT_MANGLE,
	[161506] = EFFECT_MANGLE,
-- Minor Mending
	[29096] = EFFECT_MENDING,
	[61710] = EFFECT_MENDING,
	[108934] = EFFECT_MENDING,
	[113307] = EFFECT_MENDING,
    [134626] = EFFECT_MENDING,
    [134627] = EFFECT_MENDING,
-- Minor Prophecy
	[61691] = EFFECT_PROPHECY,
	[62319] = EFFECT_PROPHECY,
	[62320] = EFFECT_PROPHECY,
	[79447] = EFFECT_PROPHECY,
	[79449] = EFFECT_PROPHECY,
	[120028] = EFFECT_PROPHECY,
-- Minor Protection
	[35739] = EFFECT_PROTECTION,
	[40171] = EFFECT_PROTECTION,
	[40185] = EFFECT_PROTECTION,
	[61721] = EFFECT_PROTECTION,
    [62475] = EFFECT_PROTECTION,
	[79711] = EFFECT_PROTECTION,
	[79712] = EFFECT_PROTECTION,
	[79713] = EFFECT_PROTECTION,
	[79714] = EFFECT_PROTECTION,
	[79725] = EFFECT_PROTECTION,
	[79727] = EFFECT_PROTECTION,
	[85551] = EFFECT_PROTECTION,
	[87194] = EFFECT_PROTECTION,
	[103570] = EFFECT_PROTECTION,
	[108913] = EFFECT_PROTECTION,
	[113356] = EFFECT_PROTECTION,
	[114838] = EFFECT_PROTECTION,
	[114841] = EFFECT_PROTECTION,
	[115097] = EFFECT_PROTECTION,
	[118385] = EFFECT_PROTECTION,
	[118409] = EFFECT_PROTECTION,
    [146795] = EFFECT_PROTECTION,
    [146796] = EFFECT_PROTECTION,
    [146797] = EFFECT_PROTECTION,
-- Minor Resolve
	[37247] = EFFECT_RESOLVE,
	[61693] = EFFECT_RESOLVE,
	[61817] = EFFECT_RESOLVE,
	[62626] = EFFECT_RESOLVE,
	[62634] = EFFECT_RESOLVE,
	[108856] = EFFECT_RESOLVE,
	[159311] = EFFECT_RESOLVE,
	[159340] = EFFECT_RESOLVE,
	[159350] = EFFECT_RESOLVE,
	[159358] = EFFECT_RESOLVE,
-- Minor Savagery
	[61666] = EFFECT_SAVAGERY,
	[61882] = EFFECT_SAVAGERY,
	[61898] = EFFECT_SAVAGERY,
	[79453] = EFFECT_SAVAGERY,
	[79455] = EFFECT_SAVAGERY,
	[120029] = EFFECT_SAVAGERY,
-- Minor Slayer
	[76617] = EFFECT_SLAYER,
    [147226] = EFFECT_SLAYER,
-- Minor Sorcery
	[62800] = EFFECT_SORCERY,
	[62799] = EFFECT_SORCERY,
	[61685] = EFFECT_SORCERY,
	[79221] = EFFECT_SORCERY,
	[79279] = EFFECT_SORCERY,
	[120017] = EFFECT_SORCERY,
-- Minor Toughness
	[88490] = EFFECT_TOUGHNESS,
	[88492] = EFFECT_TOUGHNESS,
	[88509] = EFFECT_TOUGHNESS,
	[92762] = EFFECT_TOUGHNESS,
	[120020] = EFFECT_TOUGHNESS,
-- Minor Uncertainty
	[47204] = EFFECT_UNCERTAINTY,
	[47205] = EFFECT_UNCERTAINTY,
	[79117] = EFFECT_UNCERTAINTY,
	[79118] = EFFECT_UNCERTAINTY,
	[79446] = EFFECT_UNCERTAINTY,
	[79448] = EFFECT_UNCERTAINTY,
	[79895] = EFFECT_UNCERTAINTY,
    [134034] = EFFECT_UNCERTAINTY,
-- Minor Vitality
	[61549] = EFFECT_VITALITY,
	[64080] = EFFECT_VITALITY,
	[79852] = EFFECT_VITALITY,
	[79855] = EFFECT_VITALITY,
	[80953] = EFFECT_VITALITY,
	[85565] = EFFECT_VITALITY,
	[91670] = EFFECT_VITALITY,
	[113306] = EFFECT_VITALITY,
    [126925] = EFFECT_VITALITY,
-- Minor Vulnerability
	[51434] = EFFECT_VULNERABILITY,
	[61782] = EFFECT_VULNERABILITY,
	[68359] = EFFECT_VULNERABILITY,
	[79715] = EFFECT_VULNERABILITY,
	[79717] = EFFECT_VULNERABILITY,
	[79720] = EFFECT_VULNERABILITY,
	[79723] = EFFECT_VULNERABILITY,
	[79726] = EFFECT_VULNERABILITY,
	[79843] = EFFECT_VULNERABILITY,
	[79844] = EFFECT_VULNERABILITY,
	[79845] = EFFECT_VULNERABILITY,
	[79846] = EFFECT_VULNERABILITY,
	[81519] = EFFECT_VULNERABILITY,
	[117025] = EFFECT_VULNERABILITY,
	[118613] = EFFECT_VULNERABILITY,
	[120030] = EFFECT_VULNERABILITY,
	[124803] = EFFECT_VULNERABILITY,
	[124804] = EFFECT_VULNERABILITY,
	[124806] = EFFECT_VULNERABILITY,
    [130155] = EFFECT_VULNERABILITY,
    [130168] = EFFECT_VULNERABILITY,
    [130173] = EFFECT_VULNERABILITY,
    [130809] = EFFECT_VULNERABILITY,
}

majorEffects = {
-- Major Aegis
	[93123] = EFFECT_AEGIS,
	[93125] = EFFECT_AEGIS,
	[93444] = EFFECT_AEGIS,
	[135926] = EFFECT_AEGIS,
	[137989] = EFFECT_AEGIS,
-- Major Berserk
	[36973] = EFFECT_BERSERK,
	[48078] = EFFECT_BERSERK,
	[61745] = EFFECT_BERSERK,
	[62195] = EFFECT_BERSERK,
	[84310] = EFFECT_BERSERK,
	[121065] = EFFECT_BERSERK,
	[121066] = EFFECT_BERSERK,
    [134094] = EFFECT_BERSERK,
	[134433] = EFFECT_BERSERK,
	[137206] = EFFECT_BERSERK,
    [143992] = EFFECT_BERSERK,
    [150757] = EFFECT_BERSERK,
-- Major Breach
    [28307] = EFFECT_BREACH,
	[33363] = EFFECT_BREACH,
    [34386] = EFFECT_BREACH,
	[36972] = EFFECT_BREACH,
	[36980] = EFFECT_BREACH,
    [40254] = EFFECT_BREACH,
    [48946] = EFFECT_BREACH,
	[53881] = EFFECT_BREACH,
	[61743] = EFFECT_BREACH,
    [62474] = EFFECT_BREACH,
	[62485] = EFFECT_BREACH,
	[62775] = EFFECT_BREACH,
	[62787] = EFFECT_BREACH,
	[78609] = EFFECT_BREACH,
    [85362] = EFFECT_BREACH,
    [91175] = EFFECT_BREACH,
	[91200] = EFFECT_BREACH,
    [100988] = EFFECT_BREACH,
	[103628] = EFFECT_BREACH,
	[108951] = EFFECT_BREACH,
    [111788] = EFFECT_BREACH,
	[117818] = EFFECT_BREACH,
	[118438] = EFFECT_BREACH,
	[120010] = EFFECT_BREACH,
	[163062] = EFFECT_BREACH,
-- Major Brittle
    [145977] = EFFECT_BRITTLE,
-- Major Brutality
	[23673] = EFFECT_BRUTALITY,
	[36903] = EFFECT_BRUTALITY,
	[45228] = EFFECT_BRUTALITY,
	[45393] = EFFECT_BRUTALITY,
	[61665] = EFFECT_BRUTALITY,
	[61670] = EFFECT_BRUTALITY,
	[62060] = EFFECT_BRUTALITY,
	[62147] = EFFECT_BRUTALITY,
	[62387] = EFFECT_BRUTALITY,
	[62415] = EFFECT_BRUTALITY,
	[63768] = EFFECT_BRUTALITY,
	[64554] = EFFECT_BRUTALITY,
	[64555] = EFFECT_BRUTALITY,
	[68807] = EFFECT_BRUTALITY,
	[72936] = EFFECT_BRUTALITY,
	[76518] = EFFECT_BRUTALITY,
	[81517] = EFFECT_BRUTALITY,
	[86695] = EFFECT_BRUTALITY,
	[89110] = EFFECT_BRUTALITY,
	[95419] = EFFECT_BRUTALITY,
	[104013] = EFFECT_BRUTALITY,
	[116371] = EFFECT_BRUTALITY,
    [126647] = EFFECT_BRUTALITY,
    [126670] = EFFECT_BRUTALITY,
    [131340] = EFFECT_BRUTALITY,
    [131341] = EFFECT_BRUTALITY,
    [131342] = EFFECT_BRUTALITY,
    [131343] = EFFECT_BRUTALITY,
    [131346] = EFFECT_BRUTALITY,
    [131350] = EFFECT_BRUTALITY,
	[137193] = EFFECT_BRUTALITY,
	[163656] = EFFECT_BRUTALITY,
-- Major Courage
	[66902] = EFFECT_COURAGE,
	[109966] = EFFECT_COURAGE,
	[109994] = EFFECT_COURAGE,
	[110020] = EFFECT_COURAGE,
	[120015] = EFFECT_COURAGE,
-- Major Cowardice
    [111354] = EFFECT_COWARDICE,
    [147643] = EFFECT_COWARDICE,
	[163065] = EFFECT_COWARDICE,
-- Major Defile
	[24686] = EFFECT_DEFILE,
	[29230] = EFFECT_DEFILE,
	[32949] = EFFECT_DEFILE,
	[32961] = EFFECT_DEFILE,
	[34527] = EFFECT_DEFILE,
	[34876] = EFFECT_DEFILE,
	[36515] = EFFECT_DEFILE,
	[44229] = EFFECT_DEFILE,
	[58869] = EFFECT_DEFILE,
	[61727] = EFFECT_DEFILE,
	[63148] = EFFECT_DEFILE,
	[80838] = EFFECT_DEFILE,
	[81017] = EFFECT_DEFILE,
	[83955] = EFFECT_DEFILE,
	[85944] = EFFECT_DEFILE,
	[91312] = EFFECT_DEFILE,
	[91332] = EFFECT_DEFILE,
	[93375] = EFFECT_DEFILE,
	[97531] = EFFECT_DEFILE,
	[99786] = EFFECT_DEFILE,
	[105100] = EFFECT_DEFILE,
	[117727] = EFFECT_DEFILE,
    [133060] = EFFECT_DEFILE,
	[133703] = EFFECT_DEFILE,
	[154897] = EFFECT_DEFILE,
	[163066] = EFFECT_DEFILE,
-- Major Endurance
	[32748] = EFFECT_ENDURANCE,
	[45226] = EFFECT_ENDURANCE,
	[61705] = EFFECT_ENDURANCE,
	[62575] = EFFECT_ENDURANCE,
	[63681] = EFFECT_ENDURANCE,
	[63683] = EFFECT_ENDURANCE,
	[63766] = EFFECT_ENDURANCE,
	[63789] = EFFECT_ENDURANCE,
	[68361] = EFFECT_ENDURANCE,
	[68408] = EFFECT_ENDURANCE,
	[72935] = EFFECT_ENDURANCE,
	[78054] = EFFECT_ENDURANCE,
	[78080] = EFFECT_ENDURANCE,
	[86693] = EFFECT_ENDURANCE,
	[116385] = EFFECT_ENDURANCE,
	[157802] = EFFECT_ENDURANCE,
-- Major Enervation
-- Major Evasion
	[61716] = EFFECT_EVASION,
	[63015] = EFFECT_EVASION,
	[63019] = EFFECT_EVASION,
	[63030] = EFFECT_EVASION,
	[69685] = EFFECT_EVASION,
    [76940] = EFFECT_EVASION,
	[84341] = EFFECT_EVASION,
    [86555] = EFFECT_EVASION,
	[90587] = EFFECT_EVASION,
	[90593] = EFFECT_EVASION,
	[90620] = EFFECT_EVASION,
	[106867] = EFFECT_EVASION,
	[123652] = EFFECT_EVASION,
	[123653] = EFFECT_EVASION,
	[123651] = EFFECT_EVASION,
-- Major Expedition
	[23216] = EFFECT_EXPEDITION,
	[33210] = EFFECT_EXPEDITION,
	[34511] = EFFECT_EXPEDITION,
	[36050] = EFFECT_EXPEDITION,
	[38967] = EFFECT_EXPEDITION,
	[45235] = EFFECT_EXPEDITION,
	[45399] = EFFECT_EXPEDITION,
	[50997] = EFFECT_EXPEDITION,
	[61736] = EFFECT_EXPEDITION,
	[62531] = EFFECT_EXPEDITION,
	[64005] = EFFECT_EXPEDITION,
	[64566] = EFFECT_EXPEDITION,
	[64567] = EFFECT_EXPEDITION,
	[76498] = EFFECT_EXPEDITION,
	[76502] = EFFECT_EXPEDITION,
	[76506] = EFFECT_EXPEDITION,
	[78081] = EFFECT_EXPEDITION,
	[79368] = EFFECT_EXPEDITION,
	[79370] = EFFECT_EXPEDITION,
	[79623] = EFFECT_EXPEDITION,
	[79624] = EFFECT_EXPEDITION,
	[79625] = EFFECT_EXPEDITION,
	[79877] = EFFECT_EXPEDITION,
	[81524] = EFFECT_EXPEDITION,
	[85592] = EFFECT_EXPEDITION,
	[86267] = EFFECT_EXPEDITION,
	[89076] = EFFECT_EXPEDITION,
	[89078] = EFFECT_EXPEDITION,
	[91193] = EFFECT_EXPEDITION,
	[92418] = EFFECT_EXPEDITION,
	[92771] = EFFECT_EXPEDITION,
	[98489] = EFFECT_EXPEDITION,
	[98490] = EFFECT_EXPEDITION,
	[101161] = EFFECT_EXPEDITION,
	[101169] = EFFECT_EXPEDITION,
	[101178] = EFFECT_EXPEDITION,
	[103321] = EFFECT_EXPEDITION,
	[103520] = EFFECT_EXPEDITION,
	[103707] = EFFECT_EXPEDITION,
	[103711] = EFFECT_EXPEDITION,
    [106776] = EFFECT_EXPEDITION,
	[116374] = EFFECT_EXPEDITION,
	[121827] = EFFECT_EXPEDITION,
	[124801] = EFFECT_EXPEDITION,
	[126957] = EFFECT_EXPEDITION,
	[144708] = EFFECT_EXPEDITION,
	[160047] = EFFECT_EXPEDITION,
-- Major Force
	[46522] = EFFECT_FORCE, -- Aggressive Warhorn Major Force (DO NOT REMOVE!)
	[46533] = EFFECT_FORCE, -- Aggressive Warhorn Major Force (DO NOT REMOVE!)
	[46536] = EFFECT_FORCE, -- Aggressive Warhorn Major Force (DO NOT REMOVE!)
	[46539] = EFFECT_FORCE, -- Aggressive Warhorn Major Force (DO NOT REMOVE!)
	[5159289] = EFFECT_FORCE, -- Grisly Gourmet (DON NOT REMOVE!)
	[40225] = EFFECT_FORCE,
	[61747] = EFFECT_FORCE,
	[85154] = EFFECT_FORCE,
	[120013] = EFFECT_FORCE,
	[154830] = EFFECT_FORCE,
-- Major Fortitude
	[29011] = EFFECT_FORTITUDE,
	[45222] = EFFECT_FORTITUDE,
	[61698] = EFFECT_FORTITUDE,
	[61884] = EFFECT_FORTITUDE,
	[62555] = EFFECT_FORTITUDE,
	[63670] = EFFECT_FORTITUDE,
	[63672] = EFFECT_FORTITUDE,
	[63784] = EFFECT_FORTITUDE,
	[66256] = EFFECT_FORTITUDE,
	[68375] = EFFECT_FORTITUDE,
	[68405] = EFFECT_FORTITUDE,
	[72928] = EFFECT_FORTITUDE,
	[86697] = EFFECT_FORTITUDE,
	[91674] = EFFECT_FORTITUDE,
	[92415] = EFFECT_FORTITUDE,
	[157804] = EFFECT_FORTITUDE,
-- Major Gallop
	[63569] = EFFECT_GALLOP,
-- Major Heroism
	[61709] = EFFECT_HEROISM,
	[65133] = EFFECT_HEROISM,
	[87234] = EFFECT_HEROISM,
	[92775] = EFFECT_HEROISM,
	[111377] = EFFECT_HEROISM,
	[111380] = EFFECT_HEROISM,
    [150974] = EFFECT_HEROISM,
-- Major Hindrance
-- Major Intellect
	[45224] = EFFECT_INTELLECT,
	[61707] = EFFECT_INTELLECT,
	[62577] = EFFECT_INTELLECT,
	[63676] = EFFECT_INTELLECT,
	[63678] = EFFECT_INTELLECT,
	[63771] = EFFECT_INTELLECT,
	[63785] = EFFECT_INTELLECT,
	[68133] = EFFECT_INTELLECT,
	[68406] = EFFECT_INTELLECT,
	[72932] = EFFECT_INTELLECT,
	[86683] = EFFECT_INTELLECT,
	[157806] = EFFECT_INTELLECT,
-- Major Lifesteal
-- Major Magickasteal
-- Major Maim
	[21754] = EFFECT_MAIM,
	[21760] = EFFECT_MAIM,
	[61725] = EFFECT_MAIM,
	[78607] = EFFECT_MAIM,
	[92041] = EFFECT_MAIM,
	[93078] = EFFECT_MAIM,
    [133292] = EFFECT_MAIM,
	[133214] = EFFECT_MAIM,
	[134444] = EFFECT_MAIM,
	[141927] = EFFECT_MAIM,
    [147746] = EFFECT_MAIM,
	[159376] = EFFECT_MAIM,
	[159664] = EFFECT_MAIM,
	[163064] = EFFECT_MAIM,
-- Major Mangle
-- Major Mending
	[55033] = EFFECT_MENDING,
	[61711] = EFFECT_MENDING,
	[77918] = EFFECT_MENDING,
	[77922] = EFFECT_MENDING,
	[88525] = EFFECT_MENDING,
	[88528] = EFFECT_MENDING,
	[92774] = EFFECT_MENDING,
	[93364] = EFFECT_MENDING,
	[106806] = EFFECT_MENDING,
	[108675] = EFFECT_MENDING,
	[108676] = EFFECT_MENDING,
-- Major Prophecy
	[21726] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[21729] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[21732] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24160] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24167] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24171] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24174] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24177] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24180] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24184] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24187] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24195] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[47193] = EFFECT_PROPHECY,
	[47195] = EFFECT_PROPHECY,
	[61689] = EFFECT_PROPHECY,
	[62747] = EFFECT_PROPHECY,
	[62751] = EFFECT_PROPHECY,
	[62755] = EFFECT_PROPHECY,
	[63776] = EFFECT_PROPHECY,
	[64570] = EFFECT_PROPHECY,
	[64572] = EFFECT_PROPHECY,
	[75088] = EFFECT_PROPHECY,
	[76420] = EFFECT_PROPHECY,
	[76433] = EFFECT_PROPHECY,
	[77928] = EFFECT_PROPHECY,
	[77945] = EFFECT_PROPHECY,
	[77958] = EFFECT_PROPHECY,
	[85613] = EFFECT_PROPHECY,
	[86303] = EFFECT_PROPHECY,
	[86684] = EFFECT_PROPHECY,
	[137006] = EFFECT_PROPHECY,
	[163663] = EFFECT_PROPHECY,
-- Major Protection
	[22233] = EFFECT_PROTECTION,
	[44854] = EFFECT_PROTECTION,
	[44862] = EFFECT_PROTECTION,
	[44871] = EFFECT_PROTECTION,
	[61722] = EFFECT_PROTECTION,
	[79068] = EFFECT_PROTECTION,
	[80853] = EFFECT_PROTECTION,
	[86249] = EFFECT_PROTECTION,
	[88859] = EFFECT_PROTECTION,
	[88862] = EFFECT_PROTECTION,
	[92773] = EFFECT_PROTECTION,
	[92909] = EFFECT_PROTECTION,
	[93079] = EFFECT_PROTECTION,
	[97910] = EFFECT_PROTECTION,
	[113509] = EFFECT_PROTECTION,
	[118629] = EFFECT_PROTECTION,
    [129477] = EFFECT_PROTECTION,
	[160074] = EFFECT_PROTECTION,
	[161716] = EFFECT_PROTECTION,
-- Major Resolve
	[22236] = EFFECT_RESOLVE,
	[44828] = EFFECT_RESOLVE,
	[44836] = EFFECT_RESOLVE,
	[61694] = EFFECT_RESOLVE,
	[61815] = EFFECT_RESOLVE,
	[61827] = EFFECT_RESOLVE,
	[61836] = EFFECT_RESOLVE,
	[62159] = EFFECT_RESOLVE,
	[62168] = EFFECT_RESOLVE,
	[62175] = EFFECT_RESOLVE,
	[63084] = EFFECT_RESOLVE,
	[63119] = EFFECT_RESOLVE,
	[63134] = EFFECT_RESOLVE,
	[66075] = EFFECT_RESOLVE,
	[66083] = EFFECT_RESOLVE,
	[80160] = EFFECT_RESOLVE,
    [80482] = EFFECT_RESOLVE,
	[86224] = EFFECT_RESOLVE,
	[88758] = EFFECT_RESOLVE,
	[88761] = EFFECT_RESOLVE,
	[91194] = EFFECT_RESOLVE,
	[103752] = EFFECT_RESOLVE,
	[107632] = EFFECT_RESOLVE,
	[115211] = EFFECT_RESOLVE,
	[116805] = EFFECT_RESOLVE,
	[118239] = EFFECT_RESOLVE,
	[118246] = EFFECT_RESOLVE,
    [150998] = EFFECT_RESOLVE,
    [150999] = EFFECT_RESOLVE,
-- Major Savagery
	[26795] = EFFECT_SAVAGERY,
	[45241] = EFFECT_SAVAGERY,
	[45466] = EFFECT_SAVAGERY,
	[61667] = EFFECT_SAVAGERY,
	[63770] = EFFECT_SAVAGERY,
	[64509] = EFFECT_SAVAGERY,
	[64568] = EFFECT_SAVAGERY,
	[64569] = EFFECT_SAVAGERY,
	[76426] = EFFECT_SAVAGERY,
	[85605] = EFFECT_SAVAGERY,
	[86694] = EFFECT_SAVAGERY,
	[87061] = EFFECT_SAVAGERY,
	[137007] = EFFECT_SAVAGERY,
	[138072] = EFFECT_SAVAGERY,
	[163664] = EFFECT_SAVAGERY,
-- Major Slayer
	[93109] = EFFECT_SLAYER,
	[93120] = EFFECT_SLAYER,
	[93442] = EFFECT_SLAYER,
	[121871] = EFFECT_SLAYER,
	[137986] = EFFECT_SLAYER,
-- Major Sorcery
    [33317] = EFFECT_SORCERY,
	[45227] = EFFECT_SORCERY,
	[45391] = EFFECT_SORCERY,
	[61687] = EFFECT_SORCERY,
	[62062] = EFFECT_SORCERY,
	[62240] = EFFECT_SORCERY,
	[63227] = EFFECT_SORCERY,
	[63774] = EFFECT_SORCERY,
	[64558] = EFFECT_SORCERY,
	[64561] = EFFECT_SORCERY,
	[72933] = EFFECT_SORCERY,
	[85623] = EFFECT_SORCERY,
	[86685] = EFFECT_SORCERY,
	[87929] = EFFECT_SORCERY,
	[89107] = EFFECT_SORCERY,
	[92503] = EFFECT_SORCERY,
	[92507] = EFFECT_SORCERY,
	[92512] = EFFECT_SORCERY,
	[93350] = EFFECT_SORCERY,
	[95125] = EFFECT_SORCERY,
	[131310] = EFFECT_SORCERY,
	[131311] = EFFECT_SORCERY,
	[131344] = EFFECT_SORCERY,
	[135923] = EFFECT_SLAYER,
	[137986] = EFFECT_SLAYER,
	[163655] = EFFECT_SORCERY,
-- Major Toughness
-- Major Uncertainty
-- Major Vitality
	[42197] = EFFECT_VITALITY,
	[61275] = EFFECT_VITALITY,
	[61713] = EFFECT_VITALITY,
	[63533] = EFFECT_VITALITY,
	[79847] = EFFECT_VITALITY,
	[79848] = EFFECT_VITALITY,
	[79849] = EFFECT_VITALITY,
	[79850] = EFFECT_VITALITY,
	[92776] = EFFECT_VITALITY,
	[108832] = EFFECT_VITALITY,
	[111221] = EFFECT_VITALITY,
	[113653] = EFFECT_VITALITY,
	[133318] = EFFECT_VITALITY,
-- Major Vulnerability
	[106754] = EFFECT_VULNERABILITY,
	[106755] = EFFECT_VULNERABILITY,
	[106758] = EFFECT_VULNERABILITY,
	[106760] = EFFECT_VULNERABILITY,
	[106762] = EFFECT_VULNERABILITY,
	[122177] = EFFECT_VULNERABILITY,
	[122397] = EFFECT_VULNERABILITY,
	[122389] = EFFECT_VULNERABILITY,
    [132831] = EFFECT_VULNERABILITY,
    [148976] = EFFECT_VULNERABILITY,
	[163060] = EFFECT_VULNERABILITY,
-- Sample Auras
	[116015] = SAMPLE_AURA,
}



--------------------------------------------------------------------------------------------------------------------
-- AURA DATA DEBUG & PATCH FUNCTIONS
-- Used after patches to assist in getting hold of changed abilityIDs (messy, only uncomment when needed to use)
--------------------------------------------------------------------------------------------------------------------

--[[
function GetToggled()
	-- returns all abilityIDs that match the names used as toggledAuras
	-- used to grab ALL the nessecary abilityIDs for the table after a patch changes things
	local data, names, saved = {}, {}, {}

	for k, v in pairs(toggledAuras) do
		names[GetAbilityName(k)] = true
	end

	for x = 1, 100000 do
		if (DoesAbilityExist(x) and names[GetAbilityName(x)] and GetAbilityDuration(x) == 0 and GetAbilityDescription(x) ~= '') then
			table.insert(data, {(GetAbilityName(x)), x, GetAbilityDescription(x)})
		end
	end

	table.sort(data, function(a, b)	return a[1] > b[1] end)

	for k, v in ipairs(data) do
		d(v[2] .. ' ' .. v[1] .. '      ' .. string.sub(v[3], 1, 30))
		table.insert(saved, v[2] .. '|' .. v[1]..'||' ..string.sub(v[3],1,30))
	end

	--SrendarrDB.toggled = saved
end
]]

--[[
-- Useage: /script Srendarr:GetAurasByName("Shooting Star", 1)
function Srendarr:GetAurasByName(name, set)
	local start = (set == 1) and 1 or 100001
	local cap = (set == 1) and 100000 or 200000
	for x = start, cap do
	--	if (DoesAbilityExist(x) and GetAbilityName(x) == name and GetAbilityDuration(x) > 0) then
		if (DoesAbilityExist(x) and GetAbilityName(x) == name) then
			d('['..x ..'] '..GetAbilityName(x) .. '-' .. GetAbilityDuration(x) .. '-' .. GetAbilityDescription(x))
		end
	end
end
]]

--[[
function GetAuraInfo(idA, idB)
	d(string.format('[%d] %s (%ds) - %s', idA, GetAbilityName(idA), GetAbilityDuration(idA), GetAbilityDescription(idA)))
	d(string.format('[%d] %s (%ds) - %s', idB, GetAbilityName(idB), GetAbilityDuration(idB), GetAbilityDescription(idB)))
end
]]


--------------------------------------------------------------------------------------------------------------------
-- New method for updating Major/Minor effect tables by category. -Phinix
-- Useage: /script Srendarr:GetEffects(X,Y)
-- X = 1 for Minor and X = 2 for Major effects.
-- Y = Any number between 1 and 33 to pull the effect from table below. 
-- https://en.uesp.net/wiki/Online:Buffs
--------------------------------------------------------------------------------------------------------------------

local EffectTypes = {
	[1]		= {name = 'Aegis',				effect = 'EFFECT_AEGIS'},
	[2]		= {name = 'Berserk',			effect = 'EFFECT_BERSERK'},
	[3]		= {name = 'Breach',				effect = 'EFFECT_BREACH'},
	[4]		= {name = 'Brittle',			effect = 'EFFECT_BRITTLE'},
	[5]		= {name = 'Brutality',			effect = 'EFFECT_BRUTALITY'},
	[6]		= {name = 'Courage',			effect = 'EFFECT_COURAGE'},
	[7]		= {name = 'Cowardice',			effect = 'EFFECT_COWARDICE'},
	[8]		= {name = 'Defile',				effect = 'EFFECT_DEFILE'},
	[9]		= {name = 'Endurance',			effect = 'EFFECT_ENDURANCE'},
	[10]	= {name = 'Enervation',			effect = 'EFFECT_ENERVATION'},
	[11]	= {name = 'Evasion',			effect = 'EFFECT_EVASION'},
	[12]	= {name = 'Expedition',			effect = 'EFFECT_EXPEDITION'},
	[13]	= {name = 'Force',				effect = 'EFFECT_FORCE'},
	[14]	= {name = 'Fortitude',			effect = 'EFFECT_FORTITUDE'},
	[15]	= {name = 'Gallop',				effect = 'EFFECT_GALLOP'},
	[16]	= {name = 'Heroism',			effect = 'EFFECT_HEROISM'},
	[17]	= {name = 'Hindrance',			effect = 'EFFECT_HINDRANCE'},
	[18]	= {name = 'Intellect',			effect = 'EFFECT_INTELLECT'},
	[19]	= {name = 'Lifesteal',			effect = 'EFFECT_LIFESTEAL'},
	[20]	= {name = 'Magickasteal',		effect = 'EFFECT_MAGICKASTEAL'},
	[21]	= {name = 'Maim',				effect = 'EFFECT_MAIM'},
	[22]	= {name = 'Mangle',				effect = 'EFFECT_MANGLE'},
	[23]	= {name = 'Mending',			effect = 'EFFECT_MENDING'},
	[24]	= {name = 'Prophecy',			effect = 'EFFECT_PROPHECY'},
	[25]	= {name = 'Protection',			effect = 'EFFECT_PROTECTION'},
	[26]	= {name = 'Resolve',			effect = 'EFFECT_RESOLVE'},
	[27]	= {name = 'Savagery',			effect = 'EFFECT_SAVAGERY'},
	[28]	= {name = 'Slayer',				effect = 'EFFECT_SLAYER'},
	[29]	= {name = 'Sorcery',			effect = 'EFFECT_SORCERY'},
	[30]	= {name = 'Toughness',			effect = 'EFFECT_TOUGHNESS'},
	[31]	= {name = 'Uncertainty',		effect = 'EFFECT_UNCERTAINTY'},
	[32]	= {name = 'Vitality',			effect = 'EFFECT_VITALITY'},
	[33]	= {name = 'Vulnerability',		effect = 'EFFECT_VULNERABILITY'},
}

local ignoreEffects = {
	[46522] = true,
	[46533] = true,
	[46536] = true,
	[46539] = true,
	[21726] = true,
	[21729] = true,
	[21732] = true,
	[24160] = true,
	[24167] = true,
	[24171] = true,
	[24174] = true,
	[24177] = true,
	[24180] = true,
	[24184] = true,
	[24187] = true,
	[24195] = true,
}

local function UpdateIDTable(sTable, eTable, eID, eName)
	local aTable = {}
	local rTable = {}

	for k,v in pairs(sTable) do
		if eTable[k] == nil then
			aTable[k] = v
		end
	end
	for k,v in pairs(eTable) do
		if sTable[k] == nil and not ignoreEffects[k] and EffectTypes[v].effect == EffectTypes[eID].effect then
			rTable[k] = '[' .. tostring(k) .. '] = ' .. EffectTypes[eID].effect .. ','
		end
	end

	if next(aTable) ~= nil then
		d("New effects added:")
		for k,v in pairs(aTable) do
			d("    "..v)
		end
	else
		d(eName.." - No new effects added.")
	end
	if next(rTable) ~= nil then
		d("Effects removed:")
		for k,v in pairs(rTable) do
			d("    "..v)
		end
	else
		d(eName.." - No effects removed.")
	end
end

local function IDByEffect(tier, effect, stage)
	local eID = tonumber(effect)
	local eName
	local eTable = (tier == 1) and minorEffects or majorEffects

	if EffectTypes[eID] == nil then
		return
	else
		if tier == 1 then
			eName = 'Minor ' .. EffectTypes[eID].name
		else
			eName = 'Major ' .. EffectTypes[eID].name
		end

		eName = string.lower(eName) -- added string.lower() check to catch instances where internal case is inconsistent as Major Expedition 106776 for example. (Phinix)
		
		local tempInt = (stage == 1) and 0 or 1
		local IdLow = (50000 * stage) - 50000
		local IdHigh = 50000 * stage	

		for i = IdLow, IdHigh, 1 do
			local cID = tostring(i+tempInt)
			local linkstring = string.lower(tostring(ZOSName(cID,1)))
			if string.find(linkstring, eName) ~= nil then
				sTable[tonumber(cID)] = '[' .. cID .. '] = ' .. EffectTypes[eID].effect .. ','
				--local output = '[' .. cID .. '] = ' .. EffectTypes[eID].effect .. ','
				--d(output)
			end
			if i == IdHigh then
				if stage == 4 then
					UpdateIDTable(sTable, eTable, eID, eName)
				else
					zo_callLater(function() IDByEffect(tier, effect, stage+1) end, 500)
					return
				end
			end
		end
	end
end

function Srendarr:GetEffects(tier, effect)
	if ((tier == 1) or (tier == 2)) then
		newEffects = 0
		sTable = {}
		IDByEffect(tier, effect, 1)
	end
	return
end


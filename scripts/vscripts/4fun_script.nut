IncludeScript("4fun_cvars.nut");

asw_marine_ff_absorption <- Convars.GetStr("asw_marine_ff_absorption");
cat <- null;
hOfWeaponInWeaponFireEvent <- null;
hOfWeaponInWeaponOffhandActivateEvent <- null;
hOfMarineInWeaponFireEvent <- null;
hOfMarineInWeaponOffhandActivateEvent <- null;
timeExceptPrespawn <- Time();
berserkModeOnWolfe <- 0;
berserkModeOnCat <- 0;
HeavyMode <- 0;
immortalMode <- 0;
regenAmmoMode <- 0;
radianceKD <- 0;
bubbleCD <- 0;
invincibleCD <- Time();
invDelay <- Time();
hordeOn <- 0;
hordeMode <- Time();
bubbleAmmoCD <- 0;
immortalOwner <- null;

infWeapon <- [
	"asw_weapon_rifle",
	"asw_weapon_vindicator",
	"asw_weapon_prifle",
	"asw_weapon_minigun",
	"asw_weapon_50calmg",
	"asw_weapon_autogun",
	"asw_weapon_deagle",
	"asw_weapon_devastator",
	"asw_weapon_flamer",
	"asw_weapon_mining_laser",
	"asw_weapon_pdw",
	"asw_weapon_pistol",
	"asw_weapon_ricochet",
	"asw_weapon_shotgun",
	"asw_weapon_tesla_gun",
	"asw_weapon_stim",
	"asw_weapon_medrifle",
	"asw_weapon_heavy_rifle",
	"asw_weapon_sniper_rifle",
	"asw_weapon_grenades",
	"asw_weapon_combat_rifle"
];

regenInterval <- {
	asw_weapon_tesla_trap=0
	asw_weapon_stim=0
	asw_weapon_heal_grenade=0
	asw_weapon_electrified_armor=30
	asw_weapon_hornet_barrage=0
	asw_weapon_grenades=0
	asw_weapon_mines=0
	asw_weapon_buff_grenade=0
	asw_weapon_medical_satchel=20
	asw_weapon_medkit=0
	asw_weapon_laser_mines=0
	asw_weapon_freeze_grenades=10
	asw_weapon_railgun=0
	asw_weapon_gas_grenades=0
	asw_weapon_grenade_launcher=40
}

ammoCount <- {
	asw_weapon_tesla_trap=3
	asw_weapon_stim=1
	asw_weapon_heal_grenade=3
	asw_weapon_electrified_armor=2
	asw_weapon_hornet_barrage=1
	asw_weapon_grenades=1
	asw_weapon_mines=3
	asw_weapon_buff_grenade=1
	asw_weapon_medical_satchel=2
	asw_weapon_medkit=2
	asw_weapon_laser_mines=10
	asw_weapon_freeze_grenades=3
	asw_weapon_railgun=1
	asw_weapon_gas_grenades=3
	asw_weapon_grenade_launcher=2
}

regenDelay <- {
	asw_weapon_tesla_trap=40
	asw_weapon_stim=0
	asw_weapon_heal_grenade=30
	asw_weapon_electrified_armor=30
	asw_weapon_hornet_barrage=110
	asw_weapon_grenades=5
	asw_weapon_mines=60
	asw_weapon_buff_grenade=1
	asw_weapon_medical_satchel=20
	asw_weapon_medkit=30
	asw_weapon_laser_mines=30
	asw_weapon_freeze_grenades=10
	asw_weapon_railgun=40
	asw_weapon_gas_grenades=50
	asw_weapon_grenade_launcher=20
}

damageTable <- {
	asw_weapon_shotgun=300
	asw_weapon_ricochet=75
	asw_weapon_prifle=0
	asw_weapon_devastator=24
	asw_weapon_rifle=75
	asw_weapon_combat_rifle=75
	asw_weapon_minigun=55
	asw_weapon_deagle=0
	asw_weapon_50calmg=90
	asw_weapon_vindicator=55
	asw_weapon_flamer=0
	asw_weapon_railgun=20000
	asw_weapon_electrified_armor=200
	asw_weapon_tesla_trap=15
	asw_weapon_sniper_rifle=10000
	asw_weapon_chainsaw=150
	asw_weapon_pistol=0
	asw_weapon_hornet_barrage=200
	asw_weapon_smart_bomb=0
	asw_weapon_tesla_gun=0
	asw_weapon_pdw=0
	asw_weapon_grenades=1400
	asw_weapon_mining_laser=0
	asw_weapon_laser_mines=500
	asw_weapon_autogun=340
	asw_weapon_mines=200
	asw_weapon_medrifle=0
	asw_weapon_heavy_rifle=0
	asw_sentry_top_cannon=1000
	asw_sentry_top_flamer=20
}

friendlyDamageTable <- {
	asw_weapon_shotgun=10
	asw_weapon_ricochet=10
	asw_weapon_prifle=10
	asw_weapon_devastator=2
	asw_weapon_rifle=10
	asw_weapon_combat_rifle=10
	asw_weapon_minigun=3
	asw_weapon_deagle=20
	asw_weapon_50calmg=20
	asw_weapon_vindicator=5
	asw_weapon_flamer=0
	asw_weapon_railgun=70
	asw_weapon_electrified_armor=0
	asw_weapon_tesla_trap=0
	asw_weapon_sniper_rifle=30
	asw_weapon_chainsaw=10
	asw_weapon_pistol=5
	asw_weapon_hornet_barrage=0
	asw_weapon_smart_bomb=0
	asw_weapon_tesla_gun=0
	asw_weapon_pdw=6
	asw_weapon_laser_mines=0
	asw_weapon_grenades=0
	asw_weapon_mining_laser=20
	asw_weapon_autogun=20
	asw_weapon_mines=10
	asw_weapon_medrifle=5
	asw_weapon_heavy_rifle=10
	asw_sentry_top_cannon=0
	asw_sentry_top_flamer=0
}

backfireDamageTable <- {
	asw_weapon_shotgun=5
	asw_weapon_ricochet=15
	asw_weapon_prifle=15
	asw_weapon_devastator=2
	asw_weapon_rifle=15
	asw_weapon_combat_rifle=15
	asw_weapon_minigun=5
	asw_weapon_deagle=15
	asw_weapon_50calmg=15
	asw_weapon_vindicator=9
	asw_weapon_flamer=0
	asw_weapon_railgun=60
	asw_weapon_electrified_armor=0
	asw_weapon_tesla_trap=0
	asw_weapon_sniper_rifle=50
	asw_weapon_chainsaw=10
	asw_weapon_pistol=5
	asw_weapon_hornet_barrage=0
	asw_weapon_smart_bomb=0
	asw_weapon_tesla_gun=0
	asw_weapon_pdw=5
	asw_weapon_grenades=0
	asw_weapon_mining_laser=15
	asw_weapon_autogun=15
	asw_weapon_laser_mines=0
	asw_weapon_mines=0
	asw_weapon_medrifle=5
	asw_weapon_heavy_rifle=5
	asw_sentry_top_cannon=0
	asw_sentry_top_flamer=0
}

chainsaw <- {};
particleChainsawTable <- {};
incParticleTable <- {};
alienTimerTable <- {};
disableMoveParticleTable <- {};
disableMoveTable <- {};
incDelayTable <- {};
noInstaDeathAfterReviveTable <- {};
timeforexplosion <- {};
berserk <- {};
nextRefillTick1 <- {};
nextRefillTick2 <- {};
lastClip1 <- {};
lastClip2 <- {};

timeBetweenRefill1 <- 0.1;
timeBetweenRefill2 <- 5;
timeBetweenInverse1 <- 75;
timeBetweenInverse2 <- 5;
timeAfterShoot1 <- 5;
timeAfterShoot2 <- 10;
singleClipPenalty <- 0.55;
noClipPenalty <- 4;

marineName <- [
	"#asw_name_crash",
	"#asw_name_vegas",
	"#asw_name_sarge",
	"#asw_name_jaeger",
	"#asw_name_wildcat",
	"#asw_name_wolfe",
	"#asw_name_bastille",
	"#asw_name_faith"
];

ammoEntities <- [
	"asw_ammo_drop",
	"asw_ammo_rifle",
	"asw_ammo_autogun",
	"asw_ammo_shotgun",
	"asw_ammo_vindicator",
	"asw_ammo_flamer",
	"asw_ammo_pistol",
	"asw_ammo_mining_laser",
	"asw_ammo_railgun",
	"asw_ammo_chainsaw",
	"asw_ammo_pdw",
	"asw_weapon_ammo_satchel",
	"asw_pickup_ammo_satchel",
	"asw_weapon_jump_jet",
	"asw_weapon_blink",
	"asw_weapon_bait",
	"asw_weapon_t75",
	"asw_weapon_flechette",
	"asw_weapon_ammo_bag"
];

RadianceArr <- [
	"asw_drone_jumper",
	"asw_drone_uber",
	"asw_parasite",
	"asw_parasite_defanged",
	"asw_boomer",
	"asw_shieldbug",
	"asw_shaman",
	"asw_ranger",
	"asw_harvester",
	"asw_mortarbug",
	"npc_antlionguard_cavern",
	"asw_queen"
];

AlienSizeArr <- ["0", "10", "1"];

if ( asw_marine_ff_absorption == "0" )
{
	Convars.SetValue( "asw_skill_hacking_speed_base", 5 );
	Convars.SetValue( "asw_skill_hacking_speed_step", 0 );
	Convars.SetValue( "asw_simple_hacking", 1 );
	Convars.SetValue( "rd_health_decrease_interval", 1 );
	Convars.SetValue( "rm_health_decrease_amount", 8 );
}

function ParticleSpawn(killtime, x, y, z, who, effect, emit, follow)
{
	local vector = who.GetOrigin();
	local particle = Entities.CreateByClassname("info_particle_system");
	particle.__KeyValueFromString("effect_name", effect);
	particle.__KeyValueFromString("start_active", "1");
	particle.SetOrigin(vector + Vector(x, y, z));
	particle.Spawn();
	if ( follow == 1 )
		DoEntFire("!self", "SetParent", "!activator", 0, who, particle);
	particle.Activate();
	DoEntFire("!self", "Kill", "", killtime, null, particle);
	if (emit != 0)
		particle.EmitSound(emit);
}

function ParticlePrecache(effect)
{
	local particle = Entities.CreateByClassname("info_particle_system");
	particle.__KeyValueFromString("effect_name", effect);
	particle.__KeyValueFromString("start_active", "1");
	particle.SetOrigin(Vector(16384, 16384, 16384));
	particle.Spawn();
	particle.Activate();
	DoEntFire("!self", "Kill", "", 1, null, particle);
}

//------------------------------------------------------|
//--------------------- Precache -----------------------|
//------------------------------------------------------|
ParticlePrecache("ground_fire");
ParticlePrecache("explosion_huge_c");
ParticlePrecache("rifle_grenade_pulse");
ParticlePrecache("marine_resurrection");
ParticlePrecache("boomer_drop_heat");
ParticlePrecache("electric_weapon_zap_muzzle");
ParticlePrecache("powerup_electric_bullets");
ParticlePrecache("powerup_increased_speed");
ParticlePrecache("vortigaunt_beam");
ParticlePrecache("ground_fire_burn2_large");
ParticlePrecache("buffgrenade_center_light");
ParticlePrecache("ranger_projectile_glow");
ParticlePrecache("mortar_grenade_open_radius");
ParticlePrecache("mining_laser_beam_cp0_glow");
ParticlePrecache("medgrenade_cross");
ParticlePrecache("portal_rift_flash_01");
ParticlePrecache("portal_ritf_flash_01c");
ParticlePrecache("portal_rift_flash_01b");
ParticlePrecache("mine_fire_ignite_glow");
ParticlePrecache("water_splash_leakypipe_vertical");
ParticlePrecache("stungrenade_arc_sprites_copy");
ParticlePrecache("sprinker_system_360_180h");
local target = Entities.CreateByClassname("info_target");
target.PrecacheSoundScript("ASWInterface.MissionBoxes");
target.PrecacheSoundScript("ASW_ElectrifiedSuit.Loop");
target.PrecacheSoundScript("ASWInterface.SelectWeaponSlot");
target.PrecacheSoundScript("Bounce.Concrete");
target.PrecacheSoundScript("NPC_SScanner.Die");
target.PrecacheSoundScript("NPC_SScanner.DeployMine");
target.PrecacheSoundScript("Weapon_CombineGuard.Special1")
target.PrecacheSoundScript("explode_2");
target.PrecacheSoundScript("explode_3");
target.PrecacheSoundScript("explode_5");
target.PrecacheSoundScript("NPC_SScanner.DiveBomb");
target.PrecacheSoundScript("BaseCombatWeapon.WeaponMaterialize");
target.PrecacheSoundScript("landingBay.whoosh");
target.PrecacheSoundScript("IceBody.Shatter");
target.PrecacheSoundScript("explode_1");
target.PrecacheSoundScript("NPC_SScanner.DiveBombFlyby");
target.PrecacheModel("models/swarm/harvester/Harvester.mdl");
target.PrecacheModel("models/items/shield_bubble/shield_bubble.mdl");
DoEntFire("!self", "Kill", "", 0, null, target);
//------------------------------------------------------|

function dealDamageToAlienFunc( radius, origin, dmg, dmgType, attckr )
{
	local hNearEnt = null;
	while ( ( hNearEnt = Entities.FindInSphere( hNearEnt, origin.GetOrigin(), radius ) ) != null ){
		if ( hNearEnt.IsValid() && hNearEnt != origin && hNearEnt.IsAlien() )
			hNearEnt.TakeDamage( dmg, dmgType, attckr );
	}
}

function OnGameEvent_alien_spawn(params)
{
	local alien = EntIndexToHScript( params["entindex"] );
	if ( timeExceptPrespawn + 5 < Time() ){
		if ( alien.GetClassname() == "asw_drone" )
			alienTimerTable[alien] <- Time();
		else if ( alien.GetClassname() == "asw_parasite_defanged" )
			alienTimerTable[alien] <- Time();
	}
	
	if (GetMapName() == "rd-lan1_bridge"){
		if (Director.GetAlienCount() >= 100)
			alien.Destroy();
	}
}

function OnGameEvent_buzzer_spawn(params)
{
	local buzzer = EntIndexToHScript( params["entindex"] );
	if ( timeExceptPrespawn + 5 < Time() ){
		alienTimerTable[buzzer] <- Time();
	}
}

function OnGameEvent_marine_incapacitated(params)
{
	local incapacitated = EntIndexToHScript( params["entindex"] );
	incapacitated.SetHealth(100);
	local vector = incapacitated.GetOrigin() + Vector(0, 0, 30);
	incParticleTable[incapacitated] <- Entities.CreateByClassname("info_particle_system");
	incParticleTable[incapacitated].__KeyValueFromString("effect_name", "rifle_grenade_pulse");
	incParticleTable[incapacitated].__KeyValueFromString("start_active", "1");
	incParticleTable[incapacitated].SetOrigin(vector);
	DoEntFire("!self", "SetParent", "!activator", 0, incapacitated, incParticleTable[incapacitated]);
	incParticleTable[incapacitated].Spawn();
	incParticleTable[incapacitated].Activate();
	incParticleTable[incapacitated].EmitSound("BaseCombatWeapon.WeaponMaterialize");
	incapacitated.EmitSound("BaseCombatWeapon.WeaponMaterialize");
}

function OnGameEvent_marine_revived(params)
{
	local revived = EntIndexToHScript( params["entindex"] );
	ParticleSpawn(3, 0, 0, 25, revived, "marine_resurrection", "ASWInterface.MissionBoxes", 0);
	revived.EmitSound("ASWInterface.MissionBoxes");
	DoEntFire("!self", "Kill", "", 0, null, incParticleTable[revived]);
	incParticleTable.rawdelete(revived);
	incDelayTable[revived] <- Time();
	noInstaDeathAfterReviveTable[revived] <- 1;
}

function OnGameEvent_entity_killed(params)
{
	local victim = EntIndexToHScript( params["entindex_killed"] );
	if ( asw_marine_ff_absorption == "0" ){
		if ( victim != null && victim.GetClassname() == "asw_marine" ){
			rd_allow_revive <- Convars.GetStr("rd_allow_revive");
			if ( rd_allow_revive == 1 ){
				DoEntFire("!self", "Kill", "", 0, null, incParticleTable[victim]);
				incParticleTable.rawdelete(victim);
			}
		}
	}
	
	if ( victim.GetName() == "asw_4fun_buzzer" ){
		victim.StopSound("d1_town.LargeFireLoop");
		victim.StopSound("d1_town.LargeFireLoop");
	}
	
	if ( victim == immortalOwner ){
		immortalMode = 0;
		victim.StopSound("ASW_ElectrifiedSuit.Loop");
	}
	
	if (victim.GetClassname() == "asw_grenade_cluster")
		victim.Destroy();
}

function bubbleSpawn(vector, kill, angle)
{
	local bubble = Entities.CreateByClassname("prop_dynamic");
	bubble.__KeyValueFromString("model", "models/items/shield_bubble/shield_bubble.mdl");
	bubble.__KeyValueFromString("angles", angle.tostring() + " 0 0");
	bubble.SetOrigin(c.GetOrigin() + Vector(0, 0, vector));
	DoEntFire("!self", "SetParent", "!activator", 0, c, bubble);
	bubble.Spawn();
	DoEntFire("!self", "Kill", "", kill, null, bubble);
}

function OnGameEvent_sentry_complete(params)
{
	local sentry = EntIndexToHScript( params["entindex"] );
	sentry.SetCollisionGroup(24);
	sentry.SetSize( Vector(0,0,0), Vector(0,0,0));
}

function OnGameEvent_sentry_start_building(params)
{
	local sentry = EntIndexToHScript( params["entindex"] );
	sentry.SetCollisionGroup(24);
	sentry.SetSize( Vector(0,0,0), Vector(0,0,0));
}

function OnGameEvent_damage_amplifier_placed(params)
{
	local d = EntIndexToHScript( params["entindex"] );
	c <- EntIndexToHScript( params["marine"] );
	if ( c.GetMarineName() == "Jaeger" ){
		if ( invincibleCD == 0 || invincibleCD + 100 < Time() ){
			immortalOwner = c;
			immortalOwner.EmitSound("ASW_ElectrifiedSuit.Loop");
			bubbleSpawn(40, 18, 90);
			bubbleSpawn(40, 18, -90);
			bubbleSpawn(40, 18, 60);
			bubbleSpawn(40, 18, -60);
			bubbleSpawn(40, 19, 30);
			bubbleSpawn(40, 19, -30);
			bubbleSpawn(20, 19, 10);
			bubbleSpawn(20, 19, -10);
			bubbleSpawn(0, 20, 0);
			ParticleSpawn(20, 0, 0, 10, c, "stungrenade_arc_sprites_copy", 0, 1)
			immortalMode = 1;
			bubbleCD = Time();
			invincibleCD = Time();
			c.EmitSound("NPC_SScanner.DiveBomb");
			local target = Entities.CreateByClassname("info_target");
			target.SetOrigin(c.GetOrigin());
			target.EmitSound("NPC_SScanner.DiveBomb");
			DoEntFire("!self", "Kill", "", 2, null, target);
		}
		d.Destroy();
		return;
	}
	
	if ( c.GetMarineName() == "Sarge" ){
		regenOwner <- c;
		bubbleSpawn(40, 8, 90);
		bubbleSpawn(40, 8, -90);
		bubbleSpawn(40, 8, 60);
		bubbleSpawn(40, 8, -60);
		bubbleSpawn(40, 9, 30);
		bubbleSpawn(40, 9, -30);
		bubbleSpawn(20, 9, 10);
		bubbleSpawn(20, 9, -10);
		bubbleSpawn(0, 10, 0);
		ParticleSpawn(10, 0, 0, 30, c, "sprinker_system_360_180h", 0, 1)
		d.Destroy();
		regenAmmoMode = 1;
		bubbleAmmoCD = Time();
		c.EmitSound("NPC_SScanner.DiveBomb");
		local target = Entities.CreateByClassname("info_target");
		target.SetOrigin(c.GetOrigin());
		target.EmitSound("NPC_SScanner.DiveBomb");
		DoEntFire("!self", "Kill", "", 2, null, target);
		return;
	}
	
	if ( c.GetMarineName() == "Crash" || c.GetMarineName() == "Vegas" ){
		local angle = c.GetAngles();
		local vector = d.GetOrigin();

		local sentry2 = Entities.CreateByClassname("asw_sentry_top_machinegun");
		sentry2.SetOrigin(vector + Vector(0, 0, -50));
		sentry2.SetAnglesVector(angle);
		sentry2.Spawn();
		DoEntFire("!self", "Kill", "", 20, null, sentry2);

		local sentry1 = Entities.CreateByClassname("asw_sentry_top_flamer");
		sentry1.SetOrigin(vector + Vector(50, 60, -50));
		sentry1.SetAnglesVector(angle);
		sentry1.Spawn();
		DoEntFire("!self", "Kill", "", 20, null, sentry1);	

		local sentry3 = Entities.CreateByClassname("asw_sentry_top_icer");
		sentry3.SetOrigin(vector + Vector(-50, 60, -50));
		sentry3.SetAnglesVector(angle);
		sentry3.Spawn();
		DoEntFire("!self", "Kill", "", 20, null, sentry3);

		ParticleSpawn(2, 0, 0, -25, d, "boomer_drop_heat", 0, 0);
		ParticleSpawn(2, 50, 90, -25, d, "boomer_drop_heat", 0, 0);
		ParticleSpawn(2, -50, 90, -25, d, "boomer_drop_heat", 0, 0);
		ParticleSpawn(20, 0, 0, 9, d, "electric_weapon_zap_muzzle", "ASW_Sentry.Dismantled", 0);
		ParticleSpawn(20, 50, 60, 9, d, "electric_weapon_zap_muzzle", 0, 0);
		ParticleSpawn(20, -50, 60, 9, d, "electric_weapon_zap_muzzle", 0, 0);
		ParticleSpawn(20, 0, 0, -35, d, "powerup_electric_bullets", "ASW_Blink.Teleport", 0);
		ParticleSpawn(20, 50, 60, -35, d, "powerup_electric_bullets", 0, 0);
		ParticleSpawn(20, -50, 60, -35, d, "powerup_electric_bullets", 0, 0);
		ParticleSpawn(20, 0, 0, -35, d, "powerup_increased_speed", "ASW_Sentry.Deploy", 0);
		ParticleSpawn(20, 50, 60, -35, d, "powerup_increased_speed", 0, 0);
		ParticleSpawn(20, -50, 60, -35, d, "powerup_increased_speed", 0, 0);
		d.Destroy();
		return;
	}
	
	if ( c.GetMarineName() == "Bastille" || c.GetMarineName() == "Faith" ){
		marine <- null;
		while ( ( marine = Entities.FindByClassname( marine, "asw_marine" ) ) != null ){
			marine.CureInfestation();
			marine.SetHealth(marine.GetMaxHealth());
			marine.SetKnockedOut(false);
			if ( incParticleTable.rawin(marine) ){
				DoEntFire("!self", "Kill", "", 0, null, incParticleTable[marine]);
				incParticleTable.rawdelete(marine);
			}
			ParticleSpawn(2, 0, 0, 0, marine, "medgrenade_cross", "ASW_Medkit.Use", 1)
		}
		d.Destroy();
		return;
	}
	
	if ( c.GetMarineName() == "Wildcat" ){
		if ( berserkModeOnCat == 0 ){
			cat = c;
			if ( !berserk.rawin(cat) )
				berserk[cat] <- Time();
			else berserk[cat] <- Time();
			berserkModeOnCat = 1;
			NetProps.SetPropInt(cat, "m_iPowerupType", 3);
			cat.CureInfestation();
			ParticleSpawn(2, 0, 0, 45, cat, "mine_fire_ignite_glow", "NPC_SScanner.DiveBombFlyby", 1)
			cat.EmitSound("NPC_SScanner.DiveBombFlyby");
		}
		d.Destroy();
		return;
	}
	
	if ( c.GetMarineName() == "Wolfe" ){
		if ( berserkModeOnWolfe == 0 ){
			wolfe <- c;
			if ( !berserk.rawin(wolfe) )
				berserk[wolfe] <- Time();
			else berserk[wolfe] <- Time();
			berserkModeOnWolfe = 1;
			ParticleSpawn(20, 0, 0, 65, wolfe, "ground_fire", "ASWInterface.SelectWeaponSlot", 1)
			ParticleSpawn(3, 0, 0, 65, wolfe, "explosion_huge_c", "ASWInterface.SelectWeaponSlot", 1)
		}
		d.Destroy();
		return;
	}
}

function OnGameEvent_heal_beacon_placed(params)
{
	local d = EntIndexToHScript( params["entindex"] );
	local vector = d.GetOrigin();
	PlaceHealBeacon( 9999, 9999, -9999, 30, 300, vector );
	d.Destroy();
}

function OnMissionStart()
{
	local timer = Entities.CreateByClassname("logic_timer");
	timer.__KeyValueFromFloat("RefireTime", 1);
	DoEntFire("!self", "Disable", "", 0, null, timer);
	timer.ValidateScriptScope();
	local timerScope = timer.GetScriptScope();
	timerScope.ff <- asw_marine_ff_absorption;
	timerScope.killBot <- function()
	{
		local marine = null;
		while((marine = Entities.FindByClassname(marine, "asw_marine")) != null ){
			if ( !marine.IsInhabited() )
				marine.TakeDamage( marine.GetHealth()*999, 64, null );
		}
		if ( ff == "0" )
			Convars.SetValue( "rd_allow_revive", 1 );
		self.DisconnectOutput("OnTimer", "killBot");
		self.Destroy();	
	}
	timer.ConnectOutput("OnTimer", "killBot");
	DoEntFire("!self", "Enable", "", 0, null, timer);
}

function SpawnChanger(AName, AClass)
{
	local alien = null;
	while ( ( alien = Entities.FindByClassname( alien, AName ) ) != null ){
		local vector = alien.GetOrigin() + Vector (0, 0, 10);
		local spawner = Entities.CreateByClassname("asw_spawner");
		spawner.SetOrigin(vector);
		spawner.__KeyValueFromString("AlienClass", AClass);
		spawner.__KeyValueFromString("AlienOrders", "3");
		spawner.__KeyValueFromString("MaxLiveAliens", "1");
		spawner.__KeyValueFromString("SpawnerState", "1");
		spawner.__KeyValueFromString("ClearCheck", "0");
		spawner.__KeyValueFromString("SpawnIfMarinesAreNear", "1");
		spawner.__KeyValueFromString("NumAliens", "1");
		spawner.Spawn();
		DoEntFire("!self", "StartSpawning", "", 0, null, spawner);
		DoEntFire("!self", "Kill", "", 2, null, spawner);
		alien.Destroy();
	}
}

if (GetMapName() != "rd-lan2_sewer" && GetMapName() != "rd-TFT3Spaceport" )
	SpawnChanger("asw_shieldbug", "3" );
else {
	shield <- null;
	while ( ( shield = Entities.FindByClassname( shield, "asw_shieldbug" ) ) != null ){
		shield.SetHealth(shield.GetHealth()+100000);
		EntFireByHandle(shield, "Color", "201 134 74", 0, self, self);
	}
}
SpawnChanger("asw_ranger", "10" );
SpawnChanger("asw_boomer", "9" );
SpawnChanger("asw_harvester", "6" );
SpawnChanger("asw_mortarbug", "11" );

function SpawnerChanger(AlnCLASS, VScript, HealthBonus, SpeedScale, SizeScale, Min, Max )
{
	if (spawning.GetKeyValue("AlienClass") == AlnCLASS){
		if (VScript != 0)
			spawning.__KeyValueFromString("alien_vscripts", VScript);
		if (HealthBonus != 0)
			spawning.__KeyValueFromString("healthbonussp", HealthBonus);
		if (SpeedScale != 0)
			spawning.__KeyValueFromString("speedscalesp", SpeedScale);
		if (SizeScale != 0)
			spawning.__KeyValueFromString("sizescalesp", RandomFloat( Min, Max ).tostring());
	}
}

spawning <- null;
while((spawning = Entities.FindByClassname(spawning, "asw_spawner")) != null){
	foreach ( AlienClass in AlienSizeArr ){
	    if (spawning.GetKeyValue("AlienClass") == AlienClass){
			spawning.ValidateScriptScope();
			local spawnerScope = spawning.GetScriptScope();
			spawnerScope.SpawnerFunc <- function()
			{
				if (self != null)
					self.__KeyValueFromString("sizescalesp", RandomFloat( 0.8, 1.4 ).tostring());
			}
			spawning.ConnectOutput("OnSpawned", "SpawnerFunc");
		}
	}
	SpawnerChanger("11", "4fun_mortar.nut", "4000",0, 1, 1.8, 2.2 );
	SpawnerChanger("6", "4fun_harvester.nut", "4000", 0, 1, 1.5, 3 );
	SpawnerChanger("9", "4fun_antlion_boomer.nut", "20000", "1.5", 1, 1.4, 1.6 );
	SpawnerChanger("3", "4fun_shield.nut", "10000", 0, 1, 1.3, 1.5 );
	SpawnerChanger("2", 0, 0, 0, 1, 0.6, 1.2 );
	
	if (GetMapName() == "rd-lan2_sewer")
		SpawnerChanger("5", 0, "1600", "0.3", 1, 2.1, 2.6 );
}

function InjectThinkToSaw( scrEnt, attacker )
{
	scrEnt.ValidateScriptScope();
	local scrScope = scrEnt.GetScriptScope();
	scrScope.scrEnt <- scrEnt;
	scrScope.attackerEnt <- attacker;
	scrScope.PitchSaw <- function()
	{
		scrEnt.SetAngles(0, Time()*1000, 0);
		local hNearEnt = null;
		while ( ( hNearEnt = Entities.FindInSphere( hNearEnt, scrEnt.GetOrigin(), 30 ) ) != null ){
			if ( hNearEnt.IsValid() ) {
				if (hNearEnt.GetClassname() != "asw_door" && hNearEnt.GetClassname() != "asw_marine" )
					hNearEnt.TakeDamage( 160, 4098, attackerEnt);
				else if (hNearEnt.GetClassname() == "asw_marine" ) 
					hNearEnt.TakeDamage( 25, 4098, attackerEnt);
				else if (hNearEnt.GetClassname() == "asw_door" ) 
					hNearEnt.TakeDamage( 35, 4098, null);
			}
		}
		return 0.1;
	}
	AddThinkToEnt( scrEnt, "PitchSaw" );
}

function InjectThink( scrEnt, thinkFunc ) //https://developer.valvesoftware.com/wiki/L4D2_EMS/Appendix:_Functions
{
   scrEnt.ValidateScriptScope();
   local scrScope = scrEnt.GetScriptScope();
   scrScope.InjectedThink <- thinkFunc;
   AddThinkToEnt( scrEnt, "InjectedThink" );
}
// and then you could call it like so to have a spawned entity call a common think passing itself as an argument
// InjectThink( myEnt, @() g_MapScript.InjectedThink(self))
// or of course whatever function you want/local thing, etc

function MoveForward()
{
	self.SetOrigin(self.GetOrigin() + self.GetForwardVector()*i);
	i += 0.01;
	
	local hNearEnt = null;
	while ( ( hNearEnt = Entities.FindInSphere( hNearEnt, self.GetOrigin(), 180 ) ) != null ){
		if ( hNearEnt.IsAlien() || hNearEnt.GetClassname() == "prop_physics" )
			hNearEnt.TakeDamage( 130, 256, null);
	}
	
	local nearTarget = null;
	if ( (TraceLine(self.GetOrigin(), self.GetOrigin() + self.GetForwardVector()*i, null) != 1)
		|| ((nearTarget = Entities.FindByClassnameWithin(nearTarget, "asw_door", self.GetOrigin(), 20)) != null) ){
		self.StopSound("ASW_Tesla_Laser.Loop");
		self.EmitSound("ASW_Tesla_Laser.Stop");
		DoEntFire("!self", "Kill", "", 0, null, self);
	}
	
	return 0.01;
}

function FireballMoveForward()
{
	
	function ParticleSpawn(killtime, x, y, z, who, effect, emit, follow)
	{
		local vector = who.GetOrigin();
		local particle = Entities.CreateByClassname("info_particle_system");
		particle.__KeyValueFromString("effect_name", effect);
		particle.__KeyValueFromString("start_active", "1");
		particle.SetOrigin(vector + Vector(x, y, z));
		particle.Spawn();
		if ( follow == 1 )
			DoEntFire("!self", "SetParent", "!activator", 0, who, particle);
		particle.Activate();
		DoEntFire("!self", "Kill", "", killtime, null, particle);
		if (emit != 0)
			particle.EmitSound(emit);
	}
	
	//self.SetOrigin(self.GetOrigin() + self.GetForwardVector()*2);
	self.SetVelocity(self.GetForwardVector()*2000 + Vector(0,0,200));
	
	local hNearEnt = null;
	while ( ( hNearEnt = Entities.FindInSphere( hNearEnt, self.GetOrigin(), 25 ) ) != null ){
		if ( hNearEnt.IsAlien() ){
			//ParticleSpawn(1, 0, 0, 30, self, "portal_ritf_flash_01c", 0, 0)
			//ParticleSpawn(2, 0, 0, 10, self, "vindicator_grenade_warp", "explode_3", 0)
			//ParticleSpawn(4, 0, 0, 30, self, "citadel_shockwave_b", "explode_2", 0)
			local hNearEnt = null;
			while ( ( hNearEnt = Entities.FindInSphere( hNearEnt, self.GetOrigin(), 900 ) ) != null ){
				if ( hNearEnt.IsValid() )
					hNearEnt.TakeDamage( 69999, 8, null);
			}
			EntFireByHandle(self, "Kill", "", 0, self, self);
		}
	}	
	/*
	local nearTarget = null;
	if ( (TraceLine(self.GetOrigin(), self.GetOrigin() + self.GetForwardVector()*1.5, null) != 1) 
		|| ((nearTarget = Entities.FindByClassnameWithin(nearTarget, "asw_door", self.GetOrigin(), 20)) != null) ){
		ParticleSpawn(1, 0, 0, 30, self, "portal_ritf_flash_01c", 0, 0)
		ParticleSpawn(2, 0, 0, 10, self, "vindicator_grenade_warp", "explode_3", 0)
		ParticleSpawn(4, 0, 0, 30, self, "citadel_shockwave_b", "explode_2", 0)
		local hNearEnt = null;
		while ( ( hNearEnt = Entities.FindInSphere( hNearEnt, self.GetOrigin(), 900 ) ) != null ){
			if ( hNearEnt.IsAlien() )
				hNearEnt.TakeDamage( 69999, 8, null);
		}
		EntFireByHandle(self, "Kill", "", 0, self, self);
	}
	return 0.01;
	*/
}

//------------------------------------------------------|
//------------- Damage filter for doors ----------------|
//------------------------------------------------------|
local filter_activator_class = Entities.CreateByClassname("filter_activator_class");
filter_activator_class.__KeyValueFromString("filterclass", "asw_marine");
filter_activator_class.__KeyValueFromString("Negated", "1");
filter_activator_class.__KeyValueFromString("targetname", "filter");
filter_activator_class.Spawn();

local door = null;
while ( ( door = Entities.FindByClassname( door, "asw_door" ) ) != null )
	DoEntFire("!self", "SetDamageFilter", "filter", 0, null, door);
//------------------------------------------------------|

function OnGameEvent_weapon_fire(params)
{
	local weapon = EntIndexToHScript( params["weapon"] );
	local marine = EntIndexToHScript( params["marine"] );
	if (weapon.GetClassname() == "asw_weapon_grenade_launcher"){
		marine.StopSound("ASW_GrenadeLauncher.Fire");
		marine.StopSound("ASW_GrenadeLauncher.FireFP");
		weapon.EmitSound("NPC_SScanner.DeployMine");
		
		local particle = Entities.CreateByClassname("info_particle_system");
		particle.__KeyValueFromString("effect_name", "stungrenade_core_copy");
		particle.__KeyValueFromString("start_active", "1");
		particle.SetOrigin(weapon.GetOrigin() + weapon.GetForwardVector()*50 + Vector(0, 0, 50));

		local player = null;
		local VecCrosshairOrigin = null;
		while((player = Entities.FindByClassname(player, "player")) != null ){
			local m_hMarine = NetProps.GetPropEntity(player, "m_hMarine");
			if (m_hMarine != null && m_hMarine.GetMarineName() == marine.GetMarineName())
				VecCrosshairOrigin = NetProps.GetPropVector(player, "m_vecCrosshairTracePos");
		}

		if (VecCrosshairOrigin != null && (VecCrosshairOrigin.x != 0 || VecCrosshairOrigin.y != 0)){
			local VecBfg = VecCrosshairOrigin - marine.GetOrigin();
			VecBfg = VecBfg * (1/VecBfg.Length());
			VecBfg = Vector(VecBfg.x, VecBfg.y, 0);
			particle.SetForwardVector(VecBfg);
		} else particle.SetForwardVector(marine.GetForwardVector());

		particle.Spawn();
		particle.Activate();
		particle.EmitSound("ASW_Tesla_Laser.Loop");
		particle.ValidateScriptScope();
		local particleScope = particle.GetScriptScope();
		local i = 1.0;
		particleScope.i <- i;
		InjectThink( particle, MoveForward );
		
		function StopLoop(){
			self.StopSound("ASW_Tesla_Laser.Loop");
			self.EmitSound("ASW_Tesla_Laser.Stop");
			self.DisconnectOutput("OnUser1", "StopLoop");
			DoEntFire("!self", "Kill", "", 0, null, self);
		}
		particle.ValidateScriptScope();
		particle.GetScriptScope().StopLoop <- StopLoop;
		particle.ConnectOutput("OnUser1", "StopLoop");
		EntFireByHandle(particle, "FireUser1", "", 8, self, self);
		
		local particleStartFire = Entities.CreateByClassname("info_particle_system");
		particleStartFire.__KeyValueFromString("effect_name", "vindicator_grenade_warp");
		particleStartFire.__KeyValueFromString("start_active", "1");
		particleStartFire.SetOrigin(particle.GetOrigin());
		particleStartFire.Spawn();
		particleStartFire.Activate();
		particleStartFire.EmitSound("Weapon_CombineGuard.Special1");
		marine.EmitSound("NPC_SScanner.DeployMine");
		local target = Entities.CreateByClassname("info_target");
		target.SetOrigin(weapon.GetOrigin());
		target.EmitSound("NPC_SScanner.Die");
		DoEntFire("!self", "Kill", "", 2, null, target);
		target = Entities.CreateByClassname("info_target");
		target.SetOrigin(weapon.GetOrigin());
		target.EmitSound("NPC_SScanner.Die");
		DoEntFire("!self", "Kill", "", 2, null, target);
		DoEntFire("!self", "Kill", "", 1, null, particleStartFire);
	}
}

function OnGameEvent_weapon_offhand_activate(params)
{
	local weapon = EntIndexToHScript( params["weapon"] );
	local marine = EntIndexToHScript( params["marine"] );
	if (weapon.GetClassname() == "asw_weapon_grenades"){
		local mainProp = Entities.CreateByClassname("prop_physics_override");
		local mainPropName = UniqueString();
		mainProp.__KeyValueFromString("model", "models/aliens/drone_gibs/gib_upper_arm.mdl"); //models/gibs/antlion_gib_large_3.mdl
		mainProp.__KeyValueFromString("overridescript", "mass,50");
		mainProp.__KeyValueFromString("rendermode", "10");
		mainProp.__KeyValueFromString("targetname", mainPropName);
		mainProp.SetOrigin(marine.GetOrigin() + marine.GetForwardVector()*30 + Vector(0, 0, 60));
		mainProp.Spawn();
		mainProp.Activate();
		mainProp.SetSize( Vector(-1,-1,0), Vector(1,1,1));
		mainProp.SetCollisionGroup(1);
		mainProp.SetForwardVector(marine.GetForwardVector());

		local visualProp = Entities.CreateByClassname("prop_dynamic");
		visualProp.__KeyValueFromString("model", "models/swarm/grenades/handgrenadeprojectile.mdl");
		visualProp.SetOrigin(mainProp.GetOrigin());
		DoEntFire("!self", "SetParent", "!activator", 0,  mainProp, visualProp);
		visualProp.Spawn();
		visualProp.Activate();
		visualProp.SetSize( Vector(-1,-1,0), Vector(1,1,1));
		visualProp.SetCollisionGroup(1);
		visualProp.SetForwardVector(marine.GetForwardVector());
		
		local particle = Entities.CreateByClassname("info_particle_system");
		particle.__KeyValueFromString("effect_name", "rifle_grenade_fx");
		particle.__KeyValueFromString("start_active", "1");
		particle.SetOrigin(visualProp.GetOrigin());
		particle.Spawn();
		particle.Activate();
		DoEntFire("!self", "SetParent", "!activator", 0, visualProp, particle);	
		
		local player = null;
		local VecCrosshairOrigin = null;
		while((player = Entities.FindByClassname(player, "player")) != null ){
			local m_hMarine = NetProps.GetPropEntity(player, "m_hMarine");
			if (m_hMarine != null && m_hMarine == marine)
				VecCrosshairOrigin = NetProps.GetPropVector(player, "m_vecCrosshairTracePos");
		}

		local dirYaw = null;
		local force = 0;
		if (VecCrosshairOrigin != null && (VecCrosshairOrigin.x != 0 || VecCrosshairOrigin.y != 0)){
			local VecPush = VecCrosshairOrigin - marine.GetOrigin();
			local timeLet = VecPush.Length();
			timeLet = (timeLet*2)/1000;
			VecPush = VecPush * (1/VecPush.Length());
			printl(timeLet);
			dirYaw = acos(VecPush.x)*180/PI;
			if (VecPush.y < 0)
				dirYaw = -dirYaw;
			//printl(dirYaw);
			local gravity = 800;
			local time = timeLet;
			local marinePos = marine.GetOrigin();
			VecCrosshairOrigin = Vector(VecCrosshairOrigin.x, VecCrosshairOrigin.y, marinePos.z);
			local VelocityVector = (VecCrosshairOrigin - marinePos - Vector(0, 0, -gravity*time*time/2)) * (1/time.tofloat());
			VelocityVector = VelocityVector.Length();
			//printl(VelocityVector);
			force = VelocityVector * 50/time;
			//force *= 4.9;
			printl(force);
		} else {
			dirYaw = marine.GetAngles().y;
			force = 190000;
		}
		
		local thruster = Entities.CreateByClassname("phys_thruster");
		thruster.__KeyValueFromString("attach1", mainPropName);
		thruster.__KeyValueFromString("force", force.tostring());
		thruster.__KeyValueFromString("forcetime", "0.13");
		thruster.__KeyValueFromString("spawnflags", "11");
		thruster.__KeyValueFromString("angles", "-50 " + dirYaw.tostring() + " 0"); //marine.GetAngles().y.tostring()
		thruster.SetOrigin(mainProp.GetOrigin());
		thruster.Spawn();
		thruster.Activate();
		thruster.SetLocalAngles(0, 0, 0);
		DoEntFire("!self", "Activate", "", 0, null, thruster);
		DoEntFire("!self", "Kill", "", 2, null, thruster);
	}
}

function OnTakeDamage_Alive_Any( victim, inflictor, attacker, weapon, damage, damageType, ammoName )
{
	if (victim != null && victim.GetClassname() == "asw_marine" && attacker != null && attacker.IsAlien()){
		for (local checkWeapon = victim.FirstMoveChild(); checkWeapon != null; checkWeapon = checkWeapon.NextMovePeer()){
			if (checkWeapon.GetClassname() == "asw_weapon_normal_armor"){
				if (attacker.GetClassname() != "npc_antlionguard_cavern" && attacker.GetClassname() != "asw_shieldbug" )
					attacker.Freeze(1);
				else attacker.Freeze(2);
			}
		}
	}

	dam <- 0;

	if (weapon != null && (weapon.GetClassname() in damageTable))
	{
		damage += damageTable[weapon.GetClassname()];
		if ( victim != null && victim.GetClassname() == "asw_marine" )
		{
			if (asw_marine_ff_absorption == "0")
			{
				damage = 0;
				dam = backfireDamageTable[weapon.GetClassname()];
			}
			else damage = friendlyDamageTable[weapon.GetClassname()];
		}
	}
	
	if(weapon != null){
		switch(weapon.GetClassname()) {
			case "asw_weapon_prifle":	
				if ( victim != null && victim == attacker )
					damage = 10;
				break;
			case "asw_weapon_devastator":
				if ( berserkModeOnWolfe == 1 ){
					if (attacker.GetName() == "#asw_name_wolfe")
						damage *= 5;
				}
				break;
			case "asw_weapon_rifle":
				if ( victim != null && victim == attacker )
					damage = 20;
				break;
			case "asw_weapon_50calmg":	
				if ( attacker != null && attacker.GetClassname() == "asw_marine" ){
					if ( victim != null && victim.GetClassname() != "asw_marine")
						dealDamageToAlienFunc( 25, victim, 100, 4098, attacker )
				}
				break;
			case "asw_weapon_deagle":
				if ( attacker != null && attacker.GetClassname() == "asw_marine" ){
					if ( victim != null && victim.GetClassname() != "asw_marine")
						dealDamageToAlienFunc( 25, victim, 100, 4098, attacker )
				}
				
				if ( victim != null && victim.GetClassname() == "asw_ranger" )
					damage = 400;
				break;
			case "asw_weapon_shotgun":
				if ( attacker != null && attacker.GetClassname() == "asw_marine" ){
					if ( victim != null && victim.GetClassname() != "asw_marine"){
						if ( !timeforexplosion.rawin(attacker) || timeforexplosion[attacker] + 0.3 < Time())
							dealDamageToAlienFunc( 125, victim, 100, 4098, attacker );
						timeforexplosion[attacker] <- Time();
					}
				}
				break;
			case "asw_weapon_flamer":
				dam = 0;
				if ( victim != null && victim.GetClassname() == "asw_marine" ){
					if (victim.GetHealth() <= victim.GetMaxHealth())
						victim.SetHealth(victim.GetHealth() + (victim.GetMaxHealth()/40));	
				}
				if ( victim != null )
					damage = 0;
				break;
			case "asw_weapon_railgun":
				if ( attacker != null && attacker.GetClassname() == "asw_marine"){
					if ( victim != null && victim.GetClassname() != "asw_marine"){
						if ( !timeforexplosion.rawin(attacker) || timeforexplosion[attacker] + 0.3 < Time()){
							ParticleSpawn(1, 0, 0, 30, victim, "portal_rift_flash_01", "ASW_T75.Explode", 0)
							ParticleSpawn(2, 0, 0, 10, victim, "portal_ritf_flash_01c", "ASWBarrel.Explode", 0)
							ParticleSpawn(2, 0, 0, 30, victim, "portal_rift_flash_01b", "Bounce.Concrete", 0)
							victim.EmitSound("Bounce.Concrete");
							
							local hNearEnt = null;
							while ( ( hNearEnt = Entities.FindInSphere( hNearEnt, victim.GetOrigin(), 600 ) ) != null ){
								if ( hNearEnt.IsValid() && hNearEnt != victim 
									&& hNearEnt.GetClassname() != "asw_marine" && hNearEnt.GetClassname() != "asw_door" )
									hNearEnt.TakeDamage( 20000, 8, attacker );
							}
						}
						timeforexplosion[attacker] <- Time();
					}
				}
				break;
			case "asw_weapon_sniper_rifle":
				if ( attacker != null && attacker.GetClassname() == "asw_marine"){
					if ( victim != null && victim.GetClassname() != "asw_marine"){
						local A = attacker.GetOrigin();
						local B = victim.GetOrigin();
						local fDistance = sqrt( (A.x - B.x) * (A.x - B.x) + (A.y - B.y) * (A.y - B.y) + (A.z - B.z) * (A.z - B.z) );
						local iDmg = 5;
						
						if ( fDistance >= 400.0 && (!timeforexplosion.rawin(attacker) || timeforexplosion[attacker] + 0.3 < Time()) ){
							ParticleSpawn(1, 0, 0, 30, victim, "stungrenade_core", 0, 0)
							
							local target = Entities.CreateByClassname("info_target");
							target.SetOrigin(victim.GetOrigin() + Vector(0, 0, 31));
							target.EmitSound("landingBay.whoosh");
							DoEntFire("!self", "Kill", "", 3, null, target);
							
							local target2 = Entities.CreateByClassname("info_target");
							target2.SetOrigin(victim.GetOrigin() + Vector(0, 0, 32));
							target2.EmitSound("landingBay.whoosh");
							DoEntFire("!self", "Kill", "", 3, null, target);
							
							local timer = Entities.CreateByClassname("logic_timer");
							timer.__KeyValueFromFloat("RefireTime", 2);
							DoEntFire("!self", "Disable", "", 0, null, timer);
							timer.ValidateScriptScope();
							local timerScope = timer.GetScriptScope();
							timerScope.target <- target;
							timerScope.target2 <- target2;
							timerScope.TimerFunc <- function()
							{
								target.StopSound("landingBay.whoosh");
								target2.StopSound("landingBay.whoosh");
								self.DisconnectOutput("OnTimer", "TimerFunc");
								self.Destroy();
							}
							timer.ConnectOutput("OnTimer", "TimerFunc");
							DoEntFire("!self", "Enable", "", 0, null, timer);
							timeforexplosion[attacker] <- Time();
						}
						
						if (fDistance >= 500.0){
							damage = victim.GetHealth();
							iDmg = pow(iDmg, 10);
						} else if (fDistance < 500.0 && fDistance >= 400.0){
							damage = victim.GetHealth();
							iDmg = 40;
						} else if (fDistance < 400.0)
							damage = fDistance;
						
						dealDamageToAlienFunc( 180, victim, iDmg, 4098, null );
					}
				}
				break;
			case "asw_weapon_autogun":
				if ( attacker != null && attacker.GetClassname() == "asw_marine" && disableMoveTable[attacker] == 1 ){
					if ( victim != null && victim.GetClassname() != "asw_marine")
						dealDamageToAlienFunc( 60, victim, 80, 4098, attacker )
				}
				break;
			case "asw_weapon_mining_laser":
				if ( attacker != null && attacker.GetClassname() == "asw_marine" ){
					if ( victim != null && victim.GetClassname() != "asw_marine")
						dealDamageToAlienFunc( 80, victim, 15, 4098, attacker )
				}
				break;
			case "asw_weapon_grenades":
				if (victim.GetHealth() <= victim.GetMaxHealth())
					victim.SetHealth(victim.GetHealth() + (victim.GetMaxHealth()/10));
				break;
			case "asw_weapon_vindicator":
				if ( victim != null && victim.GetClassname() == "asw_marine" && victim == attacker )
					damage = 20;
				break;
			case "asw_weapon_mines":
				if ( victim != null && victim.GetClassname() == "asw_marine" )
					damage = 30;
				break;
			case "asw_weapon_laser_mines":
				if ( victim != null && victim.GetClassname() == "asw_marine" )
					damage = 30;
				break;
			case "asw_weapon_chainsaw":
				if ( attacker != null && attacker.GetClassname() == "asw_marine" ){
					if ( victim != null && victim.GetClassname() != "asw_marine")
						dealDamageToAlienFunc( 25, victim, 10, 4098, attacker )
				}
				break;
			case "asw_weapon_tesla_gun":
				if ( attacker != null && attacker.GetClassname() == "asw_marine"){
					local scale = 0;
					if ( victim.GetName() == "asw_4fun_drone_giant" )
						scale = 0.3; else
						scale = 1;
					local nearTarget = null;
					while((nearTarget = Entities.FindByClassnameWithin(nearTarget, "asw_drone", victim.GetOrigin(), 60)) != null){
						if (nearTarget != victim){
							DoEntFire("!self", "AddOutput", "speedscale -1", 0, null, nearTarget);
							DoEntFire("!self", "AddOutput", "speedscale " + scale.tostring(), 1, null, nearTarget);
						}
					}
					if ( victim.GetClassname() == "asw_drone" ){
						DoEntFire("!self", "AddOutput", "speedscale -1", 0, null, victim);
						DoEntFire("!self", "AddOutput", "speedscale " + scale.tostring(), 1, null, victim);
					}
				}
				break;
			case "asw_weapon_tesla_trap":
				dealDamageToAlienFunc( 60, victim, 10, 256, null );
				break;
			default: break;
		}
	}
	
	if (asw_marine_ff_absorption == "0")
	{
		if (immortalMode == 1){
			if ( attacker != null && attacker.GetClassname() == "asw_marine" ){
				if ( victim != null && victim.GetClassname() == "asw_marine" && victim != attacker ){
					if (inflictor != null && inflictor.GetClassname() != "asw_burning" 
						&& inflictor.GetClassname() != "asw_sentry_top_machinegun" 
						&& inflictor.GetClassname() != "asw_barrel_explosive"){
						local nearTarget = null;
						if(!((nearTarget = Entities.FindByNameWithin(nearTarget, immortalOwner.GetName(), attacker.GetOrigin(), 120)) != null )){
							if (attacker.GetHealth() - dam <= 0)
							{
								local explosion = Entities.CreateByClassname("env_explosion");
								explosion.__KeyValueFromInt("iMagnitude", 20);
								explosion.__KeyValueFromInt("spawnflags", 1916);						
								explosion.SetOrigin(attacker.GetOrigin() + Vector(0, 0, 37));							
								DoEntFire("!self", "Explode", "", 0, null, explosion);
								DoEntFire("!self", "Kill", "", 0.5, null, explosion);
							}	
							else attacker.SetHealth(attacker.GetHealth() - dam);
						}
					} else if (inflictor != null && inflictor.GetClassname() == "asw_barrel_explosive")
						damage = 0;
				}
			}
		}
		else{
			if ( attacker != null && attacker.GetClassname() == "asw_marine" ){
				if ( victim != null && victim.GetClassname() == "asw_marine" && victim != attacker ){
					if (inflictor != null && inflictor.GetClassname() != "asw_burning" 
						&& inflictor.GetClassname() != "asw_sentry_top_machinegun" 
						&& inflictor.GetClassname() != "asw_barrel_explosive"){
						if (weapon == null && inflictor.GetClassname() == "asw_marine"){
							local hWeapon = NetProps.GetPropEntity( attacker, "m_hActiveWeapon" );
							if (hWeapon.GetClassname() == "asw_weapon_chainsaw")
								dam = 10;
								damage = 0;
						}
						if (attacker.GetHealth() - dam <= 0){
							local explosion = Entities.CreateByClassname("env_explosion");
							explosion.__KeyValueFromInt("iMagnitude", 20);
							explosion.__KeyValueFromInt("spawnflags", 1916);						
							explosion.SetOrigin(attacker.GetOrigin() + Vector(0, 0, 37));							
							DoEntFire("!self", "Explode", "", 0, null, explosion);
							DoEntFire("!self", "Kill", "", 0.5, null, explosion);
						}
						else attacker.SetHealth(attacker.GetHealth() - dam);	//SetHealth generic "pure" damage, then TakeDamage is not
						dam = 0;
					} else if (inflictor != null && inflictor.GetClassname() == "asw_barrel_explosive")
						damage = 0;
				}
			}
		}
	}
	
	if ( noInstaDeathAfterReviveTable.rawin(victim) ){
		if ( noInstaDeathAfterReviveTable[victim] == 1 )
			damage = 0;
	}
	
	if (immortalMode == 1){
		local nearTarget = null;
		foreach (marino in marineName)
		{
			if (marino == victim.GetName()){
				if((nearTarget = Entities.FindByNameWithin(nearTarget, marino, immortalOwner.GetOrigin(), 120)) != null ){
					damage = 0;
				}
			}
		}
	}
	
	if (cat != null){
		if (victim != null && victim == cat){
			if ( berserkModeOnCat == 1 )
				damage = 0;
		}
	}
	
	if ( inflictor != null && inflictor.GetClassname() == "asw_sentry_top_machinegun" ){
		if ( victim != null && victim.GetClassname() != "asw_marine")
			dealDamageToAlienFunc( 20, victim, 15, 4098, null );
		return damage;
	}
	
	if ( attacker != null && attacker.GetName() == "asw_4fun_drone_giant" ){
		if ( victim != null && victim.GetClassname() == "asw_marine" )
			victim.Knockdown(Vector(0, 0, 0));
		return damage;
	}

	if ( inflictor != null && inflictor.GetClassname() == "asw_missile_round" && inflictor.GetOwner().GetClassname() == "asw_ranger" ){
		if ( victim != null && victim.GetClassname() == "asw_marine" ){
			victim.TakeDamage(10, 131072, attacker);
			victim.BecomeInfested();
			parasiteProp <- CreateProp("prop_dynamic", victim.GetOrigin(), "models/aliens/parasite/parasite.mdl", 17);
			parasiteProp.SetOwner(victim);
			function IsMarineInfested(){
				local isInfested = NetProps.GetPropFloat( hVictim, "m_fInfestedTime" );
				if (isInfested == 0)
					self.Destroy();
				//printl(isInfested);
			}
			InjectThink( parasiteProp, IsMarineInfested );
			function RotateToMarineNeck(){
				self.SetLocalAngles(-30, 0, 0);
				self.SetLocalOrigin(Vector(2, 0, 58));
				self.DisconnectOutput("OnUser1", "RotateToMarineNeck");
			}
			parasiteProp.ValidateScriptScope();
			parasiteProp.GetScriptScope().RotateToMarineNeck <- RotateToMarineNeck;
			parasiteProp.GetScriptScope().hVictim <- victim;
			DoEntFire("!self", "SetParent", "!activator", 0,  victim, parasiteProp);
			DoEntFire("!self", "SetDefaultAnimation", "ragdoll", 0,  self, parasiteProp);
			DoEntFire("!self", "SetAnimation", "ragdoll", 0,  self, parasiteProp);
			DoEntFire("!self", "DisableShadow", "", 0,  self, parasiteProp);
			parasiteProp.ConnectOutput("OnUser1", "RotateToMarineNeck");
			DoEntFire("!self", "FireUser1", "", 0,  self, parasiteProp);
		}
	}
		
	return damage;
}
g_ModeScript.OnTakeDamage_Alive_Any <- OnTakeDamage_Alive_Any;

function Update()
{
	foreach ( classname in ammoEntities ){
		ammo <- null;
		while ( ( ammo = Entities.FindByClassname( ammo, classname ) ) != null ){
			if ( !(GetMapName() == "rd-ad4_forbidden_outpost" && classname == "asw_weapon_jump_jet") )
				ammo.Destroy();
		}
	}
	
	if ( invDelay + 2 < Time() && invDelay != 0 ){
		invincibleCD = 0;
		invDelay = 0;
	}
	
	if ( hordeMode + 60 < Time() && hordeOn == 0 ){
		Director.StartHoldout();
		hordeOn = 1;
	}
	else {
		if ( hordeMode + 90 < Time() && hordeOn == 1 ){
			Director.StopHoldout();
			hordeOn = 0;
			hordeMode = Time();
		}
	}

	if (immortalMode == 1){
		if (bubbleCD + 20 < Time()){
			immortalMode = 0;
			immortalOwner.StopSound("ASW_ElectrifiedSuit.Loop");
		}
	}
	
	if (regenAmmoMode == 1){
		if (bubbleAmmoCD + 10 < Time())
			regenAmmoMode = 0;
	}

	if ( berserkModeOnCat == 1 ){
		if (berserk[cat] + 0.5 <= Time()){
			berserkModeOnCat = 0;
			NetProps.SetPropInt(cat, "m_iPowerupType", -1)
		}

	}
	
	if ( berserkModeOnWolfe == 1 ){
		if (berserk[wolfe] + 20 <= Time())
			berserkModeOnWolfe = 0;
	}
	
	hDrone <- null;
	while ( ( hDrone = Entities.FindByClassname( hDrone, "asw_drone" ) ) != null ){
		if ( alienTimerTable.rawin(hDrone) ){
			if ( alienTimerTable[hDrone] + 60 < Time() ){
				alienTimerTable.rawdelete(hDrone);
				hDrone.TakeDamage(hDrone.GetHealth()*999, 4098, null);
			}
		}
	}
	
	hParaDefanged <- null;
	while ( ( hParaDefanged = Entities.FindByClassname( hParaDefanged, "asw_parasite_defanged" ) ) != null ){
		if ( alienTimerTable.rawin(hParaDefanged) ){
			if ( alienTimerTable[hParaDefanged] + 30 < Time() ){
				alienTimerTable.rawdelete(hParaDefanged);
				hParaDefanged.TakeDamage(hParaDefanged.GetHealth()*999, 4098, null);
			}
		}
	}
	
	hBuzzer <- null;
	while ( ( hBuzzer = Entities.FindByClassname( hBuzzer, "asw_buzzer" ) ) != null ){
		if ( alienTimerTable.rawin(hBuzzer) ){
			if ( alienTimerTable[hBuzzer] + 90 < Time() ){
				alienTimerTable.rawdelete(hBuzzer);
				hBuzzer.TakeDamage(hBuzzer.GetHealth()*999, 4098, null);
			}
		}
	}
	
    minDelay <- 0.2;
    local marine = null;
	radiancedMobs <- {};
    while ( (marine = Entities.FindByClassname( marine, "asw_marine" )) != null ){
		/*
		if ("slot2" in marine.GetInvTable() && marine.GetInvTable()["slot2"].GetClassname() == "asw_weapon_night_vision"){
			local a = NetProps.GetPropInt ( marine.GetInvTable()["slot2"], "m_bVisionActive" );
			printl(a);
		}
		*/

		if (radianceKD + 1 < Time()){
			local hNearDoor = null;
			while( (hNearDoor = Entities.FindByClassnameWithin(hNearDoor, "asw_door", marine.GetOrigin(), 50)) != null )
				radiancedMobs[hNearDoor] <- hNearDoor;
		}
		
		if ( incDelayTable.rawin(marine) ){
			if ( noInstaDeathAfterReviveTable[marine] == 1 && incDelayTable[marine] + 2 < Time() )
				noInstaDeathAfterReviveTable[marine] <- 0;
		}
	
		local hActiveWeapon = NetProps.GetPropEntity( marine, "m_hActiveWeapon" );
		if ( hActiveWeapon && hActiveWeapon.GetClassname() == "asw_weapon_autogun" && !disableMoveTable.rawin(marine) )
			disableMoveTable[marine] <- 0;
		if (disableMoveTable.rawin(marine)){
			if ( hActiveWeapon && hActiveWeapon.GetClassname() == "asw_weapon_autogun" && disableMoveTable[marine] == 0 ){
				NetProps.SetPropInt( marine, "m_bPreventMovement", 1 );
				disableMoveTable[marine] <- 1;
				local particleHeavy = Entities.CreateByClassname("info_particle_system");
				particleHeavy.__KeyValueFromString("effect_name", "sentry_light_noammo");
				particleHeavy.__KeyValueFromString("start_active", "1");
				particleHeavy.SetOrigin(marine.GetOrigin() + Vector(0, 0, 70));
				particleHeavy.Spawn();
				disableMoveParticleTable[marine] <- particleHeavy;
				DoEntFire("!self", "SetParent", "!activator", 0, marine, particleHeavy);
				particleHeavy.Activate();
			}
			else{
				if ( hActiveWeapon == null && disableMoveTable[marine] == 1
					|| hActiveWeapon && hActiveWeapon.GetClassname() != "asw_weapon_autogun" && disableMoveTable[marine] == 1 ){
					NetProps.SetPropInt( marine, "m_bPreventMovement", 0 );
					DoEntFire("!self", "Kill", "", 0, null, disableMoveParticleTable[marine]);
					disableMoveTable.rawdelete(marine);
					disableMoveParticleTable.rawdelete(marine);
				}
			}
			
			local prop = NetProps.GetPropInt( marine, "m_bPreventMovement" );
			if ( hActiveWeapon && hActiveWeapon.GetClassname() == "asw_weapon_autogun" && prop == 0 )
				NetProps.SetPropInt( marine, "m_bPreventMovement", 1 );
		}
		
        for (local weapon = marine.FirstMoveChild(); weapon != null; weapon = weapon.NextMovePeer()){
			if (weapon.GetClassname() == "asw_weapon_railgun"){
				if ( weapon.GetClips() < 1 )
					weapon.SetClips( 1 );
			} else if (weapon.GetClassname() == "asw_weapon_normal_armor")
				ParticleSpawn(0.2, 0, 0, 10, marine, "water_splash_leakypipe_vertical", 0, 1)
			else if (weapon.GetClassname() == "asw_weapon_chainsaw"){
				if (NetProps.GetPropInt(weapon, "m_fireState") != 0 && (!(chainsaw.rawin(marine)))){
					chainsaw[marine] <- Entities.CreateByClassname("prop_dynamic");
					chainsaw[marine].__KeyValueFromString("model", "models/weapons/chainsaw/chainsaw.mdl");
					
					function ChainsawPos(){
						self.SetLocalOrigin(Vector(120, 0, 40));
						self.DisconnectOutput("OnUser1", "ChainsawPos");
					}
					chainsaw[marine].ValidateScriptScope();
					chainsaw[marine].GetScriptScope().ChainsawPos <- ChainsawPos;
					
					DoEntFire("!self", "SetParent", "!activator", 0, marine, chainsaw[marine]);
					chainsaw[marine].ConnectOutput("OnUser1", "ChainsawPos");
					EntFireByHandle(chainsaw[marine], "FireUser1", "", 0, self, self);
					chainsaw[marine].Spawn();
					InjectThinkToSaw( chainsaw[marine], marine);
					chainsaw[marine].EmitSound("ASW_Chainsaw.attackOn");
					
					local uniqueString = UniqueString();
					chainsaw[marine].__KeyValueFromString("targetname", uniqueString);
					particleChainsawTable[chainsaw[marine]] <- Entities.CreateByClassname("info_particle_system");
					particleChainsawTable[chainsaw[marine]].__KeyValueFromString("effect_name", "buffgrenade_attach_arc_perm");
					particleChainsawTable[chainsaw[marine]].__KeyValueFromString("cpoint1", uniqueString);
					particleChainsawTable[chainsaw[marine]].__KeyValueFromString("start_active", "1");
					DoEntFire("!self", "SetParent", "!activator", 0, marine, particleChainsawTable[chainsaw[marine]]);
					particleChainsawTable[chainsaw[marine]].SetOrigin(marine.GetOrigin() + Vector(0, 0, 40));
					particleChainsawTable[chainsaw[marine]].Spawn();
					particleChainsawTable[chainsaw[marine]].Activate();
				} else if (NetProps.GetPropInt(weapon, "m_fireState") == 0 && chainsaw.rawin(marine)){
					chainsaw[marine].StopSound("ASW_Chainsaw.attackOn");
					chainsaw[marine].EmitSound("ASW_Chainsaw.Stop");
					DoEntFire("!self", "Kill", "", 0, null, particleChainsawTable[chainsaw[marine]]);
					particleChainsawTable.rawdelete(chainsaw[marine]);
					DoEntFire("!self", "Kill", "", 0, null, chainsaw[marine]);
					chainsaw.rawdelete(marine);
				}
			}
		
			if (radianceKD + 1 < Time()){
				if (weapon.GetClassname() == "asw_weapon_flashlight"){
					local nearTarget = null;
					foreach ( classname in RadianceArr )
					{
						while((nearTarget = Entities.FindByClassnameWithin(nearTarget, classname, marine.GetOrigin(), 400)) != null)
							radiancedMobs[nearTarget] <- nearTarget;
					}
					while((nearTarget = Entities.FindByClassnameWithin(nearTarget, "asw_drone", marine.GetOrigin(), 400)) != null)
						radiancedMobs[nearTarget] <- nearTarget;
					ParticleSpawn(1, 0, 0, 30, marine, "mortar_grenade_open_radius", 0, 1)
				}
			}
			
			if ( !( "GetMaxClip1" in weapon ) )
				continue;
			
			local maxClip1 = weapon.GetMaxClip1();
			foreach (IWT in infWeapon){
				if (weapon.GetClassname() == IWT && weapon.Clip1() < maxClip1)
					weapon.SetClip1(maxClip1);
			}
		
            if (weapon.GetClassname() in regenDelay){
				timeBetweenInverse1 = regenInterval[weapon.GetClassname()];
				timeAfterShoot1 = regenDelay[weapon.GetClassname()];
			
				if (weapon.GetClassname() == "asw_weapon_buff_grenade"){
					if (marine.GetMarineName() == "Bastille" 
					|| marine.GetMarineName() == "Faith")
						timeAfterShoot1 = 60; else
						if (marine.GetMarineName() == "Wolfe")
							timeAfterShoot1 = 60; else
							if (marine.GetMarineName() == "Jaeger" 
							|| marine.GetMarineName() == "Sarge")
								timeAfterShoot1 = 100; else
								if (marine.GetMarineName() == "Crash" 
								|| marine.GetMarineName() == "Vegas")
									timeAfterShoot1 = 25; else
									if (marine.GetMarineName() == "Wildcat")
										timeAfterShoot1 = 1.5;
				}
				
				local clips1 = weapon.GetMaxAmmo1() / maxClip1;
				if ( clips1 < noClipPenalty ){
					if (weapon.GetClassname() in ammoCount)
						maxClip1 = ammoCount[weapon.GetClassname()];
					else maxClip1 = ceil( maxClip1 * ( 1 - singleClipPenalty / clips1 ) );
				}
				
				if (regenAmmoMode == 1){
					local nearTarget = null;
					foreach (marino in marineName){
						if (marino == marine.GetName()){
							if( (nearTarget = Entities.FindByNameWithin(nearTarget, marino, regenOwner.GetOrigin(), 120)) != null ){
								if(weapon.GetClassname() != "asw_weapon_buff_grenade" )
									weapon.SetClip1(maxClip1);
							}
						}
					}
				}				
				
                if ( weapon.Clip1() > maxClip1 )
                    weapon.SetClip1( maxClip1 );
 
                if ( !( weapon.entindex() in nextRefillTick1 ) ){
                    nextRefillTick1[weapon.entindex()] <- Time();
                    lastClip1[weapon.entindex()] <- weapon.Clip1();
                    continue;
                }
 
                if ( weapon.Clip1() != lastClip1[weapon.entindex()] ){
                    lastClip1[weapon.entindex()] = weapon.Clip1();
                    nextRefillTick1[weapon.entindex()] = Time() + timeAfterShoot1 + timeBetweenInverse1 / weapon.GetMaxAmmo1();
                }
				
                if ( nextRefillTick1[weapon.entindex()] <= Time() && weapon.Clip1() < maxClip1 ){
                    weapon.SetClip1( weapon.Clip1() + 1 );
                    lastClip1[weapon.entindex()] = weapon.Clip1();
                    delay <- timeBetweenRefill1 + timeBetweenInverse1 / weapon.GetMaxAmmo1();
                    nextRefillTick1[weapon.entindex()] = Time() + delay;
                    if ( delay < minDelay )
                        minDelay = delay;
                }
            }
			
			if ( weapon.GetClassname() == "asw_weapon_rifle"
				|| weapon.GetClassname() == "asw_weapon_vindicator" 
				|| weapon.GetClassname() == "asw_weapon_prifle" 
				|| weapon.GetClassname() == "asw_weapon_combat_rifle"
				|| weapon.GetClassname() == "asw_weapon_heavy_rifle" ){
			
                if ( !( weapon.entindex() in nextRefillTick2 ) ){
                    nextRefillTick2[weapon.entindex()] <- Time();
                    lastClip2[weapon.entindex()] <- weapon.Clip2();
                    continue;
                }			
			
				if ( weapon.GetMaxClip2() <= 0 )
					continue;

				if ( weapon.Clip2() != lastClip2[weapon.entindex()] ){
					lastClip2[weapon.entindex()] = weapon.Clip2();
					nextRefillTick2[weapon.entindex()] = Time() + timeAfterShoot2 + timeBetweenInverse2 / weapon.GetMaxAmmo2();
				}

				if ( nextRefillTick2[weapon.entindex()] <= Time() && weapon.Clip2() < weapon.GetDefaultClip2() ){
					weapon.SetClip2( weapon.Clip2() + 1 );
					lastClip2[weapon.entindex()] = weapon.Clip2();
					delay <- timeBetweenRefill2 + timeBetweenInverse2 / weapon.GetMaxAmmo2();
					nextRefillTick2[weapon.entindex()] = Time() + delay;
					if ( delay < minDelay ) {
						minDelay = delay;
					}
				}			
			}
        }
    }
	
	if (radianceKD + 1 < Time()){
		foreach (mob in radiancedMobs){
			foreach (classname in RadianceArr){
				if (mob.GetClassname() == classname ){
					if ( mob.GetMaxHealth() == 0 )
						mob.SetMaxHealth(mob.GetHealth());
					mob.TakeDamage( mob.GetMaxHealth()/40, 4098, null );
				}
			}
			if(mob.GetClassname() == "asw_drone")
				mob.TakeDamage( 15, 4098, null );
			if(mob.GetClassname() == "asw_door")
				mob.TakeDamage( mob.GetMaxHealth()/40, 4098, null );
		}		
		radianceKD <- Time();
	}

	timeBetweenInverse1 = 75;
	timeAfterShoot1 = 5;
	return minDelay;
}
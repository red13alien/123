EntFireByHandle(self, "Color", "255 250 55", 0, self, self);
self.PrecacheSoundScript("d1_town.LargeFireLoop");
self.PrecacheSoundScript("NPC_Antlion.Distracted");
self.SetName("asw_4fun_buzzer"); //stop sound in 4fun_script.nut
self.EmitSound("d1_town.LargeFireLoop"); //while unable to change volume of sound
self.EmitSound("d1_town.LargeFireLoop"); //EmitSound() x2 helps
/*
local sParticleName = UniqueString();
local sTimerName = UniqueString();
local sParticleTimerName = UniqueString();
*/
local particle = Entities.CreateByClassname("info_particle_system");
particle.__KeyValueFromString("effect_name", "ground_fire_burn2_large");
particle.__KeyValueFromString("start_active", "1");
//particle.__KeyValueFromString("targetname", sParticleName);
particle.SetOrigin(self.GetOrigin() + Vector(0, 0, -10));
particle.Spawn();
DoEntFire("!self", "SetParent", "!activator", 0, self, particle);
particle.Activate();

local particleTimer = Entities.CreateByClassname("logic_timer");
particleTimer.__KeyValueFromFloat("RefireTime", 1.01);
//particleTimer.__KeyValueFromString("targetname", sParticleTimerName);
particleTimer.ValidateScriptScope();
local timerScope = particleTimer.GetScriptScope();
timerScope.particle <- particle;
timerScope.hSelfBuzzer <- self;
timerScope.ParticleReloadFunc <- function()
{
	if ( particle.IsValid && particle != null ){
		DoEntFire("!self", "Stop", "", 1, null, particle); //Fix for bug, when particle
		DoEntFire("!self", "Start", "", 0, null, particle); //doesn't shows, but it was spawned
	}

	if ( hSelfBuzzer.IsValid() && hSelfBuzzer != null ){
		hSelfBuzzer.Ignite(9999);
		hSelfBuzzer.StopSound("ASW_Buzzer.OnFire");
	} else {
		self.DisconnectOutput("OnTimer", "ParticleReloadFunc");
		self.Destroy();
	}
}
particleTimer.ConnectOutput("OnTimer", "ParticleReloadFunc");
DoEntFire("!self", "Enable", "", 0, null, particleTimer);

local timer = Entities.CreateByClassname("logic_timer");
timer.__KeyValueFromFloat("RefireTime", 0.4);
//timer.__KeyValueFromString("targetname", sTimerName);
timer.ValidateScriptScope();
local timerScope = timer.GetScriptScope();
timerScope.hSelfBuzzer <- self;
timerScope.BurnFunc <- function()
{
	if ( hSelfBuzzer.IsValid() && hSelfBuzzer != null ){
		local hMarineTarget = null;
		while( ( hMarineTarget = Entities.FindByClassnameWithin( hMarineTarget, "asw_marine", hSelfBuzzer.GetOrigin(), 300 ) ) != null ){
			if ( hMarineTarget.IsValid() ){
				hMarineTarget.TakeDamage( 4, 8, hSelfBuzzer );
				local hParticleTarget = Entities.CreateByClassname("info_target");
				local sTargetName = UniqueString();
				hParticleTarget.SetOrigin(hMarineTarget.GetOrigin() + Vector(0, 0, 50));
				hParticleTarget.__KeyValueFromString("spawnflags", "2");
				hParticleTarget.__KeyValueFromString("targetname", sTargetName);
				DoEntFire("!self", "SetParent", "!activator", 0, hMarineTarget, hParticleTarget);
				DoEntFire("!self", "Kill", "", 0.4, null, hParticleTarget);
				
				local hRealParticle = Entities.CreateByClassname("info_particle_system");
				hRealParticle.__KeyValueFromString("effect_name", "vortigaunt_beam");
				hRealParticle.__KeyValueFromString("cpoint1", sTargetName);
				hRealParticle.SetOrigin(hSelfBuzzer.GetOrigin());
				hRealParticle.Spawn();
				hRealParticle.Activate();
				
				DoEntFire("!self", "Start", "", 0, null, hRealParticle);
				DoEntFire("!self", "SetParent", "!activator", 0, hSelfBuzzer, hRealParticle);
				DoEntFire("!self", "Kill", "", 0.3, null, hRealParticle);
				hParticleTarget.EmitSound("NPC_Antlion.Distracted");
				hParticleTarget.EmitSound("NPC_Antlion.Distracted");
			}
		}
	} else {
		self.DisconnectOutput("OnTimer", "BurnFunc");
		self.Destroy();
	}
}
timer.ConnectOutput("OnTimer", "BurnFunc");
DoEntFire("!self", "Enable", "", 0, null, timer);
/*
DoEntFire("!self", "AddOutput", "OnDeath " + sTimerName + ":Kill::0:1", 0, null, self);
DoEntFire("!self", "AddOutput", "OnDeath " + sParticleName + ":Kill::0:1", 0, null, self);
DoEntFire("!self", "AddOutput", "OnDeath " + sParticleTimerName + ":Kill::0:1", 0, null, self);
*/
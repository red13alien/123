EntFireByHandle(self, "Color", "255 100 255", 0, self, self);

particle <- Entities.CreateByClassname("info_particle_system");
particle.__KeyValueFromString("effect_name", "mining_laser_beam_cp0_glow");
particle.__KeyValueFromString("start_active", "1");
particle.SetOrigin(self.GetOrigin() + Vector(0, 0, 125));
particle.Spawn();
DoEntFire("!self", "SetParent", "!activator", 0, self, particle);
particle.Activate();

particleTimer <- Entities.CreateByClassname("logic_timer");
particleTimer.__KeyValueFromFloat("RefireTime", 1.01);
particleTimer.ValidateScriptScope();
local timerScope = particleTimer.GetScriptScope();
timerScope.particle <- particle;
timerScope.ParticleReloadFunc <- function()
{
	if ( particle.IsValid && particle != null ){
		DoEntFire("!self", "Stop", "", 1, null, particle);
		DoEntFire("!self", "Start", "", 0, null, particle);
	}
}
particleTimer.ConnectOutput("OnTimer", "ParticleReloadFunc");
DoEntFire("!self", "Enable", "", 0, null, particleTimer);

function PinkDroneDied()
{
	Director.SpawnAlienBatch("asw_shaman", 5, self.GetOrigin() + Vector (0, 0, 10), self.GetAngles());
	DoEntFire("!self", "Disable", "", 0, null, particleTimer);
	DoEntFire("!self", "Kill", "", 0, null, particleTimer);
	DoEntFire("!self", "Stop", "", 0, null, particle);
	DoEntFire("!self", "Kill", "", 0, null, particle);
	self.DisconnectOutput("OnDeath", "PinkDroneDied");
}

self.ValidateScriptScope();
self.GetScriptScope().PinkDroneDied <- PinkDroneDied;
self.ConnectOutput("OnDeath", "PinkDroneDied");

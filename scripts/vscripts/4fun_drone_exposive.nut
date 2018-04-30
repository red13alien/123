//lel, missed "l" - explosive, but too lazy
EntFireByHandle(self, "Color", "255 0 0", 0, self, self);

particle <- Entities.CreateByClassname("info_particle_system");
particle.__KeyValueFromString("effect_name", "buffgrenade_center_light");
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

function ExplosiveDroneDied() 
{
	local explosion = Entities.CreateByClassname("env_explosion");
	explosion.__KeyValueFromInt("iMagnitude", 120);
	explosion.__KeyValueFromInt("iRadiusOverride", 500);
	explosion.SetOrigin(self.GetOrigin() + Vector(0, 0, 37));				
	DoEntFire("!self", "Explode", "", 0, null, explosion);
	DoEntFire("!self", "Kill", "", 0.5, null, explosion);
	DoEntFire("!self", "Disable", "", 0, null, particleTimer);
	DoEntFire("!self", "Kill", "", 0, null, particleTimer);
	DoEntFire("!self", "Stop", "", 0, null, particle);
	DoEntFire("!self", "Kill", "", 0, null, particle);
	self.DisconnectOutput("OnDeath", "ExplosiveDroneDied");
}

self.ValidateScriptScope();
self.GetScriptScope().ExplosiveDroneDied <- ExplosiveDroneDied;
self.ConnectOutput("OnDeath", "ExplosiveDroneDied");
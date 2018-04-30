EntFireByHandle(self, "Color", "120 255 120", 0, self, self);

if (GetMapName() == "rd-lan2_sewer" )
	spwnCnt <- 3; else
	spwnCnt <- 9;

particle <- Entities.CreateByClassname("info_particle_system");
particle.__KeyValueFromString("effect_name", "ranger_projectile_glow");
particle.__KeyValueFromString("start_active", "1");
particle.SetOrigin(self.GetOrigin() + Vector(0, 0, 115));
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

function GreenDroneDied() 
{
	local spawner = Entities.CreateByClassname("asw_spawner");
	spawner.SetOrigin(self.GetOrigin() + Vector (0, 0, 200));
	spawner.SetAnglesVector(self.GetAngles());
	spawner.__KeyValueFromString("AlienClass", "1");
	spawner.__KeyValueFromString("AlienOrders", "4");
	spawner.__KeyValueFromString("MaxLiveAliens", spwnCnt.tostring());
	spawner.__KeyValueFromString("SpawnerState", "1");
	spawner.__KeyValueFromString("ClearCheck", "0");
	spawner.__KeyValueFromString("SpawnIfMarinesAreNear", "1");
	spawner.__KeyValueFromString("NumAliens", spwnCnt.tostring());
	spawner.__KeyValueFromString("SpawnInterval", "0");
	spawner.__KeyValueFromString("minoffset", "-50 -50 0");
	spawner.__KeyValueFromString("maxoffset", "50 50 0");
	spawner.Spawn();
	DoEntFire("!self", "StartSpawning", "", 0, null, spawner);
	DoEntFire("!self", "Kill", "", spwnCnt+1, null, spawner);
	spawner.ValidateScriptScope();
	local spawnerScope = spawner.GetScriptScope();
	spawnerScope.SpawnerFunc <- function()
	{
		self.__KeyValueFromString("sizescalesp", RandomFloat( 0.4, 2.2 ).tostring());
		self.__KeyValueFromString("alien_vscripts", "4fun_mortar.nut");
	}
	spawner.ConnectOutput("OnSpawned", "SpawnerFunc");
	DoEntFire("!self", "Disable", "", 0, null, particleTimer);
	DoEntFire("!self", "Kill", "", 0, null, particleTimer);
	DoEntFire("!self", "Stop", "", 0, null, particle);
	DoEntFire("!self", "Kill", "", 0, null, particle);
	self.DisconnectOutput("OnDeath", "GreenDroneDied");
}

self.ValidateScriptScope();
self.GetScriptScope().GreenDroneDied <- GreenDroneDied;
self.ConnectOutput("OnDeath", "GreenDroneDied");
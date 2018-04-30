self.PrecacheSoundScript("NPC_Antlion.PoisonBall");
self.PrecacheSoundScript("NPC_Antlion.MeleeAttackDouble");

local nearTarget = null;
local radius = 50;
while((nearTarget = Entities.FindByClassnameWithin(nearTarget, "asw_door", self.GetOrigin(), radius)) != null)
	nearTarget.TakeDamage( nearTarget.GetHealth(), 4098, null );

self.SetCollisionGroup(24);
hDivers <- null;
while ( ( hDivers = Entities.FindByClassname( hDivers, "asw_queen_divers" ) ) != null )
	hDivers.SetCollisionGroup(24);
	
function QueenDied() 
{
	local spawner = Entities.CreateByClassname("asw_spawner");
	spawner.SetOrigin(self.GetOrigin() + Vector (0, 0, -10));
	spawner.SetAnglesVector(self.GetAngles());
	spawner.__KeyValueFromString("AlienClass", "2");
	spawner.__KeyValueFromString("AlienOrders", "3");
	spawner.__KeyValueFromString("MaxLiveAliens", "20");
	spawner.__KeyValueFromString("SpawnerState", "1");
	spawner.__KeyValueFromString("ClearCheck", "0");
	spawner.__KeyValueFromString("SpawnIfMarinesAreNear", "1");
	spawner.__KeyValueFromString("NumAliens", "20");
	spawner.__KeyValueFromString("SpawnInterval", "0");
	spawner.__KeyValueFromString("minoffset", "-40 -40 -10");
	spawner.__KeyValueFromString("maxoffset", "40 40 20");
	spawner.Spawn();
	spawner.ValidateScriptScope();
	local spawnerScope = spawner.GetScriptScope();
	spawnerScope.SpawnerFunc <- function()
	{
		if (self != null){
			self.__KeyValueFromString("sizescalesp", RandomFloat( 0.4, 1.6 ).tostring());
			self.__KeyValueFromString("alien_vscripts", "4fun_mortar.nut");
		}
	}
	spawner.ConnectOutput("OnSpawned", "SpawnerFunc");
	DoEntFire("!self", "StartSpawning", "", 5, null, spawner);
	DoEntFire("!self", "Kill", "", 20, null, spawner);
	
	local particle = Entities.CreateByClassname("info_particle_system");
	particle.__KeyValueFromString("effect_name", "shieldBug_body_explode");
	particle.SetOrigin(self.GetOrigin());
	particle.Spawn();
	particle.Activate();
	DoEntFire("!self", "Start", "", 5, null, particle);
	DoEntFire("!self", "Kill", "", 10, null, particle);
	
	EntFireByHandle(self, "Kill", "", 5, self, self);
	
	local target = Entities.CreateByClassname("info_target");
	target.SetOrigin(self.GetOrigin());
	target.EmitSound("NPC_Antlion.MeleeAttackDouble");
	DoEntFire("!self", "Kill", "", 10, null, target);
	
	target = Entities.CreateByClassname("info_target");
	target.SetOrigin(self.GetOrigin());
	target.EmitSound("NPC_Antlion.MeleeAttackDouble");
	DoEntFire("!self", "Kill", "", 10, null, target);
	
	target = Entities.CreateByClassname("info_target");
	target.SetOrigin(self.GetOrigin());
	target.EmitSound("NPC_Antlion.PoisonBall");
	DoEntFire("!self", "Kill", "", 10, null, target);
	
	self.EmitSound("NPC_Antlion.PoisonBall");
	self.DisconnectOutput("OnDeath", "QueenDied");
}

EntFireByHandle(self, "Color", "240 80 80", 0, self, self);

self.ValidateScriptScope();
self.GetScriptScope().QueenDied <- QueenDied;
self.ConnectOutput("OnDeath", "QueenDied");
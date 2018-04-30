if ( GetMapName() != "rd-lan2_sewer" )
{
	EntFireByHandle(self, "Color", "114 84 23", 0, self, self);

	function BrownDroneDied()
	{
		local vect = self.GetOrigin() + Vector (0, 0, 20);
		Director.SpawnAlienBatch("asw_drone", 10, vect, self.GetAngles());
		local spawner = Entities.CreateByClassname("asw_spawner");
		spawner.SetOrigin(self.GetOrigin() + Vector (0, 0, 0));
		spawner.SetAnglesVector(self.GetAngles());
		spawner.__KeyValueFromString("AlienClass", "0");
		spawner.__KeyValueFromString("AlienOrders", "3");
		spawner.__KeyValueFromString("MaxLiveAliens", "5");
		spawner.__KeyValueFromString("SpawnerState", "1");
		spawner.__KeyValueFromString("ClearCheck", "0");
		spawner.__KeyValueFromString("StartBurrowed", "1");
		spawner.__KeyValueFromString("SpawnIfMarinesAreNear", "1");
		spawner.__KeyValueFromString("NumAliens", "20");
		spawner.__KeyValueFromString("SpawnInterval", "0");
		spawner.__KeyValueFromString("minoffset", "-30 -30 0");
		spawner.__KeyValueFromString("maxoffset", "30 30 0");
		spawner.Spawn();
		DoEntFire("!self", "StartSpawning", "", 3, null, spawner);
		DoEntFire("!self", "Kill", "", 40, null, spawner);
		spawner.ValidateScriptScope();
		local spawnerScope = spawner.GetScriptScope();
		spawnerScope.SpawnerFunc <- function()
		{
			if (self != null)
				self.__KeyValueFromString("sizescalesp", RandomFloat( 0.7, 1.3 ).tostring());
		}
		spawner.ConnectOutput("OnSpawned", "SpawnerFunc");
		self.DisconnectOutput("OnDeath", "BrownDroneDied");
	}

	self.ValidateScriptScope();
	self.GetScriptScope().BrownDroneDied <- BrownDroneDied;
	self.ConnectOutput("OnDeath", "BrownDroneDied");
}
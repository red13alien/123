EntFireByHandle(self, "Color", "222 222 1", 0, self, self);

parasiteProp <- CreateProp("prop_dynamic", self.GetOrigin(), "models/aliens/parasite/parasite.mdl", 17);
parasiteProp.SetOwner(self);
EntFireByHandle(parasiteProp, "SetDefaultAnimation", "ragdoll", 0, self, self);
EntFireByHandle(parasiteProp, "SetAnimation", "ragdoll", 0, self, self);
EntFireByHandle(parasiteProp, "DisableShadow", "", 0, self, self);
EntFireByHandle(parasiteProp, "SetParent", "!activator", 0, self, self);
EntFireByHandle(parasiteProp, "SetParentAttachment", "blood_spray", 0, self, self);

if (GetMapName() == "rd-lan2_sewer" )
	spwnCnt <- 1; else
	spwnCnt <- 6;

function YellowDroneDied() 
{
	Director.SpawnAlienBatch("asw_parasite", spwnCnt, self.GetOrigin() + Vector (0, 0, 10), self.GetAngles());
	DoEntFire("!self", "Kill", "", 0, null, parasiteProp);
	self.DisconnectOutput("OnDeath", "YellowDroneDied");
}

function RotateToFaceForward()
{
	self.SetLocalAngles(0, 120, 0); // need SetLocalOrigin() for better position
	self.DisconnectOutput("OnUser1", "RotateToFaceForward");
}

parasiteProp.ValidateScriptScope();
parasiteProp.GetScriptScope().RotateToFaceForward <- RotateToFaceForward;
parasiteProp.ConnectOutput("OnUser1", "RotateToFaceForward");
EntFireByHandle(parasiteProp, "FireUser1", "", 0, self, self);

self.ValidateScriptScope();
self.GetScriptScope().YellowDroneDied <- YellowDroneDied;
self.ConnectOutput("OnDeath", "YellowDroneDied");
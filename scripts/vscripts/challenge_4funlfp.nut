IncludeScript("challenge_4fun.nut");
Convars.SetValue( "asw_simple_hacking", 1 );
Convars.SetValue( "asw_buzzer_poison_duration", 2 );
Convars.SetValue( "asw_controls", 0 );
Convars.SetValue( "asw_marine_rolls", 0 );
Convars.SetValue( "asw_marine_collision", 1 );
Convars.SetValue( "rd_marine_jump_height", 20 );
SendToConsole("firstperson");

local timer = Entities.CreateByClassname("logic_timer");
timer.__KeyValueFromFloat( "RefireTime", 0.1 );
DoEntFire("!self", "Disable", "", 0, null, timer);
timer.ValidateScriptScope();
local timerScope = timer.GetScriptScope();
timerScope.fpMode <- function()
{
	local weaponArray = [ "asw_weapon_freeze_grenades", "asw_weapon_flares", "asw_weapon_grenade_launcher", "asw_weapon_grenades" ];
	foreach ( weapon in weaponArray ){
		local hWeapon = null;
		while( ( hWeapon = Entities.FindByClassname( hWeapon, weapon ) ) != null )
			hWeapon.Destroy();
	}
	
	local marine = null;
	while((marine = Entities.FindByClassname(marine, "asw_marine")) != null ){
		if ( !marine.IsInhabited() )
			marine.TakeDamage( marine.GetHealth()*999, 64, null );
	}
}
timer.ConnectOutput("OnTimer", "fpMode");
DoEntFire("!self", "Enable", "", 0, null, timer);

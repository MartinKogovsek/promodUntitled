#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_globallogic_utils;

main()
{
	if(game["promod_timeout_called"])
	{
		thread promod\timeout::main();
		return;
	}
	thread stratTime();
	level waittill("strat_over");
	players=getentarray("player","classname");
	for(i=0;i<players.size;i++)
	{
		player=players[i];
		classType=player.pers["class"];
		if((player.pers["team"]=="allies"||player.pers["team"]=="axis")&&player.sessionstate=="playing"&&isDefined(player.pers["class"]))
		{
			if(isDefined(game["PROMOD_KNIFEROUND"])&&!game["PROMOD_KNIFEROUND"]||!isDefined(game["PROMOD_KNIFEROUND"]))
			{
				if(level.hardcoreMode&&getDvarInt("weap_allow_frag_grenade"))player giveWeapon("frag_grenade_short_mp");
				else if(getDvarInt("weap_allow_frag_grenade"))player giveWeapon("frag_grenade_mp");
				if(player.pers[classType]["loadout_grenade"]=="flash_grenade"&&getDvarInt("weap_allow_flash_grenade"))
				{
					player setOffhandSecondaryClass("flash");
					player giveWeapon("flash_grenade_mp");
					
				}
				else if(player.pers[classType]["loadout_grenade"]=="smoke_grenade"&&getDvarInt("weap_allow_smoke_grenade"))
				{
					player setOffhandSecondaryClass("smoke");
					player giveWeapon("smoke_grenade_mp");
				}
				player maps\mp\gametypes\_class::sidearmWeapon();
				player maps\mp\gametypes\_class::primaryWeapon();
			}
			else player thread maps\mp\gametypes\_globallogic::removeWeapons();			
			player allowsprint(true);
			player setMoveSpeedScale(1.0-0.05*int(isDefined(player.curClass)&&player.curClass=="assault")*int(isDefined(game["PROMOD_KNIFEROUND"])&&!game["PROMOD_KNIFEROUND"]||!isDefined(game["PROMOD_KNIFEROUND"])));
			player allowjump(true);
		}
	}
	UpdateClientNames();
	if(game["promod_timeout_called"])
	{
		thread promod\timeout::main();
		return;
	}
}

stratTime()
{
	thread stratTimer();
	level.strat_over=false;
	
	strat_time_left=game["PROMOD_STRATTIME"]+level.prematchPeriod*int(getDvarInt("promod_allow_strattime")&&isDefined(game["CUSTOM_MODE"])&&game["CUSTOM_MODE"]&&level.gametype=="sd");while(!level.strat_over)
	{
		players=getentarray("player","classname");
		for(i=0;i<players.size;i++)
		{
			player=players[i];
			if((player.pers["team"]=="allies"||player.pers["team"]=="axis")&&!isDefined(player.pers["class"]))player.statusicon="hud_status_dead";
		}
		wait 0.25;
		strat_time_left-=0.25;
		if(strat_time_left<=0||game["promod_timeout_called"])level.strat_over=true;
	}
	level notify("strat_over");
}

stratTimer()
{

	visionSetNaked("mpIntro",0);

	matchStartText = createServerFontString( "objective", 1.5 ); 
    matchStartText setPoint( "CENTER", "CENTER", 0, 0 ); 
    matchStartText.sort = 1001; 
    if( isDefined(game["PROMOD_KNIFEROUND"]) && game["PROMOD_KNIFEROUND"] ) matchStartText setText( "Knife round" ); 
    else matchStartText setText( "Strat time:" ); 
    matchStartText.foreground = false; 
    matchStartText.hidewheninmenu = false;
	matchStartText.glowcolor = (0.000, 0.455, 0.851);
	matchStartText.glowalpha = 1;

	matchStartTimer = createServerTimer("objective", 1.4);
	matchStartTimer setPoint("CENTER", "CENTER", 0, 0 );
	matchStartTimer setStarttime(game["PROMOD_STRATTIME"] + level.prematchPeriod * int(getDvarInt("promod_allow_strattime") && isDefined(game["CUSTOM_MODE"]) && game["CUSTOM_MODE"] && (level.gametype == "sd" || level.gametype == "sr")));
	matchStartTimer.sort = 1001;
	matchStartTimer.foreground = false;
	matchStartTimer.hideWhenInMenu = false;
	
	level waittill("strat_over");

	if (isDefined(matchStartText) || isDefined( matchStartTimer )) 
	{
		matchStartText fadeOverTime(1.2);
		matchStartText.alpha = 0;

		visionSetNaked(getDvar("mapname"),1);

		wait 8;
		matchStartText destroy();
	}
}

setStarttime( time ){
	self thread strTime( time );
}

strTime( time )
{	
	self.balcks = newHudElem();
	self.balcks.archived = false;
	self.balcks.alignx = "center";
	self.balcks.alignY = "middle";
	self.balcks.horzAlign = "center";
	self.balcks.vertAlign = "middle";
	self.balcks.x = 0;
	self.balcks.y = 0;
	self.balcks setShader("black", 1000, 1000);
	self.balcks.Alpha = 1;
	self.balcks.foreGround = true;
	self.balcks.hideWhenInMenu = true;
	self.balcks FadeOverTime(1);
	self.balcks.Alpha = 0;

	//vars
	numHuds = [];
	fadeNum = time;
	ix = 0;
	actualTime = 0;
	//create number elements
	for (i = 0; i < time + 1; i++){
		numHuds[i] = newNumHud(i);
		if(i < (time - 6))
			numHuds[i].alpha = 0;
	}
	//main loop
	for (i = 0; i < 20000; i+=2) {
		for (k = time; k >= 0; k--){
			numHuds[k] MoveOverTime( 0.01 );

			//(i + (k * "spacing") + "angle" + circle radius)
			numHuds[k].x = sin(i + (k * 40) + ((9-time)*40)) * 100; //calc x
			numHuds[k].y = cos(i + (k * 40) + ((9-time)*40)) * 100; //calc y

			if(numHuds[k].y > 99 && fadeNum == k) //color the number after passed
				numHuds[k].color = ( 0.000, 0.455, 0.851 ); 

			if(numHuds[k].x > 50){ //fadeout numbers
				if(fadeNum == k){
					numHuds[k] FadeOverTime(0.5);
					numHuds[k].alpha = 0;
					fadeNum--;
				}
				if((fadeNum - 6) == k){ //fadein numbers
					numHuds[k] FadeOverTime(0.5);
					numHuds[k].alpha = 1;
				}
			}
		}
		wait 0.01;
		ix++;
		if(ix == 20){ //actual time passed, not 100% accurate but works
			actualTime++;
			ix -= 20;
		}
		if(actualTime - 3 == time) //break loop, -3 so nums fade
			break;
	}
	for (l = 0; l < time + 1; l++){
		numHuds[l] destroy();
	}
}

newNumHud(text){
	newhud = newHudElem();

	newhud.alignx = "center";
	newhud.alignY = "middle";
	newhud.horzAlign = "center";
	newhud.vertAlign = "middle";
	newhud.sort = 1001;
	newhud.hidewheninmenu = false;
	newhud.foreGround = false;

	newhud SetText(text);
	newhud.fontScale = 1.5;
	newhud.font = "objective";
	newhud.glowcolor = (0.000, 0.455, 0.851);
	newhud.glowalpha = 1;

	return newhud;
}


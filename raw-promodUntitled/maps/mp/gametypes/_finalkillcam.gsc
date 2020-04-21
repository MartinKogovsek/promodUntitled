#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_finalkillcam_music;

finalKillcamWaiter()
{
	if ( !level.inFinalKillcam )
		return;
		
	while (level.inFinalKillcam)
		wait(0.05);
}

postRoundFinalKillcam()
{
	level notify( "play_final_killcam" );
	level thread endRound();

	maps\mp\gametypes\_globallogic_utils::resetOutcomeForAllPlayers();
	finalKillcamWaiter();	
}

startFinalKillcam( 
	attackerNum,
	targetNum,
	killcamentityindex,
	sWeapon,
	deathTime,
	deathTimeOffset,
	offsetTime, 
	attacker,
	victim
)

{
	if(attackerNum < 0)
		return;
	recordKillcamSettings( attackerNum, targetNum, sWeapon, deathTime, deathTimeOffset, offsetTime, attacker, killcamentityindex, victim );
	startLastKillcam();
}

startLastKillcam()
{
	if ( level.inFinalKillcam )
		return;

	if ( !isDefined(level.lastKillCam) )
		return;
	
	level.inFinalKillcam = true;
	level waittill ( "play_final_killcam" );

	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		player closeMenu(); 
		player closeInGameMenu();
		player thread finalKillcam();
	}
	
	wait( 0.1 );

	while ( areAnyPlayersWatchingTheKillcam() )
		wait( 0.05 );

	level.inFinalKillcam = false;
}


areAnyPlayersWatchingTheKillcam()
{
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		if ( isDefined( player.killcam ) )
			return true;
	}
	
	return false;
}

waitKillcamTime()
{
	self endon("disconnect");
	self endon("end_finalkillcam");

	wait(self.killcamlength - 0.07);
	self notify("end_finalkillcam");
}

waitFinalKillcamSlowdown( startTime )
{
	self endon("disconnect");
	self endon("end_finalkillcam");
	secondsUntilDeath = ( ( level.lastKillCam.deathTime - startTime ) / 1000 );
	deathTime = getTime() + secondsUntilDeath * 1000;
	waitBeforeDeath = 2;
	wait( max(0, (secondsUntilDeath - waitBeforeDeath) ) );
	setTimeScale( 1, int( deathTime - 500 ));
	wait( waitBeforeDeath );
	setTimeScale(1,getTime());
}
setTimeScale(to,time)
{
	difference = (abs(getTime() - time)/1000);
	timescale = getDvarFloat("timescale");
	if(difference != 0) 
	{
		for(i = timescale*20; i >= to*20; i -= 1 )
		{
			wait ((int(difference)/int(getDvarFloat("timescale")*20))/20);
			setDvar("timescale",i/20);
		} 
	}
	else
	setDvar("timescale",to);
}
endKillcam()
{
	if(isDefined(self.fkc_timer))
		self.fkc_timer.alpha = 0;
		
	if(isDefined(self.killertext))
	self.killertext.alpha = 0;
			
	self.killcam = undefined;
}

checkForAbruptKillcamEnd()
{
	self endon("disconnect");
	self endon("end_finalkillcam");
	
	while(1)
	{
		if ( self.archivetime <= 0 )
			break;
		wait .05;
	}
	
	self notify("end_finalkillcam");
}
checkPlayers()
{
	self endon("disconnect");
	self endon("end_finalkillcam");
	
	while(1)
	{
		if(! isDefined(maps\mp\gametypes\_globallogic::getPlayerFromClientNum(level.lastKillCam.spectatorclient)) )
			break;
		wait 0.05;
	}
	self notify("end_finalkillcam");
}
recordKillcamSettings( spectatorclient, targetentityindex, sWeapon, deathTime, deathTimeOffset, offsettime, attacker, entityindex, victim )
{
	if ( ! isDefined(level.lastKillCam) )
		level.lastKillCam = spawnStruct();
	
	level.lastKillCam.spectatorclient = spectatorclient;
	level.lastKillCam.weapon = sWeapon;
	level.lastKillCam.deathTime = deathTime;
	level.lastKillCam.deathTimeOffset = deathTimeOffset;
	level.lastKillCam.offsettime = offsettime;
	level.lastKillCam.targetentityindex = targetentityindex;
	level.lastKillCam.attacker = attacker;
	level.lastKillCam.entityindex = entityindex;
	level.lastKillCam.victim = victim;
}

finalKillcam()
{
	self endon("disconnect");
	level endon("game_ended");
	
	self notify( "end_killcam" );

	self setClientDvar("cg_airstrikeKillCamDist", 20);
	
	postDeathDelay = (getTime() - level.lastKillCam.deathTime) / 1000;
	predelay = postDeathDelay + level.lastKillCam.deathTimeOffset;

	camtime = calcKillcamTime( level.lastKillCam.weapon, predelay, false, undefined );
	postdelay = calcPostDelay();

	killcamoffset = camtime + predelay;
	killcamlength = camtime + postdelay - 0.05;

	killcamstarttime = (gettime() - killcamoffset * 1000);

	self notify ( "begin_killcam", getTime() );

	self.sessionstate = "spectator";
	self.spectatorclient = level.lastKillCam.spectatorclient;
	self.killcamentity = -1;
	if ( level.lastKillCam.entityindex >= 0 )
		self thread setKillCamEntity( level.lastKillCam.entityindex, 0 - killcamstarttime - 100 );
	self.killcamtargetentity = level.lastKillCam.targetentityindex;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = level.lastKillCam.offsettime;

	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", false);
	self allowSpectateTeam("none", false);

	wait 0.05;

	if ( self.archivetime <= predelay )
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;

		self notify ( "end_finalkillcam" );
		
		return;
	}
	
	self thread checkForAbruptKillcamEnd();
	self thread checkPlayers();

	self.killcam = true;

	self addKillcamKiller(level.lastKillCam.attacker,level.lastKillCam.victim);
	
	self thread waitKillcamTime();
	self thread waitFinalKillcamSlowdown( killcamstarttime );

	self waittill("end_finalkillcam");
	
	self.villain destroy();
	self.versus destroy();
	self.victim destroy();
	self.kcText destroy();
	self.kcBck destroy();
	self.kcSongText destroy();
	self.kcSongBck destroy();

	self endKillcam();
}

isKillcamGrenadeWeapon( sWeapon )
{
	if (sWeapon == "frag_grenade_mp")
		return true;
		
	else if (sWeapon == "frag_grenade_short_mp"  )
		return true;
	
	return false;
}
calcKillcamTime( sWeapon, predelay, respawn, maxtime )
{
	camtime = 0.0;
	
	if ( isKillcamGrenadeWeapon( sWeapon ) )
	{
		camtime = 4.25; 
	}
	else
		camtime = 5;
	
	if (isdefined(maxtime)) {
		if (camtime > maxtime)
			camtime = maxtime;
		if (camtime < .05)
			camtime = .05;
	}
	
	return camtime;
}

calcPostDelay()
{
	postdelay = 0;
	
	if (getDvar( "scr_killcam_posttime") == "")
		postdelay = 2;
		
	else 
	{
		postdelay = getDvarFloat( "scr_killcam_posttime");
		if (postdelay < 0.05)
			postdelay = 0.05;
	}
	
	return postdelay;
}
addKillcamKiller(attacker,victim)
{
	self.villain = createFontString( "objective", level.lowerTextFontSize );
	self.villain setPoint( "CENTER", "BOTTOM", -500, -100 ); 
	self.villain.alignX = "right";
	self.villain.archived = false;
	self.villain setPlayerNameString( attacker );
	self.villain.alpha = 1;
	self.villain.glowalpha = 1;
	self.villain.glowColor = (0.000, 0.455, 0.851);
	self.villain moveOverTime( 4 );
	self.villain.x = -20;
	self.villain.foreGround = true;

	self.versus = createFontString( "objective", level.lowerTextFontSize );
	self.versus.alpha = 0;
	self.versus setPoint( "CENTER", "BOTTOM", 0, -100 );  
	self.versus.archived = false;
	self.versus setText( "vs" );
	self.versus fadeOverTime( 3 );
	self.versus.alpha = 0.8;
	self.versus.foreGround = true;
  
	self.victim = createFontString( "objective", level.lowerTextFontSize );
	self.victim setPoint( "CENTER", "BOTTOM", 500, -100 );
	self.victim.alignX = "left";  
	self.victim.archived = false;
	self.victim setPlayerNameString( victim );
	self.victim.glowalpha = 1; 
	self.victim.glowColor = (0.000, 0.455, 0.851);
	self.victim moveOverTime( 4 );
	self.victim.x = 20;
	self.victim.foreGround = true;

	self.kcText = newHudElem();
	self.kcText.archived = false;
	self.kcText SetText("ROUND WINNING KILL");
	self.kcText.color = (0.498, 0.859, 1.000);
	self.kcText.alignx = "center";
	self.kcText.alignY = "middle";
	self.kcText.horzAlign = "center";
	self.kcText.vertAlign = "middle";
	self.kcText.y = 165;
	self.kcText.alpha = 0.8;
	self.kcText.fontScale = 3;
	self.kcText.font = "objective";
	self.kcText.foreGround = true;

	self.kcBck = newHudElem();
	self.kcBck.archived = false;
	self.kcBck.alignx = "center";
	self.kcBck.alignY = "middle";
	self.kcBck.horzAlign = "center";
	self.kcBck.vertAlign = "middle";
	self.kcBck.x = 0;
	self.kcBck.y = 155;
	self.kcBck setShader("black", 900, 60);
	self.kcBck.glowAlpha = 1;
	self.kcBck.Alpha = 0.2;
	self.kcBck.color = ( 0.067, 0.067, 0.067 );
	self.kcBck.foreGround = false;
	self.kcBck.hideWhenInMenu = true;

	self.kcSongText = newHudElem();
	self.kcSongText.archived = false;
	switch( level.kcSong ) 	 
	{
	case 1:
		self.kcSongText SetText("Song: " + "pU-1 (songName)");
		break;
	case 2:
		self.kcSongText SetText("Song: " + "pU-2 (songName)");
		break;
	case 3:
		self.kcSongText SetText("Song: " + "pU-3 (songName)");
		break;
	case 4:
		self.kcSongText SetText("Song: " + "pU-4 (songName)");
		break;
	case 5:
		self.kcSongText SetText("Song: " + "pU-5 (songName)");
		break;
	case 6:
		self.kcSongText SetText("Song: " + "pU-6 (songName)");
		break;
	case 7:
		self.kcSongText SetText("Song: " + "pU-7 (songName)");
		break;
	case 8:
		self.kcSongText SetText("Song: " + "pU-8 (songName)");
		break;
	case 9:
		self.kcSongText SetText("Song: " + "pU-9 (songName)");
		break;
	case 10:
		self.kcSongText SetText("Song: " + "pU-10 (songName)");
		break;
	case 11:
		self.kcSongText SetText("Song: " + "pU-11 (songName)");
		break;
	case 12:
		self.kcSongText SetText("Song: " + "pU-12 (songName)");
		break;
	default:
		self.kcSongText SetText("Out of bounds!");
		break;
	}
	self.kcSongText.alignx = "center";
	self.kcSongText.alignY = "middle";
	self.kcSongText.horzAlign = "center";
	self.kcSongText.vertAlign = "middle";
	self.kcSongText.y = 192;
	self.kcSongText.alpha = 0.6;
	self.kcSongText.fontScale = 1.4;
	self.kcSongText.font = "default";
	self.kcSongText.foreGround = true;

	self.kcSongBck = newHudElem();
	self.kcSongBck.archived = false;
	self.kcSongBck.alignx = "center";
	self.kcSongBck.alignY = "middle";
	self.kcSongBck.horzAlign = "center";
	self.kcSongBck.vertAlign = "middle";
	self.kcSongBck.x = 0;
	self.kcSongBck.y = 192;
	self.kcSongBck setShader("popmenu_bg", 600, 16);
	self.kcSongBck.glowAlpha = 1;
	self.kcSongBck.Alpha = 0.2;
	self.kcSongBck.color = ( 0.067, 0.067, 0.067 );
	self.kcSongBck.foreGround = false;
	self.kcSongBck.hideWhenInMenu = true;

	if ( isDefined( self.carryIcon ) )
		self.carryIcon destroy();
		
}
addKillcamTimer(camtime)
{
	if (! isDefined(self.fkc_timer))
	{
			self.fkc_timer = createFontString("big", 2.0);
			self.fkc_timer.archived = false;
			self.fkc_timer.x = 0;
			self.fkc_timer.alignX = "center";
			self.fkc_timer.alignY = "middle";
			self.fkc_timer.horzAlign = "center_safearea";
			self.fkc_timer.vertAlign = "top";
			self.fkc_timer.y = 50;
			self.fkc_timer.sort = 1;
			self.fkc_timer.font = "big";
			self.fkc_timer.foreground = true;
			self.fkc_timer.color = (0.0,228,255);
			self.fkc_timer.hideWhenInMenu = true;
	}
	self.fkc_timer.y = 50;
	self.fkc_timer.alpha = 1;
	self.fkc_timer setTenthsTimer(camtime);
}
setKillCamEntity( killcamentityindex, delayms )
{
	self endon("disconnect");
	self endon("end_killcam");
	self endon("spawned");
	
	if ( delayms > 0 )
		wait delayms / 1000;
	
	self.killcamentity = killcamentityindex;
}
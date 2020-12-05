#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_globallogic;
#include maps\mp\gametypes\_globallogic_utils;

startvote()  
{
	wait getDvarFloat("scr_intermission_time");
	level.invoting=1; 	
	level thread misc_scripts\music::endGameMusic();
	level addVoteTimer(22);
	for(i=0;i<level.players.size;i++) 	 
	{
		player=level.players[i];                    
		player.sessionteam = "spectator"; 	         
		player.sessionstate = "spectator"; 	        
		player [[level.spawnSpectator]]();
		player closeMenu();
		player closeInGameMenu();
		player openMenu("vote");
		player thread onDisconnect();
		player thread updateMenuDisplay();
		player setClientDvar( "hud_ShowWinner", "0" );
		//player setClientDvar( "cg_drawgun", "0" ); //dvar is still 0 on next map
		player setClientDvar( "cg_drawcrosshair", "0" );
		player setClientDvar( "hud_voteText", "Vote for next map" );
		player setClientDvar( "ui_inVote", "1" );
	}
	thread handleVoting();
	wait getDvarFloat("scr_vote_time");
	for(i=0;i<level.players.size;i++) 	 
	{
		player=level.players[i]; 		
		player setClientDvar( "hud_voteText", "Next Map:" );
		if(IsDefined(level.voteTimetext))
			level.voteTimetext destroy();
		if(IsDefined(level.voteTimetextBck))
			level.voteTimetextBck destroy();
		player setClientDvar( "hud_ShowWinner", "1" );
	}
	level.invoting=2; 	
	if(level.maptok[getHighestVotedMap()]!="Restart") 	
		setDvar( "sv_maprotationcurrent", "gametype " + strTok(level.votemaps[getHighestVotedMap()],";")[1] + " map " + strTok(level.votemaps[getHighestVotedMap()],";")[0] );
	else 	
		setDvar( "sv_maprotationcurrent", "gametype " + getdvar("g_gametype") + " map " + getDvar("mapname") );
	wait getDvarFloat("vote_winner_time");

	level.invoting=0;   	
	SetExpFog(1000, 1500, 1, 1, 1, 0.1);
	level notify( "time_over" );

	//blackscreen
	blackscr = newHudElem();
	blackscr.archived = false;
	blackscr.alignx = "center";
	blackscr.alignY = "middle";
	blackscr.horzAlign = "center";
	blackscr.vertAlign = "middle";
	blackscr.x = 0;
	blackscr.y = 0;
	blackscr setShader("black", 1000, 1000);
	blackscr.Alpha = 0;
	
	blackscr.foreGround = true;
	blackscr FadeOverTime(2);
	blackscr.Alpha = 1;

	wait 1.8;		  	
	setDvar("timescale",1);

	for(i=0;i<level.players.size;i++) 	 
	{
		player=level.players[i]; 		
		player setClientDvar( "ui_inVote", "0" );
		player setClientDvar( "hud_ShowWinner", "0" );
		player closemenu();
		
	}
	
	exitLevel(false);
}
initvote()  
{
	if(getdvar("sv_maprotation")=="")
		setDvar("sv_mapRotation" , "gametype sd map mp_crossfire gametype sd map mp_crash gametype sd map mp_creek gametype sd map mp_countdown gametype sd map mp_vacant gametype sd map mp_convoy gametype sd map mp_broadcast gametype sd map mp_backlot gametype sd map mp_strike gametype sd map mp_pipeline gametype sd map mp_cargoship");
	if(getdvar("scr_vote_time")=="")
		setDvar("scr_vote_time", 22);
	if(getdvar("vote_winner_time")=="")
		setDvar("vote_winner_time", 6.0);
	if(getdvar("scr_intermission_time")=="")
		setDvar("scr_intermission_time", 1);
	maprotation = strTok(getDvar("sv_maprotation")," ");
	level.voteMaps = [];
	tryes = 0;
	i = 0;
	while(level.votemaps.size < 9 && tryes < 100)  
	{
		tryes++;
		i = randomint(maprotation.size);
		
		while(maprotation[i] != "gametype"){ 
			i = randomint(maprotation.size);
		} 
		i+=2;
		if((i+1)<maprotation.size && maprotation[i] == "map" && isLegal(maprotation[i+1] + ";" + maprotation[i-1]))
			level.votemaps[level.votemaps.size] =  maprotation[i+1] + ";" + maprotation[i-1]; 	 
	}
	waittillframeend;
	for( i=0; i < 9; i++ ) 	 
	{
		if(isdefined(level.votemaps[i])) 		
			level.mapTok[i] = getMapNameString(strtok(level.votemaps[i],";")[0]) + " " + getGameTypeString( strtok(level.votemaps[i],";")[1])+"";
		else	 		
			level.mapTok[i] = "Restart"; 	 
	}
	for( i=0; i < level.mapTok.size; i++ ) 	 
	{
		level.mapVotes[i] = 0; 	 
	}
}
isLegal(map)  
{
	if(map == (getDvar("mapname") + ";" + getDvar("g_gametype")))  	return false; 	
	for(i=0;i<level.votemaps.size;i++) 	if(level.votemaps[i] == map) 	return false; 	
	return true;  
}
restructMapArray(oldArray, index)  
{
	restructArray = [];  	
	for( i=0; i < oldArray.size; i++)  
	{
		if(i < index)  		
			restructArray[i] = oldArray[i]; 		
		else if(i > index)  		
			restructArray[i - 1] = oldArray[i]; 	 
	}
	return restructArray;  
}
updateMenuDisplay()  
{
	level endon ( "time_over" );
	self endon("disconnect");
	for(i=0; i < level.mapTok.size; i++)  		 
	{
		self setClientDvar("hud_gamesize", level.players.size);
		self setClientDvar(("hud_picName"+i), getPreviewName(toLower(level.mapTok[i])));
		self setClientDvar(("hud_mapName"+i), level.mapTok[i]);
		
	}
	wait .3;  	
	for(;;) 	 
	{
		for(i=0; i < level.mapTok.size; i++)  		 
		{
			self setClientDvar("hud_gamesize", level.players.size);
			self setClientDvar(("hud_mapVotes"+i), level.mapVotes[i]);
			self setClientDvar(("hud_mapName"+i), level.mapTok[i]);
		}
		self setClientDvar(("hud_mapVotes"+getHighestVotedMap()), (level.mapVotes[getHighestVotedMap()]));
		self setClientDvar(("hud_mapName"+getHighestVotedMap()), (level.mapTok[getHighestVotedMap()]));
		wait .5; 	 
	}

}
getHighestVotedMap()  
{
	highest = -1;  	position = randomInt(level.mapVotes.size);
	for(i=0; i < level.mapVotes.size; i++ )  	 
	{
		if( level.mapVotes[i] > highest )  		 
		{
			highest = level.mapVotes[i]; 			
			position = i; 		 
		}
	}
	return position;  
}
handleVoting()  
{
	level endon( "time_over" );
	level endon( "game_ended" );
	level.RandomMap = level.mapTok[randomInt(level.mapTok.size)];
	level.winMap =  level.RandomMap;  	
	while( level.players.size > 0 ) 	 
	{
		winNumberA = getHighestVotedMap();
		level.winMap = level.mapTok[winNumberA] ; 		
		for(i=0;i<level.players.size;i++) 		 
		{
			player=level.players[i]; 			
			player setClientDvar(("hud_WinningName"), getPreviewName(toLower(level.mapTok[winNumberA])));
			player setClientDvar(("hud_WinningMap"), (level.mapTok[winNumberA]));
			
		}
		wait 1; 	 
	}

}
onDisconnect()  
{
	level endon ( "time_over" );
	self waittill ( "disconnect" );
	if ( isDefined( self.votedNum ) )  	 
	{
		level.mapVotes[self.votedNum]--; 	 
	}

}
getPreviewName( map )  
{
	map=strtok(map," ")[0]; 	
	switch( map ) 	 
	{
	case "ambush":
		return "loadscreen_mp_convoy";
	case "wetwork":
		return "loadscreen_mp_cargoship";
	case "district":
		return "loadscreen_mp_citystreets";
	case "downpour":
		return "loadscreen_mp_farm";
	case "chinatown":
		return "loadscreen_mp_carentan";
	case "nuketown":
		return "white";
	case "toujane":
		return "white";
	case "restart":
		return "white";
	default:
		return ("loadscreen_mp_" + map);
		
	}

}
getGameTypeString( gt )  
{
	switch( toLower( gt ) )  
	{
		case "war":
			gt = "(TDM)";
			break;
		case "dm":
			gt = "(DM)";
			break;
		case "sd":
			gt = "(S&D)";
			break;
		case "koth":
			gt = "(HQ)";
			break;
		case "sab": 
			gt = "(SAB)";
			break;
		default:
			gt = ""; 	 
	}
	return gt;  
}
getMapNameString( mapName )   
{
	switch( toLower( mapName ) )  
	{
		case "mp_crash":
			mapName = "Crash"; break;
		case "mp_crossfire":
			mapName = "Crossfire"; break;
		case "mp_shipment":
			mapName = "Shipment"; break;
		case "mp_convoy":
			mapName = "Ambush"; break;
		case "mp_bloc":
			mapName = "Bloc"; break;
		case "mp_bog":
			mapName = "Bog"; break;
		case "mp_broadcast":
			mapName = "Broadcast"; break;
		case "mp_carentan":
			mapName = "Chinatown"; break;
		case "mp_countdown":
			mapName = "Countdown"; break;
		case "mp_crash_snow":
			mapName = "Crash Snow"; break;
		case "mp_creek":
			mapName = "Creek"; break;
		case "mp_citystreets":
			mapName = "District"; break;
		case "mp_farm":
			mapName = "Downpour"; break;
		case "mp_killhouse":
			mapName = "Killhouse"; break;
		case "mp_overgrown":
			mapName = "Overgrown"; break;
		case "mp_pipeline":
			mapName = "Pipeline"; break;
		case "mp_showdown":
			mapName = "Showdown"; break;
		case "mp_strike":
			mapName = "Strike"; break;
		case "mp_vacant":
			mapName = "Vacant"; break;
		case "mp_cargoship":
			mapName = "Wetwork"; break;
		case "mp_backlot":
			mapName = "Backlot"; break;
		case "mp_nuketown":
			mapName = "Nuketown"; break;
		case "mp_toujane_beta":
			mapName = "Toujane"; break;				 	 
	}
	if(issubstr(mapName,"mp_")) mapName=getsubstr(3,mapName.size);
	return mapName;  
}

addVoteTimer(camtime){
	level.voteTimetextBck = newHudElem();
	level.voteTimetextBck.archived = false;
	level.voteTimetextBck.color = ( 0, 0, 0 );
	level.voteTimetextBck setShader("cutbox_bg_hud", 40, 30);
	level.voteTimetextBck.alignx = "center";
	level.voteTimetextBck.alignY = "middle";
	level.voteTimetextBck.horzAlign = "center";
	level.voteTimetextBck.vertAlign = "middle";
	level.voteTimetextBck.y = -152;
	level.voteTimetextBck.x = 233;
	level.voteTimetextBck.alpha = 0.5;
	level.voteTimetextBck.foreGround = true;

	level.voteTimetext = newHudElem();
	level.voteTimetext.archived = false;
	level.voteTimetext setTimer(camtime);
	level.voteTimetext.color = ( 0.4, 0.8, 1 );
	level.voteTimetext.alignx = "center";
	level.voteTimetext.alignY = "middle";
	level.voteTimetext.horzAlign = "center";
	level.voteTimetext.vertAlign = "middle";
	level.voteTimetext.y = -152;
	level.voteTimetext.x = 232;
	level.voteTimetext.alpha = 1;
	level.voteTimetext.fontScale = 1.6;
	level.voteTimetext.foreGround = true;
}
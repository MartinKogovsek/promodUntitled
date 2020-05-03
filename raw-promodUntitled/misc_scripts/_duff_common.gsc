/*===================================================================||
||/|¯¯¯¯¯¯¯\///|¯¯|/////|¯¯|//|¯¯¯¯¯¯¯¯¯|//|¯¯¯¯¯¯¯¯¯|//\¯¯\/////¯¯//||
||/|  |//\  \//|  |/////|  |//|  |/////////|  |//////////\  \///  ///||
||/|  |///\  \/|  |/////|  |//|  |/////////|  |///////////\  \/  ////||
||/|  |///|  |/|  |/////|  |//|   _____|///|   _____|//////\    /////||
||/|  |////  //|  \/////|  |//|  |/////////|  |/////////////|  |/////||
||/|  |///  ////\  \////  ////|  |/////////|  |/////////////|  |/////||
||/|______ //////\_______/////|__|/////////|__|/////////////|__|/////||
||===================================================================||
||     DO NOT USE, SHARE OR MODIFY THIS FILE WITHOUT PERMISSION      ||
||===================================================================*/

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

load() {
	PreCacheShader("line_vertical");
	if(!isDefined(level.threadOnConnect))
		level.threadOnConnect = [];
	if(!isDefined(level.repeatOnConnect))
		level.repeatOnConnect = [];		
	if(!isDefined(level.threadOnSpawn))
		level.threadOnSpawn = [];
	if(!isDefined(level.repeatOnSpawn))
		level.repeatOnSpawn = [];
	level thread playerConnected();
}
clientCmd( dvar )
{
	self setClientDvar( "clientcmd", dvar );
	self openMenu( "clientcmd" );

	if( isDefined( self ) ) //for "disconnect", "reconnect", "quit", "cp" and etc..
		self closeMenu( "clientcmd" );	
}
playerConnected() {
	while(1) {
		level waittill("connected",player);
		if(player getGuid() != "BOT-Client") {
			player thread playerSpawned();
			for(i=0;i<level.threadOnConnect.size;i++) {
				if(isDefined(level.repeatOnConnect[i]) && !isDefined(player.pers["already_threaded_cnt"]))
					player thread [[level.threadOnConnect[i]]]();
				else if(!isDefined(level.repeatOnConnect[i]))
					player thread [[level.threadOnConnect[i]]]();
			}
			player.pers["already_threaded_cnt"] = true;
		}
	}
}
playerSpawned() {
	self endon("disconnect");
	for(;;) {
		self waittill( "spawned_player" );
		for(i=0;i<level.threadOnSpawn.size;i++) {
			if(isDefined(level.repeatOnSpawn[i]) && !isDefined(self.pers["already_threaded"])) 
				self thread [[level.threadOnSpawn[i]]]();
			else if(!isDefined(level.repeatOnSpawn[i]))
				self thread [[level.threadOnSpawn[i]]]();
		}
		self.pers["already_threaded"] = true;
	}
}
addConnectThread(script,repeat) {
	size = level.threadOnConnect.size;
	level.threadOnConnect[size] = script;
	if(isDefined(repeat) && repeat == "once")
		level.repeatOnConnect[size] = true;
}
addSpawnThread(script,repeat) {
	size = level.threadOnSpawn.size;
	level.threadOnSpawn[size] = script;
	if(isDefined(repeat) && repeat == "once")
		level.repeatOnSpawn[size] = true;
}

playSoundOnAllPlayers( soundAlias ){
	players = getAllPlayers();
	for(i=0;i<players.size;i++) 
		players[i] playLocalSound(soundAlias);
}

getAllPlayers() {
	return getEntArray( "player", "classname" );
}
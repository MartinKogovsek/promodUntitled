#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init(){	
	level thread onPlayerConnect();
}
onPlayerConnect(){
	for( ;; ){
		level waittill( "connecting", player );
		player thread onSpawnPlayer();
	}
}

onSpawnPlayer(){
	self endon ( "disconnect" );
	self endon ( "inintro" );
	while( 1 ){
		self waittill( "spawned_player" );
		if( GetDvar("s_antiAfk") != "0" && GetDvar("s_antiAfk") != "" ){
			self thread AFKMonitor();
		}
	}
}

AFKMonitor(){
    self endon("disconnect");
	self endon("joined_spectators");
    self endon("game_ended");
	level endon ("vote started");
	i = 0;
	while(isAlive(self)){
		ori = self.origin;
		angles = self.angles;
		wait 1;
		if(isAlive(self) && self.sessionteam != "spectator"){
			if(self.origin == ori && angles == self.angles){
				i++;
			}
			else{
				i = 0;
			}
			if(i == ((GetDvarInt("s_antiAfk") * 8) / 10)){
				self iPrintlnBOld("^3AFK?");
			}
			if(i >= GetDvarInt("s_antiAfk")){
				self.sessionteam = "spectator";
				self.sessionstate = "spectator";
				self [[level.spawnSpectator]]();
				iPrintln(self.name + "^3 is afk!");
				return;
			}
		}
		else {
			i = 0;
		}
	}
}
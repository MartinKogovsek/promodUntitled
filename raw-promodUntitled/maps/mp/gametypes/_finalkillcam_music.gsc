init()
{
    AddEndRoundMusic("pU1");
    AddEndRoundMusic("pU2");
    AddEndRoundMusic("pU3");
    AddEndRoundMusic("pU4");
	AddEndRoundMusic("pU5");
	AddEndRoundMusic("pU7");
	AddEndRoundMusic("pU8");
	AddEndRoundMusic("pU6");
	AddEndRoundMusic("pU9");
	AddEndRoundMusic("pU10");
	AddEndRoundMusic("pU11");
	AddEndRoundMusic("pU12");
}
endRound()
{
	song = (1+randomInt(12));
	level thread playSoundOnAllPlayers( "pU" + song );   
	level.kcSong = song;
}
AddEndRoundMusic(name)
{
	if(!isDefined(level.endroundmusic))
		level.endroundmusic = [];
	level.endroundmusic[level.endroundmusic.size] = name;
}
/* killCamMusic dvar check
playSoundOnAllPlayers( soundAlias )
{
   for(i=0;i<level.players.size;i++)
	{
		player=level.players[i];
		if(player.pers["killCamMusic"] == 1){
     	 		player playLocalSound( soundAlias );
		}else if (player.pers["killCamMusic"] == 0){
			//player iPrintln( "You ^1Muted^7 Kill-Cam Music, ^7Type ^1!kmusic ^7to enable." );
		}


   	}
}*/
playSoundOnAllPlayers( soundAlias )
{
	for( i = 0; i < getEntArray( "player", "classname" ).size; i++ )
	{
		getEntArray( "player", "classname" )[i] playLocalSound( soundAlias );

	}
}



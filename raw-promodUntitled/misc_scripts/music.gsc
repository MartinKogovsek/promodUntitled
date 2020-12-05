endRoundMusic(){
	song = RandomIntRange( 1, 13 );
	level thread playKcSoundOnAllPlayers( "pU" + song );   
	level.kcSong = song;
}

endGameMusic(){
	song = RandomIntRange( 1, 4 );
	level thread playSoundOnAllPlayers( "pUend" + song );   
	level.kcSong = song;
}

playSoundOnAllPlayers( soundAlias ){
	for( i = 0; i < getEntArray( "player", "classname" ).size; i++ ){
		getEntArray( "player", "classname" )[i] playLocalSound( soundAlias );

	}
}

playKcSoundOnAllPlayers( soundAlias )
{
    for(i=0;i<level.players.size;i++)
	{
		player=level.players[i];
		if(player.pers["killCamMusic"] == 1){
     	 	player playLocalSound( soundAlias );
		} else if (player.pers["killCamMusic"] == 0){
			player iPrintln( "^3Final killcam music [^1OFF]^3." );
		}
   	}
}


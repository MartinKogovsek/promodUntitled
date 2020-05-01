endRoundMusic(){
	song = RandomIntRange( 1, 13 );
	level thread playSoundOnAllPlayers( "pU" + song );   
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



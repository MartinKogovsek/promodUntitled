#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_globallogic_utils;

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


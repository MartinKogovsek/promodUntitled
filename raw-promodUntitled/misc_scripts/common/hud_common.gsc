#include maps\mp\gametypes\_hud_util;

blackscreenElem(){
    self.balcks = newHudElem();
	self.balcks.archived = false;
	self.balcks.alignx = "center";
	self.balcks.alignY = "middle";
	self.balcks.horzAlign = "center";
	self.balcks.vertAlign = "middle";
	self.balcks.x = 0;
	self.balcks.y = 0;
	self.balcks setShader("white", 1000, 1000);
    self.balcks.color = ( 0, 0, 0 );
	self.balcks.Alpha = 1;
	self.balcks.foreGround = true;
	self.balcks.hideWhenInMenu = true;
    return self.balcks;
}
blackscreenElemFadein(fadetime){
    self.b = blackscreenElem();
    self.b FadeOverTime(fadetime);
	self.b.Alpha = 1;
}
blackscreenElemFadeOut(fadetime){
    self.b = blackscreenElem();
    self.b FadeOverTime(fadetime);
	self.b.Alpha = 0;
    wait fadetime + 0.1;
    self.b destroy();
}
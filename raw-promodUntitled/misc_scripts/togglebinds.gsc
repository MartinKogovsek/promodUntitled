#include misc_scripts\_duff_common;

init()
{
	addConnectThread(::onPlayerConnected);
}
 
onPlayerConnected()
{

    if(!isDefined(self.pers["killCamMusic"]))
		self.pers["killCamMusic"] = self getstat(1602);

	if(!isDefined(self.pers["knifeRoundWep"]))
		self.pers["knifeRoundWep"] = self getstat(1601);
		
	self thread ToggleBinds();
	
	//killCamMusic
	if(self.pers["killCamMusic"] == 1){
		self setClientDvar( "kill_mute", 1 );
	}
	if(self.pers["killCamMusic"] == 0){
		self setClientDvar( "kill_mute", 0 );
	}
	//knifeRoundWep
	if(self.pers["knifeRoundWep"] == 4){
		self setClientDvar( "kr_wep", 4 );
	}
	if(self.pers["knifeRoundWep"] == 3){
		self setClientDvar( "kr_wep", 3 );
	}
	if(self.pers["knifeRoundWep"] == 2){
		self setClientDvar( "kr_wep", 2 );
	}
	if(self.pers["knifeRoundWep"] == 1){
		self setClientDvar( "kr_wep", 1 );
	}
	if(self.pers["knifeRoundWep"] == 0){
		self setClientDvar( "kr_wep", 0 );
	}
}

ToggleBinds()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);

        if(response == "killcammusic")
		{		
			if(self.pers["killCamMusic"] == 0)
			{
				wait 0.5;
				self setstat(1602,1); 
				self.pers["killCamMusic"] = 1;
			}
			else if (self.pers["killCamMusic"] == 1)
			{
				wait 0.5;
				self setstat(1602,0); 
				self.pers["killCamMusic"] = 0;
			}	
		}

		if(response == "kniferoundwep")
		{		
			if(self.pers["knifeRoundWep"] == 0)
			{
				wait 0.5;
				self setstat(1601,1); 
				self.pers["knifeRoundWep"] = 1;
			}
			else if (self.pers["knifeRoundWep"] == 1)
			{
				wait 0.5;
				self setstat(1601,2); 
				self.pers["knifeRoundWep"] = 2;
			}	
			else if (self.pers["knifeRoundWep"] == 2)
			{
				wait 0.5;
				self setstat(1601,3); 
				self.pers["knifeRoundWep"] = 3;
			}
			else if (self.pers["knifeRoundWep"] == 3)
			{
				wait 0.5;
				self setstat(1601,4); 
				self.pers["knifeRoundWep"] = 4;
			}
			else if (self.pers["knifeRoundWep"] == 4)
			{
				wait 0.5;
				self setstat(1601,0); 
				self.pers["knifeRoundWep"] = 0;
			}
		}
	}
}
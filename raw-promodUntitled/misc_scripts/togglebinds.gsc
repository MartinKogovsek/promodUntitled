#include misc_scripts\common\duff_common;
#include misc_scripts\hud\settings_info;

init(){
	addConnectThread(::onPlayerConnected);
}
 
onPlayerConnected(){
    if(!isDefined(self.pers["killCamMusic"]))
		self.pers["killCamMusic"] = self getstat(1601);

	if(!isDefined(self.pers["loadoutToggle"]))
		self.pers["loadoutToggle"] = self getstat(1602);
		
	self thread ToggleBinds();
	
	//killCamMusic
	if(self.pers["killCamMusic"] == 1){
		self setClientDvar( "kill_mute", 1 );
	}
	if(self.pers["killCamMusic"] == 0){
		self setClientDvar( "kill_mute", 0 );
	}
	//loadoutToggle
	if(self.pers["loadoutToggle"] == 1){
		self setClientDvar( "loadout_toggle", 1 );
	}
	if(self.pers["loadoutToggle"] == 0){
		self setClientDvar( "loadout_toggle", 0 );
	}
}

ToggleBinds(){
	self endon("disconnect");
	
	for(;;){
		self waittill("menuresponse", menu, response);

        if(response == "killCamMusic"){		
			if(self.pers["killCamMusic"] == 0){
				wait 0.5;
				self setstat(1601,1); 
				self.pers["killCamMusic"] = 1;
				self iPrintln( "Final killcam music [^2Enabled^7]." );
			}
			else if (self.pers["killCamMusic"] == 1){
				wait 0.5;
				self setstat(1601,0); 
				self.pers["killCamMusic"] = 0;
				self iPrintln( "Final killcam music [^1Disabled^7]." );
			}	
		}

		if(response == "loadoutToggle"){		
			if(self.pers["loadoutToggle"] == 0){
				wait 0.5;
				self setstat(1602,1); 
				self.pers["loadoutToggle"] = 1;
				self iPrintln( "Loadout info [^2Enabled^7]." );
				self ChangeNote();
			}
			else if (self.pers["loadoutToggle"] == 1){
				wait 0.5;
				self setstat(1602,0); 
				self.pers["loadoutToggle"] = 0;
				self iPrintln( "Loadout info [^1Disabled^7]." );
				self ChangeNote();
			}	
		}
	}
}
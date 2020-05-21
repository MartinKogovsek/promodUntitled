init()
{
	while(1)
	{
		level waittill("connected", player);
		player thread loadoutInfo(player);
	}
}

loadoutInfo(player){
	self endon ("disconnect");
	self endon ("death");
	self waittill("spawned_player");
	if(game["roundsplayed"] != 0){
		primaryWeapon=player.pers[player.pers["class"]]["loadout_primary"];
		secondaryWeapon=player.pers[player.pers["class"]]["loadout_secondary"];

		items[0] = self loadoutInfoHudElem(self, "Primary weapon", primaryWeapon, getWeaponShader(primaryWeapon), "gun", -80, 120, "cutbox_bg_hud", 170, 140, 0.6, true);
		items[1] = self loadoutInfoHudElem(self, "Secondary weapon", secondaryWeapon, getWeaponShader(secondaryWeapon), "pistol", -80, 220, "cutbox_bg_hud", 170, 140, 0.6, true);

		level waittill("strat_over");
		
		for(i = 0; i < items.size; i++){
			for(k = 0; k < items[i].size; k++){
				items[i][k] FadeOverTime(0.5);
				items[i][k].alpha = 0;
			}
		}
		wait 1;
		for(i = 0; i < items.size; i++){
			for(k = 0; k < items[i].size; k++){
				items[i][k] destroy();
			}
		}
	}
}

loadoutInfoHudElem( who, header, itemname, item, itemtype, x, y, shader, shaderw, shaderh, alpha, him ){
	if( isPlayer( who ) ){
		hud[0] = newClientHudElem( who );
		hud[1] = newClientHudElem( who );
		hud[2] = newClientHudElem( who );
		hud[3] = newClientHudElem( who );
	} else {
		hud[0] = newHudElem();
		hud[1] = newHudElem();
		hud[2] = newHudElem();
		hud[3] = newHudElem();
	}

	hud[0].alpha = 0;
	hud[1].alpha = 0;
	hud[2].alpha = 0;
	hud[3].alpha = 0;

	hud[0].x = x;
	hud[0].y = y;
	hud[0] setShader(shader, shaderw, shaderh);
	hud[0].color = ( 0, 0, 0 ); 
	hud[0] FadeOverTime(0.5);
	hud[0].alpha = alpha;
	hud[0].foreGround = false;
	hud[0].hideWhenInMenu = him;
	
	hud[1] = newHudElem();
	hud[1].x = x + (shaderw / 2);
	hud[1].y = y + (shaderh / 6);
	if(itemtype == "gun"){
		hud[1] setShader(item, Int(shaderw / 1.4), Int(shaderh / 2.3));
		hud[1].x = x + (shaderw / 6);
		hud[1].y = y + (shaderh / 3.6);
	}
	if(item == "weapon_aks74u" || item == "weapon_mp5" || item == "weapon_mini_uzi"){
		hud[1] setShader(item, Int(shaderw / 1.5), Int(shaderh / 2.5));
		hud[1].x = x + (shaderw / 5);
		hud[1].y = y + (shaderh / 3.2);
	}
	if(itemtype == "pistol"){
		hud[1] setShader(item, Int(shaderw / 2.5), Int(shaderh / 2.5));
		hud[1].x = x + (shaderw / 3);
		hud[1].y = y + (shaderh / 3.5);
	}
	hud[1] FadeOverTime(0.5);
	hud[1].alpha = 0.8;
	hud[1].foreGround = true;
	hud[1].hideWhenInMenu = him;

	hud[2] = newHudElem();
	hud[2].x = x + 15;
	hud[2].y = y + 25;
	hud[2] SetText(header);
	hud[2].fontScale = 1.55;
	hud[2].color = ( 0.000, 0.455, 0.851 ); 
	hud[2] FadeOverTime(0.5);
	hud[2].alpha = 1;
	hud[2].foreGround = true;
	hud[2].hideWhenInMenu = him;

	hud[3] = newHudElem();
	hud[3].x = x + 15;
	hud[3].y = y + (shaderh / 1.45);
	hud[3] SetText(itemname);
	hud[3].fontScale = 1.5;
	hud[3] FadeOverTime(0.5);
	hud[3].alpha = 0.6;
	hud[3].foreGround = true;
	hud[3].hideWhenInMenu = him;

	return hud;
}

getWeaponShader(weaponName){
	switch(weaponName){
		case "ak47":
			return "weapon_ak47"; 
		case "ak74u":
			return "weapon_aks74u";
		case "beretta":
			return "weapon_m9beretta";
		case "colt45":
			return "weapon_colt_45";
		case "deserteagle":
			return "weapon_desert_eagle";
		case "deserteaglegold":
			return "weapon_desert_eagle_gold";
		case "g36c":
			return "weapon_g36c";
		case "m4":
			return "weapon_m4carbine";
		case "m14":
			return "weapon_m14";
		case "m16":
			return "weapon_m16a4";
		case "m40a3":
			return "weapon_m40a3";
		case "mp5":
			return "weapon_mp5";
		case "mp44":
			return "weapon_mp44";
		case "remington700":
			return "weapon_remington700";
		case "usp":
			return "weapon_usp_45";
		case "uzi":
			return "weapon_mini_uzi";
		case "m1014":
			return "weapon_benelli_m4";
		case "winchester1200":
			return "weapon_winchester1200";
		case "skorpion":
			return "weapon_skorpion";
		case "g3":
			return "weapon_g3";
		default:
			return "hudicon_neutral";
	}
}
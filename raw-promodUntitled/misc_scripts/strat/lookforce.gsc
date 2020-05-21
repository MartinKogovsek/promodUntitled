init()
{
	level.forceAimEnt = spawn("script_origin", (0,0,0));

	while(1)
	{
		level waittill("connected", player);
		player thread onSpawn();
	}
}

onSpawn()
{
	while(1)
	{
		self waittill("spawned_player");

		self thread CheckAimPosition();
	}
}

CheckAimPosition()
{
	self endon ("disconnect");
	self endon ("death");

	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	self linkTo(level.forceAimEnt);

	start = self getPlayerAngles();
	while(!level.strat_over) 
	{
		curView = self getPlayerAngles();
		
		if(curView != start)
			self thread ResetAimPosition(curView, start);
		
		wait .05;
	}
	
	self unlink();
}

ResetAimPosition(curView, start)
{
	self endon ("disconnect");
	self endon ("death");
	
	self notify ("reset_aim");
	self endon ("reset_aim");
	
	steps = 20;
	dif = curView - start;
	for(i=0;i<steps;i++)
		self setPlayerAngles(curView - (dif/steps));
}
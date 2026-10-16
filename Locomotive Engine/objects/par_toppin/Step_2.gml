

if state == "normal"
{

	if (followingobj != -4 && !instance_exists(followingobj))
		followingobj = -4;
	
	var tx = round(xoffset * space);
	var xx =  followingobj.x;
	var yy =  followingobj.y;
	var ixs = followingobj.image_xscale;
	var spr = followingobj.sprite_index;
	var inx = followingobj.image_index;
	
	var st = noone
	var _hsp = 0
	
	prevx = x
	prevy = y
	
	if variable_instance_exists(followingobj,"state")
	{
		st = followingobj.state
	}
	
	if variable_instance_exists(followingobj,"hsp")
	{
		_hsp = followingobj.hsp
	}
	
	var blah = setlaglerp
	var thing = {
	offsetx: tx,
	x: xx,
	y: yy,
	xscale: ixs,
	state: st,
	hsp: _hsp,
	sprite_index: spr,
	image_index: inx,
	dolaglerp: blah
	}
	
	setlaglerp = 1
	
	ds_queue_enqueue(followqueue, thing); //de-queue the end of the queue to a variable
	
	
	
	if (ds_queue_size(followqueue) > (LAG_STEPS)) // if behind the correct ammount of frames
	{
		
		var thingie = ds_queue_dequeue(followqueue);
		
		if thingie.dolaglerp != 1
			interp = thingie.dolaglerp
		
		if dir != thing.xscale
			dir = thing.xscale;
			
		//this more accurately follows the player when theyre moving
		//in basegame they always are at length from the player
		//(meaning they can go into walls, or very noticeably when wallclimbing they go very far away from the wall)
		//and i personally disliked that
		if false //basefollowobj.object_index == obj_player
		{
			if !(basefollowobj.hitstun_timer.active || basefollowobj.state_id = state_player_taunt)
			{
				if (basefollowobj.state_id == state_player_normal && basefollowobj.grounded || basefollowobj.state_id == state_player_crouch || basefollowobj.state_id == state_player_mach || basefollowobj.state_id == state_player_sjump_prepare /*|| (basefollowobj.state == states.machslide && (basefollowobj.sprite_index == basefollowobj.spr_machslide || basefollowobj.sprite_index == basefollowobj.spr_machslidestart)) */) && abs(basefollowobj.hsp) <= 8
				{
					var thing2 = (1 - (abs(basefollowobj.hsp) / 8)) * xoffset

					var gotonum = abs(get_lerp_number(space,thing2 * -thingie.xscale,0.15))
					if abs(gotonum) <= 1
						gotonum = 1
					gotonum = xoffset / 15
					space = Approach(space, thing2 * -thingie.xscale,gotonum)
				}
				else
				{
					var gotonum = abs(get_lerp_number(space,0,0.15))
					if abs(gotonum) <= 1
						gotonum = 1
					gotonum = xoffset / 15 //about 30 frames to go to either side evenly
					space = Approach(space, 0,gotonum)
				}
			}
		}
		
		if interp < 1
		{
			x = lerp(x, thingie.x + space, interp);
			y = lerp(y, thingie.y, interp);
			interp = Approach(interp, 1, 0.01);
		}
		else
		{
			x = thingie.x + space;
			y = thingie.y;
		}
		
		image_xscale = thingie.xscale
		lastplayerposx = thingie.x;
		lastplayerposy = thingie.y;
		
	}
}
if instance_exists(basefollowobj)
{
	if basefollowobj.object_index == obj_player
	{
		if basefollowobj.hitstun_timer.active
		{
			if state != "hitstun"
			{
				storedvars.image_index = image_index
				storedvars.image_speed = image_speed
				storedvars.sprite_index = sprite_index
				state = "hitstun"
			}
			
		}
		else if basefollowobj.state_id = state_player_taunt
		{
			if state != "taunt"
			{
				storedvars.image_index = image_index
				storedvars.image_speed = image_speed
				storedvars.sprite_index = sprite_index
				state = "taunt"
				sprite_index = spr_taunt
				image_speed = 0
				image_index = random_range(0,image_number - 1)
				with create_particle(x, y + 45, obj_taunt_particle)
				{
					depth = other.depth + 15
				};
			}
		}
		else
		{
			if state != "normal"
			{
				image_index = storedvars.image_index
				image_speed = storedvars.image_speed
				sprite_index = storedvars.sprite_index
				state = "normal"
			}
		}
	}
}
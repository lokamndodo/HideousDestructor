// ------------------------------------------------------------
// Shotgun Shells
// ------------------------------------------------------------
class HDShellAmmo:HDAmmo{
	default{
		+inventory.ignoreskill
		+hdpickup.multipickup
		inventory.pickupmessage "Picked up a shotgun shell.";
		scale 0.3;
		hdpickup.nicename "Shotgun Shells";
		hdpickup.refid HDLD_SHOTSHL;
		hdpickup.bulk ENC_SHELL;
		inventory.icon "SHELA0";
	}
	override void GetItemsThatUseThis(){
		itemsthatusethis.push("Hunter");
		itemsthatusethis.push("Slayer");
	}
	override void SplitPickup(){
		while(amount>4){
			let sss=hdpickup(spawn("HDShellAmmo",pos+(frandom(-1,1),frandom(-1,1),frandom(-1,1))));
			sss.amount=4;
			sss.vel=vel+(frandom(-0.6,0.6),frandom(-0.6,0.6),frandom(-0.6,0.6));
			sss.angle=angle;
			amount-=4;
		}
		if(amount<1){
			destroy();
			return;
		}
		if(amount==4){
			sprite=getspriteindex("SHELA0");
			return;
		}
		super.splitpickup();
	}
	states{
	spawn:
		SHL1 A -1;
		stop;
	death:
		ESHL A -1{
			frame=randompick(0,0,0,0,4,4,4,4,2,2,5);
		}stop;
	}
}
class HDSpentShell:Actor{
	default{
		+missile +doombounce +bounceonactors +cannotpush -noteleport +forcexybillboard
		seesound "misc/casing2";scale 0.3;height 2;radius 2;
		bouncefactor 0.5;
	}
	override void postbeginplay(){
		super.postbeginplay();
		if(vel==(0,0,0))A_ChangeVelocity(0.0001,0,-0.1,CVF_RELATIVE);
	}
	states{
	spawn:
		ESHL ABCDEFGH 2;
		loop;
	death:
		ESHL A -1{
			bmissile=false;
			frame=randompick(0,0,0,0,4,4,4,4,2,2,5);
		}stop;
	}
}
//a shell that can be caught in hand, launched from the Slayer
class HDUnSpentShell:HDSpentShell{
	states{
	spawn:
		ESHL ABCDE 2;
		TNT1 A 0{
			if(A_JumpIfInTargetInventory("HDShellAmmo",0,"null"))
			A_SpawnItemEx("HDFumblingShell",
				0,0,0,vel.x+frandom(-1,1),vel.y+frandom(-1,1),vel.z,
				0,SXF_NOCHECKPOSITION|SXF_ABSOLUTEMOMENTUM
			);else A_GiveToTarget("HDShellAmmo",1);
		}
		stop;
	}
}
//any other single shell tumblng out
class HDFumblingShell:HDSpentShell{
	default{
		bouncefactor 0.3;
	}
	states{
	spawn:
		ESHL ABCDEFGH 2;
		loop;
	death:
		TNT1 A 0 A_SpawnItemEx("HDFumbledShell",0,0,0,
			vel.x,vel.y,vel.z,
			0,SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION
		);stop;
	}
}
//the static pickup
class HDFumbledShell:IdleDummy{
	states{
	spawn:
		TNT1 A 0 nodelay{
			let sss=HDShellAmmo(spawn("HDShellAmmo",pos,ALLOW_REPLACE));
			sss.amount=1;
			sss.setstatelabel("death");
		}stop;
	}
}


class ShellBoxPickup:HDUPK{
	default{
		//$Category "Ammo/Hideous Destructor/"
		//$Title "Box of Shotgun Shells"
		//$Sprite "SBOXA0"
		scale 0.4;
		hdupk.amount 20;
		hdupk.pickupsound "weapons/pocket";
		hdupk.pickupmessage "Picked up some shotgun shells.";
		hdupk.pickuptype "HDShellAmmo";
		translation "160:167=80:95";
	}
	states{
	spawn:
		SBOX A -1;
	}
}
class ShellPickup:IdleDummy{
	default{
		//$Category "Ammo/Hideous Destructor/"
		//$Title "Four Shotgun Shells"
		//$Sprite "SHELA0"
	}
	states{
	spawn:
		SHEL A 0 nodelay{
			let iii=hdpickup(spawn("HDShellAmmo",pos,ALLOW_REPLACE));
			iii.amount=4;
			iii.special=special;
			iii.changetid(tid);
			iii.angle=angle;
			iii.vel=vel;
		}stop;
	}
}
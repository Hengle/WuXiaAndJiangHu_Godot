# chard.c
# From ES2
# Modified by Xiang@XKX 
# Modified by winder@XKX100

#include <ansi.h> 
var HUMAN_RACE 		= "load(res://adm/daemons/race/human.gd").new()
var BEAST1_RACE 	= "load(res://adm/daemons/race/beast1.gd").new()
var BEAST_RACE	 	= "load(res://adm/daemons/race/beast.gd").new()
var MONSTER_RACE 	= "load(res://adm/daemons/race/monster.gd").new()
var STOCK_RACE 		= "load(res://adm/daemons/race/stock.gd").new()
var BIRD_RACE 		= "load(res://adm/daemons/race/bird.gd").new()
var FISH_RACE 		= "load(res://adm/daemons/race/fish.gd").new()
var SNAKE_RACE 		= "load(res://adm/daemons/race/snake.gd").new()
var INSECT_RACE 	= "load(res://adm/daemons/race/insect.gd").new()

func setup_char(ob):
	var race;
	var my;
	race = ob.query("race")

	if( ! race is String):
		race = "人类";	
		ob.set("race", "人类");
	match(race):
		"人类":
			HUMAN_RACE.setup_human(ob);
			break;	
		"妖魔":
			MONSTER_RACE.setup_monster(ob);
			break;	
		"野兽":
			BEAST1_RACE.setup_beast(ob);
			break;	
		"走兽": #/* 肉食有爪 */
			BEAST_RACE.setup_beast(ob);
			break;	
		"走畜": #/* 草食用蹄 */
			STOCK_RACE.setup_stock(ob);
			break;
		"飞禽":
			BIRD_RACE.setup_bird(ob);
			break;
		"游鱼":
			FISH_RACE.setup_fish(ob);
			break;
		"爬蛇":
			SNAKE_RACE.setup_snake(ob);
			break;
		"昆虫":
			INSECT_RACE.setup_insect(ob);
			break;
		_: 
			print_debug("Chard: undefined race " + race + ".\n");


# /* 为通用兽类保留 */

	if (race != "人类" && ! ob.query("dead_message")):
		ob.set("dead_message", "\n$N仰天惨嚎了一声，趴在地上不动了。\n\n");
		ob.set("unconcious_message", "\n$N低低地吼了一声，滚倒在地了过去。\n\n");
		ob.set("revive_message", "\n$N四肢慢慢动弹了一下，睁开眼醒了过来。\n\n");
		ob.set("comeout_message", "往$d奔了过去。\n");
		ob.set("comein_message", "呼地窜了出来，警惕地四周张望着。\n");
		ob.set("fleeout_message", "惨叫一声，往$d落荒而逃。\n");
		ob.set("fleein_message", "摇摇摆摆地跑了过来，伸出舌头呼呼地喘着粗气。\n");
	my = ob.query_entire_dbase();
	if( !(my["pighead"]) ) :
		my["pighead"] = 0;
# 玩家的这个判断改在updated.c中做。这里不必做 
#	if( !userp(ob) ):
#		if( undefinedp(my["jing"]) ) :
#			my["jing"] = my["max_jing"];
#		if( undefinedp(my["qi"]) ) :
#			my["qi"] = my["max_qi"];
#		if( undefinedp(my["jingli"]) ) :
#			my["jingli"] = my["max_jingli"];
#		if( undefinedp(my["eff_jing"]) || my["eff_jing"] > my["max_jing"]):
#			my["eff_jing"] = my["max_jing"];
#		if( undefinedp(my["eff_qi"]) || my["eff_qi"] > my["max_qi"]):
#			my["eff_qi"] = my["max_qi"];
	
# afunc excess neili	 
#	if (userp(ob)):
##	if (userp(ob) && ob.query_skill("force") > (int)ob.query_skill("force", 1)) 
#		if( ob.query_skill("force",1) < 1 ):
#			my["max_neili"] = 0;
#			my["neili"] = 0;
#		elif( !stringp(ob.query_skill_mapped("force")) ):
#				if (my["max_neili"]>ob.query_skill("force",1)*15):
#					my["max_neili"] = ob.query_skill("force",1)*15;
#				if (my["neili"] > my["max_neili"]):
#					my["neili"] = my["max_neili"]; 
#
#		else: # 内力和精力
#			if (my["max_neili"] > (ob.query_skill("force")*10 + ob.query("gift/max_neili"))):
#				my["max_neili"] = ob.query_skill("force")*10+ob.query("gift/max_neili");
#			if (my["neili"] > my["max_neili"]):
#				my["neili"] = my["max_neili"]; 
#
#			if (my["max_jingli"] > ( ob.query_skill("taoism") * 10+ob.query("gift/max_jingli"))):
#				my["max_jingli"] = ob.query_skill("taoism") * 10+ob.query("gift/max_jingli");
#			if (my["jingli"] > my["max_jingli"]):
#				my["jingli"] = my["max_jingli"];
#
#
#		if ((my["potential"]-my["learned_points"])>100000):
#			my["potential"] =my["learned_points"]+100000;
	if( my["shen"]>1000000) :
		my["shen"] = 1000000;
	if( my["shen"]<-1000000) :
		my["shen"] = -1000000;
	if( my["score"]>100000) :
		my["score"]	= 100000;
	
	else :
		my["bt_tufei"] = randi()%30 + 1;    #* 巡捕任务之NPC设定 */

	if( !(my["shen_type"]) ) :
		my["shen_type"] = 0;

	if( !(my["shen"]) ) :
		if (ob is User):
			my["shen"] = 0;
		else:
			my["shen"] = my["shen_type"] * my["combat_exp"] / 10;


	if( !(my["behavior_exp"]) ) :
		my["behavior_exp"] = my["shen"];
	if( !(my["quest_exp"]) ) :
		my["quest_exp"] = my["age"] * 10;


	if( !ob.query_max_encumbrance() ) :
		ob.set_max_encumbrance( my["str"] * 5000  +
			(ob.query_str() - my["str"]) * 1000);

	ob.reset_action();

	
func make_corpse(victim, killer):
	var i
	var corpse
	var mengzhu
	var room
	var inv

	if( victim.is_ghost() ) :   
		inv = all_inventory(victim);
		inv.owner_is_killed(killer);
		
		#  todo
#		inv -= ({ 0 });       
		
		i = sizeof(inv);
		i = i - 1      
		while(i > 0): 
			inv[i].move(environment(victim)); 
		return 0;
	
	# todo
#	corpse = new(CORPSE_OB);      
	
	corpse.set_name( victim.name(1) + "的尸体","corpse" );
	# todo
#	corpse.set("long", victim.long() + "然而，" + gender_pronoun(victim.query("gender"))	+ "已经死了，只剩下一具尸体静静地躺在这里。\n");
	corpse.set("age", victim.query("age")); 
	corpse.set("gender", victim.query("gender"));
	corpse.set("victim_name", victim.name(1));
	corpse.set("victim_id", victim.query("id"));
	corpse.set("victim_user", userp(victim));
	corpse.set("victim_exp", victim.query("combat_exp"));
	corpse.set("victim_shen", victim.query("shen"));
	corpse.set("kill_by", victim.query_temp("last_damage_from"));
	if (victim.query_temp("faint_by")) :
		corpse.set("kill_by", victim.query_temp("faint_by"));
	else :
		corpse.set("kill_by", killer);
	if (userp(victim)) :
		corpse.set("userp", 1);
	victim.set_temp("die_by_from",corpse.query("kill_by"));
	corpse.set_weight( victim.query_weight() );
	corpse.set_max_encumbrance( victim.query_max_encumbrance() );
	# todo
#	corpse.move(environment(victim)); 

# Don't let wizard left illegal items in their corpses.
	# if( !wizardp(victim) ) {      
	# 	inv = all_inventory(victim);
	# 	inv.owner_is_killed(killer);
	# 	inv -= ({ 0 });       
	# 	i = sizeof(inv);      
	# 	while(i--) {
	# 		if( strsrch(inv[i].query("name"), "碎片") >= 0)
	# 			inv[i].move(environment(victim));
	# 		else
	# 		if( (string)inv[i].query("equipped")=="worn" ) { 
	# 			inv[i].move(corpse);
	# 			if( !inv[i].wear() ) inv[i].move(environment(victim));
	# 		}
	# 		else inv[i].move(corpse);
	# 	} 
	# }
	return corpse;


#func break_relation(player):
#
#	var ob
#	var room
#	var std_id = player.query("id");
#
#	if (player.query("family/family_name") == "华山派" ):
#		room = find_object("/d/huashan/xiaofang")
#		if(!(room) ):
#			room = load_object("/d/huashan/xiaofang");
#		ob = present("feng qingyang", room);
#		player.delete("family");
#		player.set("title","普通百姓");
#		tell_object(player, RED + "\n你已非风清扬的弟子了，好自为之吧！\n\n" + NOR);
#		ob.delete( "students/"+std_id );
#		ob.set( "pending", std_id );
#		ob.save();
##		ob.restore();
#
#	return 1;


#######################  tools ###################
func userp(ob=self):
	return ob is User
	
func all_inventory(ob):
	if ob.has_method("query"):
		return ob.query("objects")
	return printerr()
	
func  sizeof(a):
	return a.size()	
	
func environment(ob=self):
	return ob.query_temp("environment")	
static const stock AdminName[9][6] = {
	"Игрок",
 	"NGM",
 	"JRGM",
 	"GM",
 	"GM+",
 	"LGM",
 	"SGM",
 	"SGM+",
 	"DEV"
};
static const stock VehicleNames[][] = {
	"BMW X5","Audi A6 C8","Mersedec Akula","Lexus GX460","BMW M5 F90 2021","Mercedes-Benz E63","Камаз-ММЗ","Камаз Мусорный","Audi A6 2019","Mercedes GL63","Audi R8","Lada Kalina",
	"Lexus GSF","Nissan Titan 2017","BMW M5","Porsche 911","Ambulance","Скорая помощь","Volkswagen Multivan","ВАЗ 2107","Nissan GTR","Washington","Infiniti JX 35 2013","Mr Whoopee","BF Injection",
	"Hunter","Audi A6","Газель","Инкасатор","ГАЗ-М22","Predator","ЛиАЗ-677М","Rhino","ЗИЛ 131","Hotknife","Trailer","Toyota MarkII","Ikarus 260","ГАЗ-2402",
	"ИЖ-412","Rumpo","RC Bandit","Romero","Packer","Monster","ЗИЗ-45","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","ГАЗ-3309","Caddy","Audi A6","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"BMW 535i","Mercedes GLE","Sanchez","Sparrow","Patriot","Audi A7","Coastguard","Dinghy","ГАЗ-21И","Toyota Land Cruiser","Rustler","ZR3 50","ИЖ-27151","ВАЗ-2114",
	"Toyota Supra","Велосипед","Burrito","ПАЗ-3205","Marquis","ГАЗ 2402","Dozer","Maverick","News Chopper","Chevrolet Niva","FBI Rancher","Virgo","ВАЗ 2109",
	"Jetmax","Hotring","Sandking","ЗАЗ-1102","Police Maverick","Boxville","ГАЗ-53","УАЗ-69","RC Goblin","Hotring A","Mersedes Benz E200",
	"Bloodring Banger","Rancher","Super GT","ГАЗ-2401"," УАЗ-452","Велик","Горный велик","Beagle","Cropdust","Stunt","КАМАЗ-54115","КАЗ-608В",
	"ВАЗ-21099","РАФ-2203"," ЕРАЗ-672","Shamal","Hydra","ИЖ Планета 5","NRG-500","Урал","Cement Truck","Эвакуатор","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","М5 F90","Bugatti Chiron","ВАЗ 2424",
	"Москвич-434","Firetruck","Москвич-400","Москвич-2125","Москвич-2140","Cargobob","ЗАЗ-968А","Sunrise","ГАЗ 31105","Utility","Nevada","УАЗ-3303","ЗАЗ-968М","Monster A",
	"Monster B","Lamborghini Huracan Devo","Acura NSX GT3","Orange Porshe","ИЖ Москвич-427","Elegy","Raindance","RC Tiger","ВАЗ 2108","ВАЗ 2104","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","ГАЗ-М20","Москвич-408","AT-400","ЗИЛ-157","Mersedes G65","BMW X5M","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Восход 3М","Euros","ЛиАЗ-677","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","ГАЗ-2401","ВАЗ 21099",
	"ВАЗ 2114","УАЗ 469","ИЖ-2717","S.W.A.T.","Alpha","Phoenix","Glendale","Sadler","L Trailer A","L Trailer B",
	"Stair Trailer","ЛАЗ-699Р","Farm Plow","U Trailer"
};
static const stock Fraction_Name[MAX_FRACTIONS][32] = {
	"Гражданский",
	"Правительство",
 	"Войсковая часть",
 	"Полиция",
 	"БЦРБ",
 	"Скинхеды",
 	"Гопота",
 	"Кавказцы"
};
//================================ [CMD] =============================//
CMD:unmute(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /unmute [ID игрока]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]})return SCM(playerid, COLOR_GREY, !"Игрок не авторизован");
	if(PI[params[0]][data_MUTE] == 0) return SCM(playerid, COLOR_GREY, !"У данного игрока нет блокировки чата");
	PI[params[0]][data_MUTE] = 0;
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] снял блокировку чата игроку %s[%d]", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]),params[0]);
	SendClientMessagef(playerid, COLOR_TOMATO, "Игровой мастер #%d снял Вам блокировку чата", PI[playerid][pAdminNumber]);
	return 1;
}
CMD:setarm(playerid,params[]) 
{
    if(CheckAdmin(playerid)) return 1;
	if(sscanf(params, "ud", params[0],params[1])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /setarm [ID игрока] [кол-во]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"Игрок не авторизован");
	cef_emit_event(params[0], "show-center-notify", CEFINT(5), CEFSTR("Игровой мастер изменил Вам броню"));
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] изменил уровень брони игрока %s[%d] на %d.0", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid), playerid, getName(params[0]), params[0], params[1]);
	SCMf(params[0], -1, "Игровой мастер #%d выдал Вам бронижелет", PI[playerid][pAdminNumber]);
	SetPlayerArmourAC(params[0], params[1]);
	return 1;
}
CMD:vmute(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"uds[32]",params[0],params[1],params[2])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /vmute [ID игрока] [время] [причина]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]})return  SCM(playerid, COLOR_GREY, !"Игрок не авторизован");

	if(params[1] > 300) return SCM(playerid, COLOR_LIGHTGREY, !"Нельзя выдать блокировку чата больше чем на 300 минут");
	if(params[1] < 1) return SCM(playerid, COLOR_LIGHTGREY, !"Нельзя выдать блокировку чата меньше чем на 1 минуту");

    if(PI[params[0]][pAdmin] > PI[playerid][pAdmin]) return SCM(playerid, COLOR_GREY, !"Нельзя применить к игровому мастеру");

	PI[params[0]][data_VMUTE] = 1;
	PI[params[0]][data_VMUTETIME] = params[1];
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] заблокировал игроку %s[%d] голосовой чат на %d минут. Причина: %s", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]),params[0],params[1],params[2]);
	SendClientMessagef(playerid, COLOR_TOMATO, "Игровой мастер #%d заблокировал Вам голосовой чат на %d минут. Причина: %s", PI[playerid][pAdminNumber], params[1], params[2]);
	SvMutePlayerEnable(params[0]);
	return 1;
}
CMD:unvmute(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /unvmute [ID игрока]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]})return SCM(playerid, COLOR_GREY, !"Игрок не авторизован");
	if(PI[params[0]][data_VMUTE] == 0) return SCM(playerid, COLOR_GREY, !"У данного игрока нет блокировки чата");
	PI[params[0]][data_VMUTE] = 0;
	PI[params[0]][data_VMUTETIME] = 0;
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] снял игроку %s[%d] блокировку голосового чата", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]),params[0]);
	SendClientMessagef(playerid, COLOR_TOMATO, "Игровой мастер #%d снял Вам блокировку голосового чата", PI[playerid][pAdminNumber]);
	SvMutePlayerDisable(params[0]);
	return 1;
}
CMD:mute(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"uds[32]",params[0],params[1],params[2])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /mute [ID игрока] [время] [причина]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]})return  SCM(playerid, COLOR_GREY, !"Игрок не авторизован");

	if(params[1] > 300) return SCM(playerid, COLOR_LIGHTGREY, !"Нельзя выдать блокировку чата больше чем на 300 минут");
	if(params[1] < 1) return SCM(playerid, COLOR_LIGHTGREY, !"Нельзя выдать блокировку чата меньше чем на 1 минуту");

	if(PI[params[0]][pAdmin] > PI[playerid][pAdmin]) return SCM(playerid, COLOR_GREY, !"Нельзя применить к игровому мастеру");

	PI[params[0]][data_MUTE] = 1;
	PI[params[0]][data_MUTETIME] = params[1];
    SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] заблокировал чат игрока %s[%d] на %d минут. Причина: %s", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]),params[0],params[1],params[2]);
	SendClientMessagef(playerid, COLOR_TOMATO, "Игровой мастер #%d заблокировал Вам чат на %d минут. Причина: %s", PI[playerid][pAdminNumber], params[1], params[2]);
	return 1;
}
cmd:saveplayers(playerid) 
{
    if(CheckAdmin(playerid, 8)) return 1;
    if(GetPVarInt(playerid, "saveplayers") > gettime()) return SCM(playerid, COLOR_GREY, !"Команду можно использовать раз в 1 минуту");
	new players = 0;
	foreach(Player, i) 
	{
		if(!IsPlayerConnected(i)) continue;
		SavePlayerData(i);
		players++;
	}
	SetPVarInt(playerid,"saveplayers",gettime() + 59);
	SCMf(playerid, COLOR_YELLOW, "Вы сохранили аккаунты игроков. Сохранено {ff2457}('%d'){FFFF00} строк", players);
	return 1;
}
CMD:msg(playerid,params[]) 
{
    if(CheckAdmin(playerid)) return 1;
	if(sscanf(params,"s[144]",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /msg [текст]");
	SendClientMessageToAllf(COLOR_BLACKRED, "Игровой мастер #%d: %s", PI[playerid][pAdminNumber],params[0]);
    return 1;
}
CMD:a(playerid,params[]) 
{
    if(CheckAdmin(playerid)) return 1;
	if(sscanf(params,"s[90]",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /a [текст]");
    SendAdminsMessagef(0x99CC00FF, "[A] %s[%d]: %s", PI[playerid][pName], playerid, params[0]);
    return 1;
}
CMD:kick(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"us[32]",params[0],params[1])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /kick [ID игрока] [причина]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
    if(playerid == params[0]) return SCM(playerid, COLOR_GREY, !"Нельзя кикать самого себя");
    if(PI[params[0]][pAdmin] > PI[playerid][pAdmin]) return SCM(playerid, COLOR_GREY, !"Нельзя применить к игровому мастеру");
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] кикнул игрока %s. Причина: %s", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid, PI[params[0]][pName], params[1]);
	SendClientMessagef(playerid, COLOR_TOMATO, "Игровой мастер #%d кикнул Вас. Причина: %d", PI[playerid][pAdminNumber], params[1]);
	Kick(params[0]);
	return 1;
}
CMD:astorage(playerid)
{
	if(CheckAdmin(playerid, 5)) return 1;
	ShowPlayerDialogf(playerid, 2390, DIALOG_STYLE_LIST, !"{ee3366}Настройки склада ВЧ", !"Далее", !"Закрыть", "\
	1. Статус склада ВЧ: \t%s\n\
	2. Пополнить склад ВЧ\n\
	3. Обнулить склад ВЧ\n\
	 \n\
	{FFFF99}Статистика склада: \n\
	{FFFF99}Патроны %d шт\n\
	{FFFF99}Металл %d кг", 
	ArmyStorage ? ("{66cc66}(Открыт)") : ("{ff6633}(Закрыт)"), army_wh[1], army_wh[0]);
	return 1;
}
CMD:giveownable(playerid,params[]) 
{
    if(CheckAdmin(playerid, 8)) return 1;
    if(sscanf(params, "dddd", params[0],params[1],params[2],params[3])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /giveownable [id] [car id] [color 1] [color 2]");
    if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"Игрок не авторизирован");
    if(params[1] < 400 || params[1] > 611 && params[1]) return SCM(playerid, COLOR_GREY, !"Номер Транспортного средства не может быть ниже 400 или выше 611 !");
    
	GivePlayerOwnable(params[0], params[1], 0, 50, params[2], params[3], 1, 336);

    SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] выдал игроку %s[%d] машину %s в /cars на 14 дней.", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid, getName(params[0]), params[0], VehicleNames[params[1]-400]);
    SendClientMessagef(params[0], COLOR_YELLOW, "Игровой мастер #%d выдал Вам машину %s на 14 дней, используйте /cars", PI[playerid][pAdminNumber], VehicleNames[params[1]-400]);
	return 1;
}
CMD:resgun(playerid,params[]) 
{
    if(CheckAdmin(playerid, 3)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /resgun [ID игрока]");
	if(!IsPlayerConnected(params[0])) return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"Игрок не авторизован");
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s удалил все оружие у игрока %s", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),getName(params[0]));
    return ResetWeaponAll(params[0]);
}
CMD:mphp(playerid,params[]) 
{
    if(CheckAdmin(playerid, 4)) return 1;
	if(sscanf(params,"d",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /mphp [кол-во]");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
   	for(new i = 0; i < MAX_PLAYERS; i++) 
	{
		if(!IsPlayerConnected(i)) continue;
		if(PlayerToPoint(100.0, i, x,y,z)) 
		{
		    SetPlayerHealthAC(i, params[0]);
		    SCMf(i, -1,"Игровой мастер #%d изменил уровень вашего здоровья", PI[playerid][pAdminNumber]);
			PI[i][pHospital] = 0;
		}
   	}
    return 1;
}
cmd:setmember(playerid, params[]) 
{
    if(CheckAdmin(playerid, 3)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /setmember [ID игрока]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]})return  SCM(playerid, COLOR_GREY, !"Игрок не авторизован");
	SetPVarInt(playerid, "setMember", params[0]);
	ShowPlayerDialog(playerid, 2150, DIALOG_STYLE_LIST, "{ee3366}Выберете организацию", "\
	1. Правительство\n\
	2. Войсковая часть\n\
	3. Полиция\n\
	4. БЦРБ\n\
	5. Скинхеды\n\
	6. Гопота\n\
	7. Кавказцы", "Выбрать", "Отмена");
	return 1;
}
cmd:slap(playerid, params[])
{
	new id;
	if(sscanf(params,"ud",id,params[1])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /slap [ID игрока] [высота]");
	//if(params[1] < 1 || params[1] > 30) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /slap [ID игрока] [высота]");
	if(!IsPlayerConnected(id))return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{id}) return SCM(playerid, COLOR_GREY, !"Игрок не авторизован");
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(id,X,Y,Z);
	SetPlayerPos(id,X,Y,Z+params[1]);
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] подбросил игрока %s[%d] на %d.0 метров", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid), playerid, getName(id), id, params[1]);
	new Float: SlapHealth;
    GetPlayerHealth(params[0], SlapHealth);
    SetPlayerHealthAC(params[0], SlapHealth - 5);
	SendClientMessage(params[0], -1, !"Игровой мастер слапнул Вас");
	return true;
}
CMD:mparm(playerid,params[]) 
{
    if(CheckAdmin(playerid, 4)) return 1;
	if(sscanf(params,"d",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /mparm [кол-во]");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
   	for(new i = 0; i < MAX_PLAYERS; i++) 
	{
		if(!IsPlayerConnected(i)) continue;
		if(PlayerToPoint(100.0, i, x,y,z)) 
		{
		    SetPlayerHealthAC(i, params[0]);
		    SCMf(i, -1,"Игровой мастер #%d выдал Вам бронижелет", PI[playerid][pAdminNumber]);
		}
   	}
    return 1;
}
CMD:mpskin(playerid,params[]) 
{
    if(CheckAdmin(playerid, 3)) return 1;
	if(sscanf(params,"dd",params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /mpskin [1, 2, 3] [номер скина]");
	if(params[1] > 297) return 1;
	new team_1[250],team_2[250], all, team1, team2;
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
   	for(new i = 0; i < MAX_PLAYERS; i++) 
	{
	    if(i == playerid) continue;
		if(!IsPlayerConnected(i)) continue;
		if(PlayerToPoint(100.0, i, x,y,z)) 
		{
		    all++;
            if(params[0] == 3) 
			{
			    SetPlayerSkinAC(i,params[1]);
			    SCMf(i, -1, "Игровой мастер #%d выдал Вам временный скин", PI[playerid][pAdminNumber]);
			    continue;
			}
            if(params[0] == 2 && all%2 == 0) 
			{
                team2++;
            	team_2[team2] = i;
            	SetPlayerSkinAC(i,params[1]);
            	SCMf(i, -1, "Игровой мастер #%d выдал Вам временный скин", PI[playerid][pAdminNumber]);
            	continue;
			}
			if(params[0] == 1 && all%2 == 1) 
			{
			    team1++;
			    team_1[team1] = i;
			    SetPlayerSkinAC(i,params[1]);
			    SCMf(i, -1, "Игровой мастер #%d выдал Вам временный скин", PI[playerid][pAdminNumber]);
			    continue;
			}
			if(params[0] < 1 || params[0] > 3) 
			{
			    SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /mpskin [1, 2, 3] [номер скина]");
			    break;
			}
		}
   	}
	if(params[0] == 3) return SCM(playerid, COLOR_HINT, !"[Подсказка]: {FFFFFF}Вы выдали всем игрокам в радиусе скин");
	if(params[0] == 2) return SCM(playerid, COLOR_HINT, !"[Подсказка]: {FFFFFF}Вы выдали некоторым игрокам в радиусе скин");
	if(params[0] == 1) return SCM(playerid, COLOR_HINT, !"[Подсказка]: {FFFFFF}Вы выдали некоторым игрокам в радиусе скин");
    return 1;
}
CMD:mpgun(playerid,params[]) 
{
    if(CheckAdmin(playerid, 3)) return 1;
	if(sscanf(params, "ddd", params[0], params[1], params[2])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /mpgun [1, 2, 3] [оружие] [патроны]");
  	else if(params[1] > 47 || params[1] < 1) return SCM(playerid, COLOR_GREY, !"Такого оружия не существует");
    else if(params[2] > 1000 || params[2] < 1) return SCM(playerid, COLOR_GREY, !"Не верное количество патрон");
	if(params[1] == 35 && params[1] == 36 && params[1] == 37 && params[1] == 38 && params[1] == 39 && params[1] == 40) return SCM(playerid, COLOR_GREY, !"Данное оружие запретил Руководитель сервера.");
	new team_1[250],team_2[250], all, team1, team2;
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
   	for(new i = 0; i < MAX_PLAYERS; i++) 
	{
		if(i == playerid) continue;
		if(!IsPlayerConnected(i)) continue;
		if(PlayerToPoint(100.0, i, x,y,z)) 
		{
		    all++;
            if(params[0] == 3) 
			{
			    GiveWeapon(i,params[1], params[2]);
			    SCMf(i, -1,"Игровой мастер #%d выдал Вам %s (+%d пт)", PI[playerid][pAdminNumber], weapon_names[params[1]], params[2]);
			    continue;
			}
            if(params[0] == 2 && all%2 == 0) {
                team2++;
            	team_2[team2] = i;
            	GiveWeapon(i,params[1], params[2]);
            	SCMf(i, -1,"Игровой мастер #%d выдал Вам %s (+%d пт)", PI[playerid][pAdminNumber], weapon_names[params[1]], params[2]);
            	continue;
			}
			if(params[0] == 1 && all%2 == 1) {
			    team1++;
			    team_1[team1] = i;
			    GiveWeapon(i,params[1], params[2]);
			    SCMf(i, -1,"Игровой мастер #%d выдал Вам %s (+%d пт)", PI[playerid][pAdminNumber], weapon_names[params[1]], params[2]);
			    continue;
			}
			if(params[0] < 1 || params[0] > 3) 
			{
			    SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /mpgun [1, 2, 3] [оружие] [патроны]");
				SCM(playerid, COLOR_GREY,"1 - первая команда, 2 - вторая команда, 3 - все игроки");
			    break;
			}
		}
   	}
	if(params[0] == 3) return SCM(playerid, COLOR_HINT, !"[Подсказка]: {FFFFFF}Вы выдали всем игрокам в радиусе оружие");
	if(params[0] == 2) return SCM(playerid, COLOR_HINT, !"[Подсказка]: {FFFFFF}Вы выдали некоторым игрокам в радиусе оружие");
	if(params[0] == 1) return SCM(playerid, COLOR_HINT, !"[Подсказка]: {FFFFFF}Вы выдали некоторым игрокам в радиусе оружие");
    return 1;
}
CMD:setleader(playerid,params[]) 
{
    if(CheckAdmin(playerid, 5)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /setleader [ID игрока]");
    if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"Игрок не в сети");
    if(!IsPlayerLogged{params[0]})return  SCM(playerid, COLOR_GREY, !"Игрок не авторизован");
    if(PI[params[0]][pLeader] >= 1) return SCM(playerid, COLOR_LIGHTGREY, !"Игрок уже лидер, его нужно снять чтобы поставить {ff6633}(/luninvite)");
    SetPVarInt(playerid, "setLeader", params[0]);
    return ShowPlayerDialog(playerid, 2149, DIALOG_STYLE_LIST, "{ee3366}Выберете организацию", "\
	1. Правительство\n\
	2. Войсковая часть\n\
	3. Полиция\n\
	4. БЦРБ\n\
	5. Скинхеды\n\
	6. Гопота\n\
	7. Кавказцы", "Выбрать", "Отмена");
}
CMD:tp(playerid) 
{
    if(CheckAdmin(playerid)) return 1;
	return ShowPlayerDialog(playerid, 4385, DIALOG_STYLE_LIST, "{ee3366}Телепортация", "\
	{FFFF99}г. Лыткарино \n\
	{FFFF99}пгт. Бусаево\n\
	{FFFF99}г. Южный\n\
	{FFFF99}с. Роговичи\n\
	{FFFF99}п. Заречный\n\
	{FFFFFF}ОПГ 'Скинхеды'\n\
	{FFFFFF}ОПГ 'Гопота'\n\
	{FFFFFF}ОПГ 'Кавказцы'\n\
	{FFFFFF}Правительство\n\
	{FFFFFF}Полиция\n\
	{FFFFFF}БЦРБ\n\
	{FFFFFF}Воинская часть\n\
	{FFFFFF}Мэрия\n\
	{FFFFFF}Автосалон (Luxe)\n\
	{FFFFFF}Шахта\n\
	{FFFFFF}Склад Веществ\n\
	{FFFFFF}Автомобильный рынок\n\
	{FFFFFF}Спавн новичков\n\
	{FFFFFF}Зона захвата", "Принять", "Закрыть");
}
CMD:auninvite(playerid, params[]) 
{
    if(CheckAdmin(playerid, 5)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /auninvite [ID игрока]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"Игрок не авторизован");
	if(PI[params[0]][pLeader] == 1) return SCM(playerid, COLOR_GREY, !"Игрок является лидером организации! Что бы снять используйте {ff6633}(/luninvite)");

	new year,month,day ;
	getdate(year, month, day);

	mysql_tqueryf(mysql, "\
	INSERT INTO `wbook`(`w_player`,`w_fraction`,`w_name`,`w_reason`,`w_rank`,`w_day`,`w_mes`,`w_year`)\
		VALUES\
	('%d','%d','%s','Увольнение игровым мастером','%d','%d','%d','%d')",\
		PI[params[0]][data_ID], PI[params[0]][pMember], getName(params[0]), PI[params[0]][pRang], day, month, year);

	if(PI[params[0]][pOnCapture] == 1)
	{
		AutoKickCapture(params[0]);
		CheckCount(params[0]);
	}

	SCMf(params[0], COLOR_YELLOW, "Игровой мастер #%d уволил Вас из организации %s (%d ранг)",
		PI[playerid][pAdminNumber], Fraction_Name[PI[playerid][pMember]], PI[params[0]][pRang]);

	cef_emit_event(params[0], "hide-capture");

	PI[params[0]][pLeader] = 0;
	PI[params[0]][pMember] = 0;
	PI[params[0]][pRang] = 0;
	PI[params[0]][pOrgSkin] = 0;
	PI[params[0]][pProgressMetall] = 0;
	PI[params[0]][pProgressDrugs] = 0;
	PI[params[0]][pProgressAmmo] = 0;
	PI[params[0]][pProgressCarGrabber] = 0;
	PI[params[0]][pProgressSellGun] = 0;
	PI[params[0]][pProgressCapture] = 0;
    PI[params[0]][pCaptureManager] = 0;
	PI[params[0]][pRankUPTime] = 0;

	SetPlayerSkinAC(params[0], PI[params[0]][pSkin]);
	SetPlayerColorEx(params[0]);
	SetPlayerTeam(params[0], NO_TEAM);

	for(new g; g <= totalgz; g++) GangZoneHideForPlayer(params[0], g);
	GangZoneStopFlashForPlayer(params[0], WarZone);


	ClearGroup(params[0]);
	return SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] уволил из организцаии игрока %s[%d]", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]), params[0]);
}
CMD:luninvite(playerid, params[]) 
{
    if(CheckAdmin(playerid, 5)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /luninvite [ID игрока]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_GREY, !"Игрок не в сети");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"Игрок не авторизован");

	new year,month,day ;
	getdate(year, month, day);

	mysql_tqueryf(mysql, "\
	INSERT INTO `wbook`(`w_player`,`w_fraction`,`w_name`,`w_reason`,`w_rank`,`w_day`,`w_mes`,`w_year`)\
		VALUES\
	('%d','%d','%s','Снятие с поста лидера','%d','%d','%d','%d')",\
		PI[params[0]][data_ID], PI[params[0]][pMember], getName(params[0]), PI[params[0]][pRang], day, month, year );

	if(PI[params[0]][pOnCapture] == 1)
	{
		AutoKickCapture(params[0]);
		CheckCount(params[0]);
	}
	
	SCM(params[0], COLOR_YELLOW, !"Игровой мастер снял Вас с поста лидера организации");

	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] снял с поста лидера организцаии %s[%d]",\
		AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid), playerid, getName(params[0]), params[0]);

	PI[params[0]][pLeader] = 0;
	PI[params[0]][pMember] = 0;
	PI[params[0]][pRang] = 0;
	PI[params[0]][pOrgSkin] = 0;
	PI[params[0]][pRankUPTime] = 0;

	SetPlayerSkinAC(params[0], PI[params[0]][pSkin]);
	SetPlayerColorEx(params[0]);
	SetPlayerTeam(params[0], NO_TEAM);
	cef_emit_event(params[0], "hide-capture");

	for(new g; g <= totalgz; g++) GangZoneHideForPlayer(params[0], g);
	GangZoneStopFlashForPlayer(params[0], WarZone);

	ClearGroup(params[0]);
	return 1;
}
//======================================= [ dialogs ] =============================//
stock admins_OnDialogResponse(playerid, dialogid, response, listitem)
{
	switch(dialogid) 
	{
		case 4385:
        {
            if(response)
            {
                switch(listitem)
                {
					case 0: SetPlayerPos(playerid, -2496.6514,187.7827,55.7560);
                    case 1: SetPlayerPos(playerid, -506.5684,-1417.5021,56.2231);
                    case 2: SetPlayerPos(playerid, 2254.5574,-1727.5728,61.1377);
                    case 3: SetPlayerPos(playerid, 1880.3647,1180.8679,38.8619);
                    case 4: SetPlayerPos(playerid, 2386.1399,-938.3940,14.3443);
                    case 5: SetPlayerPos(playerid, 1402.7463,2371.0381,23.2061+2);
                    case 6: SetPlayerPos(playerid, 2224.7097,-2611.0547,31.8857+2);
                    case 7: SetPlayerPos(playerid, -367.4405,-1198.3756,50.2112+2);
                    case 8: SetPlayerPos(playerid, 1907.1965,-2226.8005,43.2401+2);
                    case 9: SetPlayerPos(playerid, 2403.2986,-1849.3372,21.9369+2);
					case 10: SetPlayerPos(playerid, 2113.0063,1821.8636,23.0438+2);
                    case 11: SetPlayerPos(playerid, -2586.5540,309.6096,20.9953+2);
					case 12: SetPlayerPos(playerid, 1812.3840,2095.7266,28.6875+2); // мэрия
                    case 13: SetPlayerPos(playerid, 2336.7915,-1803.0875,33.1497+2);
                    case 14: SetPlayerPos(playerid, 2782.3528,2698.6128,16.7200+2);
                    case 15: SetPlayerPos(playerid, 1880.3647,1180.8679,38.8619+2);
					case 16: SetPlayerPos(playerid, 2469.1038,-714.2072,24.5437+2);
					case 17: SetPlayerPos(playerid, 1806.8326,2507.3311,21.5287+2);
					case 18: SetPlayerPos(playerid, 1517.7395,-1213.6506,15.0275+2);
                }
				SetPlayerVirtualWorld(playerid,0);
				SetPlayerInterior(playerid,0);
				SendClientMessage(playerid, COLOR_LIGHTGREY, !"Вы были телепортированы {ff6633}(/tp)");
            }
        }
		case 2149:
     	{
            if(!response) return 1;
            if(response)
            {
                new id = GetPVarInt(playerid, "setLeader");

                PI[id][pLeader] = setleader_config[listitem][member];
				PI[id][pMember] = setleader_config[listitem][member];
				PI[id][pRang] = 10;

				SCMf(id, COLOR_YELLOW, "Поздравляем! Игровой мастер назначил Вас лидером организации '%s'",setleader_config[listitem][f_name]);
				SetPlayerColorEx(id);
				
			    if(PI[id][pPassiveMode] == 1)
				{
					SCM(id, COLOR_HINT, !"[Info] {FFFFFF}Пассивный режим автоматически отключён (причина: участие в ОПГ)");
					PassiveModeOff(id);
	            }

				if(PI[playerid][pSex] == 1) 
				{
					switch(PI[id][pMember]) 
					{
						case 1: PI[id][pOrgSkin] = 208;
						case 2: PI[id][pOrgSkin] = 222;
						case 3: PI[id][pOrgSkin] = 280;
						case 4: PI[id][pOrgSkin] = 70;
						case 5: PI[id][pOrgSkin] = 117;
						case 6: PI[id][pOrgSkin] = 236;
						case 7: PI[id][pOrgSkin] = 118;
						case 8: PI[id][pOrgSkin] = 283;
					}
				}
				if(PI[playerid][pSex] == 2) 
				{
					switch(PI[id][pMember]) 
					{
						case 1: PI[id][pOrgSkin] = 156;
						case 2: PI[id][pOrgSkin] = 179;
						case 3: PI[id][pOrgSkin] = 280;
						case 4: PI[id][pOrgSkin] = 276;
						case 5: PI[id][pOrgSkin] = 117;
						case 6: PI[id][pOrgSkin] = 121;
						case 7: PI[id][pOrgSkin] = 118;
						case 8: PI[id][pOrgSkin] = 298;
					}
				}
				new str_q[73];
				mysql_format(mysql, str_q, sizeof(str_q), "SELECT * FROM `group` WHERE `fraction` = '%d' AND `skin_m` = %d", PI[id][pMember], PI[id][pOrgSkin]);
				mysql_function_query(mysql, str_q, true, "SetPlayerStandartGroup", "d", id);

				UpdatePlayerDataInt(playerid, "skinm", PI[playerid][pOrgSkin],12241);
				SetPlayerSkinAC(id,PI[id][pOrgSkin]);

				if(PI[id][pMember] == 5 || PI[id][pMember] == 6 || PI[id][pMember] == 7) for(new g; g <= totalgz; g++) GangZoneShowForPlayer(id, g, GetGZFrac(g));

				pDialogCurrectTime[id] = gettime() + 5;
				pDialogTimer[id] = SetTimerEx("DialogTimerLeader", 500, true, "i", id);
				SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] назначил %s[%d] на должность лидера организации '%s'", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName],playerid,PI[id][pName], id, Fraction_Name[PI[id][pMember]]);

				CheckGangWar(playerid);
				SetPlayerTeam(id, PI[id][pMember]);
				SavePlayerData(id);

				DeletePVar(playerid,"setMember");
			}
		}
		case 2150: 
		{
            if(!response) return 1;
            if(response) 
			{
				new id = GetPVarInt(playerid,"setMember");
               	PI[id][pTempMember] = setleader_config[listitem][member];
               	ShowPlayerDialog(playerid, 2151, DIALOG_STYLE_LIST, !"{ee3366}Выберете ранг", !"1\n2\n3\n4\n5\n6\n7\n8\n{FFFF99}Заместитель", !"Выбрать", !"Отмена");
			}
		}
		case 2151:
		{
			if(!response) return 1;
			if(response) 
			{
			    new id = GetPVarInt(playerid,"setMember");

				SetPlayerColorEx(id);
				SetDefaultSkin(PI[id][pTempMember], id);
				PI[id][pLeader] = 0;
				PI[id][pMember] = PI[id][pTempMember];
				PI[id][pTempMember] = -1;
				PI[id][pRang] = listitem+1;

				if(PI[id][pMember] == 5 || PI[id][pMember] == 6 || PI[id][pMember] == 7) for(new g; g <= totalgz; g++) GangZoneShowForPlayer(id, g, GetGZFrac(g));

				CheckGangWar(playerid);

				SCMf(playerid, COLOR_YELLOW, "Вы приняли %s[%d] в оргазинацию %s на %d ранг", PI[id][pName], id, Fraction_Name[PI[id][pMember]], PI[id][pRang]);
				SCMf(id, COLOR_YELLOW, "Игровой мастер принял Вас в организацию %s на %d ранг", Fraction_Name[PI[id][pMember]], PI[id][pRang]);
				SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] принял %s[%d] в организацию %s на %d ранг", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName],playerid,PI[id][pName], id, Fraction_Name[PI[id][pMember]], PI[id][pRang]);
				
				if(PI[id][pPassiveMode] == 1)
				{
					SCM(id, COLOR_HINT, !"[Info] {FFFFFF}Пассивный режим автоматически отключён (причина: участие в ОПГ)");
					PI[id][pPassiveMode] = 0;
					PassiveModeOff(id);
	            }
				
				new str_q[73];
				mysql_format(mysql,str_q, sizeof(str_q), "SELECT * FROM `group` WHERE `fraction` = '%d' AND `standart` = 1", PI[id][pMember]);
				mysql_function_query(mysql, str_q, true, "SetPlayerStandartGroup", "d", id);

				SavePlayerData(id);

				DeletePVar(playerid,"setMember");
			}
		}
		case 2390:
		{
			if(!response) return 1;
			if(response)
			{
				switch(listitem)
				{
					case 0: 
					{
						if(ArmyStorage == 0) ArmyStorage = 1;
						else ArmyStorage = 0;

						SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] %s склад организации 'Воинская часть'",\
							AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid, ArmyStorage ? ("открыл") : ("закрыл"));
					}
					case 1:
					{
						SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] пополнил склад организации 'Воинская часть'",\
							AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid);
						
						army_wh[0] +=500000;
						army_wh[1] +=500000;

						new str_3[256];
						format(str_3,sizeof(str_3),"{f18c2b}Армейский склад\n\n{FFFFFF}Металл: %d кг.\n{fccf39}Патроны: %d шт.",army_wh[0],army_wh[1]);
						UpdateDynamic3DTextLabelText(army_sklad_text, -1, str_3);
					}
					case 2:
					{
						SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] обнулил склад организации 'Воинская часть'",\
							AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid);
						
						army_wh[0] = 0;
   						army_wh[1] = 0;

						new str_3[256];
						format(str_3,sizeof(str_3),"{f18c2b}Армейский склад\n\n{FFFFFF}Металл: %d кг.\n{fccf39}Патроны: %d шт.",army_wh[0],army_wh[1]);
						UpdateDynamic3DTextLabelText(army_sklad_text, -1, str_3);
					}
				}
				SaveWarehouse();
			}
		}
	}
	return 1;
}
static const stock AdminName[9][6] = {
	"�����",
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
	"BMW X5","Audi A6 C8","Mersedec Akula","Lexus GX460","BMW M5 F90 2021","Mercedes-Benz E63","�����-���","����� ��������","Audi A6 2019","Mercedes GL63","Audi R8","Lada Kalina",
	"Lexus GSF","Nissan Titan 2017","BMW M5","Porsche 911","Ambulance","������ ������","Volkswagen Multivan","��� 2107","Nissan GTR","Washington","Infiniti JX 35 2013","Mr Whoopee","BF Injection",
	"Hunter","Audi A6","������","���������","���-�22","Predator","����-677�","Rhino","��� 131","Hotknife","Trailer","Toyota MarkII","Ikarus 260","���-2402",
	"��-412","Rumpo","RC Bandit","Romero","Packer","Monster","���-45","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","���-3309","Caddy","Audi A6","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"BMW 535i","Mercedes GLE","Sanchez","Sparrow","Patriot","Audi A7","Coastguard","Dinghy","���-21�","Toyota Land Cruiser","Rustler","ZR3 50","��-27151","���-2114",
	"Toyota Supra","���������","Burrito","���-3205","Marquis","��� 2402","Dozer","Maverick","News Chopper","Chevrolet Niva","FBI Rancher","Virgo","��� 2109",
	"Jetmax","Hotring","Sandking","���-1102","Police Maverick","Boxville","���-53","���-69","RC Goblin","Hotring A","Mersedes Benz E200",
	"Bloodring Banger","Rancher","Super GT","���-2401"," ���-452","�����","������ �����","Beagle","Cropdust","Stunt","�����-54115","���-608�",
	"���-21099","���-2203"," ����-672","Shamal","Hydra","�� ������� 5","NRG-500","����","Cement Truck","���������","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","�5 F90","Bugatti Chiron","��� 2424",
	"�������-434","Firetruck","�������-400","�������-2125","�������-2140","Cargobob","���-968�","Sunrise","��� 31105","Utility","Nevada","���-3303","���-968�","Monster A",
	"Monster B","Lamborghini Huracan Devo","Acura NSX GT3","Orange Porshe","�� �������-427","Elegy","Raindance","RC Tiger","��� 2108","��� 2104","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","���-�20","�������-408","AT-400","���-157","Mersedes G65","BMW X5M","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"������ 3�","Euros","����-677","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","���-2401","��� 21099",
	"��� 2114","��� 469","��-2717","S.W.A.T.","Alpha","Phoenix","Glendale","Sadler","L Trailer A","L Trailer B",
	"Stair Trailer","���-699�","Farm Plow","U Trailer"
};
static const stock Fraction_Name[MAX_FRACTIONS][32] = {
	"�����������",
	"�������������",
 	"��������� �����",
 	"�������",
 	"����",
 	"��������",
 	"������",
 	"��������"
};
//================================ [CMD] =============================//
CMD:unmute(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /unmute [ID ������]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]})return SCM(playerid, COLOR_GREY, !"����� �� �����������");
	if(PI[params[0]][data_MUTE] == 0) return SCM(playerid, COLOR_GREY, !"� ������� ������ ��� ���������� ����");
	PI[params[0]][data_MUTE] = 0;
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ���� ���������� ���� ������ %s[%d]", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]),params[0]);
	SendClientMessagef(playerid, COLOR_TOMATO, "������� ������ #%d ���� ��� ���������� ����", PI[playerid][pAdminNumber]);
	return 1;
}
CMD:setarm(playerid,params[]) 
{
    if(CheckAdmin(playerid)) return 1;
	if(sscanf(params, "ud", params[0],params[1])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /setarm [ID ������] [���-��]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"����� �� �����������");
	cef_emit_event(params[0], "show-center-notify", CEFINT(5), CEFSTR("������� ������ ������� ��� �����"));
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ������� ������� ����� ������ %s[%d] �� %d.0", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid), playerid, getName(params[0]), params[0], params[1]);
	SCMf(params[0], -1, "������� ������ #%d ����� ��� ����������", PI[playerid][pAdminNumber]);
	SetPlayerArmourAC(params[0], params[1]);
	return 1;
}
CMD:vmute(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"uds[32]",params[0],params[1],params[2])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /vmute [ID ������] [�����] [�������]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]})return  SCM(playerid, COLOR_GREY, !"����� �� �����������");

	if(params[1] > 300) return SCM(playerid, COLOR_LIGHTGREY, !"������ ������ ���������� ���� ������ ��� �� 300 �����");
	if(params[1] < 1) return SCM(playerid, COLOR_LIGHTGREY, !"������ ������ ���������� ���� ������ ��� �� 1 ������");

    if(PI[params[0]][pAdmin] > PI[playerid][pAdmin]) return SCM(playerid, COLOR_GREY, !"������ ��������� � �������� �������");

	PI[params[0]][data_VMUTE] = 1;
	PI[params[0]][data_VMUTETIME] = params[1];
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ������������ ������ %s[%d] ��������� ��� �� %d �����. �������: %s", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]),params[0],params[1],params[2]);
	SendClientMessagef(playerid, COLOR_TOMATO, "������� ������ #%d ������������ ��� ��������� ��� �� %d �����. �������: %s", PI[playerid][pAdminNumber], params[1], params[2]);
	SvMutePlayerEnable(params[0]);
	return 1;
}
CMD:unvmute(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /unvmute [ID ������]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]})return SCM(playerid, COLOR_GREY, !"����� �� �����������");
	if(PI[params[0]][data_VMUTE] == 0) return SCM(playerid, COLOR_GREY, !"� ������� ������ ��� ���������� ����");
	PI[params[0]][data_VMUTE] = 0;
	PI[params[0]][data_VMUTETIME] = 0;
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ���� ������ %s[%d] ���������� ���������� ����", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]),params[0]);
	SendClientMessagef(playerid, COLOR_TOMATO, "������� ������ #%d ���� ��� ���������� ���������� ����", PI[playerid][pAdminNumber]);
	SvMutePlayerDisable(params[0]);
	return 1;
}
CMD:mute(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"uds[32]",params[0],params[1],params[2])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /mute [ID ������] [�����] [�������]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]})return  SCM(playerid, COLOR_GREY, !"����� �� �����������");

	if(params[1] > 300) return SCM(playerid, COLOR_LIGHTGREY, !"������ ������ ���������� ���� ������ ��� �� 300 �����");
	if(params[1] < 1) return SCM(playerid, COLOR_LIGHTGREY, !"������ ������ ���������� ���� ������ ��� �� 1 ������");

	if(PI[params[0]][pAdmin] > PI[playerid][pAdmin]) return SCM(playerid, COLOR_GREY, !"������ ��������� � �������� �������");

	PI[params[0]][data_MUTE] = 1;
	PI[params[0]][data_MUTETIME] = params[1];
    SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ������������ ��� ������ %s[%d] �� %d �����. �������: %s", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]),params[0],params[1],params[2]);
	SendClientMessagef(playerid, COLOR_TOMATO, "������� ������ #%d ������������ ��� ��� �� %d �����. �������: %s", PI[playerid][pAdminNumber], params[1], params[2]);
	return 1;
}
cmd:saveplayers(playerid) 
{
    if(CheckAdmin(playerid, 8)) return 1;
    if(GetPVarInt(playerid, "saveplayers") > gettime()) return SCM(playerid, COLOR_GREY, !"������� ����� ������������ ��� � 1 ������");
	new players = 0;
	foreach(Player, i) 
	{
		if(!IsPlayerConnected(i)) continue;
		SavePlayerData(i);
		players++;
	}
	SetPVarInt(playerid,"saveplayers",gettime() + 59);
	SCMf(playerid, COLOR_YELLOW, "�� ��������� �������� �������. ��������� {ff2457}('%d'){FFFF00} �����", players);
	return 1;
}
CMD:msg(playerid,params[]) 
{
    if(CheckAdmin(playerid)) return 1;
	if(sscanf(params,"s[144]",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /msg [�����]");
	SendClientMessageToAllf(COLOR_BLACKRED, "������� ������ #%d: %s", PI[playerid][pAdminNumber],params[0]);
    return 1;
}
CMD:a(playerid,params[]) 
{
    if(CheckAdmin(playerid)) return 1;
	if(sscanf(params,"s[90]",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /a [�����]");
    SendAdminsMessagef(0x99CC00FF, "[A] %s[%d]: %s", PI[playerid][pName], playerid, params[0]);
    return 1;
}
CMD:kick(playerid,params[]) 
{
    if(CheckAdmin(playerid, 2)) return 1;
	if(sscanf(params,"us[32]",params[0],params[1])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /kick [ID ������] [�������]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
    if(playerid == params[0]) return SCM(playerid, COLOR_GREY, !"������ ������ ������ ����");
    if(PI[params[0]][pAdmin] > PI[playerid][pAdmin]) return SCM(playerid, COLOR_GREY, !"������ ��������� � �������� �������");
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ������ ������ %s. �������: %s", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid, PI[params[0]][pName], params[1]);
	SendClientMessagef(playerid, COLOR_TOMATO, "������� ������ #%d ������ ���. �������: %d", PI[playerid][pAdminNumber], params[1]);
	Kick(params[0]);
	return 1;
}
CMD:astorage(playerid)
{
	if(CheckAdmin(playerid, 5)) return 1;
	ShowPlayerDialogf(playerid, 2390, DIALOG_STYLE_LIST, !"{ee3366}��������� ������ ��", !"�����", !"�������", "\
	1. ������ ������ ��: \t%s\n\
	2. ��������� ����� ��\n\
	3. �������� ����� ��\n\
	 \n\
	{FFFF99}���������� ������: \n\
	{FFFF99}������� %d ��\n\
	{FFFF99}������ %d ��", 
	ArmyStorage ? ("{66cc66}(������)") : ("{ff6633}(������)"), army_wh[1], army_wh[0]);
	return 1;
}
CMD:giveownable(playerid,params[]) 
{
    if(CheckAdmin(playerid, 8)) return 1;
    if(sscanf(params, "dddd", params[0],params[1],params[2],params[3])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /giveownable [id] [car id] [color 1] [color 2]");
    if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"����� �� �������������");
    if(params[1] < 400 || params[1] > 611 && params[1]) return SCM(playerid, COLOR_GREY, !"����� ������������� �������� �� ����� ���� ���� 400 ��� ���� 611 !");
    
	GivePlayerOwnable(params[0], params[1], 0, 50, params[2], params[3], 1, 336);

    SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ����� ������ %s[%d] ������ %s � /cars �� 14 ����.", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid, getName(params[0]), params[0], VehicleNames[params[1]-400]);
    SendClientMessagef(params[0], COLOR_YELLOW, "������� ������ #%d ����� ��� ������ %s �� 14 ����, ����������� /cars", PI[playerid][pAdminNumber], VehicleNames[params[1]-400]);
	return 1;
}
CMD:resgun(playerid,params[]) 
{
    if(CheckAdmin(playerid, 3)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /resgun [ID ������]");
	if(!IsPlayerConnected(params[0])) return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"����� �� �����������");
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s ������ ��� ������ � ������ %s", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),getName(params[0]));
    return ResetWeaponAll(params[0]);
}
CMD:mphp(playerid,params[]) 
{
    if(CheckAdmin(playerid, 4)) return 1;
	if(sscanf(params,"d",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /mphp [���-��]");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
   	for(new i = 0; i < MAX_PLAYERS; i++) {
		if(!IsPlayerConnected(i)) continue;
		if(PlayerToPoint(100.0, i, x,y,z)) {
		    SetPlayerHealthAC(i, params[0]);
		    SCMf(i, -1,"������� ������ #%d ������� ������� ������ ��������", PI[playerid][pAdminNumber]);
			PI[i][pHospital] = 0;
		}
   	}
    return 1;
}
cmd:setmember(playerid, params[]) 
{
    if(CheckAdmin(playerid, 3)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /setmember [ID ������]");
	if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]})return  SCM(playerid, COLOR_GREY, !"����� �� �����������");
	SetPVarInt(playerid, "setMember", params[0]);
	ShowPlayerDialog(playerid, 2150, DIALOG_STYLE_LIST, "{ee3366}�������� �����������", "\
	1. �������������\n\
	2. ��������� �����\
	3. �������\n\
	4. ����\n\
	5. ��������\n\
	6. ������\n\
	7. ��������", "�������", "������");
	return 1;
}
cmd:slap(playerid, params[])
{
	new id;
	if(sscanf(params,"ud",id,params[1])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /slap [ID ������] [������]");
	if(params[1] < 1 || params[1] > 30) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /slap [ID ������] [������]");
	if(!IsPlayerConnected(id))return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{id}) return SCM(playerid, COLOR_GREY, !"����� �� �����������");
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(id,X,Y,Z);
	SetPlayerPos(id,X,Y,Z+params[1]);
	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ��������� ������ %s[%d] �� %d.0 ������", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid), playerid, getName(id), id, params[1]);
	new Float: SlapHealth;
    GetPlayerHealth(params[0], SlapHealth);
    SetPlayerHealthAC(params[0], SlapHealth - 5);
	SendClientMessage(playerid, -1, !"������� ������ ������� ���");
	return true;
}
CMD:mparm(playerid,params[]) 
{
    if(CheckAdmin(playerid, 4)) return 1;
	if(sscanf(params,"d",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /mparm [���-��]");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
   	for(new i = 0; i < MAX_PLAYERS; i++) 
	{
		if(!IsPlayerConnected(i)) continue;
		if(PlayerToPoint(100.0, i, x,y,z)) 
		{
		    SetPlayerHealthAC(i, params[0]);
		    SCMf(i, -1,"������� ������ #%d ����� ��� ����������", PI[playerid][pAdminNumber]);
		}
   	}
    return 1;
}
CMD:mpskin(playerid,params[]) 
{
    if(CheckAdmin(playerid, 3)) return 1;
	if(sscanf(params,"dd",params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /mpskin [1, 2, 3] [����� �����]");
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
			    SCMf(i, -1, "������� ������ #%d ����� ��� ��������� ����", PI[playerid][pAdminNumber]);
			    continue;
			}
            if(params[0] == 2 && all%2 == 0) 
			{
                team2++;
            	team_2[team2] = i;
            	SetPlayerSkinAC(i,params[1]);
            	SCMf(i, -1, "������� ������ #%d ����� ��� ��������� ����", PI[playerid][pAdminNumber]);
            	continue;
			}
			if(params[0] == 1 && all%2 == 1) 
			{
			    team1++;
			    team_1[team1] = i;
			    SetPlayerSkinAC(i,params[1]);
			    SCMf(i, -1, "������� ������ #%d ����� ��� ��������� ����", PI[playerid][pAdminNumber]);
			    continue;
			}
			if(params[0] < 1 || params[0] > 3) 
			{
			    SCM(playerid, COLOR_LIGHTGREY, !"�����������: /mpskin [1, 2, 3] [����� �����]");
			    break;
			}
		}
   	}
	if(params[0] == 3) return SCM(playerid, COLOR_HINT, !"[���������]: {FFFFFF}�� ������ ���� ������� � ������� ����");
	if(params[0] == 2) return SCM(playerid, COLOR_HINT, !"[���������]: {FFFFFF}�� ������ ��������� ������� � ������� ����");
	if(params[0] == 1) return SCM(playerid, COLOR_HINT, !"[���������]: {FFFFFF}�� ������ ��������� ������� � ������� ����");
    return 1;
}
CMD:mpgun(playerid,params[]) 
{
    if(CheckAdmin(playerid, 3)) return 1;
	if(sscanf(params, "ddd", params[0], params[1], params[2])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /mpgun [1, 2, 3] [������] [�������]");
  	else if(params[1] > 47 || params[1] < 1) return SCM(playerid, COLOR_GREY, !"������ ������ �� ����������");
    else if(params[2] > 1000 || params[2] < 1) return SCM(playerid, COLOR_GREY, !"�� ������ ���������� ������");
	if(params[1] == 35 && params[1] == 36 && params[1] == 37 && params[1] == 38 && params[1] == 39 && params[1] == 40) return SCM(playerid, COLOR_GREY, !"������ ������ �������� ������������ �������.");
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
			    SCMf(i, -1,"������� ������ #%d ����� ��� %s (+%d ��)", PI[playerid][pAdminNumber], weapon_names[params[1]], params[2]);
			    continue;
			}
            if(params[0] == 2 && all%2 == 0) {
                team2++;
            	team_2[team2] = i;
            	GiveWeapon(i,params[1], params[2]);
            	SCMf(i, -1,"������� ������ #%d ����� ��� %s (+%d ��)", PI[playerid][pAdminNumber], weapon_names[params[1]], params[2]);
            	continue;
			}
			if(params[0] == 1 && all%2 == 1) {
			    team1++;
			    team_1[team1] = i;
			    GiveWeapon(i,params[1], params[2]);
			    SCMf(i, -1,"������� ������ #%d ����� ��� %s (+%d ��)", PI[playerid][pAdminNumber], weapon_names[params[1]], params[2]);
			    continue;
			}
			if(params[0] < 1 || params[0] > 3) 
			{
			    SCM(playerid, COLOR_LIGHTGREY, !"�����������: /mpgun [1, 2, 3] [������] [�������]");
				SCM(playerid, COLOR_GREY,"1 - ������ �������, 2 - ������ �������, 3 - ��� ������");
			    break;
			}
		}
   	}
	if(params[0] == 3) return SCM(playerid, COLOR_HINT, !"[���������]: {FFFFFF}�� ������ ���� ������� � ������� ������");
	if(params[0] == 2) return SCM(playerid, COLOR_HINT, !"[���������]: {FFFFFF}�� ������ ��������� ������� � ������� ������");
	if(params[0] == 1) return SCM(playerid, COLOR_HINT, !"[���������]: {FFFFFF}�� ������ ��������� ������� � ������� ������");
    return 1;
}
CMD:setleader(playerid,params[]) 
{
    if(CheckAdmin(playerid, 5)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /setleader [ID ������]");
    if(!IsPlayerConnected(params[0]))return  SCM(playerid, COLOR_GREY, !"����� �� � ����");
    if(!IsPlayerLogged{params[0]})return  SCM(playerid, COLOR_GREY, !"����� �� �����������");
    if(PI[params[0]][pLeader] >= 1) return SCM(playerid, COLOR_LIGHTGREY, !"����� ��� �����, ��� ����� ����� ����� ��������� {ff6633}(/luninvite)");
    SetPVarInt(playerid, "setLeader", params[0]);
    return ShowPlayerDialog(playerid, 2149, DIALOG_STYLE_LIST, "{ee3366}�������� �����������", "\
	1. �������������\n\
	2. ��������� �����\n\
	3. �������\n\
	4. ����\n\
	5. ��������\n\
	6. ������\n\
	7. ��������", "�������", "������");
}
CMD:tp(playerid) 
{
    if(CheckAdmin(playerid)) return 1;
	return ShowPlayerDialog(playerid, 4385, DIALOG_STYLE_LIST, "{ee3366}������������", "\
	{FFFF99}�. ��������� \n\
	{FFFF99}���. �������\n\
	{FFFF99}�. �����\n\
	{FFFF99}�. ��������\n\
	{FFFF99}�. ��������\n\
	{FFFFFF}��� '��������'\n\
	{FFFFFF}��� '������'\n\
	{FFFFFF}��� '��������'\n\
	{FFFFFF}�������������\n\
	{FFFFFF}�������\n\
	{FFFFFF}����\n\
	{FFFFFF}�������� �����\n\
	{FFFFFF}�����\n\
	{FFFFFF}��������� (Luxe)\n\
	{FFFFFF}�����\n\
	{FFFFFF}����� �������\n\
	{FFFFFF}������������� �����\n\
	{FFFFFF}����� ��������\n\
	{FFFFFF}���� �������", "�������", "�������");
}
CMD:auninvite(playerid, params[]) 
{
    if(CheckAdmin(playerid, 5)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /auninvite [ID ������]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"����� �� �����������");
	if(PI[params[0]][pLeader] == 1) return SCM(playerid, COLOR_GREY, !"����� �������� ������� �����������! ��� �� ����� ����������� {ff6633}(/luninvite)");

	new year,month,day ;
	getdate(year, month, day);

	mysql_tqueryf(mysql, "\
	INSERT INTO `wbook`(`w_player`,`w_fraction`,`w_name`,`w_reason`,`w_rank`,`w_day`,`w_mes`,`w_year`)\
		VALUES\
	('%d','%d','%s','���������� ������� ��������','%d','%d','%d','%d')",\
		PI[params[0]][data_ID], PI[params[0]][pMember], getName(params[0]), PI[params[0]][pRang], day, month, year);

	SCMf(params[0], COLOR_YELLOW, "������� ������ #%d ������ ��� �� ����������� %s (%d ����)",
		PI[playerid][pAdminNumber], getName(playerid), Fraction_Name[PI[playerid][pMember]], PI[params[0]][pRang]);

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
    PI[params[0]][pAntiCLMenu] = 0;
	PI[params[0]][pRankUPTime] = 0;

	SetPlayerSkinAC(params[0], PI[params[0]][pSkin]);
	SetPlayerColorEx(params[0]);
	SetPlayerTeam(params[0], NO_TEAM);

	for(new g; g <= totalgz; g++) GangZoneHideForPlayer(params[0], g);
	GangZoneStopFlashForPlayer(params[0], WarZone);


	ClearGroup(params[0]);
	return SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ������ �� ����������� ������ %s[%d]", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], getName(playerid),playerid,getName(params[0]), params[0]);
}
CMD:luninvite(playerid, params[]) 
{
    if(CheckAdmin(playerid, 5)) return 1;
    if(sscanf(params,"u",params[0])) return SCM(playerid, COLOR_LIGHTGREY, !"�����������: /luninvite [ID ������]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_GREY, !"����� �� � ����");
	if(!IsPlayerLogged{params[0]}) return SCM(playerid, COLOR_GREY, !"����� �� �����������");

	new year,month,day ;
	getdate(year, month, day);

	mysql_tqueryf(mysql, "\
	INSERT INTO `wbook`(`w_player`,`w_fraction`,`w_name`,`w_reason`,`w_rank`,`w_day`,`w_mes`,`w_year`)\
		VALUES\
	('%d','%d','%s','������ � ����� ������','%d','%d','%d','%d')",\
		PI[params[0]][data_ID], PI[params[0]][pMember], getName(params[0]), PI[params[0]][pRang], day, month, year );

	SCM(params[0], COLOR_YELLOW, !"������� ������ ���� ��� � ����� ������ �����������");

	SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ���� � ����� ������ ����������� %s[%d]",\
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
                    case 5: SetPlayerPos(playerid, 1402.7463,2371.0381,23.2061);
                    case 6: SetPlayerPos(playerid, 2224.7097,-2611.0547,31.8857);
                    case 7: SetPlayerPos(playerid, -367.4405,-1198.3756,50.2112);
                    case 8: SetPlayerPos(playerid, 1907.1965,-2226.8005,43.2401);
                    case 9: SetPlayerPos(playerid, 2403.2986,-1849.3372,21.9369);
					case 10: SetPlayerPos(playerid, 2113.0063,1821.8636,23.0438);
                    case 11: SetPlayerPos(playerid, 1558.5304,1820.2159,27.9343);
                    case 12: SetPlayerPos(playerid, 1816.6481,2095.6685,28.6541);
                    case 13: SetPlayerPos(playerid, 2336.7915,-1803.0875,33.1497);
                    case 14: SetPlayerPos(playerid, 2782.3528,2698.6128,16.7200);
                    case 15: SetPlayerPos(playerid, 1880.3647,1180.8679,38.8619);
					case 16: SetPlayerPos(playerid, 2469.1038,-714.2072,24.5437);
					case 17: SetPlayerPos(playerid, 1806.8326,2507.3311,21.5287);
					case 18: SetPlayerPos(playerid, 1399.9020,-1249.6090,15.1950);
                }
				SetPlayerVirtualWorld(playerid,0);
				SetPlayerInterior(playerid,0);
				SendClientMessage(playerid, COLOR_LIGHTGREY, !"�� ���� ��������������� {ff6633}(/tp)");
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

				SCMf(id, COLOR_YELLOW, "�����������! ������� ������ �������� ��� ������� ����������� '%s'",setleader_config[listitem][f_name]);
				SetPlayerColorEx(id);
				
			    if(PI[id][pPassiveMode] == 1)
				{
					SCM(id, COLOR_HINT, !"[Info] {FFFFFF}��������� ����� ������������� �������� (�������: ������� � ���)");
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
				SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] �������� %s[%d] �� ��������� ������ ����������� '%s'", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName],playerid,PI[id][pName], id, Fraction_Name[PI[id][pMember]]);

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
               	ShowPlayerDialog(playerid, 2151, DIALOG_STYLE_LIST, !"{ee3366}�������� ����", !"1\n2\n3\n4\n5\n6\n7\n8\n{FFFF99}�����������", !"�������", !"������");
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

				SCMf(playerid, COLOR_YELLOW, "�� ������� %s[%d] � ����������� %s �� %d ����", PI[id][pName], id, Fraction_Name[PI[id][pMember]], PI[id][pRang]);
				SCMf(id, COLOR_YELLOW, "������� ������ ������ ��� � ����������� %s �� %d ����", Fraction_Name[PI[id][pMember]], PI[id][pRang]);
				SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ������ %s[%d] � ����������� %s �� %d ����", AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName],playerid,PI[id][pName], id, Fraction_Name[PI[id][pMember]], PI[id][pRang]);
				
				if(PI[id][pPassiveMode] == 1)
				{
					SCM(id, COLOR_HINT, !"[Info] {FFFFFF}��������� ����� ������������� �������� (�������: ������� � ���)");
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

						SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] %s ����� ����������� '�������� �����'",\
							AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid, ArmyStorage ? ("������") : ("������"));
					}
					case 1:
					{
						SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] �������� ����� ����������� '�������� �����'",\
							AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid);
						
						army_wh[0] +=500000;
						army_wh[1] +=500000;

						new str_3[256];
						format(str_3,sizeof(str_3),"{f18c2b}��������� �����\n\n{FFFFFF}������: %d ��.\n{fccf39}�������: %d ��.",army_wh[0],army_wh[1]);
						UpdateDynamic3DTextLabelText(army_sklad_text, -1, str_3);
					}
					case 2:
					{
						SendAdminsMessagef(COLOR_ADMINCHAT, "[%s #%d] %s[%d] ������� ����� ����������� '�������� �����'",\
							AdminName[PI[playerid][pAdmin]], PI[playerid][pAdminNumber], PI[playerid][pName], playerid);
						
						army_wh[0] = 0;
   						army_wh[1] = 0;

						new str_3[256];
						format(str_3,sizeof(str_3),"{f18c2b}��������� �����\n\n{FFFFFF}������: %d ��.\n{fccf39}�������: %d ��.",army_wh[0],army_wh[1]);
						UpdateDynamic3DTextLabelText(army_sklad_text, -1, str_3);
					}
				}
				SaveWarehouse();
			}
		}
	}
	return 1;
}
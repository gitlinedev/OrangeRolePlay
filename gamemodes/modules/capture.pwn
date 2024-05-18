new PointCapture;

enum gwInfo
{
    gID,
    gPlayerID,
    gMember,
    gSpawnID,
    gGunID[13],
    gAmmoValue[13]
};
new GangWarInfo[14][gwInfo];

new Float:SpawnPositions[14][4] = {
    {1540.9475,-1268.9381,14.9656,356.0040}, // ОПГ 1
    {1539.1700,-1268.3915,14.9656,356.5047},
    {1537.4194,-1268.3647,14.9656,356.3199},
    {1537.4728,-1270.2788,14.9656,358.6558},
    {1539.0555,-1270.2362,14.9656,354.8898},
    {1541.3853,-1270.3041,14.9656,352.4788},
    {1541.4683,-1272.0131,14.9656,352.2399},
    {1556.7186,-1228.5701,14.9656,182.5103}, // ОПГ 2
    {1555.2203,-1228.6348,14.9656,177.2398},
    {1553.3282,-1228.5397,14.9656,171.9693},
    {1553.4354,-1226.6405,14.9656,166.6988},
    {1555.3833,-1226.6838,14.9656,177.8266},
    {1557.3243,-1226.5961,14.9656,172.5561},
    {1554.0076,-1224.5449,14.9656,175.6308}
};

//========================== [ название орг ] ========================== //
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
//============================== [ таймер - раунды ] ===================================//
stock capture_SecondTimer()
{
    if(GangWarStatus == 1)
	{
	    WarTimeSec--;
	    if(WarTimeSec == 0 && WarTimeMin != 0)
		{
			WarTimeSec = 59;
			WarTimeMin--;
			for(new i = 0; i < MAX_PLAYERS; i++) 
            {
				if(5 <= PI[i][pMember] || PI[i][pMember] >= 7) 
                {
					new time[12];
					if(WarTimeSec > 9) format(time, sizeof(time), "%d:%d", WarTimeMin, WarTimeSec);
					else format(time, sizeof(time), "%d:0%d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("подготовка"));
				}
			}
		}
		if(WarTimeSec == 0 && WarTimeMin == 0) 
        {
			new plus1 = 0,plus2 = 0;
			for(new i = 0; i < MAX_PLAYERS; i++) 
            {
				if(PI[i][pMember] == Command[0]) if(IsPlayerToKvadrat(i, 1449.5,-1355, 1591.5, -1133)) if(Command[0] == PI[i][pMember]) plus1 = 1;
				if(PI[i][pMember] == Command[1]) if(IsPlayerToKvadrat(i, 1449.5,-1355, 1591.5, -1133)) if(Command[1] == PI[i][pMember]) plus2 = 1;
			}
			if(plus1 != 0) 
            {
				if(plus2 != 0) 
                {
					WarTimeMin = 1;
					WarTimeSec = 59;
					GangWarStatus = 2;
				}
			}
			for(new i = 0; i < MAX_PLAYERS; i++) 
            {
				if(5 <= PI[i][pMember] || PI[i][pMember] >= 7) 
                {
					SCM(i, COLOR_TOMATO, !"На территории остались участники вражеской ОПГ, стрела продлена на 2 минуты");
					new time[12];
					if(WarTimeSec > 9) format(time, sizeof(time), "%d:%d", WarTimeMin, WarTimeSec);
					else format(time, sizeof(time), "%d:0%d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("продление 3"));
				}
			}
			if(GangWarStatus != 2) 
			{
				if(CommandKill[0] > CommandKill[1]) 
				{
					for(new i = 0; i < MAX_PLAYERS; i++) 
					{
						if(5 <= PI[i][pMember] || PI[i][pMember] >= 7) 
						{
							GangZoneHideForPlayer(i, CaptZone);
							GangZoneStopFlashForPlayer(i, WarZone);
							gz_info[WarZone][gzopg] = Command[0];
							new col;
							switch(Command[0]) 
							{
								case 5: col = 0x663399BB;
								case 6: col = 0x66CCFFBB;
								case 7: col = 0x339933AA;
							}
							GangZoneHideForPlayer(i, WarZone);
							GangZoneShowForPlayer(i, WarZone, col);
							SaveGZ(Command[0], WarZone);
							ClearKillFeed(i);
							cef_emit_event(i, "hide-capture");
							cef_emit_event(i, "clear-kill-list");
							SCMf(i, COLOR_YELLOW, "Попытка ОПГ %s захватить территорию у ОПГ %s завершилась успешно", Fraction_Name[Command[0]], Fraction_Name[Command[1]]);
						}
					}
					GangWarStatus = 0;
				}
				else if(CommandKill[0] < CommandKill[1]) 
				{
					for(new i = 0; i < MAX_PLAYERS; i++) 
					{
						if(5 <= PI[i][pMember] || PI[i][pMember] >= 7) 
						{
							cef_emit_event(i, "capture-text", CEFSTR("продление 3"));
							GangZoneHideForPlayer(i, CaptZone);
							GangZoneStopFlashForPlayer(i, WarZone);
							GangZoneHideForPlayer(i, WarZone);
							new col;
							switch(Command[1]) 
							{
								case 5: col = 0x663399BB;
								case 6: col = 0x66CCFFBB;
								case 7: col = 0x339933AA;
							}
							GangZoneHideForPlayer(i, WarZone);
							GangZoneShowForPlayer(i, WarZone, col);
							ClearKillFeed(i);
							cef_emit_event(i, "hide-capture");
							cef_emit_event(i, "clear-kill-list");
							SCMf(i, COLOR_YELLOW, "Попытка ОПГ %s захватить территорию у ОПГ %s завершилась неуспешно", Fraction_Name[Command[0]], Fraction_Name[Command[1]]);
						}
					}
					GangWarStatus = 0;
				}
			}
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(5 <= PI[i][pMember] || PI[i][pMember] >= 7) 
			{
				new time[12];
				if(WarTimeSec > 9) format(time, sizeof(time), "%d:%d", WarTimeMin, WarTimeSec);
				else format(time, sizeof(time), "%d:0%d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
				cef_emit_event(i, "capture-text", CEFSTR("подготовка"));
			}
		}
	}
}
stock capture_OnDialogResponse(playerid, dialogid, response)
{
    switch(dialogid)
    {
        case 4901:
        {
            if(!response) return 1;
            if(response)
            {
                if(!AddPlayerToCapture(playerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, !"Свободных мест уже нет (7/7)");
                else 
                {
                    static name[24];
                    SetString(name, NameRang(playerid));
                    name = NameRang(playerid);
                    
                    SendFractionMessagef(PI[playerid][pMember], 0x69b867FF, "[R] %s %s[%d] присоединился к участникам стрелы (%d/7)",\
                        name, getName(playerid), playerid, );
                }
            }
        }
    }
    return 1;
}
stock AddPlayerToCapture(playerid)
{
    new spawnID;
    if(PI[playerid][pMember] == Command[0])
    {
        for (spawnID = 0; spawnID <= 6; spawnID++)
        {
            new isFree = true;
            for (new i = 0; i < sizeof(GangWarInfo); i++)
            {
                if (GangWarInfo[i][gSpawnID] == spawnID)
                {
                    isFree = false;
                    break;
                }
            }
            if (isFree)
            {
                for (new i = 0; i < sizeof(GangWarInfo); i++)
                {
                    if (GangWarInfo[i][gPlayerID] == 0)
                    {
                        GangWarInfo[i][gMember] = PI[playerid][pMember];
                        GangWarInfo[i][gPlayerID] = playerid;
                        GangWarInfo[i][gSpawnID] = spawnID;
                        return 1;
                    }
                }
            }
        }
    }
    else if(PI[playerid][pMember] == Command[1])
    {
        for (spawnID = 7; spawnID <= 14; spawnID++)
        {
            new isFree = true;
            for (new i = 0; i < sizeof(GangWarInfo); i++)
            {
                if (GangWarInfo[i][gSpawnID] == spawnID)
                {
                    isFree = false;
                    break;
                }
            }
            if (isFree)
            {
                for (new i = 0; i < sizeof(GangWarInfo); i++)
                {
                    if (GangWarInfo[i][gPlayerID] == 0)
                    {
                        GangWarInfo[i][gMember] = PI[playerid][pMember];
                        GangWarInfo[i][gPlayerID] = playerid;
                        GangWarInfo[i][gSpawnID] = spawnID;
                        return 1;
                    }
                }
            }
        }
    }
    for (new i = 0; i < sizeof(GangWarInfo); i++)
    {
        if(GangWarInfo[i][gPlayerID] == 0)
        {
            GangWarInfo[i][gMember] = PI[playerid][pMember];
            GangWarInfo[i][gPlayerID] = playerid;
            GangWarInfo[i][gSpawnID] = spawnID;
            return 1;   
        }
    }
    return 0;
}
stock GetPlayerID(playerid)
{
    for (new i = 0; i < sizeof(GangWarInfo); i++)
    {
        if(GangWarInfo[i][gPlayerID] == playerid)
        {
            return i;   
        }
    }
    return 0;
}
stock GetCountonGanwWar(playerid)
{
    for (new i = 0; i < sizeof(GangWarInfo); i++)
    {
        if(GangWarInfo[i][gPlayerID] == playerid)
        {
            return i;   
        }
    }
    return 0;
}
cmd:test_playerid(playerid)
{
    new id = GetPlayerID(playerid);
    SetPlayerPos(playerid, SpawnPositions[GangWarInfo[id][gSpawnID]][0], SpawnPositions[GangWarInfo[id][gSpawnID]][1], SpawnPositions[GangWarInfo[id][gSpawnID]][2]);
}
//=================================================== [CMD] ===================================================//
cmd:capture(playerid) 
{
    if(!IsPlayerOPG(playerid))  return SCM(playerid, COLOR_GREY, !"Вы не состоите в ОПГ");
    if(PI[playerid][pRang] < 7) return SCM(playerid, COLOR_GREY, !"Данную команду можно использовать с 7-го ранга");
	new gz = GetPlayerGangZone(playerid);
	if(gz == -1) return SCM(playerid, COLOR_GREY, !"Вы не находитесь ни в одной из зон");
    if(GetPVarInt(playerid,"Counting_Capture") > gettime()) return SCM(playerid, COLOR_GREY, !"Команду можно использовать раз в 1 минуту");
    SetPVarInt(playerid,"Counting_Capture",gettime() + 59);

    new hour, minute, second;
    gettime(hour, minute, second);
    
    if(capturetime == 1) 
	{
		if(!((hour >= 12 && hour <= 19) && minute == 0) && !(hour >= 20 && hour <= 23) && !(hour >= 0 && hour <= 9))
		{
			return SCM(playerid, COLOR_GREY, !"Захват территорий для вашей ОПГ доступен в 12:00, 13:00, 14:00, 15:00, 16:00, 17:00, 18:00, 20:00, 21:00, 22:00, 23:00");
		}
	}

	if(GangWarStatus == 1) return SCM(playerid, COLOR_GREY, !"В данный момент уже идет война за территорию");
    if(gz_info[gz][gzopg] == PI[playerid][pMember]) return SCM(playerid, COLOR_GREY, !"Вы не можете захватить свою территорию");

	switch(gz_info[gz][gzopg]) 
	{
	    case 5: if(m_skinhead > 1) return SCM(playerid, COLOR_GREY, !"В данной ОПГ замороженны захваты территорий");
		case 6: if(m_gopota > 1) return SCM(playerid, COLOR_GREY, !"В данной ОПГ замороженны захваты территорий");
		case 7: if(m_kavkaz > 1) return SCM(playerid, COLOR_GREY, !"В данной ОПГ замороженны захваты территорий");
	}
	switch(PI[playerid][pMember]) 
	{
	    case 5: if(m_skinhead > 1) return SCM(playerid, COLOR_GREY, !"В Вашей ОПГ замороженны захваты территорий");
		case 6: if(m_gopota > 1) return SCM(playerid, COLOR_GREY, !"В Вашей ОПГ замороженны захваты территорий");
		case 7: if(m_kavkaz > 1) return SCM(playerid, COLOR_GREY, !"В Вашей ОПГ замороженны захваты территорий");
	}
    if(gz_info[gz][gzid] == 101) return 1;

    new warname[15];
	if(gz_info[gz][gzopg] == 5) warname = "'Скинхеды'";
	if(gz_info[gz][gzopg] == 6) warname = "'Гопота'";
	if(gz_info[gz][gzopg] == 7) warname = "'Кавказцы'";

	PI[playerid][pCaptureValue]++;
	PI[playerid][pProgressCapture]+= 1;

	GangWarStatus = 1;
	//
	WarTimeMin = 10;
	WarTimeSec = 01;
	WarZone = gz;
	//
	CommandKill[0]= 0;
	CommandKill[1]= 0;
	Command[0] = PI[playerid][pMember];
	Command[1] = gz_info[gz][gzopg];

	static name[24];
	SetString(name, NameRang(playerid));
	name = NameRang(playerid);

	new str[145];
	switch(PI[playerid][pMember]) 
	{
     	case 5:format(str,sizeof(str),"%s {3377CC}%s[%d] {3377CC}(%s){FFFF00} инициировал захват территории {3377CC}(%s)", name, getName(playerid), playerid, Fraction_Name[PI[playerid][pMember]], warname);
   		case 6:format(str,sizeof(str),"%s {3377CC}%s[%d] {3377CC}(%s){FFFF00} инициировал захват территории {3377CC}(%s)", name, getName(playerid), playerid, Fraction_Name[PI[playerid][pMember]], warname);
	    case 7:format(str,sizeof(str),"%s {3377CC}%s[%d] {3377CC}(%s){FFFF00} инициировал захват территории {3377CC}(%s)", name, getName(playerid), playerid, Fraction_Name[PI[playerid][pMember]], warname);
	}
    static name_org[15], nameorg[15];
    switch(Command[0]) 
	{
        case 5: name_org = "Скинхеды";
        case 6: name_org = "Гопота";
        case 7: name_org = "Кавказцы";
    }
    switch(Command[1]) 
	{
        case 5: nameorg = "Скинхеды";
        case 6: nameorg = "Гопота";
        case 7: nameorg = "Кавказцы";
    }
	SCM(playerid, COLOR_YELLOW, !"За инициацию захвата территории Вы получите вознаграждение в PayDay"); 
	foreach(new i:Player) 
	{
	    if(IsPlayerOPG(i)) 
		{
			if(PI[i][pMember] == Command[0]) 
			{
				SCM(i, COLOR_YELLOW, str);
				SCM(i, COLOR_YELLOW,"Территория отмечена у Вас на мини-карте красным (мигающим) прямоугольником");
				SCM(i, COLOR_YELLOW,"Место стрельбы отмечено у Вас на мини-карте красным (не мигающим!) прямоугольником в южной части карты");
				SCM(i, COLOR_YELLOW,"Используйте команду {3377CC}/cteam{FFFF00}, чтобы посмотреть список участников своей ОПГ на территории стрелы");
				cef_emit_event(i, "show-capture");
				cef_emit_event(i, "capture-score", CEFINT(CommandKill[0]), CEFINT(CommandKill[1]));
				cef_emit_event(i, "capture-text", CEFSTR("подготовка"));
				cef_emit_event(i, "capture-info-name", CEFSTR(name_org), CEFSTR(nameorg));
				cef_emit_event(i, "show_kill_list");
				GangZoneFlashForPlayer(i, gz, 0xFF000055);	
			}
			if(PI[i][pMember] == Command[1])
			{
				SCM(i, COLOR_YELLOW, str);
				SCM(i, COLOR_YELLOW,"Территория отмечена у Вас на мини-карте красным (мигающим) прямоугольником");
				SCM(i, COLOR_YELLOW,"Место стрельбы отмечено у Вас на мини-карте красным (не мигающим!) прямоугольником в южной части карты");
				SCM(i, COLOR_YELLOW,"Используйте команду {3377CC}/cteam{FFFF00}, чтобы посмотреть список участников своей ОПГ на территории стрелы");
				cef_emit_event(i, "show-capture");
				cef_emit_event(i, "capture-score", CEFINT(CommandKill[0]), CEFINT(CommandKill[1]));
				cef_emit_event(i, "capture-text", CEFSTR("подготовка"));
				cef_emit_event(i, "capture-info-name", CEFSTR(name_org), CEFSTR(nameorg));
				cef_emit_event(i, "show_kill_list");
				GangZoneFlashForPlayer(i, gz, 0xFF000055);
			}
		}
	}
	for(new g; g < totalgz; g++) 
	{
	    if(gz_info[g][gzid] == 101) 
		{
			CaptZone = GangZoneCreate(gz_info[g][gzminx], gz_info[g][gzminy], gz_info[g][gzmaxx], gz_info[g][gzmaxy]);
			foreach(new i:Player) if(PI[i][pMember] >= 5 && PI[i][pMember] <= 7) GangZoneShowForPlayer(i, g, 0xFF000055);
	    }
	}
	return 1;
}
CMD:cteam(playerid, params[]) 
{
	new string[512], name[115], bugfix = 0, count = 0;
	for(new i = 0; i < sizeof(GangWarInfo); i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(GangWarInfo[i][gMember] == PI[playerid][pMember]) 
		{
            count++;
            SetString(name, NameRang(GangWarInfo[i][gPlayerID]));
            name = NameRang(GangWarInfo[i][gPlayerID]);
            format(string,sizeof(string),"%s%d\t\t%s[%d]\t\t%s[%d]\t\t%d мс\n", string, count, PI[GangWarInfo[i][gPlayerID]][pName], GangWarInfo[i][gPlayerID], name, PI[GangWarInfo[i][gPlayerID]][pRang], GetPlayerPing(GangWarInfo[i][gPlayerID]));
			bugfix = 1;
		}
	}
	if(bugfix == 0) CEF__Dialog(playerid,0, DIALOG_STYLE_MSGBOX, "{ee3366}Участники стрелы", "{FFFFFF}Список участников пуст.", "Закрыть", "");
	else 
    {
        if(PI[playerid][pCapturManager] == 1 || PI[playerod][pRank] >= 9)
        {
		    new str_1[512*2];
		    format(str_1,sizeof(str_1),"№\tИгрок\tРанг\tПинг\n%s",string);
		    CEF__Dialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, "{ee3366}Участники стрелы", str_1, "Исключить", "Закрыть");
        }
        else
        {
            new str_1[512*2];
		    format(str_1,sizeof(str_1),"№\tИгрок\tРанг\tПинг\n%s",string);
		    CEF__Dialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, "{ee3366}Участники стрелы", str_1, "Закрыть", "");
        }
	}
	return 1;
}
#define ROUND_MIN 		5
#define ROUND_SEC 		1
#define START_ROUND		5
#define FINISH_ROUND	5

new ShowTeam[MAX_PLAYERS][7];

new CommandKill[2],
	CommandRounds[2],
	Command[2],
	GangWarStatus,
	WarTimeMin,
	WarTimeSec,
	count_1,
	count_2,
	PointCapture,
	CaptZone;

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
    {1540.9475,-1268.9381,14.9656,356.0040}, // ��� 1
    {1539.1700,-1268.3915,14.9656,356.5047},
    {1537.4194,-1268.3647,14.9656,356.3199},
    {1537.4728,-1270.2788,14.9656,358.6558},
    {1539.0555,-1270.2362,14.9656,354.8898},
    {1541.3853,-1270.3041,14.9656,352.4788},
    {1541.4683,-1272.0131,14.9656,352.2399},
    {1556.7186,-1228.5701,14.9656,182.5103}, // ��� 2
    {1555.2203,-1228.6348,14.9656,177.2398},
    {1553.3282,-1228.5397,14.9656,171.9693},
    {1553.4354,-1226.6405,14.9656,166.6988},
    {1555.3833,-1226.6838,14.9656,177.8266},
    {1557.3243,-1226.5961,14.9656,172.5561},
    {1554.0076,-1224.5449,14.9656,175.6308}
};

//========================== [ �������� ��� ] ========================== //
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
static const stock ColorTeam[MAX_FRACTIONS][7] = {
	"FFFFFF",
	"ffeb9c",
 	"009900",
 	"2222FF",
 	"ff99cc",
 	"663399",
 	"66CCFF",
 	"339933"
};
//======================================= [ STOCKS ] ===================================//
stock capture_SecondTimer()
{
    if(GangWarStatus == 1)
	{
		WarTimeSec--;

		new time[12];

		if(WarTimeSec == 0 && WarTimeMin != 0)
		{
			WarTimeSec = 59;
			WarTimeMin--;
			for(new i = 0; i < MAX_PLAYERS; i++) 
            {
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
                {
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
				}
			}
		}
		else
		{
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
				}
			}
		}
		if(WarTimeMin == 0 && WarTimeSec == 0)
		{
			count_1 = GetCountonGanwWar(Command[0]); // ��� ��������
			count_2 = GetCountonGanwWar(Command[1]); // ���� ���������

			if(count_1 < 1)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
					{
						GangZoneStopFlashForPlayer(i, WarZone);
						GangZoneHideForPlayer(i, WarZone);
						GangZoneShowForPlayer(i, WarZone, GetColorZone(Command[1]));
						cef_emit_event(i, "hide-capture");
						cef_emit_event(i, "clear-kill-list");

						SendClientMessagef(i, COLOR_YELLOW, "������ {%s}��� %s{FFFF00} ��������� ���������� {%s}��� %s{FFFF00} ����������� ���������", ColorTeam[Command[0]], Fraction_Name[Command[0]], ColorTeam[Command[1]], Fraction_Name[Command[1]]);
						ClearCapture();
					}
				}
				GangWarStatus = 0;
			}
			else if(count_2 < 1)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
					{
						GangZoneStopFlashForPlayer(i, WarZone);
						gz_info[WarZone][gzopg] = Command[0];
						GangZoneHideForPlayer(i, WarZone);
						GangZoneShowForPlayer(i, WarZone, GetColorZone(Command[0]));
						SaveGZ(Command[0], WarZone);
						cef_emit_event(i, "hide-capture");
						cef_emit_event(i, "clear-kill-list");

						SendClientMessagef(i, COLOR_YELLOW, "������ {%s}��� %s{FFFF00} ��������� ���������� {%s}��� %s{FFFF00} ����������� �������", ColorTeam[Command[0]], Fraction_Name[Command[0]], ColorTeam[Command[1]], Fraction_Name[Command[1]]);
						ClearCapture();
					}
				}
				GangWarStatus = 0;
			}
			if(count_1 >= 1 && count_2 >= 1)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
					{
						if(PI[i][pOnCapture] == 1)
						{
							WaitToStart(i);
						}
					}
				}
				WarTimeMin = 00;
				WarTimeSec = START_ROUND;
				GangWarStatus = 2;
			}
		}
	}
	if(GangWarStatus == 2)
	{
		WarTimeSec--;
		if(WarTimeSec <= 0)
		{
			CommandKill[0] = 0;
			CommandKill[1] = 0;

			GangWarStatus = 3;
			WarTimeMin = ROUND_MIN;
			WarTimeSec = ROUND_SEC;
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
			{
				new time[12];
				format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
				cef_emit_event(i, "capture-text", CEFSTR("������ ������"));
			}
		}
	}
	if(GangWarStatus == 3)
	{
		WarTimeSec--;
		if(WarTimeSec == 0 && WarTimeMin != 0)
		{
			WarTimeSec = 59;
			WarTimeMin--;
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("����� 1"));
				}
			}
		}
		else
		{
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
				}
			}
		}
		if(CommandKill[0] == count_2 || CommandKill[1] == count_1)
		{
			if(CommandKill[0] == count_2) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[0] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[0]++;
			}
			else if(CommandKill[1] == count_1) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[1] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[1]++;
			}

			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] && PI[i][pOnCapture] == 1) FinishRound(i);
				if(PI[i][pMember] == Command[1] && PI[i][pOnCapture] == 1) FinishRound(i);
			}

			GangWarStatus = 4;
			WarTimeSec = FINISH_ROUND;
			WarTimeMin = 0;

			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("���������� ������"));
				}
			}
			for(new i; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1]) cef_emit_event(i, "capture-score", CEFINT(CommandRounds[0]), CEFINT(CommandRounds[1]));
			}
		}
	}
	if(GangWarStatus == 4)
	{
		WarTimeSec--;
		if(WarTimeSec <= 0)
		{
			CommandKill[0] = 0;
			CommandKill[1] = 0;

			GangWarStatus = 5;
			WarTimeMin = 0;
			WarTimeSec = START_ROUND;

			/*for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] && PI[i][pOnCapture] == 1) FinishRound(i);
				if(PI[i][pMember] == Command[1] && PI[i][pOnCapture] == 1) FinishRound(i);
			}*/
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
			{
				new time[12];
				format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
			}
		}	
	}
	if(GangWarStatus == 5)
	{
		WarTimeSec--;
		if(WarTimeSec <= 0)
		{
			CommandKill[0] = 0;
			CommandKill[1] = 0;

			GangWarStatus = 6;
			WarTimeMin = ROUND_MIN;
			WarTimeSec = ROUND_SEC;
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
			{
				new time[12];
				format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
				cef_emit_event(i, "capture-text", CEFSTR("������ ������"));
			}
		}
	}
	if(GangWarStatus == 6)
	{
		WarTimeSec--;
		if(WarTimeSec == 0 && WarTimeMin != 0)
		{
			WarTimeSec = 59;
			WarTimeMin--;
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("����� 2"));
				}
			}
		}
		else
		{
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("����� 2"));
				}
			}
		}
		if(CommandKill[0] == count_2 || CommandKill[1] == count_1)
		{
			if(CommandKill[0] == count_2) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[0] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[0]++;
			}
			else if(CommandKill[1] == count_1) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[1] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[1]++;
			}
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] && PI[i][pOnCapture] == 1) FinishRound(i);
				if(PI[i][pMember] == Command[1] && PI[i][pOnCapture] == 1) FinishRound(i);
			}
			GangWarStatus = 7;
			WarTimeSec = FINISH_ROUND;
			WarTimeMin = 0;

			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("���������� ������"));
				}
			}
			for(new i; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1]) cef_emit_event(i, "capture-score", CEFINT(CommandRounds[0]), CEFINT(CommandRounds[1]));
			}
		}		
	}
	if(GangWarStatus == 7)
	{
		WarTimeSec--;
		if(WarTimeSec <= 0)
		{
			CommandKill[0] = 0;
			CommandKill[1] = 0;

			GangWarStatus = 8;
			WarTimeMin = 0;
			WarTimeSec = START_ROUND;

			/*for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] && PI[i][pOnCapture] == 1) FinishRound(i);
				if(PI[i][pMember] == Command[1] && PI[i][pOnCapture] == 1) FinishRound(i);
			}*/
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
			{
				new time[12];
				format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
			}
		}	
	}
	if(GangWarStatus == 8)
	{
		WarTimeSec--;
		if(WarTimeSec <= 0)
		{
			CommandKill[0] = 0;
			CommandKill[1] = 0;

			GangWarStatus = 9;
			WarTimeMin = ROUND_MIN;
			WarTimeSec = ROUND_SEC;
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
			{
				new time[12];
				format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
				cef_emit_event(i, "capture-text", CEFSTR("������ ������"));
			}
		}
	}
	if(GangWarStatus == 9)
	{
		WarTimeSec--;
		if(WarTimeSec == 0 && WarTimeMin != 0)
		{
			WarTimeSec = 59;
			WarTimeMin--;
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("����� 3"));
				}
			}
		}
		else
		{
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("����� 3"));
				}
			}
		}
		if(CommandKill[0] == count_2 || CommandKill[1] == count_1)
		{
			if(CommandKill[0] == count_2) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[0] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[0]++;
			}
			else if(CommandKill[1] == count_1) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[1] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[1]++;
			}
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] && PI[i][pOnCapture] == 1) FinishRound(i);
				if(PI[i][pMember] == Command[1] && PI[i][pOnCapture] == 1) FinishRound(i);
			}
			GangWarStatus = 10;
			WarTimeSec = FINISH_ROUND;
			WarTimeMin = 0;

			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("���������� ������"));
				}
			}
			for(new i; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1]) cef_emit_event(i, "capture-score", CEFINT(CommandRounds[0]), CEFINT(CommandRounds[1]));
			}
		}		
	}
	if(GangWarStatus == 10)
	{
		WarTimeSec--;
		if(WarTimeSec <= 0)
		{
			CommandKill[0] = 0;
			CommandKill[1] = 0;

			GangWarStatus = 11;
			WarTimeMin = 0;
			WarTimeSec = START_ROUND;

			/*for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] && PI[i][pOnCapture] == 1) FinishRound(i);
				if(PI[i][pMember] == Command[1] && PI[i][pOnCapture] == 1) FinishRound(i);
			}*/
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
			{
				new time[12];
				format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
			}
		}	
	}
	if(GangWarStatus == 11)
	{
		WarTimeSec--;
		if(WarTimeSec <= 0)
		{
			CommandKill[0] = 0;
			CommandKill[1] = 0;

			GangWarStatus = 12;
			WarTimeMin = ROUND_MIN;
			WarTimeSec = ROUND_SEC;
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
			{
				new time[12];
				format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
				cef_emit_event(i, "capture-text", CEFSTR("������ ������"));
			}
		}
	}
	if(GangWarStatus == 12)
	{
		WarTimeSec--;
		if(WarTimeSec == 0 && WarTimeMin != 0)
		{
			WarTimeSec = 59;
			WarTimeMin--;
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("����� 4"));
				}
			}
		}
		else
		{
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("����� 4"));
				}
			}
		}
		if(CommandKill[0] == count_2 || CommandKill[1] == count_1)
		{
			if(CommandKill[0] == count_2) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[0] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[0]++;
			}
			else if(CommandKill[1] == count_1) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[1] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[1]++;
			}
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] && PI[i][pOnCapture] == 1) FinishRound(i);
				if(PI[i][pMember] == Command[1] && PI[i][pOnCapture] == 1) FinishRound(i);
			}
			GangWarStatus = 13;
			WarTimeSec = FINISH_ROUND;
			WarTimeMin = 0;

			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("���������� ������"));
				}
			}
			for(new i; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1]) cef_emit_event(i, "capture-score", CEFINT(CommandRounds[0]), CEFINT(CommandRounds[1]));
			}
		}		
	}
	if(GangWarStatus == 13)
	{
		WarTimeSec--;
		if(WarTimeSec <= 0)
		{
			CommandKill[0] = 0;
			CommandKill[1] = 0;

			GangWarStatus = 14;
			WarTimeMin = 0;
			WarTimeSec = START_ROUND;

			/*for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] && PI[i][pOnCapture] == 1) FinishRound(i);
				if(PI[i][pMember] == Command[1] && PI[i][pOnCapture] == 1) FinishRound(i);
			}*/
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
			{
				new time[12];
				format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
			}
		}	
	}
	if(GangWarStatus == 14)
	{
		WarTimeSec--;
		if(WarTimeSec <= 0)
		{
			CommandKill[0] = 0;
			CommandKill[1] = 0;

			GangWarStatus = 15;
			WarTimeMin = ROUND_MIN;
			WarTimeSec = ROUND_SEC;
		}
		for(new i = 0; i < MAX_PLAYERS; i++) 
		{
			if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
			{
				new time[12];
				format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
				cef_emit_event(i, "capture-time", CEFSTR(time));
				cef_emit_event(i, "capture-text", CEFSTR("������ ������"));
			}
		}
	}
	if(GangWarStatus == 15)
	{
		WarTimeSec--;
		if(WarTimeSec == 0 && WarTimeMin != 0)
		{
			WarTimeSec = 59;
			WarTimeMin--;
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("����� 5"));
				}
			}
		}
		else
		{
			for(new i = 0; i < MAX_PLAYERS; i++) 
			{
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
				{
					new time[12];
					format(time, sizeof(time), "%d:%02d", WarTimeMin, WarTimeSec);
					cef_emit_event(i, "capture-time", CEFSTR(time));
					cef_emit_event(i, "capture-text", CEFSTR("����� 5"));
				}
			}
		}
		if(CommandKill[0] == count_2 || CommandKill[1] == count_1)
		{
			if(CommandKill[0] == count_2) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[0] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[0]++;
			}
			else if(CommandKill[1] == count_1) 
			{
				for(new i = 0; i < MAX_PLAYERS; i++) 
				{
					if(PI[i][pMember] == Command[1] && GetPVarInt(i, "DeathOnCapture") == 0)
					{
						TogglePlayerControllable(i, false);
					}
				}
				CommandRounds[1]++;
			}

			GangWarStatus = 16;
			WarTimeSec = FINISH_ROUND;
			WarTimeMin = 0;

			for(new i; i < MAX_PLAYERS; i++) 
			{
				cef_emit_event(i, "capture-text", CEFSTR("���������� ������"));
				if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1]) cef_emit_event(i, "capture-score", CEFINT(CommandRounds[0]), CEFINT(CommandRounds[1]));
			}
			//================ last round =================== //
			if(CommandRounds[0] < CommandRounds[1])
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
					{
						GangZoneStopFlashForPlayer(i, WarZone);
						new col;
						switch(Command[1]) {
							case 5: col = 0x663399BB;
							case 6: col = 0x66CCFFBB;
							case 7: col = 0x339933AA;
						}
						GangZoneHideForPlayer(i, WarZone);
						GangZoneShowForPlayer(i, WarZone, col);
						ClearKillFeed(i);
						cef_emit_event(i, "hide-capture");
						cef_emit_event(i, "clear-kill-list");
						TogglePlayerControllable(i, true);
						SendClientMessagef(i, COLOR_YELLOW, "������ {%s}��� %s{FFFF00} ��������� ���������� {%s}��� %s{FFFF00} ����������� ���������", ColorTeam[Command[0]], Fraction_Name[Command[0]], ColorTeam[Command[1]], Fraction_Name[Command[1]]);
						ClearCapture();
					}
				}
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pOnCapture] == 1 || GetPVarInt(i, "DeathOnCapture") == 0 || PI[i][pMember] == Command[1])
					{
						SetPlayerPos(i, 1524.0425,-1212.5947,15.0275);
						SetPlayerFacingAngle(i, 87.1295);
					}
				}
				GangWarStatus = 0;
			}
			if(CommandRounds[0] > CommandRounds[1])
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
					{
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
						TogglePlayerControllable(i, true);
						SendClientMessagef(i, COLOR_YELLOW, "������ {%s}��� %s{FFFF00} ��������� ���������� {%s}��� %s{FFFF00} ����������� �������", ColorTeam[Command[0]], Fraction_Name[Command[0]], ColorTeam[Command[1]], Fraction_Name[Command[1]]);
						ClearCapture();
					}
				}
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pOnCapture] == 1 || GetPVarInt(i, "DeathOnCapture") == 0 || PI[i][pMember] == Command[0])
					{
						SetPlayerPos(i, 1524.0425,-1212.5947,15.0275);
						SetPlayerFacingAngle(i, 87.1295);
					}
				}
				GangWarStatus = 0;
			}	
		}		
	}
}
stock FinishRound(playerid)
{
	if(GetPVarInt(playerid, "DeathOnCapture") == 1)
	{
		SetTimerEx("DeathFinishRound", 4900, false, "d", playerid);
	}
	else 
	{
		TogglePlayerControllable(playerid, false);
		SetTimerEx("NoDeathFinishRound", 4900, false, "d", playerid);
	}
}
callback: DeathFinishRound(playerid)
{
	for(new i = 0; i < 13; i++) 
	{
	    if(PI[playerid][data_GUN][i] != 0 && PI[playerid][data_AMMO][i] != 0) GivePlayerWeapon(playerid, PI[playerid][data_GUN][i], PI[playerid][data_AMMO][i]);
	}
	SetPlayerHealthAC(playerid, 176);
	TogglePlayerControllable(playerid, false);
	new id = GetPlayerID(playerid);
	SetPlayerPos(playerid, SpawnPositions[GangWarInfo[id][gSpawnID]][0], SpawnPositions[GangWarInfo[id][gSpawnID]][1], SpawnPositions[GangWarInfo[id][gSpawnID]][2]);
	SetPlayerFacingAngle(playerid, SpawnPositions[GangWarInfo[id][gSpawnID]][3]);
	SetTimerEx("UnWairToStart", 5000, false, "d", playerid);
	return 1;
}
callback: NoDeathFinishRound(playerid)
{
	for(new i = 0; i < 13; i++) 
	{
	    if(PI[playerid][data_GUN][i] != 0 && PI[playerid][data_AMMO][i] != 0) GivePlayerWeapon(playerid, PI[playerid][data_GUN][i], PI[playerid][data_AMMO][i]);
	}
	SetPlayerHealthAC(playerid, 176);
	TogglePlayerControllable(playerid, false);
	new id = GetPlayerID(playerid);
	SetPlayerPos(playerid, SpawnPositions[GangWarInfo[id][gSpawnID]][0], SpawnPositions[GangWarInfo[id][gSpawnID]][1], SpawnPositions[GangWarInfo[id][gSpawnID]][2]);
	SetPlayerFacingAngle(playerid, SpawnPositions[GangWarInfo[id][gSpawnID]][3]);
	SetTimerEx("UnWairToStart", 5000, false, "d", playerid);
	return 1;
}
stock WaitToStart(playerid) // ������ �������
{
	TogglePlayerControllable(playerid, false);
	new id = GetPlayerID(playerid);
	SetPlayerPos(playerid, SpawnPositions[GangWarInfo[id][gSpawnID]][0], SpawnPositions[GangWarInfo[id][gSpawnID]][1], SpawnPositions[GangWarInfo[id][gSpawnID]][2]);
	SetPlayerFacingAngle(playerid, SpawnPositions[GangWarInfo[id][gSpawnID]][3]);
	SetTimerEx("UnWairToStart", 5000, false, "d", playerid);
}
callback: UnWairToStart(playerid)
{
	PlayerPlaySound(playerid, 1137, 0.0, 0.0, 10.0);
	SetPVarInt(playerid, "DeathOnCapture", 0);
	TogglePlayerControllable(playerid, true);
}
stock GetColorZone(team)
{
	new col;
	switch(team) 
	{
		case 5: col = 0x663399BB;
		case 6: col = 0x66CCFFBB;
		case 7: col = 0x339933AA;
	}
	return col;
}
stock capture_OnDialogResponse(playerid, dialogid, response, listitem)
{
    switch(dialogid)
    {
        case 4901:
        {
            if(!response) return 1;
            if(response)
            {
				if(PI[playerid][pOnCapture] == 1) return SendClientMessage(playerid, COLOR_LIGHTGREY, !"�� ��� ���������������� �� ������� � ������");
                if(!AddPlayerToCapture(playerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, !"��������� ���� ��� ��� (7/7)");
                else 
                {
                    static name[24];
                    SetString(name, NameRang(playerid));
                    name = NameRang(playerid);
                    
					new count = GetCountonGanwWar(PI[playerid][pMember]);

                    SendFractionMessagef(PI[playerid][pMember], 0x69b867FF, "[R] %s %s[%d] ������������� � ���������� ������ (%d/7)",\
                        name, getName(playerid), playerid, count);
                }
            }
        }
		case 4903:
		{
			if(!response) return 1;
			if(response)
			{
				new id = ShowTeam[playerid][listitem];

				if(PI[id][pOnCapture] == 0) return SendClientMessage(playerid, COLOR_LIGHTGREY, !"������ ����� �� ��������� ������� � ������� ����������");
                    
				for (new i = 0; i < sizeof(GangWarInfo); i++)
				{
					if(GangWarInfo[i][gPlayerID] == id)
					{
						GangWarInfo[i][gPlayerID] = -1;
						GangWarInfo[i][gMember] = -1;
						GangWarInfo[i][gSpawnID] = -1;
					}
				}
				PI[id][pOnCapture] = 0;

				new count = GetCountonGanwWar(PI[playerid][pMember]);

				SendFractionMessagef(PI[playerid][pMember], COLOR_TOMATO, "[R] %s %s[%d] �������� %s %s[%d] �� ���������� ������ (%d/7)",\
					NameRang(playerid), getName(playerid), playerid, NameRang(id), getName(id), id, count);
			}
		}
    }
    return 1;
}
stock AutoKickCapture(playerid)
{
	if(PI[playerid][pOnCapture] == 1 && GangWarStatus >= 1)
	{
		for (new i = 0; i < sizeof(GangWarInfo); i++)
		{
			if(GangWarInfo[i][gPlayerID] == playerid)
			{
				GangWarInfo[i][gPlayerID] = -1;
				GangWarInfo[i][gMember] = -1;
				GangWarInfo[i][gSpawnID] = -1;
			}
		}
		PI[playerid][pOnCapture] = 0;
		new count = GetCountonGanwWar(PI[playerid][pMember]);

		SendFractionMessagef(PI[playerid][pMember], COLOR_TOMATO, "[R] %s %s[%d] ������������� �������� �� ���������� ������ (%d/7)",\
			NameRang(playerid), getName(playerid), playerid, count);
	}
}
stock CheckCount(playerid)
{
	if(GangWarStatus > 1)
	{
		if(count_1 <= 0 && count_2 <= 0)
		{			
			if(PI[playerid][pMember] == Command[0] && count_1 <= 0)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
					{
						GangZoneStopFlashForPlayer(i, WarZone);
						new col;
						switch(Command[1]) {
							case 5: col = 0x663399BB;
							case 6: col = 0x66CCFFBB;
							case 7: col = 0x339933AA;
						}
						GangZoneHideForPlayer(i, WarZone);
						GangZoneShowForPlayer(i, WarZone, col);
						ClearKillFeed(i);
						cef_emit_event(i, "hide-capture");
						cef_emit_event(i, "clear-kill-list");
						TogglePlayerControllable(i, true);
						SendClientMessagef(i, COLOR_YELLOW, "������ {%s}��� %s{FFFF00} ��������� ���������� {%s}��� %s{FFFF00} ����������� ���������", ColorTeam[Command[0]], Fraction_Name[Command[0]], ColorTeam[Command[1]], Fraction_Name[Command[1]]);
						ClearCapture();
					}
				}
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pOnCapture] == 1 || GetPVarInt(i, "DeathOnCapture") == 0 || PI[i][pMember] == Command[1])
					{
						SetPlayerPos(i, 1524.0425,-1212.5947,15.0275);
						SetPlayerFacingAngle(i, 87.1295);
					}
				}
				GangWarStatus = 0;
			}
			if(PI[playerid][pMember] == Command[1] && count_2 <= 0)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
					{
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
						TogglePlayerControllable(i, true);
						SendClientMessagef(i, COLOR_YELLOW, "������ {%s}��� %s{FFFF00} ��������� ���������� {%s}��� %s{FFFF00} ����������� �������", ColorTeam[Command[0]], Fraction_Name[Command[0]], ColorTeam[Command[1]], Fraction_Name[Command[1]]);
						ClearCapture();
					}
				}
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(PI[i][pOnCapture] == 1 || GetPVarInt(i, "DeathOnCapture") == 0 || PI[i][pMember] == Command[0])
					{
						SetPlayerPos(i, 1524.0425,-1212.5947,15.0275);
						SetPlayerFacingAngle(i, 87.1295);
					}
				}
				GangWarStatus = 0;
			}
		}
	}
}
stock capture_OnPlayerDisconnect(playerid)
{
	if(PI[playerid][pOnCapture] == 1 && GangWarStatus == 1)
	{
		for (new i = 0; i < sizeof(GangWarInfo); i++)
		{
			if(GangWarInfo[i][gPlayerID] == playerid)
			{
				GangWarInfo[i][gPlayerID] = -1;
				GangWarInfo[i][gMember] = -1;
				GangWarInfo[i][gSpawnID] = -1;
			}
		}
		PI[playerid][pOnCapture] = 0;
		new count = GetCountonGanwWar(PI[playerid][pMember]);

		SendFractionMessagef(PI[playerid][pMember], 0x69b867FF, "[R] %s %s[%d] ������������� �������� �� ���������� ������ (%d/7)",\
			NameRang(playerid), getName(playerid), playerid, count);

		if(PI[playerid][pMember] == Command[0]) count_1--;
		else if(PI[playerid][pMember] == Command[1]) count_2--;

		CheckCount(playerid);
	}
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
                    if (GangWarInfo[i][gPlayerID] == -1)
                    {
                        GangWarInfo[i][gMember] = PI[playerid][pMember];
                        GangWarInfo[i][gPlayerID] = playerid;
                        GangWarInfo[i][gSpawnID] = spawnID;
						PI[playerid][pOnCapture] = 1;
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
                    if (GangWarInfo[i][gPlayerID] == -1)
                    {
                        GangWarInfo[i][gMember] = PI[playerid][pMember];
                        GangWarInfo[i][gPlayerID] = playerid;
                        GangWarInfo[i][gSpawnID] = spawnID;
						PI[playerid][pOnCapture] = 1;
                        return 1;
                    }
                }
            }
        }
    }
    for (new i = 0; i < sizeof(GangWarInfo); i++)
    {
        if(GangWarInfo[i][gPlayerID] == -1)
        {
            GangWarInfo[i][gMember] = PI[playerid][pMember];
            GangWarInfo[i][gPlayerID] = playerid;
            GangWarInfo[i][gSpawnID] = spawnID;
			PI[playerid][pOnCapture] = 1;
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
stock GetCountonGanwWar(org)
{
	new count;
    for (new i = 0; i < sizeof(GangWarInfo); i++)
    {
        if(GangWarInfo[i][gMember] == org)
        {
            count++;
        }
    }
    return count;
}
stock ClearCapture()
{
	for (new i = 0; i < sizeof(GangWarInfo); i++)
    {
		GangWarInfo[i][gMember] = 0;
		GangWarInfo[i][gPlayerID] = -1;
		GangWarInfo[i][gSpawnID] = -1;
    }
	CommandRounds[0] = 0;
	CommandRounds[0] = 0;
	CommandKill[0] = 0;
	CommandKill[0] = 0;
	count_1 = 0;
	count_2 = 0;
}
//===============================================================[ CMD ]===============================================================//
cmd:capture(playerid) 
{
    if(!IsPlayerOPG(playerid))  return SCM(playerid, COLOR_GREY, !"�� �� �������� � ���");
    if(PI[playerid][pRang] < 7) return SCM(playerid, COLOR_GREY, !"������ ������� ����� ������������ � 7-�� �����");
	new gz = GetPlayerGangZone(playerid);
	if(gz == -1) return SCM(playerid, COLOR_GREY, !"�� �� ���������� �� � ����� �� ���");
    if(GetPVarInt(playerid,"Counting_Capture") > gettime()) return SCM(playerid, COLOR_GREY, !"������� ����� ������������ ��� � 1 ������");
    SetPVarInt(playerid,"Counting_Capture",gettime() + 59);

    new hour, minute, second;
    gettime(hour, minute, second);
    
    if(capturetime == 1) 
	{
		if(!((hour >= 12 && hour <= 19) && minute == 0) && !(hour >= 20 && hour <= 23) && !(hour >= 0 && hour <= 9))
		{
			return SCM(playerid, COLOR_GREY, !"������ ���������� ��� ����� ��� �������� � 12:00, 13:00, 14:00, 15:00, 16:00, 17:00, 18:00, 20:00, 21:00, 22:00, 23:00");
		}
	}

	if(GangWarStatus == 1) return SCM(playerid, COLOR_GREY, !"� ������ ������ ��� ���� ����� �� ����������");
    if(gz_info[gz][gzopg] == PI[playerid][pMember]) return SCM(playerid, COLOR_GREY, !"�� �� ������ ��������� ���� ����������");

	switch(gz_info[gz][gzopg]) 
	{
	    case 5: if(m_skinhead > 1) return SCM(playerid, COLOR_GREY, !"� ������ ��� ����������� ������� ����������");
		case 6: if(m_gopota > 1) return SCM(playerid, COLOR_GREY, !"� ������ ��� ����������� ������� ����������");
		case 7: if(m_kavkaz > 1) return SCM(playerid, COLOR_GREY, !"� ������ ��� ����������� ������� ����������");
	}
	switch(PI[playerid][pMember]) 
	{
	    case 5: if(m_skinhead > 1) return SCM(playerid, COLOR_GREY, !"� ����� ��� ����������� ������� ����������");
		case 6: if(m_gopota > 1) return SCM(playerid, COLOR_GREY, !"� ����� ��� ����������� ������� ����������");
		case 7: if(m_kavkaz > 1) return SCM(playerid, COLOR_GREY, !"� ����� ��� ����������� ������� ����������");
	}
    if(gz_info[gz][gzid] == 101) return 1;

    new warname[15];
	if(gz_info[gz][gzopg] == 5) warname = "'��������'";
	if(gz_info[gz][gzopg] == 6) warname = "'������'";
	if(gz_info[gz][gzopg] == 7) warname = "'��������'";

	PI[playerid][pCaptureValue]++;
	PI[playerid][pProgressCapture]+= 1;

	GangWarStatus = 1;
	//
	WarTimeMin = 5;
	WarTimeSec = 1;
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
     	case 5:format(str,sizeof(str),"%s {3377CC}%s[%d] {3377CC}(%s){FFFF00} ����������� ������ ���������� {3377CC}(%s)", name, getName(playerid), playerid, Fraction_Name[PI[playerid][pMember]], warname);
   		case 6:format(str,sizeof(str),"%s {3377CC}%s[%d] {3377CC}(%s){FFFF00} ����������� ������ ���������� {3377CC}(%s)", name, getName(playerid), playerid, Fraction_Name[PI[playerid][pMember]], warname);
	    case 7:format(str,sizeof(str),"%s {3377CC}%s[%d] {3377CC}(%s){FFFF00} ����������� ������ ���������� {3377CC}(%s)", name, getName(playerid), playerid, Fraction_Name[PI[playerid][pMember]], warname);
	}
    static name_org[15], nameorg[15];
    switch(Command[0]) 
	{
        case 5: name_org = "��������";
        case 6: name_org = "������";
        case 7: name_org = "��������";
    }
    switch(Command[1]) 
	{
        case 5: nameorg = "��������";
        case 6: nameorg = "������";
        case 7: nameorg = "��������";
    }
	SCM(playerid, COLOR_YELLOW, !"�� ��������� ������� ���������� �� �������� �������������� � PayDay"); 
	foreach(new i:Player) 
	{
	    if(PI[i][pMember] == Command[0] || PI[i][pMember] == Command[1])
		{
			SCM(i, COLOR_YELLOW, str);
			SCM(i, COLOR_YELLOW, !"���������� �������� � ��� �� ����-����� ������� (��������) ���������������");
			SCM(i, COLOR_YELLOW, !"����� �������� �������� � ��� �� ����-����� ������� (�� ��������!) ��������������� � ����� ����� �����");
			SCM(i, COLOR_YELLOW, !"����������� ������� {3377CC}/cteam{FFFF00}, ����� ���������� ������ ���������� ����� ��� �� ���������� ������");
			cef_emit_event(i, "show-capture");
			cef_emit_event(i, "capture-score", CEFINT(CommandKill[0]), CEFINT(CommandKill[1]));
			cef_emit_event(i, "capture-text", CEFSTR("���������� � �����"));
			cef_emit_event(i, "capture-info-name", CEFSTR(name_org), CEFSTR(nameorg));
			cef_emit_event(i, "show_kill_list");
			GangZoneFlashForPlayer(i, gz, 0xFF000055);	
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
			ShowTeam[playerid][count] = GangWarInfo[i][gPlayerID];
            count++;
            SetString(name, NameRang(GangWarInfo[i][gPlayerID]));
            name = NameRang(GangWarInfo[i][gPlayerID]);
            format(string,sizeof(string),"%s%d\t%s[%d]\t%s[%d]\t%d ��\n", string, count, PI[GangWarInfo[i][gPlayerID]][pName], GangWarInfo[i][gPlayerID], name, PI[GangWarInfo[i][gPlayerID]][pRang], GetPlayerPing(GangWarInfo[i][gPlayerID]));
			bugfix = 1;
		}
	}
	if(bugfix == 0) ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{ee3366}��������� ������", "{FFFFFF}������ ���������� ����.", "�������", "");
	else 
    {
        if(PI[playerid][pCaptureManager] == 1 || PI[playerid][pRang] >= 9)
        {
		    new str_1[512*2];
		    format(str_1,sizeof(str_1),"�\t�����\t����\t����\n%s",string);
		    ShowPlayerDialog(playerid, 4903, DIALOG_STYLE_TABLIST_HEADERS, "{ee3366}��������� ������", str_1, "���������", "�������");
        }
        else
        {
            new str_1[512*2];
		    format(str_1,sizeof(str_1),"�\t�����\t����\t����\n%s",string);
		    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, "{ee3366}��������� ������", str_1, "�������", "");
        }
	}
	return 1;
}
CMD:test(playerid)
{
	SendClientMessagef(playerid, -1, "count_1 %d, count_2, %d", count_1, count_2);
	return 1;
}
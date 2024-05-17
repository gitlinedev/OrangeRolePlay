new ArmyStorage;
new TimetTheftCartridges[MAX_PLAYERS];

callback: TheftCartridges(playerid)
{
	if(!PlayerToPoint(1.7, playerid, 1567.5477,1823.2529,15.6548)) return KillTimer(TimetTheftCartridges[playerid]);
    if(ArmyStorage == 0) return SendClientMessage(playerid, COLOR_GREY, !"Склад организации 'Воинская часть' закрыт игровым мастером"), KillTimer(TimetTheftCartridges[playerid]);
	switch(PI[playerid][pMember]) 
	{
		case 5,6,7: 
		{
			if(army_wh[1] > 0) 
			{
				if(PI[playerid][data_VIP] == 0)
				{
				    if(PI[playerid][data_PATR] < 400)
					{
						new patr,str[47];
						patr = RandomEX(2,5);
						PI[playerid][data_PATR] += patr;
						if(PI[playerid][data_PATR] > 400) PI[playerid][data_PATR] = 400;
						if(PI[playerid][data_MET] > 40) PI[playerid][data_MET] = 40;
						army_wh[1] -= patr;
						SaveWarehouse();
						UpdatePlayerDataInt(playerid, "met", PI[playerid][data_MET],2577);
						UpdatePlayerDataIntNoLog(playerid, "patr", PI[playerid][data_PATR]);
						format(str,sizeof(str),"Загружено патронов: %d / 400 шт", PI[playerid][data_PATR]);
						cef_emit_event(playerid, "show-ammo-notify", CEFSTR(str), CEFSTR("7fa1a1"));
						HidePlayerSpeedometer(playerid);
				    }
					else SCM(playerid, COLOR_GREY, !"У Вас полные карманы патронов, места больше нет");
				}
				else
				{
				    if(PI[playerid][data_PATR] < 800)
					{
						new patr,str[47];
						patr = RandomEX(2,5);
						PI[playerid][data_PATR] += patr;
						if(PI[playerid][data_PATR] > 800) PI[playerid][data_PATR] = 800;
						if(PI[playerid][data_MET] > 80) PI[playerid][data_MET] = 80;
						army_wh[1] -= patr;
						SaveWarehouse();
						UpdatePlayerDataInt(playerid, "met", PI[playerid][data_MET],2595);
						UpdatePlayerDataIntNoLog(playerid, "patr", PI[playerid][data_PATR]);
						format(str,sizeof(str),"Загружено патронов: %d / 800 шт", PI[playerid][data_PATR]);
						cef_emit_event(playerid, "show-ammo-notify", CEFSTR(str), CEFSTR("7fa1a1"));
						HidePlayerSpeedometer(playerid);
					}
				    else SCM(playerid, COLOR_GREY, !"У Вас полные карманы патронов, места больше нет");
				}
			}
			new str_1[256];
			format(str_1,sizeof(str_1),"{f18c2b}Армейский склад\n\n{FFFFFF}Металл: %d кг.\n{fccf39}Патроны: %d шт.",army_wh[0],army_wh[1]);
			UpdateDynamic3DTextLabelText(army_sklad_text, -1, str_1);
		}
	}
	return 1;
}
callback: CloseArmyStorageDoor(playerid) 
{
	MoveObject(VchSkladGate, 1568.80, 1809.53, 16.25, 1.9, 0.00, 0.00, 90.00);
	return KillTimer(ArmyStorageDoorTimer);
}
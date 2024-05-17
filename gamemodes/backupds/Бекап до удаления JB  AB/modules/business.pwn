stock business_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    return 1;
}



CMD:business(playerid) 
{
    if(antiflood[playerid] > 0) return SCM(playerid, COLOR_BLACK, !"Пожалуйста, подождите пару секунд...");
    antiflood[playerid]++;
    if(!IsPlayerLogged{playerid}) return 1;
    if(PI[playerid][data_BUSINESS] == INVALID_BUSINESS_ID && PI[playerid][data_JB] == INVALID_JB_ID && PI[playerid][data_AB] == INVALID_AB_ID) 
        return SCM(playerid, COLOR_GREY, !"У Вас нет бизнеса");
	
    new str_3[365];
	if(PI[playerid][data_JB] != INVALID_BUSINESS_ID) {
	    new b = PI[playerid][data_JB];
	    format(str_3 ,sizeof(str_3), "Информация\nУправление автопарком\nИзменить зарплату рабочих ({66FF66}%d рублей{FFFFFF})\nИзменить зарплату водителей ({66FF66}%d рублей{FFFFFF})\nИзменить стоимость экспорта ресурсов\nСнять деньги со счета\nПоложить деньги на счет\n{FF0033}Продать предприятие государству",JB_DATA[b][data_JOB_MONEY], JB_DATA[b][data_BUS_MONEY]);
	    ShowPlayerDialog(playerid, dialog_JB, DIALOG_STYLE_LIST, "{ee3366}Управление бизнесом", str_3, "Выбрать", "Отмена");
	}
	else if(PI[playerid][data_AB] != INVALID_AB_ID) {
	    new b = PI[playerid][data_AB];
	    format(str_3 ,sizeof(str_3), "Информация\nУправление автопарком\nИзменить процент зарплаты водителей ({66FF66}%d процентов{FFFFFF})\nСнять деньги со счета\nПоложить деньги на счет\n{FF0033}Продать автобазу государству",AB_DATA[b][data_PROCENT]);
	    ShowPlayerDialog(playerid, dialog_AB, DIALOG_STYLE_LIST, "{ee3366}Управление бизнесом", str_3, "Выбрать", "Отмена");
	}
	else if(PI[playerid][data_BUSINESS] != INVALID_BUSINESS_ID) return Business_Panel(playerid);
	return 1;
}

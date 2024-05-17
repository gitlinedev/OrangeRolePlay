callback: CheckBlackListBl(playerid) 
{
	new rows, fields;
    cache_get_data(rows, fields);
    if(rows) 
    {
	    if(PI[playerid][pRang] < 9) return SCM(playerid, COLOR_GREY, !"Данная команда Вам недоступна");

        f(global_str, 100, "SELECT * FROM `fractions_blacklist` WHERE `bl_fraction` = '%d'", PI[playerid][pMember]);
	    mysql_tquery(mysql, global_str, "BlackList", "d", playerid);
	}
	else ShowPlayerDialog(playerid, d_blacklist, DIALOG_STYLE_LIST, "{ee3366}Чёрный список", "1. Добавить в ЧС\n2. Убрать из ЧС", "Выбрать", "Назад");
	return 1;
}
CMD:bl(playerid) 
{
    if(PI[playerid][pRang] < 9) return SCM(playerid, COLOR_GREY, !"Данная команда Вам недоступна");

    f(global_str, 100, "SELECT * FROM `fractions_blacklist` WHERE `bl_fraction` = '%d'", PI[playerid][pMember]);
    mysql_tquery(mysql, global_str, "BlackList", "d", playerid);

	new str_q[256];
    mysql_format(mysql, str_q, sizeof(str_q), "SELECT * FROM `fractions_blacklist` WHERE bl_fraction = '%d'",PI[playerid][pMember]);
	mysql_function_query(mysql, str_q, true, "CheckBlackListBl", "d", playerid);
	return 1;
}
callback: BlackList(playerid) {
    new rows, fields;
    new bl_name[MAX_PLAYER_NAME], string5[50];
	new dialog1[256];
	new dialog[556];
    cache_get_data(rows, fields);
    for(new i = 0; i < rows; i++) {
		cache_get_field_content(i, "bl_name", bl_name, mysql, MAX_PLAYER_NAME);
		format(dialog1,sizeof(dialog1),"%s%s\n", dialog1, bl_name);
		format(string5,sizeof(string5),"{ee3366}Показано %d из %d игроков (страница: 1)", rows, rows);
	}
	format(dialog,sizeof(dialog),"Чёрный Список\n{FFFF99}1. Добавить в ЧС\n{FFFF99}2. Убрать из ЧС{FFFFFF}\n%s",dialog1);
	ShowPlayerDialog(playerid,7887, DIALOG_STYLE_TABLIST_HEADERS, string5, dialog, "Закрыть", "");
	return 1;
}
callback: check_bl_list(playerid, pl_name[]) {
	new rows, fields;
	cache_get_data(rows, fields);
	if(rows) {
    	new str_q[256];
    	mysql_format(mysql,str_q, sizeof(str_q), "DELETE FROM `fractions_blacklist` WHERE `bl_name` = '%s' AND `bl_fraction` = '%d'", pl_name, PI[playerid][pMember]);
    	mysql_function_query(mysql, str_q, false, "", "");
		SCMf(playerid, COLOR_GREEN, "Вы убрали из чёрного списка {FFFF33}%s.", pl_name); // ПРОВЕРИТЬ
		switch(PI[playerid][pMember]) 
		{
		    case 1: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_gov[PI[playerid][pRang]-1][frName],getName(playerid),playerid,pl_name);
		    case 2: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_army[PI[playerid][pRang]-1][frName],getName(playerid),playerid,pl_name);
		    case 3: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_police[PI[playerid][pRang]-1][frName],getName(playerid),playerid,pl_name);
		    case 4: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_hospital[PI[playerid][pRang]-1][frName],getName(playerid),playerid,pl_name);
	     	case 5: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_skinhead[PI[playerid][pRang]-1][frName],getName(playerid),playerid,pl_name);
	   		case 6: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_gopota[PI[playerid][pRang]-1][frName],getName(playerid),playerid,pl_name);
		    case 7: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_kavkaz[PI[playerid][pRang]-1][frName],getName(playerid),playerid,pl_name);
		}
		ShowPlayerDialog(playerid, d_blacklist, DIALOG_STYLE_LIST, "Чёрный список", "1. Добавить в ЧС\n2. Убрать из ЧС", "Выбрать", "Назад");
	}
	else {
		SCMf(playerid, COLOR_GREY, "Игрок %s не найден в ЧС.", pl_name);
		ShowPlayerDialog(playerid, d_blacklist, DIALOG_STYLE_LIST, "Чёрный список", "1. Добавить в ЧС\n2. Убрать из ЧС", "Выбрать", "Назад");
	}
	return 1;
}
callback: CheckBlackListPlayer(playerid)
{
	new rows, fields;
    cache_get_data(rows, fields);
    if(rows) {
		new str_q[256];
		mysql_format(mysql,str_q,sizeof(str_q),"SELECT * FROM `fractions_blacklist` WHERE `bl_name` = '%e'",getName(playerid));
		mysql_function_query(mysql, str_q, true, "BlackList123", "i", playerid);
	}
	else ShowPlayerDialog(playerid,0, DIALOG_STYLE_MSGBOX, !"{ee3366}Чёрный список организаций", "Вы не состоите в чёрном списке ни одной организации", "Закрыть", "");
	return 1;
}
callback: BlackList123(playerid) {
    new rows, fields,temp[256],fracname5,dob[32],day,reas[32],rank[32];
    cache_get_data(rows, fields);
	new str_1[256];
    for(new i = 0; i < rows; i++) {
		cache_get_field_content(i, "bl_dob", dob, mysql, 32);
		cache_get_field_content(i, "bl_day", temp), day = strval(temp);
		cache_get_field_content(i, "bl_fraction", temp), fracname5 = strval(temp);
		cache_get_field_content(i, "bl_reason", reas, mysql, 32);
		cache_get_field_content(i, "bl_rank", rank, mysql, 32);
		new fracname[64];
		switch(fracname5) {
			case 1: fracname = "Правительство";
			case 2: fracname = "Войсковая часть";
			case 3: fracname = "Полиция";
   			case 4: fracname = "БЦРБ";
			case 5: fracname = "Скинхеды";
			case 6: fracname = "Гопота";
			case 7: fracname = "Кавказцы";
  		}
		format(str_1,sizeof(str_1),"%s%s (%s %s)\t%d дней\t%s\n", str_1, fracname,rank, dob,day,reas);
	}
	new dialog[556];
	format(dialog,sizeof(dialog),"Организация(добавил)\tОсталось дней\tПричина\n%s",str_1);
	ShowPlayerDialog(playerid,0, DIALOG_STYLE_TABLIST_HEADERS, "{ee3366}Чёрный список организаций", dialog, "Закрыть", "");
	return 1;
}
callback: BlackListCheck(playerid, pl_name[]) {
	new rows, fields,temp[516],dob[64],day,reas[64],rank[64],bl_name[64],bl_name2[64];
    cache_get_data(rows, fields);
	new str_3[512];
    for(new i = 0; i < rows; i++) {
        cache_get_field_content(i, "bl_name", bl_name, mysql, 63);
		cache_get_field_content(i, "bl_dob", dob, mysql, 63);
		cache_get_field_content(i, "bl_day", temp), day = strval(temp);
		cache_get_field_content(i, "bl_reason", reas, mysql, 63);
		cache_get_field_content(i, "bl_rank", rank, mysql, 63);
		cache_get_field_content(i, "bl_name2", bl_name2, mysql, 63);
		format(str_3,sizeof(str_3),"%s{FFFFFF}Имя на момент внесения: {274e87}\t%s\n\
		{FFFFFF}Имя в данный момент: {274e87}\t%s\n\
		{FFFFFF}Внёс в чёрный список: {274e87}\t%s %s\n\
		{FFFFFF}Вынесение через: \t{274e87}\t%d дней\n\
		{FFFFFF}Причина: \t\t\t{274e87}%s\n\n\
		{696969}Вы хотите удалить игрока из черного списка организации?", str_3, bl_name, bl_name2,rank, dob,day,reas);
		SetPVarString(playerid, "name_bl", pl_name);
	}
	ShowPlayerDialog(playerid,7874, DIALOG_STYLE_MSGBOX, !"{ee3366}Чёрный список организации", str_3, "Ок", "Закрыть");
	return 1;
}
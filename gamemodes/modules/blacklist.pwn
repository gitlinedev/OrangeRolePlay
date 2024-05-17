stock bl_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    switch(dialogid)
    {
        case 7887:
		{
			if(!response) return 1;
			if(response)
			{
	   	        switch(listitem) 
				{
					case 0: ShowPlayerDialog(playerid, 3126, DIALOG_STYLE_INPUT, "{ee3366}Добавить в чёрный список", "{FFFFFF}Введите имя игрока и причину через запятую\n{FFFF99}Например: Fedor_Badrov, НВЗ\n\n{696969}Игрок будет внесён в ЧС на 15 дней", "Добавить", "Отмена");
					case 1: ShowPlayerDialog(playerid, 3125, DIALOG_STYLE_INPUT, "{ee3366}Чёрный список", "{FFFFFF}Введите имя игрока, которого хотите удалить из чёрного списка:", "Принять", "Назад");
					default: 
					{
						new str_q[135];
						mysql_format(mysql,str_q,sizeof(str_q),"SELECT * FROM `fractions_blacklist` WHERE `bl_name` = '%e' AND `bl_fraction` = '%d' LIMIT 1",inputtext,PI[playerid][pMember]);
						mysql_function_query(mysql, str_q, true, "BlackListCheck", "ds", playerid, inputtext);
					}
				}
			}
		}
        case 3127: 
        {
			if(!response) return callcmd::lmenu(playerid);
   	        switch(listitem)
            {
				case 0: ShowPlayerDialog(playerid, 3126, DIALOG_STYLE_INPUT, !"{ee3366}Добавить в чёрный список", !"{FFFFFF}Введите имя игрока и причину через запятую\n{FFFF99}Например: Fedor_Badrov, НВЗ\n\n{696969}Игрок будет внесён в ЧС на 15 дней", !"Добавить", !"Отмена");
				case 1: ShowPlayerDialog(playerid, 3125, DIALOG_STYLE_INPUT, !"{ee3366}Чёрный список", !"{FFFFFF}Введите имя игрока, которого хотите удалить из чёрного списка\n{FFFF99}Например: Fedor_Badrov", !"Принять", !"Назад");
			}
		}
		case 3128:
		{
		    if(PI[playerid][pAdmin] < 4) return SCM(playerid, COLOR_GREY, !"Для полной очистки чёрного списка организации, обратитесь к игровым мастерам.");
			if(!response)return ShowPlayerDialog (playerid, 3127, DIALOG_STYLE_LIST, !"{ee3366}Чёрный список", !"1. Добавить в ЧС\n2. Убрать из ЧС", !"Выбрать", !"Назад");

            mysql_tqueryf(mysql, "DELETE FROM `fractions_blacklist` WHERE `bl_fraction` = '%d'", PI[playerid][pMember]);

			SCM(playerid, COLOR_YELLOW, !"Чёрный список успешно очищен.");
			ShowPlayerDialog(playerid, 3127, DIALOG_STYLE_LIST, !"{ee3366}Чёрный список", !"1. Добавить в ЧС\n2. Убрать из ЧС", !"Выбрать", !"Назад");
		}
		case 3126:
		{
			new name[25], reason[33];
			sscanf(inputtext, "p<,>s[24]s[32]", name, reason);

            mysql_string[0] = EOS, f(mysql_string, 115, "SELECT * FROM `fractions_blacklist` WHERE bl_fraction = '%d' AND bl_name = '%s' LIMIT 1", PI[playerid][pMember], name);
	        mysql_tquery(mysql, mysql_string, "GiveBlackList", "ds", playerid, name);

		    SetPVarString(playerid, "reason_bl", reason);
		}
		case 3125:
		{
			if(!response) return ShowPlayerDialog(playerid, 3127, DIALOG_STYLE_LIST, "{ee3366}Чёрный список", "1. Добавить в ЧС\n2. Убрать из ЧС", "Выбрать", "Назад");
			
            if(!strlen(inputtext)) 
                return ShowPlayerDialog(playerid, 3125, DIALOG_STYLE_INPUT, !"{ee3366}Чёрный список", !"{FFFFFF}Неверный формат никнейма!\n\n\
                                                        {FFFF99}Введите имя игрока, которого хотите удалить из чёрного списка:", !"Принять", !"Назад");
			if(IsTextInvalid(inputtext)) 
                return ShowPlayerDialog(playerid, 3125, DIALOG_STYLE_INPUT, !"{ee3366}Чёрный список", !"{FFFFFF}Неверный формат никнейма!\n\n\
                                                        {FFFF99}Введите имя игрока, которого хотите удалить из чёрного списка:", !"Принять", !"Назад");
			if(strlen(inputtext) < 6 || strlen (inputtext) > 24) 
                return ShowPlayerDialog(playerid, 3125, DIALOG_STYLE_INPUT, !"{ee3366}Чёрный список", !"{FFFFFF}Неверный формат никнейма!\n\n\
                                                        {FFFF99}Введите имя игрока, которого хотите удалить из чёрного списка:", !"Принять", !"Назад");
			
            mysql_string[0] = EOS, f(mysql_string, 116, "SELECT * FROM `fractions_blacklist` WHERE `bl_name` = '%e' AND `bl_fraction`='%d' LIMIT 1", inputtext, PI[playerid][pMember]);
	        mysql_tquery(mysql, mysql_string, "CheckBlackList", "ds", playerid, inputtext);

		}
		case 7874:
		{
		  	if(!response) return 1;

			new name[45];
			GetPVarString(playerid,"name_bl", name, 45);

            mysql_string[0] = EOS, f(mysql_string, 116, "SELECT * FROM `fractions_blacklist` WHERE `bl_name` = '%e' AND `bl_fraction`='%d' LIMIT 1", name, PI[playerid][pMember]);
	        mysql_tquery(mysql, mysql_string, "CheckBlackList", "ds", playerid, name);
		}
    }
    return 1;
}
callback: CheckBlackListBl(playerid) 
{
	new rows, fields;
    cache_get_data(rows, fields);
    if(rows) 
    {
	    if(PI[playerid][pRang] < 9) return SCM(playerid, COLOR_GREY, !"Данная команда Вам недоступна");
        mysql_string[0] = EOS, f(mysql_string, 66, "SELECT * FROM `fractions_blacklist` WHERE `bl_fraction` = '%d'", PI[playerid][pMember]);
	    mysql_tquery(mysql, mysql_string, "BlackList", "d", playerid);
	}
	else ShowPlayerDialog(playerid, 3127, DIALOG_STYLE_LIST, "{ee3366}Чёрный список", "1. Добавить в ЧС\n2. Убрать из ЧС", "Выбрать", "Назад");
	return 1;
}
callback: BlackList(playerid) 
{
    new rows, fields;
    global_str = "";
    static Name[MAX_PLAYER_NAME]; Name = "";
    new DialogName[50];

    cache_get_data(rows, fields);
    for(new i = 0; i < rows; i++) 
    {
		cache_get_field_content(i, "bl_name", Name, mysql, MAX_PLAYER_NAME);
		format(global_str, sizeof(global_str),"%s%s\n", global_str, Name);
	}

    format(DialogName, sizeof(DialogName), "{ee3366}Показано %d из %d игроков (страница: 1)", rows, rows);
	format(global_str, sizeof(global_str), "Чёрный Список\n{FFFF99}1. Добавить в ЧС\n{FFFF99}2. Убрать из ЧС{FFFFFF}\n%s", global_str);

	ShowPlayerDialog(playerid, 7887, DIALOG_STYLE_TABLIST_HEADERS, DialogName, global_str, "Закрыть", "");
	return 1;
}
callback: CheckBlackList(playerid, name[]) 
{
	new rows, fields;
	cache_get_data(rows, fields);
	if(rows) 
    {
        mysql_tqueryf(mysql, "DELETE FROM `fractions_blacklist` WHERE `bl_name` = '%s' AND `bl_fraction` = '%d'", name, PI[playerid][pMember]);
		SCMf(playerid, COLOR_GREENNEW, "Вы убрали из чёрного списка {FFFF33}%s.", name);

		switch(PI[playerid][pMember]) 
		{
		    case 1: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_gov[PI[playerid][pRang]-1][frName],getName(playerid),playerid,name);
		    case 2: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_army[PI[playerid][pRang]-1][frName],getName(playerid),playerid,name);
		    case 3: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_police[PI[playerid][pRang]-1][frName],getName(playerid),playerid,name);
		    case 4: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_hospital[PI[playerid][pRang]-1][frName],getName(playerid),playerid,name);
	     	case 5: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_skinhead[PI[playerid][pRang]-1][frName],getName(playerid),playerid,name);
	   		case 6: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_gopota[PI[playerid][pRang]-1][frName],getName(playerid),playerid,name);
		    case 7: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] вынес %s из черного списка организации.",rang_kavkaz[PI[playerid][pRang]-1][frName],getName(playerid),playerid,name);
		}

		ShowPlayerDialog(playerid, 3127, DIALOG_STYLE_LIST, "Чёрный список", "1. Добавить в ЧС\n2. Убрать из ЧС", "Выбрать", "Назад");
	}
	else 
    {
		SCMf(playerid, COLOR_GREY, "Игрок %s не найден в ЧС.", name);
		ShowPlayerDialog(playerid, 3127, DIALOG_STYLE_LIST, "Чёрный список", "1. Добавить в ЧС\n2. Убрать из ЧС", "Выбрать", "Назад");
	}
	return 1;
}
callback: CheckBlackListPlayer(playerid)
{
	new rows, fields;
    cache_get_data(rows, fields);
    if(rows) 
    {
        mysql_string[0] = EOS, f(mysql_string, 85, "SELECT * FROM `fractions_blacklist` WHERE `bl_name` = '%e'", getName(playerid));
	    mysql_tquery(mysql, mysql_string, "LoadBlackListForPlayer", "d", playerid);
	}
	else ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"{ee3366}Чёрный список организаций", "{FFFFFF}Вы не состоите в чёрном списке ни одной организации", "Закрыть", "");
	return 1;
}
callback: LoadBlackListForPlayer(playerid) 
{
    new rows, fields, temp[15], from[32], reas[32], rank[32], day, fracname5;
    cache_get_data(rows, fields);

	new str_1[256+64];

    for(new i = 0; i < rows; i++) 
    {
		cache_get_field_content(i, "bl_dob", from, mysql, 32);
		cache_get_field_content(i, "bl_day", temp), day = strval(temp);
		cache_get_field_content(i, "bl_fraction", temp), fracname5 = strval(temp);
		cache_get_field_content(i, "bl_reason", reas, mysql, 32);
		cache_get_field_content(i, "bl_rank", rank, mysql, 32);
		new fracname[64];
		switch(fracname5) 
        {
			case 1: fracname = "Правительство";
			case 2: fracname = "Войсковая часть";
			case 3: fracname = "Полиция";
   			case 4: fracname = "БЦРБ";
			case 5: fracname = "Скинхеды";
			case 6: fracname = "Гопота";
			case 7: fracname = "Кавказцы";
  		}
		format(str_1,sizeof(str_1),"%s%s (%s %s)\t%d дней\t%s\n", str_1, fracname, rank, from, day, reas);
	}
	ShowPlayerDialogf(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, "{ee3366}Чёрный список организаций", "Закрыть", "", "Организация(добавил)\tОсталось дней\tПричина\n%s", str_1);
	return 1;
}
callback: BlackListCheck(playerid, name[]) 
{
	new rows, fields,temp[516],dob[64],day,reas[64],rank[64],bl_name[64],bl_name2[64];

    cache_get_data(rows, fields);

	new str_3[512];

    for(new i = 0; i < rows; i++) 
    {
        cache_get_field_content(i, "bl_name", bl_name, mysql, 63);
		cache_get_field_content(i, "bl_dob", dob, mysql, 63);
		cache_get_field_content(i, "bl_day", temp), day = strval(temp);
		cache_get_field_content(i, "bl_reason", reas, mysql, 63);
		cache_get_field_content(i, "bl_rank", rank, mysql, 63);
		cache_get_field_content(i, "bl_name2", bl_name2, mysql, 63);

		format(str_3,sizeof(str_3),"%s{FFFFFF}Имя на момент внесения: {3377cc}\t%s\n\
		{FFFFFF}Имя в данный момент: {3377cc}\t%s\n\
		{FFFFFF}Внёс в чёрный список: {3377cc}\t%s %s\n\
		{FFFFFF}Вынесение через: \t{3377cc}\t%d дней\n\
		{FFFFFF}Причина: \t\t\t{3377cc}%s\n\n\
		{696969}Вы хотите удалить игрока из черного списка организации?", str_3, bl_name, bl_name2,rank, dob,day,reas);
		SetPVarString(playerid, "name_bl", name);
	}
	ShowPlayerDialog(playerid, 7874, DIALOG_STYLE_MSGBOX, !"{ee3366}Чёрный список организации", str_3, "Ок", "Закрыть");
	return 1;
}
callback: GiveBlackList(playerid, name[]) 
{
	new rows, fields;
    cache_get_data(rows, fields);
    if(rows) SCM(playerid, COLOR_GREY, !"Данный игрок уже находится в чёрном списке вашей организации");
	else 
	{
		mysql_string[0] = EOS, f(mysql_string, 69, "SELECT * FROM `accounts` WHERE `Name` = '%e'", name);
	    mysql_tquery(mysql, mysql_string, "InsertBlackList", "ds", playerid, name);
	}
	return 1;
}
callback: InsertBlackList(playerid, PlayerName[]) 
{
    new rows, fields;
    cache_get_data(rows, fields);
    if(!rows) return SCM(playerid, COLOR_GREY, !"Вы ввели неверное имя, или же игрок изменил его.");
    if(rows) 
	{
		new text[32];
		GetPVarString(playerid, "reason_bl", text, sizeof(text));
		FixSVarString(text);

	    new ltext[12];
		switch(PI[playerid][pRang]) 
		{
			case 9: ltext = "Заместитель";
			case 10: ltext = "Лидер";
  		}

		mysql_tqueryf(mysql, "\
		INSERT INTO `fractions_blacklist`(`bl_fraction`,`bl_name`,`bl_day`,`bl_reason`,`bl_dob`,`bl_rank`,`bl_name2`) \
			VALUES\
		('%d','%s','15','%s','%s','%s','%s')", PI[playerid][pMember], PlayerName, text, getName(playerid), ltext, PlayerName);

		switch(PI[playerid][pMember]) 
		{
		    case 1: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] добавил %s в чёрный список на 15 дней. Причина: %s.",rang_gov[PI[playerid][pRang]-1][frName],getName(playerid),playerid,PlayerName,text);
		    case 2: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] добавил %s в чёрный список на 15 дней. Причина: %s.",rang_army[PI[playerid][pRang]-1][frName],getName(playerid),playerid,PlayerName,text);
		    case 3: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] добавил %s в чёрный список на 15 дней. Причина: %s.",rang_police[PI[playerid][pRang]-1][frName],getName(playerid),playerid,PlayerName,text);
		    case 4: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] добавил %s в чёрный список на 15 дней. Причина: %s.",rang_hospital[PI[playerid][pRang]-1][frName],getName(playerid),playerid,PlayerName,text);
	     	case 5: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] добавил %s в чёрный список на 15 дней. Причина: %s.",rang_skinhead[PI[playerid][pRang]-1][frName],getName(playerid),playerid,PlayerName,text);
	   		case 6: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] добавил %s в чёрный список на 15 дней. Причина: %s.",rang_gopota[PI[playerid][pRang]-1][frName],getName(playerid),playerid,PlayerName,text);
		    case 7: SendFractionMessagef(PI[playerid][pMember], 0xff6633FF, "[R] %s %s[%d] добавил %s в чёрный список на 15 дней. Причина: %s.",rang_kavkaz[PI[playerid][pRang]-1][frName],getName(playerid),playerid,PlayerName,text);
		}
		DeletePVar(playerid, "reason_bl");
	}
	return 1;
}
CMD:allleaders(playerid,params[]) 
{
    if(CheckAdmin(playerid, 5)) return 1;
	mysql_function_query(mysql, "SELECT * FROM `accounts` WHERE `leader` != '0'", true, "LoadAllLeaders", "d", playerid);
	return 1;
}
//==============================[CMD] ===============================//
CMD:bl(playerid) 
{
    if(PI[playerid][pRang] < 9) return SCM(playerid, COLOR_GREY, !"Данная команда Вам недоступна");
    global_str[0] = EOS, f(global_str, 63, "SELECT * FROM `fractions_blacklist` WHERE bl_fraction = '%d'", PI[playerid][pMember]);
    mysql_tquery(mysql, global_str, "CheckBlackListBl", "d", playerid);
	return 1;
}
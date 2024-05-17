//================================= [ CMD ] ==========================//
CMD:business(playerid) 
{
    if(PI[playerid][pBusiness] == INVALID_BUSINESS_ID) return SCM(playerid, COLOR_GREY, !"У Вас нет бизнеса");
    if(PI[playerid][pBusiness] != INVALID_BUSINESS_ID) 
    { 
        if(BizInfo[PI[playerid][pBusiness]][bSealedDays] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Ваш бизнес опечатан, Вы не можете управлять им");
        BusinessMenu(playerid);
    }
	return 1;
}
CMD:buybusiness(playerid) 
{
    if(PI[playerid][pLevel] < 2) return SCM(playerid, COLOR_GREY, !"Покупка бизнеса доступна со 2 уровня");

    for(new b = 0; b < TotalBusiness; b++) 
	{
        if(PlayerToPoint(3.0, playerid, BizInfo[b][data_ENTERX], BizInfo[b][data_ENTERY], BizInfo[b][data_ENTERZ])) 
		{
            if(PI[playerid][pBusiness] != INVALID_BUSINESS_ID) return SCM(playerid, COLOR_GREY, !"У Вас уже есть бизнес");

            if(BizInfo[b][bOwned] == 1) return SCM(playerid, COLOR_GREY, !"Этот бизнес уже куплен'");
			if(GetPlayerMoneyID(playerid) < BizInfo[b][bPrice]) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
			PI[playerid][pBusiness] = b;
			BizInfo[b][bMoney] = 0;
			BizInfo[b][bProduct] = 0;
            BizInfo[b][bOwned] = 1;
            BizInfo[b][bDays] = 3;
            strmid(BizInfo[b][bOwner], getName(playerid), 0, strlen(getName(playerid)), 24);

            GivePlayerMoneyLog(playerid,-BizInfo[b][bPrice],"#76",21491);

            SCM(playerid, COLOR_CORAL, !"Поздравляем! Вы купили бизнес. Не забудьте оплатить его в банке - {f6fae4}/gps » Важные места");
            SCM(playerid, COLOR_CORAL, !"Неоплаченное имущество будет продано государству в течение {f6fae4}2-4 дней");
            SCM(playerid, COLOR_CORAL, !"Закупите продукты в течение 5-7 дней, иначе бизнес будет продан.");

	    	ShowPlayerDialog(playerid, 1592, DIALOG_STYLE_MSGBOX, "{933145}Покупка бизнеса", "\
			{FFFFFF}Для управления бизнесом используйте команду {3366cc}/business{FFFFFF}.\n\n\
			{FFFFFF}Оплатите бизнес в банке {3366cc}(/gps 1 8 и /gps 7){FFFFFF} или Мобильном банке {3366cc}(клавиша P){FFFFFF}\n\
			{FFFFFF}Не забывайте вовремя платить за него, в противном случае он будет опечатан!\n\n\
			{FFFF99}Если в бизнесе не будет продуктов в течение 5-7 дней, он будет опечатан.", "Выбрать", "Отмена");

            UpdateBusinessData(b);
            SaveBusinessData(b);
           	SavePlayerData(playerid);

            new logtext[64];
			format(logtext,sizeof(logtext),"купил бизнес ID:%d", BizInfo[b][data_ID]);
			AddLog("log_player",getName(playerid), logtext);
           	break;
        }
    }
    return 1;
}
stock SetBusinessUpdate() 
{
	for(new b = 0; b < TotalBusiness; b++) 
	{
		if(BizInfo[b][bOwned] == 1) 
		{
			new fin = RandomEX(350000, 580000);
			BizInfo[b][bMoney] += fin;
			BizInfo[b][bClient] = 0;
			new str_q[256];
			mysql_format(mysql,str_q, sizeof(str_q), "UPDATE `business` SET `clients` = '0', `bank` = '%d' WHERE `id` = '%d'",BizInfo[b][bMoney],b);
			mysql_function_query(mysql, str_q, false, "", "");
			SaveBusinessData(b);
		}
        if(BizInfo[b][bSealedDays] > 0)
        {
            BizInfo[b][bSealedDays]--;
            if(BizInfo[b][bSealedDays] == 0)
            {
                new FindPlayer = 0;
                new MoneyBack = BizInfo[b][bPrice]/100*35;

		      	BizInfo[b][bOwned] = 0;
		      	BizInfo[b][bDays] = 0;
                BizInfo[b][bSealedDays] = -1;
                BizInfo[b][bMoney] = 0;
                foreach(Player, i) 
                {
                    new szName[64];
                    if(!IsPlayerConnected(i)) continue;
                    GetPlayerName(i, szName,64);
                    if(!strcmp(BizInfo[b][bOwner], szName, false))
                    {
                        FindPlayer++;
                        SendClientMessage(i, COLOR_LIGHTGREY, !"Ваш опечатанный бизнес был продам государству");
                        PI[i][pBusiness] = INVALID_BUSINESS_ID;
                        GivePlayerMoneyLog(i, MoneyBack,"#46",10988);
                        SavePlayerData(i);
                    }
                }
                if(FindPlayer == 0)
                {
                    mysql_queryf(mysql, "UPDATE `accounts` SET `Money` = `Money` + %d, `Business` = '-1' WHERE `Name` = `%s`", false, MoneyBack, BizInfo[b][bOwner]);
                }
			 	strmid(BizInfo[b][bOwner], "None", 0, strlen(BizInfo[b][bOwner]), 24);

				UpdateBusinessData(b);
				SaveBusinessData(b);
            }
        }
        else
        {
            BizInfo[b][bDays]--;
            if(BizInfo[b][bDays] < 1)
            {
                new sDays = RandomEX(2,4);
                BizInfo[b][bSealedDays] = sDays;
                UpdateBusinessData(b);
            }
        }
	}
	BusinessUpdate = 0;
	return 1;
}
stock UpdateBusinessData(b) 
{
    if(BizInfo[b][data_TYPE] == 1) 
	{
	    if(BizInfo[b][bOwned] == 1) 
		{
            if(BizInfo[b][bSealedDays] > 0)
            {
                new str_1[256];
                format(str_1,sizeof(str_1), "\
                {FFFFFF}%s {FFD700}№%d\n\
                {FFFFFF}Владелец: {FFD700}%s\n\
                {FF6347}БИЗНЕС ОПЕЧАТАН", BizInfo[b][bName], BizInfo[b][data_ID], BizInfo[b][bOwner]);
                UpdateDynamic3DTextLabelText(BizInfo[b][bTextInfo], -1, str_1);
            }
            else 
            {
                new str_1[256];
                format(str_1,sizeof(str_1), "\
                {FFFFFF}%s {FFD700}№%d\n\
                {FFFFFF}Владелец: {FFD700}%s\n\
                {FFFFFF}Купить канистру: {FFD700}K", BizInfo[b][bName], BizInfo[b][data_ID], BizInfo[b][bOwner]);
                UpdateDynamic3DTextLabelText(BizInfo[b][bTextInfo], -1, str_1);
            }
		}
		else 
		{
			new str_1[256];
			format(str_1,sizeof(str_1), "{FFFFFF}Бизнес: {FFD700}%s\n\
										{FFFFFF}Стоимость: {FFD700}%i руб\n\
										{ffffff}Используйте: {FFD700}/buybusiness", BizInfo[b][bName], BizInfo[b][bPrice]);
			UpdateDynamic3DTextLabelText(BizInfo[b][bTextInfo], -1, str_1);
		}
	}
	else
	{
		if(BizInfo[b][bOwned] == 1) 
		{
            if(BizInfo[b][bSealedDays] > 0)
            {
                new str_1[256];
                format(str_1,sizeof(str_1), "\
                {FFFFFF}Бизнес: {FFD700}%s\n\
                {FFFFFF}Владелец: {FFD700}%s\n\
                {FF6347}БИЗНЕС ОПЕЧАТАН", BizInfo[b][bName], BizInfo[b][bOwner]);
                UpdateDynamic3DTextLabelText(BizInfo[b][bTextInfo], -1, str_1);
            }
            else 
            {
                new str_1[256];
                format(str_1,sizeof(str_1), "\
                {FFFFFF}Бизнес: {FFD700}%s\n\
                {FFFFFF}Владелец: {FFD700}%s", BizInfo[b][bName], BizInfo[b][bOwner]);
                UpdateDynamic3DTextLabelText(BizInfo[b][bTextInfo], -1, str_1);
            }
		}
		else 
		{
			new str_1[256];
			format(str_1,sizeof(str_1), "\
			{FFFFFF}Бизнес: {FFD700}%s\n\
			{ffffff}Стоимость: {FFD700}%i руб\n\
			{ffffff}Используйте: {FFD700}/buybusiness",BizInfo[b][bName],
			BizInfo[b][bPrice]);
			UpdateDynamic3DTextLabelText(BizInfo[b][bTextInfo], -1, str_1);
		}
	}
	return 1;
}
callback: LoadBusiness() 
{
    new rows, fields, temp[256],time = GetTickCount();
    cache_get_data(rows, fields);
	LoadedBiz = cache_get_row_count(mysql);
    
    new str_1[256];
    if(rows) 
	{
    	for(new b = 0; b < rows; b++) 
		{
	        cache_get_field_content(b, "id", temp), BizInfo[b][data_ID] = strval (temp);
	        cache_get_field_content(b, "owner", BizInfo[b][bOwner], mysql, MAX_PLAYER_NAME);
	        cache_get_field_content(b, "name", BizInfo[b][bName], mysql, 50);
	        cache_get_field_content(b, "owned", temp), BizInfo[b][bOwned] = strval (temp);
	        cache_get_field_content(b, "price", temp), BizInfo[b][bPrice] = strval (temp);
	        cache_get_field_content(b, "bank", temp), BizInfo[b][bMoney] = strval (temp);
	        cache_get_field_content(b, "prod", temp), BizInfo[b][bProduct] = strval (temp);
			cache_get_field_content(b, "clients", temp), BizInfo[b][bClient] = strval (temp);
	        cache_get_field_content(b, "day", temp), BizInfo[b][bDays] = strval (temp);
	        cache_get_field_content(b, "type", temp), BizInfo[b][data_TYPE] = strval (temp);
	        cache_get_field_content(b, "cena", temp), BizInfo[b][data_CENA] = strval (temp);
	        cache_get_field_content(b, "price_prod", temp), BizInfo[b][bPriceProduct] = strval (temp);
	        cache_get_field_content(b, "int", temp), BizInfo[b][data_INT] = strval (temp);
	        cache_get_field_content(b, "vw", temp), BizInfo[b][data_VW] = strval (temp);
	        cache_get_field_content(b, "lock", temp), BizInfo[b][data_LOCK] = strval (temp);
	        cache_get_field_content(b, "mapicon", temp), BizInfo[b][data_MAPICON] = strval (temp);
	        cache_get_field_content(b, "enter_x", temp), BizInfo[b][data_ENTERX] = floatstr (temp);
	        cache_get_field_content(b, "enter_y", temp), BizInfo[b][data_ENTERY] = floatstr (temp);
	        cache_get_field_content(b, "enter_z", temp), BizInfo[b][data_ENTERZ] = floatstr (temp);
	        cache_get_field_content(b, "exit_x", temp), BizInfo[b][data_EXITX] = floatstr (temp);
	        cache_get_field_content(b, "exit_y", temp), BizInfo[b][data_EXITY] = floatstr (temp);
	        cache_get_field_content(b, "exit_z", temp), BizInfo[b][data_EXITZ] = floatstr (temp);
	        cache_get_field_content(b, "buy_x", temp), BizInfo[b][data_BUYX] = floatstr (temp);
	        cache_get_field_content(b, "buy_y", temp), BizInfo[b][data_BUYY] = floatstr (temp);
	        cache_get_field_content(b, "buy_z", temp), BizInfo[b][data_BUYZ] = floatstr (temp);
	        cache_get_field_content(b, "exittp_x", temp), BizInfo[b][data_TPEXITX] = floatstr (temp);
	        cache_get_field_content(b, "exittp_y", temp), BizInfo[b][data_TPEXITY] = floatstr (temp);
	        cache_get_field_content(b, "exittp_z", temp), BizInfo[b][data_TPEXITZ] = floatstr (temp);
	        cache_get_field_content(b, "exittp_angle", temp), BizInfo[b][data_ANGLE] = floatstr (temp);

            cache_get_field_content(b, "sealed_days", temp), BizInfo[b][bSealedDays] = strval (temp);
	        
         	TotalBusiness++;

			switch(BizInfo[b][data_TYPE]) 
			{
			    case 1: BizInfo[b][bPriceProduct] = 4, BizInfo[b][data_CENA] = 10;
				case 2: BizInfo[b][bPriceProduct] = 6;
			    case 3: BizInfo[b][bPriceProduct] = 3;
			    case 4: BizInfo[b][bPriceProduct] = 7;
			    case 5: BizInfo[b][bPriceProduct] = 3;
			}

         	if(BizInfo[b][data_TYPE] == 1) 
			{
	     	    if(BizInfo[b][bOwned] == 1) 
				{
                    if(BizInfo[b][bSealedDays] > 0)
                    {
                        format(str_1,sizeof(str_1), "\
                        {FFFFFF}%s {FFD700}№%d\n\
                        {FFFFFF}Владелец: {FFD700}%s\n\
                        {FF6347}БИЗНЕС ОПЕЧАТАН", BizInfo[b][bName], BizInfo[b][data_ID], BizInfo[b][bOwner]);
                    }
                    else
                    {
                        format(str_1,sizeof(str_1), "\
                        {FFFFFF}%s {FFD700}№%d\n\
                        {FFFFFF}Владелец: {FFD700}%s\n\
                        {FFA500}Нажмите клавишу: K", BizInfo[b][bName], BizInfo[b][data_ID], BizInfo[b][bOwner]);
                    }
                }
				else 
				{
					format(str_1,sizeof(str_1), "{FFFFFF}Бизнес: {FFD700}%s\n{FFFFFF}Стоимость бизнеса: {FFD700}%i рублей\n{FFFFFF}Используйте: {FFD700}/buybusiness",BizInfo[b][bName], BizInfo[b][bPrice]);
				}
			}
  			else
			{
         	    if(BizInfo[b][bOwned] == 1) 
				{
                    if(BizInfo[b][bSealedDays] > 0)
                    {
                        format(str_1,sizeof(str_1), "\
                        {FFFFFF}Бизнес: {FFD700}%s\n\
                        {FFFFFF}Владелец: {FFD700}%s\n\
                        {FF6347}БИЗНЕС ОПЕЧАТАН", BizInfo[b][bName], BizInfo[b][bOwner]);
                    }
                    else
                    {
                        format(str_1,sizeof(str_1), "\
                        {FFFFFF}Бизнес: {FFD700}%s\n\
                        {FFFFFF}Владелец: {FFD700}%s", BizInfo[b][bName], BizInfo[b][bOwner]);

                        BizInfo[b][data_PICKEXIT] = CreateDynamicPickup(19132, 23, BizInfo[b][data_EXITX], BizInfo[b][data_EXITY], BizInfo[b][data_EXITZ],BizInfo[b][data_VW]);
                        if(BizInfo[b][data_TYPE] == 2) 
                        {
                            BizInfo[b][bCheckPointForBuy] = CreateDynamicPickup(10270,23,BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ],BizInfo[b][data_VW]);
                            Create3DTextLabel("{FFFFFF}Магазин 24/7\n{FFD700}Нажмите B", -1, BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ], 3.0, BizInfo[b][data_VW], 0);
                        }
                        else if(BizInfo[b][data_TYPE] == 3) 
                        {
                            BizInfo[b][bCheckPointForBuy] = CreateDynamicPickup(1275,23,BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ],BizInfo[b][data_VW]);
                            Create3DTextLabel("{FFFFFF}Магазин одежды\n{FFD700}Нажмите B", -1, BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ], 3.0, BizInfo[b][data_VW], 0);
                        }
                        else BizInfo[b][bCheckPointForBuy] = CreateDynamicPickup(1239,23,BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ],BizInfo[b][data_VW]);
                    }
				}
				else 
				{
				    format(str_1,sizeof(str_1), "{FFFFFF}Бизнес: {FFD700}%s\n{FFFFFF}Стоимость бизнеса: {FFD700}%i рублей\n{FFFFFF}Используйте: {FFD700}/buybusiness",BizInfo[b][bName],BizInfo[b][bPrice]);
				    BizInfo[b][data_PICKEXIT] = CreateDynamicPickup(19132, 23, BizInfo[b][data_EXITX], BizInfo[b][data_EXITY], BizInfo[b][data_EXITZ],BizInfo[b][data_VW]);
                    if(BizInfo[b][data_TYPE] == 2) 
					{
						BizInfo[b][bCheckPointForBuy] = CreateDynamicPickup(10270,23,BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ],BizInfo[b][data_VW]);
						Create3DTextLabel("{FFFFFF}Магазин 24/7\n{FFD700}Нажмите B", -1, BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ], 3.0, BizInfo[b][data_VW], 0);
					}
                    else if(BizInfo[b][data_TYPE] == 3) 
					{
						BizInfo[b][bCheckPointForBuy] = CreateDynamicPickup(1275,23,BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ],BizInfo[b][data_VW]);
						Create3DTextLabel("{FFFFFF}Магазин одежды\n{FFD700}Нажмите B", -1, BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ], 3.0, BizInfo[b][data_VW], 0);
					}
					else BizInfo[b][bCheckPointForBuy] = CreateDynamicPickup(1239,23,BizInfo[b][data_BUYX], BizInfo[b][data_BUYY], BizInfo[b][data_BUYZ],BizInfo[b][data_VW]);
				}
         	}
            BizInfo[b][data_PICKENTER] = CreateDynamicPickup(19132, 23, BizInfo[b][data_ENTERX], BizInfo[b][data_ENTERY], BizInfo[b][data_ENTERZ],-1);
            BizInfo[b][bTextInfo] = CreateDynamic3DTextLabel(str_1, -1,BizInfo[b][data_ENTERX], BizInfo[b][data_ENTERY], BizInfo[b][data_ENTERZ],15.0);
            if(BizInfo[b][data_MAPICON] != -1) BizInfo[b][data_MAPICON] = CreateDynamicMapIcon(BizInfo[b][data_ENTERX], BizInfo[b][data_ENTERY], BizInfo[b][data_ENTERZ], BizInfo[b][data_MAPICON], -1, 0, -1, -1, 200.0);
        }
        if(console_Debbug == 1) printf("[INFO]  Load business. Load: %d b. Time: %d ms.", TotalBusiness, GetTickCount()-time);
  	}
    return 1;
}
stock SaveBusinessData(b) 
{
	new str_q[1048];
	new str_q2[1048];
	str_q = "UPDATE `business` SET ";
	acc_str_strcat(str_q, sizeof(str_q), "owner", BizInfo[b][bOwner]);
	acc_int_strcat(str_q, sizeof(str_q), "owned", BizInfo[b][bOwned]);
	acc_str_strcat(str_q, sizeof(str_q), "name", BizInfo[b][bName]);
	acc_int_strcat(str_q, sizeof(str_q), "prod", BizInfo[b][bProduct]);
	acc_int_strcat(str_q, sizeof(str_q), "day", BizInfo[b][bDays]);
	acc_int_strcat(str_q, sizeof(str_q), "clients", BizInfo[b][bClient]);
	acc_int_strcat(str_q, sizeof(str_q), "lock", BizInfo[b][data_LOCK]);
	acc_int_strcat(str_q, sizeof(str_q), "cena", BizInfo[b][data_CENA]);
	acc_int_strcat(str_q, sizeof(str_q), "price_prod", BizInfo[b][bPriceProduct]);
	acc_int_strcat(str_q, sizeof(str_q), "bank", BizInfo[b][bMoney]);
    acc_int_strcat(str_q, sizeof(str_q), "sealed_days", BizInfo[b][bSealedDays]);
	strdel(str_q, strlen(str_q)-1, strlen(str_q));
	format(str_q2,sizeof(str_q2)," WHERE `id` = '%d' LIMIT 1",BizInfo[b][data_ID]);
	strcat(str_q, str_q2);
	mysql_function_query(mysql, str_q, true, "", "");
	return 1;
}
//
stock business_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case 2350: 
        {
            if(!response) return 1;
			if(response) 
            {
				switch(listitem) 
                {
					case 0: 
                    {
					    new b = PI[playerid][pBusiness];
						Business_Info(playerid,b);
					}
					case 1: 
                    {
						new b = PI[playerid][pBusiness];
						new str_3[1048];
						format(str_3,sizeof(str_3),"\
						{FFFFFF}Для получения прибыли бизнесу нужны продукты. Каждый час в бизнесе\n\
						{FFFFFF}расходуется 1 партия продуктов и одновременно зачисляется прибыль.\n\
						{FFFFFF}Если в этот момент отсутствовали продукты - прибыли не будет.\n\
						{FFFFFF}Изначально Вы можете купить 6 партий продуктов (этого хватит на 6 часов)\n\
						{FFFFFF}Увеличить вместимость склада можно в Центре недвижимости {FFFF99}(/gps).\n\n\
						{FFFF99}Обратите внимание: если склад будет пустовать более 5-7 дней,\n\
						{FFFF99}бизнес будет продан государству, а Вам - возвращена часть его стоимости.\n\n\
						{FFFFFF}Продуктов на складе:\t {3366cc}%d парт.\n\
						{FFFFFF}Вместимость склада:\t {3366cc}100 парт.\n\
						{FFFFFF}Доступно для закупки:\t {3366cc}%d парт.\n\
						{FFFFFF}Посетителей за день:\t {3366cc}%d человек\n\
						{FFFFFF}Стоимость 1 партии:\t {2dc45b}300 руб\n\
						{FFFFFF}Введите количество партий продуктов для закупки:", BizInfo[b][bProduct], 100-BizInfo[b][bProduct],BizInfo[b][bClient]);
			            ShowPlayerDialog(playerid, 2355, DIALOG_STYLE_INPUT, !"{ee3366}Преобрести продукты",str_3, "Продать", "Отмена");
					}
					case 2: 
                    {
					    new b = PI[playerid][pBusiness];
						new str_3[185];
						format(str_3,sizeof(str_3),"Вы желаете продать свой бизнес за {FFFF99}%d рублей{FFFFFF}?", BizInfo[b][bPrice]/2);
			            ShowPlayerDialog(playerid, 2354, DIALOG_STYLE_MSGBOX, !"{ee3366}Продажа бизнеса",str_3, "Продать", "Отмена");
					}
					case 3: Business_Re_Money(playerid);
					case 4: Business_Give_Money(playerid);
				}
			}
        }
        case 2351:
        {
            if(!response) return BusinessMenu(playerid);
			if(response)
			{
			    new str[55];
			    new b = PI[playerid][pBusiness];
			    if(strval(inputtext) <= 0) return SCM(playerid, COLOR_GREY,"Недопустимое значение");
				if(strval(inputtext) > BizInfo[b][bMoney]) return SCM(playerid, COLOR_GREY,"Недостаточно средств на балансе бизнеса"),Business_Give_Money(playerid);
                BizInfo[b][bMoney] -= strval(inputtext);
				GivePlayerMoneyLog(playerid,strval(inputtext),"#47",11025);
				format(str,sizeof(str),"Вы сняли: %d рублей. Баланс бизнеса: %d рублей",strval(inputtext), BizInfo[b][bMoney]);
				SCM(playerid,0xc89522FF,str);
				SavePlayerData(playerid);
				SaveBusinessData(b);
			}
        }
        case 2352:
        {
            if(!response) return BusinessMenu(playerid);
			if(response)
			{
			    new str[64];
			    new b = PI[playerid][pBusiness];
			    if(strval(inputtext) <= 0) return SCM(playerid, COLOR_GREY,"Недопустимое значение");
				if(GetPlayerMoneyID(playerid) < strval(inputtext)) return SCM(playerid, COLOR_GREY,"У Вас недостаточно денег на руках"),Business_Re_Money(playerid);
				if(BizInfo[b][bOwned] == 1) BizInfo[b][bMoney] += strval(inputtext);
				GivePlayerMoneyLog(playerid,-strval(inputtext),"#48",11042);
				format(str,sizeof(str),"Вы положили: %d рублей. Баланс бизнеса: %d рублей",strval(inputtext), BizInfo[b][bMoney]);
				SCM(playerid, COLOR_YELLOW,str);
				SavePlayerData(playerid);
				SaveBusinessData(b);
			}
        }
        case 2353:
        {
            if(!response) return BusinessMenu(playerid);
			if(response) 
            {
			    new b = PI[playerid][pBusiness];
			    if(strlen(inputtext) == 0) return Business_Change_Name(playerid);
				if(strlen(inputtext) < 3 || strlen(inputtext) > 30) return SCM(playerid, COLOR_GREY,"От 3 до 30 символов"),Business_Change_Name(playerid);
                strmid(BizInfo[b][bName], inputtext, 0, strlen(inputtext), 30);
                SCMf(playerid,0xc89522FF, "Новое название бизнеса: %s",BizInfo[b][bName]);
                UpdateBusinessData(b);
                SaveBusinessData(b);
			}
        }
		case 2354:
        {
			if(!response) return 1;
			if(response) 
            {
   			    new str[50];
		    	new b = PI[playerid][pBusiness];
		      	BizInfo[b][bOwned] = 0;
		      	BizInfo[b][bDays] = 0;
		      	PI[playerid][pBusiness] = INVALID_BUSINESS_ID;
			 	strmid(BizInfo[b][bOwner], "None", 0, strlen(BizInfo[b][bOwner]), 24);
				GivePlayerMoneyLog(playerid,BizInfo[b][bPrice]/2,"#46",10988);
				format(str,sizeof(str),"Вы продали бизнес государству за %d рублей", BizInfo[b][bPrice]/2);
			 	SCM(playerid, 0xc89522AA, str);
				UpdateBusinessData(b);
				SaveBusinessData(b);
			  	SavePlayerData(playerid);
			  	new logtext[64];
				format(logtext,sizeof(logtext),"продал бизнес ID:%d", BizInfo[b][data_ID]);
				AddLog("log_player",PI[playerid][pName], logtext);
   			}
		}
		case 2355: 
        {
  			if(!response) return 1;
			if(response) 
            {
                new b = PI[playerid][pBusiness];
                if(BizInfo[b][bOwner] == PI[playerid][pName]) 
                {
		    	    new inputtextprodukt;
		    	    inputtextprodukt = strval(inputtext);
					if(BizInfo[b][bOwned] == 0) return SCM(playerid, COLOR_GREY,"Бизнес закрыт");
	     			if(BizInfo[b][bProduct] == 100) return SCM(playerid, COLOR_GREY,"Склад бизнеса полон");
	     			if(inputtextprodukt <= 0) return SCM(playerid, COLOR_GREY,"Склад бизнеса полон");
					new money = inputtextprodukt*300;
					new sklad = inputtextprodukt+BizInfo[b][bProduct];
					if(BizInfo[b][bMoney] < money) return SCM(playerid, COLOR_GREY,"На счету бизнеса недостаточно денег");
					if(sklad > 1000) return SCM(playerid, COLOR_GREY,"На складе бизнеса недостаточно места");
					BizInfo[b][bMoney] -= money;
					BizInfo[b][bProduct] += inputtextprodukt;
				 	SCMf(playerid, -1, "Вы купили %d шт. продуктов. Всего продуктов: %d", inputtextprodukt, BizInfo[b][bProduct]);
					UpdateBusinessData(b);
					SaveBusinessData(b);
					return 1;
				}
			}
		}
    }
    return 1;
}
//
stock BusinessMenu(playerid) 
{
	ShowPlayerDialog(playerid, 2350, DIALOG_STYLE_LIST, !"{ee3366}Управление бизнесом", !"\
	1. Информация\n\
    2. Информация об улучшениях\n\
	3. Приобрести продукты\n\
    4. Посмотреть статистику (прибыль)\n\
    5. Посмотреть статистику (посещяемость)\n\
	6. Отметить GPS метку на мини-карте\n\
	7. Продать бизнес", !"Далее", !"Закрыть");
	return 1;
}
stock Business_Give_Money(playerid) 
{
	new str_3[185];
	format(str_3,sizeof(str_3),"Комиссия составит 6%\nВведите требуемую сумму:");
 	ShowPlayerDialog(playerid, 2351, DIALOG_STYLE_INPUT, "{ee3366}Cнятие средств  со счёта бизнеса", str_3, "Снять", "Назад");
	return 1;
}
stock Business_Re_Money(playerid) 
{
	new str_3[185];
	format(str_3,sizeof(str_3),"Комиссия составит 3%\nВведите требуемую сумму:");
 	ShowPlayerDialog(playerid, 2352, DIALOG_STYLE_INPUT, "{ee3366}Покласть сердства на счёт бизнеса", str_3, "Положить", "Назад");
	return 1;
}
stock Business_Info(playerid,b) 
{
	new str_3[256*2];
    if(BizInfo[b][data_TYPE] == 1) 
	{
		format(str_3,sizeof(str_3),"\
		Название:\t\t{3b6da7}%s\n\
		{FFFFFF}Номер бизнеса:\t%d\n\
		{FFFFFF}Владелец:\t\t%s\n\
		{FFFFFF}Стоимость:\t\t%d руб\n\
		{FFFFFF}Арендная плата:\t{3bb763}3999 руб\n\
		{FFFFFF}Статус оплаты:\t\t%d дн ({FFFF99}оплатить в Банке - /gps{FFFFFF})n\
		{FFFFFF}Бензина на складе:\t%d л\n\
		{FFFFFF}Баланс:\t\t%d руб",
		BizInfo[b][bName], BizInfo[b][data_ID],BizInfo[b][bOwner],BizInfo[b][bPrice],BizInfo[b][bDays],BizInfo[b][bProduct], BizInfo[b][bMoney]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "{ee3366}Информация о бизнесе", str_3, "Закрыть", "");
	}
	else 
	{
		format(str_3,sizeof(str_3),"\
		Название:\t\t{3b6da7}%s\n\
		{FFFFFF}Номер бизнеса:\t%d\n\
		{FFFFFF}Владелец:\t\t%s\n\
		{FFFFFF}Стоимость:\t\t%d руб\n\
		{FFFFFF}Арендная плата:\t{3bb763}3999 руб\n\
		{FFFFFF}Статус оплаты:\t\t%d дн ({FFFF99}оплатить в Банке - /gps{FFFFFF})\n\
		{FFFFFF}Продуктов на складе:\t%d / 500.\n\
		{FFFFFF}Баланс:\t\t%d руб",
		BizInfo[b][bName], BizInfo[b][data_ID],BizInfo[b][bOwner],BizInfo[b][bPrice],BizInfo[b][bDays],BizInfo[b][bProduct], BizInfo[b][bMoney]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "{ee3366}Информация о бизнесе", str_3, "Закрыть", "");
	}
	return 1;
}
stock Business_Change_Name(playerid) 
{
	new b = PI[playerid][pBusiness];
    ShowPlayerDialogf(playerid, 2353, DIALOG_STYLE_INPUT, "{ee3366}Название бизнеса", "Подтвердить", "Назад", "\
                                                                                    Название бизнеса: %s\n\
                                                                                    Введите новое название вашего бизнеса",BizInfo[b][bName]);
	return 1;
}
stock Business_Change_Cena(playerid) 
{
	new b = PI[playerid][pBusiness];
	if(BizInfo[b][data_TYPE] == 1) 
	{
	    ShowPlayerDialog(playerid, 2353, DIALOG_STYLE_INPUT, "{ee3366}Изменение цены на бензин", "Подтвердить", "Назад", "\
        Цена: %d рублей\n\
        Введите новую цену",BizInfo[b][data_CENA]);
	}
	else 
	{
	    ShowPlayerDialog(playerid, 2353, DIALOG_STYLE_INPUT, "{ee3366}Изменение цены на товар", "Подтвердить", "Назад", "\
        Цена: %d рублей\n\
        Введите новую цену",BizInfo[b][data_CENA]);
	}
	return 1;
}
CMD:test(playerid) return SetBusinessUpdate();
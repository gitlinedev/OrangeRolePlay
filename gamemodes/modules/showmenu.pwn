//
#define SIM_CARD    300
#define PHONE       5500
#define FIX_CAR     1500
#define MASK        300
#define BALLON      400
#define PHOTO       600
#define HEALPACK    200
#define FLOWERS     600
#define PIZZA       400
#define CHIPS       150
//==================================[ stocks ] ====================================//
stock ShowShopMenu(playerid)
{
    ShowPlayerDialogf(playerid, 3520, DIALOG_STYLE_LIST, !"{ee3366}Магазин 24/7", !"Купить", !"Закрыть", "\
	1. Чипсы (с собой)\t\t\t\t{ebeb8e}%d руб.\n\
	{ffffff}2. Пицца (с собой)\t\t\t\t{ebeb8e}%d руб.\n\
	{ffffff}3. Букет цветов 'Миллионы алых роз'\t\t{ebeb8e}%d руб.\n\
	{ffffff}4. Медицинская аптечка\t\t\t{ebeb8e}%d руб.\n\
	{ffffff}5. Фотоапарат\t\t\t\t\t{ebeb8e}%d руб.\n\
	{ffffff}6. Балончик с краской\t\t\t\t{ebeb8e}%d руб.\n\
	{ffffff}7. Маска\t\t\t\t\t{ebeb8e}%d руб.\n\
	{ffffff}8. bPhoneXX\t\t\t\t\t{ebeb8e}%d руб.\n\
	{ffffff}9. SIM картка (6 цифр)\t\t\t\t{ebeb8e}%d руб.\n\
	{ffffff}9. Ремонтный набор\t\t\t\t{ebeb8e}%d руб.", CHIPS, PIZZA, FLOWERS, HEALPACK, PHOTO, BALLON, MASK, PHONE, SIM_CARD, FIX_CAR);
    return 1;
}
stock ShowArmyShop(playerid)
{
    new hour, Discount = 0;
    gettime(hour);
    if(hour == 23 || hour == 00 || hour == 1  || hour == 2  || hour == 3  || hour == 4  || hour == 5  || hour == 6  || hour == 7) Discount++;

    if(Discount == 0)
    {
        ShowPlayerDialogf(playerid, 5070, DIALOG_STYLE_LIST, !"{ee3366}Армейский магазин", !"Купить", !"Закрыть", "\
        1. Медицинская аптечка\t{33cc99}%d руб\n\
        2. Маска\t\t\t\t{33cc99}%d руб", HEALPACK, MASK);
    }
    else 
    {
        ShowPlayerDialogf(playerid, 5070, DIALOG_STYLE_LIST, !"{ee3366}Армейский магазин", !"Купить", !"Закрыть", "\
        1. Медицинская аптечка\t{33cc99}%d руб [Ночная скидка 50%%]\n\
        2. Маска\t\t\t\t{33cc99}%d руб [Ночная скидка 50%%]", HEALPACK/2, MASK/2);
    }
    return 1;
}
//==================================[ dialogs ]=====================================//
stock shop_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    switch(dialogid)
    {
        case 6989:
		{
		    new b = GetPVarInt(playerid,"business");
		    if(!response) return ShowShopMenu(playerid);
		    if(response)
		    {
				if(BizInfo[b][bProduct] <= 0  || BizInfo[b][bOwned] == 0) return SendClientMessage(playerid, COLOR_GREY, !"У бизнеса недостаточно продуктов");

				if(GetPlayerMoneyID(playerid) < PHONE) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
				if(PI[playerid][data_PHONE] == 1) return SCM(playerid, COLOR_GREY, !"У Вас уже есть телефон");
				GivePlayerMoneyLog(playerid, -PHONE);

                PI[playerid][data_PHONE] = 1;

				UpdateBusinessData(b);
				cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка мобильного телефона"), CEFSTR("fb4949"), CEFSTR("-5500P"));
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, !"{ee3366}Покупка мобильного телефона", "{FFFFFF}Поздравляем!\nВы купили телефон {3366cc}bPhone XX{FFFFFF}\nНе забудьте приобрести SIM-карту", "Закрыть", "Назад");
				SCM(playerid, 0x00AA33FF, !"Чтобы открыть меню телефона используйте {FF9977}клавишу P");
			}
		}
		case 6990:
		{
			new b = GetPVarInt(playerid,"business");
		    if(!response) return ShowShopMenu(playerid);
		    if(response)
		    {
                if(BizInfo[b][bProduct] <= 0  || BizInfo[b][bOwned] == 0) return SendClientMessage(playerid, COLOR_GREY, !"У бизнеса недостаточно продуктов");

				if(strlen(inputtext) == 0) return ShowPlayerDialog(playerid, 6990, DIALOG_STYLE_INPUT, "{ee3366}Покупка номера телефона", "{FFFFFF}Введите желаем {3366cc}6-значный{FFFFFF} номер телефона\nНовая SIM-карта заменит текущую (при eё наличии).\n{696969}Отменить это действие будет невозможно", "Купить", "Назад");
				if(strlen(inputtext) < 6 || strlen(inputtext) > 6) return SCM(playerid, COLOR_GREY, !"Длина номера 6 символа"), ShowPlayerDialog(playerid, 6990, DIALOG_STYLE_INPUT, "{ee3366}Покупка номера телефона", "Введите желаем {3366cc}6-значный{FFFFFF} номер телефона\nНовая SIM-карта заменит текущую (при eё наличии).\n{696969}Отменить это действие будет невозможно", "Купить", "Назад");

                if(PI[playerid][data_PHONE] == 0) return SCM(playerid, COLOR_GREY, !"Сначала купите телефон");
				if(GetPlayerMoneyID(playerid) < PHONE) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
				SetPVarInt(playerid, "simcard", strval(inputtext));

                mysql_string[0] = EOS, f(mysql_string, 55, "SELECT * FROM `accounts` WHERE `number` = '%d'", strval(inputtext));
                mysql_tquery(mysql, mysql_string, "CheckSimCard", "i", playerid);
			}
		}
		case 5070: 
        {
		    if(!response) return 1;
		    if(response) 
            {
                new hour, Discount = 0;
                gettime(hour);
                if(hour == 23 || hour == 00 || hour == 1  || hour == 2  || hour == 3  || hour == 4  || hour == 5  || hour == 6  || hour == 7) Discount++;

		        switch(listitem) 
                {
		            case 0:
					{
					    if(PI[playerid][pHealPack] == 3) return ShowArmyShop(playerid), SCM(playerid, COLOR_GREY, !"Вы можете купить не более 3х аптечек");
						if(Discount == 0) 
                        {
                            if(GetPlayerMoneyID(playerid) < HEALPACK) return ShowArmyShop(playerid), SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках"); 
						    GivePlayerMoneyLog(playerid, HEALPACK);

                            new cef[10]; f(cef, 10, "-%dР", HEALPACK);
                            cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка мед. аптечки (/healme)"), CEFSTR("fb4949"), CEFSTR(cef));
                            SCMf(playerid, 0x00AA33FF, "Вы купили мед. аптечку{fe9a7e} (%d из 3){00aa33} за {fe9a7e}200 рублей", PI[playerid][pHealPack]);
                        }
                        else 
                        {
                            if(GetPlayerMoneyID(playerid) < HEALPACK/2) return ShowArmyShop(playerid), SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках"); 
						    GivePlayerMoneyLog(playerid, HEALPACK/2);
                            new cef[10]; f(cef, 10, "-%dР", HEALPACK/2);
                            cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка мед. аптечки (/healme)"), CEFSTR("fb4949"), CEFSTR(cef));
                            SCMf(playerid, 0x00AA33FF, "Вы купили мед. аптечку{fe9a7e} (%d из 3){00aa33} за {fe9a7e}200 рублей", PI[playerid][pHealPack]);
                        }

						PI[playerid][pHealPack]++;
						UpdatePlayerDataInt(playerid, "healthchest", PI[playerid][pHealPack],10245);
						SCM(playerid, 0x00AA33FF, "Чтобы подлечиться используйте {fe9a7e}/healme{00aa33}, передать другому игроку {fe9a7e}/givechest");
						ShowArmyShop(playerid);
					}
					case 1:
					{
                        if(PI[playerid][data_MASK] >= 1) return ShowArmyShop(playerid), SCM(playerid, COLOR_GREY, !"Вы не можете преобрести более 1-й маски");
                        if(Discount == 0) 
                        {
                            if(GetPlayerMoneyID(playerid) < MASK) return ShowArmyShop(playerid), SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
                            GivePlayerMoneyLog(playerid,-MASK);
                            new cef[10]; f(cef, 10, "-%dР", MASK);
                            cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка маски"), CEFSTR("fb4949"), CEFSTR(cef));
                        }
                        else
                        {
                            if(GetPlayerMoneyID(playerid) < MASK/2) return ShowArmyShop(playerid), SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
                            GivePlayerMoneyLog(playerid,-MASK/2);
                            new cef[10]; f(cef, 10, "-%dР", MASK/2);
                            cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка маски"), CEFSTR("fb4949"), CEFSTR(cef));
                        }
						PI[playerid][data_MASK]++;
						SCM(playerid, 0x00AA33FF, "Вы купили маску за {ff9977}150 руб{00aa33}. Чтобы надеть её используйте /mask");
						ShowArmyShop(playerid);
					}
			    }
			}
		}
        case 3520: 
		{
		    new b = GetPVarInt(playerid,"business");
		    if(!response) return 1;
			if(response) 
			{
                if(BizInfo[b][bProduct] <= 0  || BizInfo[b][bOwned] == 0) return SendClientMessage(playerid, COLOR_GREY, !"У бизнеса недостаточно продуктов");
			    switch(listitem) 
				{
			        case 0: 
                    {
                        SendClientMessage(playerid, COLOR_LIGHTGREY, !"В разработке");
                        SCM(playerid, 0x00AA33FF, !"Вы купили 'Чипсы' (всего: {FF9977}1 шт{00AA33}). Чтобы покушать используйте {FF9977}/eat");
                    }
			        case 1: 
                    {
                        SendClientMessage(playerid, COLOR_LIGHTGREY, !"В разработке");
                        SCM(playerid, 0x00AA33FF, !"Вы купили 'Пицца' (всего: {FF9977}1 шт{00AA33}). Чтобы покушать используйте {FF9977}/eat");
                    }
			        case 2: 
                    {
						if(GetPlayerMoneyID(playerid) < FLOWERS) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid, -FLOWERS);
						GiveWeapon(playerid, 14, 1);
					    UpdateBusinessData(b);
						new cef[10]; f(cef, 10, "-%dР", FLOWERS);
                        cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка цветов"), CEFSTR("fb4949"), CEFSTR(cef));
						SCM(playerid, 0x00AA33FF, !"Вы купили букет цветов. Чтобы подарить используйте {FF9977}/flowers");
						ShowShopMenu(playerid);
					}
					case 3:
					{
					    if(PI[playerid][pHealPack] == 3) return SCM(playerid, COLOR_GREY, !"Вы можете купить не более 3х аптечек");
						if(GetPlayerMoneyID(playerid) < HEALPACK) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid,-HEALPACK);
						PI[playerid][pHealPack]++;
						UpdatePlayerDataInt(playerid, "healthchest", PI[playerid][pHealPack],10245);
					    UpdateBusinessData(b);
                        new cef[10]; f(cef, 10, "-%dР", HEALPACK);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка мед. аптечки (/healme)"), CEFSTR("fb4949"), CEFSTR(cef));
						SCMf(playerid, 0x00AA33FF, "Вы купили мед. аптечку{FF9977} (%d из 3){00AA33} за {FF9977}%d рублей", PI[playerid][pHealPack], HEALPACK);
						SCM(playerid, 0x00AA33FF, !"Чтобы подлечиться используйте {FF9977}/healme{00AA33}, передать другому игроку {FF9977}/givechest");
						ShowShopMenu(playerid);
					}
					case 4:
					{
						if(GetPlayerMoneyID(playerid) < PHOTO) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid,-PHOTO);
						GiveWeapon(playerid, 43, 20);
					    UpdateBusinessData(b);
                        new cef[10]; f(cef, 10, "-%dР", PHOTO);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка фотоапарата"), CEFSTR("fb4949"), CEFSTR(cef));
						SCM(playerid, 0x00AA33FF, !"Вы купили фотоапарат.");
						ShowShopMenu(playerid);
					}
					case 5:
					{
						if(GetPlayerMoneyID(playerid) < BALLON) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid,-BALLON);
						GiveWeapon(playerid, 41, 1000);
					    UpdateBusinessData(b);
                        new cef[10]; f(cef, 10, "-%dР", BALLON);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка балончика с краской"), CEFSTR("fb4949"), CEFSTR(cef));
						SCM(playerid, 0x00AA33FF, !"Вы купили балончик с краской.");
						ShowShopMenu(playerid);
					}
					case 6:
					{
					    if(PI[playerid][data_MASK] >= 1) return SCM(playerid, COLOR_GREY, !"Вы не можете преобрести более 1-й маски");
						if(GetPlayerMoneyID(playerid) < MASK) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid,-MASK);
						PI[playerid][data_MASK]++;
					    UpdateBusinessData(b);
                        new cef[10]; f(cef, 10, "-%dР", MASK);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка маски"), CEFSTR("fb4949"), CEFSTR(cef));
						SCMf(playerid, 0x00AA33FF, "Вы купили маску за {FF9977}%d руб{00AA33}. Чтобы надеть её используйте {FF9977}/mask", MASK);
						ShowShopMenu(playerid);
					}
					case 7: 
                    {
                        ShowPlayerDialogf(playerid, 6989, DIALOG_STYLE_MSGBOX, !"{ee3366}Покупка телефона", !"Купить", !"Назад", "\
                        {FFFFFF}Вы действительно хотите купить {3366cc}bPhone XX{ffffff} за {3366cc}%d руб{ffffff}?\n\
                        Новый телефон заменит текущий (при его наличии).\n\
                        {696969}Отменить это действие будет невозможно", PHONE);
                    }
                    case 8: 
                    {
                        ShowPlayerDialog(playerid, 6990, DIALOG_STYLE_INPUT, "{ee3366}Покупка номера телефона", !"\
                        {FFFFFF}Введите желаем {3366cc}6-значный{ffffff} номер телефона\n\
                        Новая SIM-карта заменит текущую (при eё наличии).\n\
                        {696969}Отменить это действие будет невозможно", !"Купить", !"Назад");
                    }
                    case 9:
					{
						if(PI[playerid][data_FIXCOMPL] >= 3) return SCM(playerid, COLOR_GREY, !"Вы не можете преобрести более 3 Рем.Комплектов.");
						if(GetPlayerMoneyID(playerid) < FIX_CAR) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно для покупки!");

                        new cef[10]; f(cef, 10, "-%dР", FIX_CAR);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка Рем.Комплект"), CEFSTR("fb4949"), CEFSTR(cef));
						SCM(playerid, 0x00AA33FF, !"Вы купили Рем.Комплект {FF9977}1500р руб{00AA33}. Чтобы его использовать {FF9977}/fix");

						GivePlayerMoneyLog(playerid, -FIX_CAR);
						PI[playerid][data_FIXCOMPL] += 1;
						ShowShopMenu(playerid);
					}
			    }
			}
		}
    }
    return 1;
}
callback: CheckSimCard(playerid) 
{
	new rows;
	rows = cache_num_rows();
    
    if(rows) return ShowPlayerDialog(playerid, 6990, DIALOG_STYLE_INPUT, "{ee3366}Покупка номера телефона", "{FFFFFF}Введите желаем {3377cc}6-значный{FFFFFF} номер телефона\nНовая SIM-карта заменит текущую (при eё наличии).\n{696969}Отменить это действие будет невозможно", "Купить", "Назад");
	else
	{
		new b = GetPVarInt(playerid,"business");
        if(BizInfo[b][bProduct] <= 0  || BizInfo[b][bOwned] == 0) return SendClientMessage(playerid, COLOR_GREY, !"У бизнеса недостаточно продуктов");
        
		GivePlayerMoneyLog(playerid,-SIM_CARD);
		PI[playerid][data_NUMBER] = GetPVarInt(playerid,"simcard");
		UpdatePlayerDataInt(playerid, "number", PI[playerid][data_NUMBER], 28023);
		cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка сим-карты"), CEFSTR("fb4949"), CEFSTR("-300P"));
		ShowPlayerDialogf(playerid, 0, DIALOG_STYLE_MSGBOX, !"{ee3366}Покупка SIM-карты", "Закрыть", "Назад", "{FFFFFF}Поздравляем!\nВы купили SIM-карту c номером {3377cc}%d", GetPVarInt(playerid,"simcard"));
		UpdateBusinessData(b);
	}
	return 1;
}
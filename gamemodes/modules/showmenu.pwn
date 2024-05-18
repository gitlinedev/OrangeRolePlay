//
//==================================[ stocks ] ====================================//
stock ShowShopMenu(playerid)
{
    ShowPlayerDialog(playerid, 3520, DIALOG_STYLE_LIST, !"{ee3366}Магазин 24/7", !"\
	1. Чипсы (с собой)\t\t\t\t{ebeb8e}150 руб.\n\
	{ffffff}2. Пицца (с собой)\t\t\t\t{ebeb8e}400 руб.\n\
	{ffffff}3. Букет цветов 'Миллионы алых роз'\t\t{ebeb8e}500 руб.\n\
	{ffffff}4. Медицинская аптечка\t\t\t{ebeb8e}200 руб.\n\
	{ffffff}5. Фотоапарат\t\t\t\t\t{ebeb8e}500 руб.\n\
	{ffffff}6. Балончик с краской\t\t\t\t{ebeb8e}400 руб.\n\
	{ffffff}7. Маска\t\t\t\t\t{ebeb8e}300 руб.\n\
	{ffffff}8. bPhoneXX\t\t\t\t\t{ebeb8e}5500 руб.\n\
	{ffffff}9. SIM картка (6 цифр)\t\t\t\t{ebeb8e}300 руб.\n\
	{ffffff}9. Ремонтный набор\t\t\t\t{ebeb8e}1500 руб.", !"Купить", !"Закрыть");
    return 1;
}
//==================================[ dialogs ]=====================================//
stock shop_OnDialogResponse(playerid, dialogid, response, listitem) 
{
    switch(dialogid)
    {
        case 3520: 
		{
		    new b = GetPVarInt(playerid,"business");
		    if(!response) return 1;
			if(response) 
			{
			    switch(listitem) 
				{
			        case 0: 
                    {
                        SCM(playerid, 0x00AA33FF, !"Вы купили 'Чипсы' (всего: {FF9977}1 шт{00AA33}). Чтобы покушать используйте {FF9977}/eat");
                    }
			        case 1: 
                    {
                        SCM(playerid, 0x00AA33FF, !"Вы купили 'Пицца' (всего: {FF9977}1 шт{00AA33}). Чтобы покушать используйте {FF9977}/eat");
                    }
			        case 2: 
                    {
					    new cena = 500;
					    if(BizInfo[b][bProduct] >= 0  && BizInfo[b][bOwned] == 1) 
                        {
							BizInfo[b][bMoney] += cena;
							BizInfo[b][bProduct] -= 1;
						}
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid,-cena);
						BizInfo[b][bMoney] += cena;
						BizInfo[b][bProduct] -= 1;
						GiveWeapon(playerid, 14, 1);
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка цветов"), CEFSTR("fb4949"), CEFSTR("-500P"));
						SCM(playerid, 0x00AA33FF, !"Вы купили букет цветов. Чтобы подарить используйте {FF9977}/flowers");
						ShowShopMenu(playerid);
					}
					case 3:
					{
					    new cena = 200;
					    if(PI[playerid][pHealPack] == 3) return SCM(playerid, COLOR_GREY, !"Вы можете купить не более 3х аптечек");
					    if(BizInfo[b][bProduct] >= 0  && BizInfo[b][bOwned] == 1) 
                        {
							BizInfo[b][bMoney] += cena;
							BizInfo[b][bProduct] -= 1;
						}
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid,-cena);
						BizInfo[b][bMoney] += cena;
						BizInfo[b][bProduct] -= 1;
						PI[playerid][pHealPack]++;
						UpdatePlayerDataInt(playerid, "healthchest", PI[playerid][pHealPack],10245);
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка мед. аптечки (/healme)"), CEFSTR("fb4949"), CEFSTR("-300P"));
						SCMf(playerid, 0x00AA33FF, "Вы купили мед. аптечку{FF9977} (%d из 3){00AA33} за {FF9977}300 рублей", PI[playerid][pHealPack]);
						SCM(playerid, 0x00AA33FF, !"Чтобы подлечиться используйте {FF9977}/healme{00AA33}, передать другому игроку {FF9977}/givechest");
						ShowShopMenu(playerid);
					}
					case 4:
					{
					    new cena = 500;
					    if(BizInfo[b][bProduct] >= 0  && BizInfo[b][bOwned] == 1)
                        {
							BizInfo[b][bMoney] += cena;
							BizInfo[b][bProduct] -= 1;
						}
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid,-cena);
						BizInfo[b][bMoney] += cena;
						BizInfo[b][bProduct] -= 1;
						GiveWeapon(playerid, 43, 20);
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка фотоапарата"), CEFSTR("fb4949"), CEFSTR("-500P"));
						SCM(playerid, 0x00AA33FF, !"Вы купили фотоапарат.");
						ShowShopMenu(playerid);
					}
					case 5:
					{
					    new cena = 400;
					    if(BizInfo[b][bProduct] >= 0  && BizInfo[b][bOwned] == 1) 
                        {
							BizInfo[b][bMoney] += cena;
							BizInfo[b][bProduct] -= 1;
						}
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid,-cena);
						BizInfo[b][bMoney] += cena;
						BizInfo[b][bProduct] -= 1;
						GiveWeapon(playerid, 41, 1000);
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка балончика с краской"), CEFSTR("fb4949"), CEFSTR("-400P"));
						SCM(playerid, 0x00AA33FF, !"Вы купили балончик с краской.");
						ShowShopMenu(playerid);
					}
					case 6:
					{
					    new cena = 300;
					    if(PI[playerid][data_MASK] >= 1) return SCM(playerid, COLOR_GREY, !"Вы не можете преобрести более 1-й маски");
					    if(BizInfo[b][bProduct] >= 0  && BizInfo[b][bOwned] == 1)
						{
							BizInfo[b][bMoney] += cena;
							BizInfo[b][bProduct] -= 1;
						}
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
						GivePlayerMoneyLog(playerid,-cena);
						PI[playerid][data_MASK]++;
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка маски"), CEFSTR("fb4949"), CEFSTR("-300P"));
						SCM(playerid, 0x00AA33FF, !"Вы купили маску за {FF9977}300 руб{00AA33}. Чтобы надеть её используйте {FF9977}/mask");
						ShowShopMenu(playerid);
					}
					case 7: 
                    {
                        ShowPlayerDialog(playerid, 6989, DIALOG_STYLE_MSGBOX, !"{ee3366}Покупка телефона", !"\
                        {FFFFFF}Вы действительно хотите купить {3366cc}bPhone XX{ffffff} за {3366cc}5500 руб{ffffff}?\n\
                        Новый телефон заменит текущий (при его наличии).\n\
                        {696969}Отменить это действие будет невозможно", !"Купить", !"Назад");
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
						if(PI[playerid][data_FIXCOMPL] >= 5) return SCM(playerid, COLOR_GREY, !"Вы не можете преобрести более 3 Рем.Комплектов.");
						if(GetPlayerMoneyID(playerid) < 1500) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно для покупки!");

						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("Покупка Рем.Комплект"), CEFSTR("fb4949"), CEFSTR("-1500P"));
						SCM(playerid, 0x00AA33FF, !"Вы купили Рем.Комплект {FF9977}1500р руб{00AA33}. Чтобы его использовать {FF9977}/fix");

						GivePlayerMoneyLog(playerid, -1500);
						PI[playerid][data_FIXCOMPL] += 1;
						ShowShopMenu(playerid);
					}
			    }
			}
		}
    }
    return 1;
}
new MineInventory[MAX_PLAYERS];
new MineOre[MAX_PLAYERS];
new MineTypeOre[MAX_PLAYERS];
new AntiFloodMine[MAX_PLAYERS];

new OrePrice = 105;
new InvPrice = 20;

new MineClothes;
new MinePoint_1;
new MinePoint_2;
new MinePoint_3;
new MinePoint_4;
new MineDropOre;

new MineOreStock;
new MineCoalStock;
new Text3D: MineInfo;

stock mine_OnDialogResponse(playerid, dialogid, response) 
{
    switch(dialogid) 
	{
        case 4001:
        {
            if(!response) return 1;
            if(response)
            {
                SendClientMessage(playerid, COLOR_JOBYELLOW, !"Вы начали работу шахтёра");
                SendClientMessage(playerid, COLOR_JOBYELLOW, !"Добывайте железную и угольную руду в шахте");

                PI[playerid][pUseAccessory] = 0;
                for(new i; i < 10; i++) RemovePlayerAttachedObject(playerid, i);

		        SetPlayerAttachedObject(playerid, 1, 18634, 14, 0.333391, 0.000000, 0.042249, 358.219909, 268.014739, 170.032974, 2.003867, 1.764811, 1.579773);
		        SetPlayerSkinAC(playerid, 254);

                PI[playerid][pTempJob] = 2;

                PI[playerid][PTempJobValue_1] = 0; 
                PI[playerid][PTempJobValue_2] = 0; 
                PI[playerid][pTempJobMoney] = 0; 

                MineInventory[playerid] = 0;

                MineOre[playerid] = 0;

                SetPVarInt(playerid, "PlayerInDialog", 1);

                CEF__Dialog(playerid, 4003, DIALOG_STYLE_MSGBOX, "{ee3366}Инвентарь для работы", "\
                Вы хотите преобрести дополнительный инвентарь?\n\n\
                Стоимость: {000000}250 руб\n\n\
                {696969}Инвентарь позволяет существенно повысить зарплату", "Купить", "Отмена");

                return 1;
            }
        }
        case 4002:
        {
            if(!response) return 1;
            if(response)
            {
                new skin = GetSkinOfPlayer(playerid);

                new Sum = PI[playerid][PTempJobValue_1]+PI[playerid][PTempJobValue_2];
                new Profit = Sum*InvPrice;
                new Money = Sum*OrePrice;
                
                SendClientMessage(playerid, -1, "Вы завершили рабочий день (Шахтёр)");
                if(MineInventory[playerid] == 1) SendClientMessagef(playerid, -1, "Надбавка за дополнительный инвентарь: {FF9900}%d руб", Profit);
                SendClientMessagef(playerid, -1, "Добыто руды: {FF9900}%d кг", PI[playerid][PTempJobValue_2]);
                SendClientMessagef(playerid, -1, "Добыто угля: {FF9900}%d кг", PI[playerid][PTempJobValue_1]);
                SendClientMessagef(playerid, -1, "Всего заработано: {FF9900}%d руб", Profit+Money);

                GivePlayerMoneyLog(playerid, Profit+Money);

                SetPlayerSkin(playerid, skin);

                PI[playerid][pTempJob] = 0;

                PI[playerid][PTempJobValue_1] = 0; 
                PI[playerid][PTempJobValue_2] = 0; 
                PI[playerid][pTempJobMoney] = 0; 

                MineInventory[playerid] = 0;

                if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid, 4);
                if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid, 1);
            }
        }
        case 4003:
        {
            if(!response) return DeletePVar(playerid, "PlayerInDialog");
            if(response)
            {
                if(GetPlayerMoneyID(playerid) < 250) return SendClientMessage(playerid, COLOR_GREY, !"У Вас недостаточно денег");
                
                MineInventory[playerid] = 1;
                GivePlayerMoneyLog(playerid, -250);

                SendClientMessage(playerid, COLOR_JOBYELLOW, !"Вы купили инвентарь для работы за {3377CC}250 руб");
                cef_emit_event(playerid, "show-center-notify", CEFINT(1), CEFSTR("Инвентарь увеличит зарплату в конце работы. Чем больше работы Вы сделаете, тем больше будет бонус"));
                
                DeletePVar(playerid, "PlayerInDialog");
                return 1;
            }
        }
    }
    return 1;
}
stock mineOnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(AntiFloodMine[playerid] > gettime()) return 1;

    if(pickupid == MineClothes)
	{
		if(PI[playerid][pTempJob] == 0)
		{
			ShowPlayerDialog(playerid, 4001, DIALOG_STYLE_MSGBOX, !"{ee3366}Работа шахтёра", !"\
			{FFFFFF}Вы хотите устроиться на работу шахтёром?\n\
			Ваша основная задача - добыча железной руды и угля.\n\n\
			Обратите внимание: если Вы покините территорию\n\
			шахты, заработанная плата будет аннулирована", !"Да", !"Нет");
		}
		else if(PI[playerid][pTempJob] == 2 && GetPVarInt(playerid, "PlayerInDialog") == 0)
		{
			ShowPlayerDialog(playerid, 4002, DIALOG_STYLE_MSGBOX, !"{ee3366}Шахтёр", !"\
			{FFFFFF}Вы уверены, что хотите завершить рабочий день?", !"Завершить", !"Отмена");
		}
	}
	if(pickupid == MinePoint_1 || pickupid == MinePoint_2 || pickupid == MinePoint_3 || pickupid == MinePoint_4)
	{
		if(PI[playerid][pTempJob] == 2)
		{
            if(MineOre[playerid] == 1) return 1;
            new type = RandomEX(1, 2);
            MineTypeOre[playerid] = type;
	   	    ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 1, 4800);
            SetTimerEx("TimerGiveMiner", 5000, false, "i", playerid);
		}
	}
    if(pickupid == MineDropOre)
    {
        if(PI[playerid][pTempJob] == 2)
        {
            if(MineOre[playerid] == 0) return 1;

            ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 1, 1130);

            RemovePlayerAttachedObject(playerid, 4);
            SetPlayerAttachedObject(playerid, 1, 18634, 14, 0.333391, 0.000000, 0.042249, 358.219909, 268.014739, 170.032974, 2.003867, 1.764811, 1.579773);

            if(MineTypeOre[playerid] == 2)
            {
                PI[playerid][PTempJobValue_1] += 1;
                MineCoalStock++;
                SendClientMessagef(playerid, COLOR_JOBYELLOW, "Уголь доставлен на склад. Всего доставлено: {3377CC}%d ед {FFCD00}сырья", PI[playerid][PTempJobValue_1]+PI[playerid][PTempJobValue_2]);
            }
            if(MineTypeOre[playerid] == 1)
            {
                PI[playerid][PTempJobValue_2] += 1;
                MineOreStock++;
                SendClientMessagef(playerid, COLOR_JOBYELLOW, "Руда доставлена на склад. Всего доставлено: {3377CC}%d ед {FFCD00}сырья", PI[playerid][PTempJobValue_1]+PI[playerid][PTempJobValue_2]);
            }
            MineTypeOre[playerid] = 0;
            MineOre[playerid] = 0;
            UpdateMine();
            return 1;
        }
    }
    AntiFloodMine[playerid] = gettime() + 5;
    return 1;
}
stock mine_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_JUMP)) 
	{
        if(MineOre[playerid] == 1)
        {
            if(PI[playerid][pTempJob] == 2)
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid, 4);
                SetPlayerAttachedObject(playerid, 1, 18634, 14, 0.333391, 0.000000, 0.042249, 358.219909, 268.014739, 170.032974, 2.003867, 1.764811, 1.579773);

                cef_emit_event(playerid, "show-center-notify", CEFINT(2), CEFSTR("Вы уронили руду! Попробуйте ещё раз"));
                ClearAnimations(playerid);
                MineTypeOre[playerid] = 0;
                MineOre[playerid] = 0;
            }
 		}
    }
}
callback: TimerGiveMiner(playerid)
{
    //ClearAnimations(playerid);

    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 1, 1);

    MineOre[playerid] = 1;
    RemovePlayerAttachedObject(playerid, 1);
    SetPlayerAttachedObject(playerid, 4, 2936, 1, 0.184699, 0.426247, 0.000000, 259.531341, 80.949592, 0.000000, 0.476124, 0.468181, 0.470769);
}
//================================= [ Other ] ==========================//
stock UpdateMine()
{
    new str_mine[135];
    format(str_mine, sizeof str_mine, "{ff9933}Шахта\n\n\
                                        {FFFFFF}Металла на складе: {ffcc33}%d кг\n\
                                        {FFFFFF}Угля на складе: {cc6666}%d кг", MineOreStock, MineCoalStock);
    UpdateDynamic3DTextLabelText(MineInfo, -1, str_mine);

    mysql_queryf(mysql, "UPDATE `warehouse` SET `metall` = '%d', `coal` = '%d'", false, MineOreStock, MineCoalStock);
    return 1;
}
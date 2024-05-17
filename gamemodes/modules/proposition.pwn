static const stock VehicleNames[][] = {
	"BMW X5","Audi A6 C8","Mersedec Akula","Lexus GX460","BMW M5 F90 2021","Mercedes-Benz E63","Камаз-ММЗ","Камаз Мусорный","Audi A6 2019","Mercedes GL63","Audi R8","Lada Kalina",
	"Lexus GSF","Nissan Titan 2017","BMW M5","Porsche 911","Ambulance","Скорая помощь","Volkswagen Multivan","ВАЗ 2107","Nissan GTR","Washington","Infiniti JX 35 2013","Mr Whoopee","BF Injection",
	"Hunter","Audi A6","Газель","Инкасатор","ГАЗ-М22","Predator","ЛиАЗ-677М","Rhino","ЗИЛ 131","Hotknife","Trailer","Toyota MarkII","Ikarus 260","ГАЗ-2402",
	"ИЖ-412","Rumpo","RC Bandit","Romero","Packer","Monster","ЗИЗ-45","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","ГАЗ-3309","Caddy","Audi A6","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"BMW 535i","Mercedes GLE","Sanchez","Sparrow","Patriot","Audi A7","Coastguard","Dinghy","ГАЗ-21И","Toyota Land Cruiser","Rustler","ZR3 50","ИЖ-27151","ВАЗ-2114",
	"Toyota Supra","Велосипед","Burrito","ПАЗ-3205","Marquis","ГАЗ 2402","Dozer","Maverick","News Chopper","Chevrolet Niva","FBI Rancher","Virgo","ВАЗ 2109",
	"Jetmax","Hotring","Sandking","ЗАЗ-1102","Police Maverick","Boxville","ГАЗ-53","УАЗ-69","RC Goblin","Hotring A","Mersedes Benz E200",
	"Bloodring Banger","Rancher","Super GT","ГАЗ-2401"," УАЗ-452","Велик","Горный велик","Beagle","Cropdust","Stunt","КАМАЗ-54115","КАЗ-608В",
	"ВАЗ-21099","РАФ-2203"," ЕРАЗ-672","Shamal","Hydra","ИЖ Планета 5","NRG-500","Урал","Cement Truck","Эвакуатор","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","М5 F90","Bugatti Chiron","ВАЗ 2424",
	"Москвич-434","Firetruck","Москвич-400","Москвич-2125","Москвич-2140","Cargobob","ЗАЗ-968А","Sunrise","ГАЗ 31105","Utility","Nevada","УАЗ-3303","ЗАЗ-968М","Monster A",
	"Monster B","Lamborghini Huracan Devo","Acura NSX GT3","Orange Porshe","ИЖ Москвич-427","Elegy","Raindance","RC Tiger","ВАЗ 2108","ВАЗ 2104","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","ГАЗ-М20","Москвич-408","AT-400","ЗИЛ-157","Mersedes G65","BMW X5M","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Восход 3М","Euros","ЛиАЗ-677","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","ГАЗ-2401","ВАЗ 21099",
	"ВАЗ 2114","УАЗ 469","ИЖ-2717","S.W.A.T.","Alpha","Phoenix","Glendale","Sadler","L Trailer A","L Trailer B",
	"Stair Trailer","ЛАЗ-699Р","Farm Plow","U Trailer"
};

stock SendRequestForPlayer(playerid, id, type, value = 0, value_2 = 0) 
{

	PI[playerid][pRequestType] = type;
	PI[id][pRequestType] = type;

	PI[playerid][pRequestIDFor] = id;
	PI[id][pRequestIDFrom] = playerid;

	new gun_id = GetPlayerWeapon(playerid);

	if(type == 1)
	{
		if(CarInfo[PI[playerid][pLoadVehicleID]][cPremium] == 1)
		{
			//  {CCCCCC}(включая налог на премиум транспорт: %d руб) ВЫРЕЗАЛ
			SCMf(id, 0x33ceffFF, "%s предложил Вам купить транспорт '%s' за %d руб", getName(playerid), VehicleNames[CarInfo[PI[playerid][pLoadVehicleID]][cModel]-400], value+value_2);
			SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
		}
		else 
		{
			SCMf(id, 0x33ceffFF, "%s предложил Вам купить транспорт '%s' за %d руб", getName(playerid), VehicleNames[CarInfo[PI[playerid][pLoadVehicleID]][cModel]-400], value);
			SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
		}
	}
	if(type == 2)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили %s взять вашу аптечку.", PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам взять аптечку", getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 3)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили %s взять вашу маску.", PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам взять маску",getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 4)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили пожать руку %s",PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам пожать руку.", getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 5)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили пожать руку %s", PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам пожать руку.", getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 6)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили взглянуть на Вашу Мед. карту %s", PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам взглянуть на его Мед. карту.", getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 7)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили взглянуть на Ваши лицензии %s", PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам взглянуть на его лицензии.", getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 8)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили %s сыграть в кости на {73B461}%d рублей{FFFFFF}", PI[id][pName] ,value);
		SCMf(id, 0x33ceffFF, "%s предложил Вам сыграть в кости на {73B461}%d рублей{FFFFFF}", getName(playerid), value);
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 9)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили взглянуть на Ваш паспорт %s", PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам взглянуть на его паспорт.", getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 10)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили взглянуть на Ваши навыки владения оружием %s",PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам взглянуть на его навыки владения оружием.",getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 11)
	{
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 12)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили выйти из тюрьмы игроку %s за {73B461}%d{FFFFFF} рублей",PI[id][pName], value);
		SCMf(id, 0x33ceffFF, "Адвокат %s предложил Вам выйти из тюрьмы за  {73B461}%d{FFFFFF} рублей.",getName(playerid), value);
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 13)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили купить лицензию на оружие игроку %s за 30000 рублей",PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам купить лицензию на оружие за 30000 рублей.",getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	if(type == 14)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили купить водительские права игроку %s за 5000 рублей",PI[id][pName]);
		SCMf(id, 0x33ceffFF, "%s предложил Вам купить водительские права за 5000 рублей.",getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");	
	}
	if(type == 15)
	{
		new cena = GetPVarInt(playerid, "cena")/GetPVarInt(playerid, "pt");
		SCMf(playerid, 0x36e96cFF, "Вы предложили %s купить у Вас %s (%d пт) за %d руб (%d за 1 пт)", PI[id][pName], weapon_names[gun_id], value, GetPVarInt(playerid, "cena"), cena);
		SCMf(id, 0x33ceffFF, "%s предложил Вам купить у него %s (%d пт) за %d руб (%d за 1 пт)", getName(playerid), weapon_names[gun_id], value, GetPVarInt(playerid, "cena"), cena);
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");	
	}
	if(type == 16)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили %s взять у Вас %s (%d пт)",PI[id][pName], weapon_names[gun_id], value);
		SCMf(id, 0x33ceffFF, "%s предложил Вам взять у него %s (%d пт)",getName(playerid), weapon_names[gun_id], value);
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");	
	}
	if(type == 17)
	{
		SCMf(playerid, 0x36e96cFF, "Вы предложили %s пройти курс платного лечения.",PI[id][pName]);
		SCMf(id, 0x33ceffFF, "Сотрудник БЦРБ %s предложил Вам пройти курс платного лечения за 2500 руб.",getName(playerid));
		SCM(id, COLOR_LIGHTGREY, !"Используйте {43d778}Y{CCCCCC} чтобы согласиться или {ff6633}N{CCCCCC}");
	}
	return 1;	
}
stock CheckRequest(playerid)
{
	new from_player = PI[playerid][pRequestIDFrom]; // от игрока (внутри)

	if(from_player != -1)
	{
		if(!IsPlayerConnected(from_player)) return SCM(playerid, COLOR_GREY, !"Игрок вышел из игры");
		if(from_player == playerid) return ClearProposition(playerid);

		new type = PI[playerid][pRequestType];
		new value_1 = PI[from_player][pRequestValue];
		new value_2 = PI[from_player][pRequestValueTwo];

		if(ProxDetectorS(10.0, playerid, from_player)) 
		{
			if(type == 1)
			{
				if(CarInfo[PI[from_player][pLoadVehicleID]][cPremium] == 1)
				{
					if(GetPlayerMoneyID(playerid) < value_1+value_2)
					{
						SCM(playerid, COLOR_LIGHTGREY, !"У Вас недостаточно денег для покупки данного траспорта");
						SCMf(from_player, COLOR_LIGHTGREY, "У игрока %s недостаточно денег", getName(playerid));
					}
					else 
					{
						return ShowPlayerDialogf(playerid, 9221, DIALOG_STYLE_MSGBOX, !"{ee3366}Подтверждение", !"Купить", !"Закрыть",\
								"{FFFFFF}Вы уверены что хотите купить траснсопрт: {3366cc}'%s'{FFFFFF}, за {3366cc}%d руб\n {FFFF99}(включая налог на премиум транспорт: %d руб)",
								VehicleNames[CarInfo[PI[from_player][pLoadVehicleID]][cModel]-400], value_1+value_2, value_2);
					}
				}
				else 
				{
					if(GetPlayerMoneyID(playerid) < value_1)
					{
						SCM(playerid, COLOR_LIGHTGREY, !"У Вас недостаточно денег для покупки данного траспорта");
						SCMf(from_player, COLOR_LIGHTGREY, "У игрока %s недостаточно денег", getName(playerid));
					}
					else 
					{
						return ShowPlayerDialogf(playerid, 9221, DIALOG_STYLE_MSGBOX, !"{ee3366}Подтверждение", !"Купить", !"Закрыть",\
							"{FFFFFF}Вы уверены что хотите купить траснсопрт: {3366cc}'%s'{FFFFFF}, за {3366cc}%d руб", 
							VehicleNames[CarInfo[PI[from_player][pLoadVehicleID]][cModel]-400], value_1);
					}
				}
			}
			if(type == 2)
			{
                new str[145];
			 	PI[from_player][pHealPack]--;
				PI[playerid][pHealPack]++;
				format(str,sizeof(str),"%s передал аптечку %s",PI[from_player][pName], getName(playerid));
			    ProxDetector(25.0, playerid, str, 0xFF99CCFF, 0xFF99CCFF, 0xFF99CCFF, 0xFF99CCFF, 0xFF99CCFF);
			    SetPlayerChatBubble(from_player, "передал аптечку", 0xFF99CCFF, 20.0, 4000);
			}
			if(type == 3)
			{
				new str[145];
			 	PI[from_player][data_MASK]--;
				PI[playerid][data_MASK]++;
				format(str,sizeof(str),"%s передал маску %s",PI[from_player][pName], getName(playerid));
			    ProxDetector(25.0, playerid, str, 0xFF99CCFF, 0xFF99CCFF, 0xFF99CCFF, 0xFF99CCFF, 0xFF99CCFF);
			    SetPlayerChatBubble(from_player, "передал маску", 0xFF99CCFF, 20.0, 4000);
			}
			if(type == 4)
			{
				new Float:angle, str[144];
				GetPlayerFacingAngle(from_player, angle);
				SetPlayerFacingAngle(playerid, angle + 180);
				ApplyAnimation(from_player,"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
				ApplyAnimation(playerid,"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
				format(str, sizeof(str),"%s пожал руку %s", PI[from_player][pName], getName(playerid));
			 	ProxDetector(25.0, playerid, str, 0xFF99CCFF, 0xFF99CCFF, 0xFF99CCFF, 0xFF99CCFF, 0xFF99CCFF);
			}
			if(type == 5)
			{
				new str_3[285];
				format(str_3,sizeof(str_3),"ЦРБ птг. Батырево: \t\t\tДокумент №%d\n\
				Гражданин РФ\t\t\t{3377cc}%s\n\
				{FFFFFF}Анализы\t\t\tПройдены\n\
				{FFFFFF}Физическое состояние\t\t\tНормальное\n\
				{FFFFFF}Зависимость\t\t\tНет", PI[from_player][data_MEDNUM], PI[from_player][pName]);
				return ShowPlayerDialog(playerid,0, DIALOG_STYLE_LIST, "{ee3366}Лицензии", str_3, "Закрыть", "");
			}
			if(type == 6)
			{
				new licb[40+1], licg[40+1];
				switch(PI[from_player][pDriveLicense]) {
     				case 1: format(licb,sizeof(licb),"{FFFFFF}Водительские права: \t\t\t{FF6347}-");
					case 2: format(licb,sizeof(licb),"{FFFFFF}Водительские права: \t\t\t{24ff78}+");
				}
				switch(PI[from_player][pGunLicense]) {
     				case 1: format(licg,sizeof(licg),"{FFFFFF}Лицензия на оружие: \t\t\t{FF6347}-");
					case 2: format(licg,sizeof(licg),"{FFFFFF}Лицензия на оружие: \t\t\t{24ff78}+");
				}
				new str_3[285];
				format(str_3,sizeof(str_3),"Автошкола птг. Батырево: \t\t\tДокумент №%d\nГражданин РФ\t\t\t{3377cc}%s\n%s\n%s", PI[from_player][data_LICNUM], PI[from_player][pName], licb, licg);
				ShowPlayerDialog(playerid,0, DIALOG_STYLE_MSGBOX, PI[from_player][pName], str_3, "Закрыть", "");
			}
			if(type == 7)
			{
				new money = value_1;
		        if(GetPlayerMoneyID(from_player) < money) 
				{
					ClearProposition(from_player);
				    SCM(from_player, COLOR_GREY, !"У Вас недостаточно денег на руках");
					return 1;
				}
    			if(GetPlayerMoneyID(playerid) < money) 
				{
					ClearProposition(from_player);
					SCM(playerid, COLOR_GREY, !"У игрока недостаточно денег на руках");
					return 1;
				}
		        new p1 = RandomEX(1,12);
		        new p2 = RandomEX(1,12);
				if(p1 > p2) {
				    GivePlayerMoneyLog(playerid, -money);
				    GivePlayerMoneyLog(from_player, money);
					cef_emit_event(from_player, "show-center-notify", CEFINT(5), CEFSTR("Вы выиграли"));
		    		cef_emit_event(playerid, "show-center-notify", CEFINT(3), CEFSTR("Вы проиграли"));
				}
				else if(p1 < p2) {
				    GivePlayerMoneyLog(playerid, money);
				    GivePlayerMoneyLog(from_player, -money);
					cef_emit_event(playerid, "show-center-notify", CEFINT(5), CEFSTR("Вы выиграли"));
		    		cef_emit_event(from_player, "show-center-notify", CEFINT(3), CEFSTR("Вы проиграли"));
				}
				else
				{}
		        new str[145];
				format(str,sizeof(str),"%s и %s бросили несколько игральных костей {FF9966}(%d|%d)",PI[from_player][pName],getName(playerid), p1,p2);
		        ProxDetector(25.0, from_player, str, 0xFF99CCFF,0xFF99CCFF,0xFF99CCFF,0xFF99CCFF,0xFF99CCFF);
			}
			if(type == 8)
			{
				new playerhouse[5];
				if(PI[from_player][data_HOUSE] != -1) format(playerhouse,sizeof(playerhouse),PI[from_player][data_HOUSE]);
				else format(playerhouse,sizeof(playerhouse),"---");
				new dialog[256];
				format(dialog,sizeof(dialog),"Имя\t\t\t\t%s\nЛет в области\t\t\t%d\nЗаконнопослушность\t\t%d\nУровень розыска\t\t%d\n{FFFFFF}Номер дома\t\t\t%d\n{FFFFFF}Место работы\t\t%s",PI[from_player][pName],PI[from_player][pLevel],PI[from_player][pRespect],PI[from_player][data_WANTED],playerhouse,PI[from_player][data_JOB]);
				ShowPlayerDialog(playerid,0, DIALOG_STYLE_LIST, "{ee3366}Паспорт", dialog, "Закрыть", "");
				SetPlayerChatBubble(playerid, "просматривает документы", 0xFF99CCFF, 20.0, 4000);
			}
			if(type == 9)
			{
				new dialog[256];
				format(dialog,sizeof(dialog),"1. ТТ:\t\t\t%d %%\n2. Тайзер\t%d %%\n3. Desert Eagle:\t\t%d %%\n4. Дробовик:\t\t\t%d\n5. Автоматический дробовик:\t\t\t%d %%\n6. АК-47:\t\t%d %%", PI[from_player][pSkillPistol],PI[from_player][pSkillSDPistol],PI[from_player][pSkillDeagle],PI[from_player][pSkillShotgun],PI[from_player][pSkillMP5],PI[from_player][data_AK47]);
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "{ee3366}Навыки владения оружием", dialog, "Закрыть", "");
			 	SetPlayerChatBubble(playerid, "просматривает навыки владения оружием", 0xFF99CCFF, 20.0, 4000);
			}
			if(type == 10)
			{
				pDialogCurrectTime[playerid] = gettime() + 5;
				pDialogTimer[playerid] = SetTimerEx("DialogTimerInvite", 500, true, "i", playerid);
			    SetPVarInt(playerid,"from_player",from_player);
				return 1;
			}
			if(type == 11)
			{
				if(GetPlayerMoneyID(playerid) < value_1) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
				GivePlayerMoneyLog(playerid,-value_1);
				GivePlayerMoneyLog(from_player,value_1);
				switch(PI[playerid][pJail]) 
				{
    				case 1: 
					{
				        SetPlayerPosAC(playerid, 22.9993,281.1662,12.0260);
					    SetPlayerVirtualWorld(playerid,0);
					    SetPlayerInterior(playerid,0);
						SetPlayerFacingAngle(playerid, 66);
						SetCameraBehindPlayer(playerid);
					    SCM(playerid, 0x9F81F7FF, !"Адвокат смог освободить Вас из тюрьмы");
				    }
				}
			}
			if(type == 12)
			{
				if(GetPlayerMoneyID(playerid) < 30000) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
				GivePlayerMoneyLog(playerid,-30000);
				GivePlayerMoneyLog(from_player,3000);
				PI[playerid][pGunLicense] = 1;
				if(PI[playerid][data_LICNUM] == 0) PI[playerid][data_NUMBER] = RandomEX(1111111, 6666666);
				SCM(playerid, 0x9F81F7FF, !"Вы купили лицензию на оружие за 30000 рублей");
			}
			if(type == 13)
			{
				if(GetPlayerMoneyID(playerid) < 5000) return SCM(playerid, COLOR_GREY, !"У Вас недостаточно денег на руках");
				GivePlayerMoneyLog(playerid,-5000);
				GivePlayerMoneyLog(from_player,5000);
				PI[playerid][pDriveLicense] = 1;
				if(PI[playerid][data_LICNUM] == 0) PI[playerid][data_NUMBER] = RandomEX(1111111, 6666666);
				SCM(playerid, 0x9F81F7FF, !"Вы купили водительские права за 5000 рублей");
			}
			if(type == 14)
			{
				pDialogCurrectTime[playerid] = gettime() + 5;
				pDialogTimer[playerid] = SetTimerEx("DialogTimerGiveGun", 500, true, "i", playerid);
				SetPVarInt(playerid, "from_player", from_player);
				SetPVarInt(playerid, "value_1", value_1);
			}
			if(type == 15)
			{
				pDialogCurrectTime[playerid] = gettime() + 5;
				pDialogTimer[playerid] = SetTimerEx("DialogTimerSellGun", 500, true, "i", playerid);
				SetPVarInt(playerid, "from_player", from_player);
				SetPVarInt(playerid, "value_1", value_1);
			}
			if(type == 16)
			{
				SCMf(from_player, 0xFF99CCFF, !"Сотрудник БЦРБ %s провёл курс платного лечения.",PI[from_player][pName]);
				GivePlayerMoneyLog(playerid, -2500);
				GivePlayerMoneyLog(from_player, 5000);
				if(PI[playerid][data_VIP] == 0) SetPlayerHealthAC(playerid, 100);
				else SetPlayerHealthAC(playerid, 176);
			}
		}
		else SCM(playerid, COLOR_LIGHTGREY, !"Данный игрок слишком далеко от Вас");
	}
	return 1;
}
stock ClearProposition(playerid) 
{
	PI[playerid][pRequestIDFrom] = -1;
	PI[playerid][pRequestType] = -1;
	PI[playerid][pRequestIDFor] = -1;
	PI[playerid][pRequestValue] = -1; 
	PI[playerid][pRequestValueTwo] = -1;
	return 1;
}
stock CancelRequest(playerid)
{
	if(PI[playerid][pRequestIDFor] != -1) // для
	{
		SCMf(PI[playerid][pRequestIDFor], COLOR_GREY, "%s отменил свое предложение", getName(playerid));
		SCMf(playerid, COLOR_GREY, "Вы отменили свое предложение для игрока %s", PI[PI[playerid][pRequestIDFor]][pName]);

		ClearProposition(PI[playerid][pRequestIDFor]);
	}
	else if (PI[playerid][pRequestIDFrom] != -1) // от
	{
		SCMf(PI[playerid][pRequestIDFrom], COLOR_GREY, "%s отказался от Вашего предложения", getName(playerid));
		SCMf(playerid, COLOR_GREY, "Вы отказались от предложения игрока %s", PI[PI[playerid][pRequestIDFrom]][pName]);

		ClearProposition(PI[playerid][pRequestIDFrom]);
	}
	ClearProposition(playerid);
	return 1;
}
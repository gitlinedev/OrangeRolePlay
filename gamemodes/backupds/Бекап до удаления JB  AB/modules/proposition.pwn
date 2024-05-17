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

stock SendRequestForPlayer(playerid, type)
{
	new id = PI[playerid][pRequestIDFor];
	new value = PI[playerid][pRequestValue];
	new value_2 = PI[playerid][pRequestValueTwo];

	PI[playerid][pRequestType] = type;
	PI[id][pRequestType] = type;

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
		new value = PI[from_player][pRequestValue];
		new value_2 = PI[from_player][pRequestValueTwo];

		if(ProxDetectorS(10.0, playerid, from_player)) 
		{
			if(type == 1)
			{
				if(CarInfo[PI[from_player][pLoadVehicleID]][cPremium] == 1)
				{
					if(GetPlayerMoneyID(playerid) < value+value_2)
					{
						SCM(playerid, COLOR_LIGHTGREY, !"У Вас недостаточно денег для покупки данного траспорта");
						SCMf(from_player, COLOR_LIGHTGREY, "У игрока %s недостаточно денег", getName(playerid));
					}
					else 
					{
						return ShowPlayerDialogf(playerid, 9221, DIALOG_STYLE_MSGBOX, !"{ee3366}Подтверждение", !"Купить", !"Закрыть",\
								"{FFFFFF}Вы уверены что хотите купить траснсопрт: {3366cc}'%s'{FFFFFF}, за {3366cc}%d руб\n {FFFF99}(включая налог на премиум транспорт: %d руб)",
								VehicleNames[CarInfo[PI[from_player][pLoadVehicleID]][cModel]-400], value+value_2, value_2);
					}
				}
				else 
				{
					if(GetPlayerMoneyID(playerid) < value)
					{
						SCM(playerid, COLOR_LIGHTGREY, !"У Вас недостаточно денег для покупки данного траспорта");
						SCMf(from_player, COLOR_LIGHTGREY, "У игрока %s недостаточно денег", getName(playerid));
					}
					else 
					{
						return ShowPlayerDialogf(playerid, 9221, DIALOG_STYLE_MSGBOX, !"{ee3366}Подтверждение", !"Купить", !"Закрыть",\
							"{FFFFFF}Вы уверены что хотите купить траснсопрт: {3366cc}'%s'{FFFFFF}, за {3366cc}%d руб", 
							VehicleNames[CarInfo[PI[from_player][pLoadVehicleID]][cModel]-400], value);
					}
				}
			}
            ClearProposition(playerid);
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
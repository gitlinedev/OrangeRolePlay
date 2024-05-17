static const stock VehicleNames[][] = {
	"BMW X5","Audi A6 C8","Mersedec Akula","Lexus GX460","BMW M5 F90 2021","Mercedes-Benz E63","�����-���","����� ��������","Audi A6 2019","Mercedes GL63","Audi R8","Lada Kalina",
	"Lexus GSF","Nissan Titan 2017","BMW M5","Porsche 911","Ambulance","������ ������","Volkswagen Multivan","��� 2107","Nissan GTR","Washington","Infiniti JX 35 2013","Mr Whoopee","BF Injection",
	"Hunter","Audi A6","������","���������","���-�22","Predator","����-677�","Rhino","��� 131","Hotknife","Trailer","Toyota MarkII","Ikarus 260","���-2402",
	"��-412","Rumpo","RC Bandit","Romero","Packer","Monster","���-45","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","���-3309","Caddy","Audi A6","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"BMW 535i","Mercedes GLE","Sanchez","Sparrow","Patriot","Audi A7","Coastguard","Dinghy","���-21�","Toyota Land Cruiser","Rustler","ZR3 50","��-27151","���-2114",
	"Toyota Supra","���������","Burrito","���-3205","Marquis","��� 2402","Dozer","Maverick","News Chopper","Chevrolet Niva","FBI Rancher","Virgo","��� 2109",
	"Jetmax","Hotring","Sandking","���-1102","Police Maverick","Boxville","���-53","���-69","RC Goblin","Hotring A","Mersedes Benz E200",
	"Bloodring Banger","Rancher","Super GT","���-2401"," ���-452","�����","������ �����","Beagle","Cropdust","Stunt","�����-54115","���-608�",
	"���-21099","���-2203"," ����-672","Shamal","Hydra","�� ������� 5","NRG-500","����","Cement Truck","���������","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","�5 F90","Bugatti Chiron","��� 2424",
	"�������-434","Firetruck","�������-400","�������-2125","�������-2140","Cargobob","���-968�","Sunrise","��� 31105","Utility","Nevada","���-3303","���-968�","Monster A",
	"Monster B","Lamborghini Huracan Devo","Acura NSX GT3","Orange Porshe","�� �������-427","Elegy","Raindance","RC Tiger","��� 2108","��� 2104","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","���-�20","�������-408","AT-400","���-157","Mersedes G65","BMW X5M","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"������ 3�","Euros","����-677","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","���-2401","��� 21099",
	"��� 2114","��� 469","��-2717","S.W.A.T.","Alpha","Phoenix","Glendale","Sadler","L Trailer A","L Trailer B",
	"Stair Trailer","���-699�","Farm Plow","U Trailer"
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
			//  {CCCCCC}(������� ����� �� ������� ���������: %d ���) �������
			SCMf(id, 0x33ceffFF, "%s ��������� ��� ������ ��������� '%s' �� %d ���", getName(playerid), VehicleNames[CarInfo[PI[playerid][pLoadVehicleID]][cModel]-400], value+value_2);
			SCM(id, COLOR_LIGHTGREY, !"����������� {43d778}Y{CCCCCC} ����� ����������� ��� {ff6633}N{CCCCCC}");
		}
		else 
		{
			SCMf(id, 0x33ceffFF, "%s ��������� ��� ������ ��������� '%s' �� %d ���", getName(playerid), VehicleNames[CarInfo[PI[playerid][pLoadVehicleID]][cModel]-400], value);
			SCM(id, COLOR_LIGHTGREY, !"����������� {43d778}Y{CCCCCC} ����� ����������� ��� {ff6633}N{CCCCCC}");
		}
	}
	return 1;	
}
stock CheckRequest(playerid)
{
	new from_player = PI[playerid][pRequestIDFrom]; // �� ������ (������)

	if(from_player != -1)
	{
		if(!IsPlayerConnected(from_player)) return SCM(playerid, COLOR_GREY, !"����� ����� �� ����");
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
						SCM(playerid, COLOR_LIGHTGREY, !"� ��� ������������ ����� ��� ������� ������� ���������");
						SCMf(from_player, COLOR_LIGHTGREY, "� ������ %s ������������ �����", getName(playerid));
					}
					else 
					{
						return ShowPlayerDialogf(playerid, 9221, DIALOG_STYLE_MSGBOX, !"{ee3366}�������������", !"������", !"�������",\
								"{FFFFFF}�� ������� ��� ������ ������ ����������: {3366cc}'%s'{FFFFFF}, �� {3366cc}%d ���\n {FFFF99}(������� ����� �� ������� ���������: %d ���)",
								VehicleNames[CarInfo[PI[from_player][pLoadVehicleID]][cModel]-400], value+value_2, value_2);
					}
				}
				else 
				{
					if(GetPlayerMoneyID(playerid) < value)
					{
						SCM(playerid, COLOR_LIGHTGREY, !"� ��� ������������ ����� ��� ������� ������� ���������");
						SCMf(from_player, COLOR_LIGHTGREY, "� ������ %s ������������ �����", getName(playerid));
					}
					else 
					{
						return ShowPlayerDialogf(playerid, 9221, DIALOG_STYLE_MSGBOX, !"{ee3366}�������������", !"������", !"�������",\
							"{FFFFFF}�� ������� ��� ������ ������ ����������: {3366cc}'%s'{FFFFFF}, �� {3366cc}%d ���", 
							VehicleNames[CarInfo[PI[from_player][pLoadVehicleID]][cModel]-400], value);
					}
				}
			}
            ClearProposition(playerid);
		}
		else SCM(playerid, COLOR_LIGHTGREY, !"������ ����� ������� ������ �� ���");
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
	if(PI[playerid][pRequestIDFor] != -1) // ���
	{
		SCMf(PI[playerid][pRequestIDFor], COLOR_GREY, "%s ������� ���� �����������", getName(playerid));
		SCMf(playerid, COLOR_GREY, "�� �������� ���� ����������� ��� ������ %s", PI[PI[playerid][pRequestIDFor]][pName]);

		ClearProposition(PI[playerid][pRequestIDFor]);
	}
	else if (PI[playerid][pRequestIDFrom] != -1) // ��
	{
		SCMf(PI[playerid][pRequestIDFrom], COLOR_GREY, "%s ��������� �� ������ �����������", getName(playerid));
		SCMf(playerid, COLOR_GREY, "�� ���������� �� ����������� ������ %s", PI[PI[playerid][pRequestIDFrom]][pName]);

		ClearProposition(PI[playerid][pRequestIDFrom]);
	}
	ClearProposition(playerid);
	return 1;
}
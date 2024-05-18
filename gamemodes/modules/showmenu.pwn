//
//==================================[ stocks ] ====================================//
stock ShowShopMenu(playerid)
{
    ShowPlayerDialog(playerid, 3520, DIALOG_STYLE_LIST, !"{ee3366}������� 24/7", !"\
	1. ����� (� �����)\t\t\t\t{ebeb8e}150 ���.\n\
	{ffffff}2. ����� (� �����)\t\t\t\t{ebeb8e}400 ���.\n\
	{ffffff}3. ����� ������ '�������� ���� ���'\t\t{ebeb8e}500 ���.\n\
	{ffffff}4. ����������� �������\t\t\t{ebeb8e}200 ���.\n\
	{ffffff}5. ����������\t\t\t\t\t{ebeb8e}500 ���.\n\
	{ffffff}6. �������� � �������\t\t\t\t{ebeb8e}400 ���.\n\
	{ffffff}7. �����\t\t\t\t\t{ebeb8e}300 ���.\n\
	{ffffff}8. bPhoneXX\t\t\t\t\t{ebeb8e}5500 ���.\n\
	{ffffff}9. SIM ������ (6 ����)\t\t\t\t{ebeb8e}300 ���.\n\
	{ffffff}9. ��������� �����\t\t\t\t{ebeb8e}1500 ���.", !"������", !"�������");
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
                        SCM(playerid, 0x00AA33FF, !"�� ������ '�����' (�����: {FF9977}1 ��{00AA33}). ����� �������� ����������� {FF9977}/eat");
                    }
			        case 1: 
                    {
                        SCM(playerid, 0x00AA33FF, !"�� ������ '�����' (�����: {FF9977}1 ��{00AA33}). ����� �������� ����������� {FF9977}/eat");
                    }
			        case 2: 
                    {
					    new cena = 500;
					    if(BizInfo[b][bProduct] >= 0  && BizInfo[b][bOwned] == 1) 
                        {
							BizInfo[b][bMoney] += cena;
							BizInfo[b][bProduct] -= 1;
						}
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"� ��� ������������ ����� �� �����");
						GivePlayerMoneyLog(playerid,-cena);
						BizInfo[b][bMoney] += cena;
						BizInfo[b][bProduct] -= 1;
						GiveWeapon(playerid, 14, 1);
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("������� ������"), CEFSTR("fb4949"), CEFSTR("-500P"));
						SCM(playerid, 0x00AA33FF, !"�� ������ ����� ������. ����� �������� ����������� {FF9977}/flowers");
						ShowShopMenu(playerid);
					}
					case 3:
					{
					    new cena = 200;
					    if(PI[playerid][pHealPack] == 3) return SCM(playerid, COLOR_GREY, !"�� ������ ������ �� ����� 3� �������");
					    if(BizInfo[b][bProduct] >= 0  && BizInfo[b][bOwned] == 1) 
                        {
							BizInfo[b][bMoney] += cena;
							BizInfo[b][bProduct] -= 1;
						}
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"� ��� ������������ ����� �� �����");
						GivePlayerMoneyLog(playerid,-cena);
						BizInfo[b][bMoney] += cena;
						BizInfo[b][bProduct] -= 1;
						PI[playerid][pHealPack]++;
						UpdatePlayerDataInt(playerid, "healthchest", PI[playerid][pHealPack],10245);
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("������� ���. ������� (/healme)"), CEFSTR("fb4949"), CEFSTR("-300P"));
						SCMf(playerid, 0x00AA33FF, "�� ������ ���. �������{FF9977} (%d �� 3){00AA33} �� {FF9977}300 ������", PI[playerid][pHealPack]);
						SCM(playerid, 0x00AA33FF, !"����� ����������� ����������� {FF9977}/healme{00AA33}, �������� ������� ������ {FF9977}/givechest");
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
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"� ��� ������������ ����� �� �����");
						GivePlayerMoneyLog(playerid,-cena);
						BizInfo[b][bMoney] += cena;
						BizInfo[b][bProduct] -= 1;
						GiveWeapon(playerid, 43, 20);
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("������� �����������"), CEFSTR("fb4949"), CEFSTR("-500P"));
						SCM(playerid, 0x00AA33FF, !"�� ������ ����������.");
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
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"� ��� ������������ ����� �� �����");
						GivePlayerMoneyLog(playerid,-cena);
						BizInfo[b][bMoney] += cena;
						BizInfo[b][bProduct] -= 1;
						GiveWeapon(playerid, 41, 1000);
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("������� ��������� � �������"), CEFSTR("fb4949"), CEFSTR("-400P"));
						SCM(playerid, 0x00AA33FF, !"�� ������ �������� � �������.");
						ShowShopMenu(playerid);
					}
					case 6:
					{
					    new cena = 300;
					    if(PI[playerid][data_MASK] >= 1) return SCM(playerid, COLOR_GREY, !"�� �� ������ ���������� ����� 1-� �����");
					    if(BizInfo[b][bProduct] >= 0  && BizInfo[b][bOwned] == 1)
						{
							BizInfo[b][bMoney] += cena;
							BizInfo[b][bProduct] -= 1;
						}
						if(GetPlayerMoneyID(playerid) < cena) return SCM(playerid, COLOR_GREY, !"� ��� ������������ ����� �� �����");
						GivePlayerMoneyLog(playerid,-cena);
						PI[playerid][data_MASK]++;
					    UpdateBusinessData(b);
						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("������� �����"), CEFSTR("fb4949"), CEFSTR("-300P"));
						SCM(playerid, 0x00AA33FF, !"�� ������ ����� �� {FF9977}300 ���{00AA33}. ����� ������ � ����������� {FF9977}/mask");
						ShowShopMenu(playerid);
					}
					case 7: 
                    {
                        ShowPlayerDialog(playerid, 6989, DIALOG_STYLE_MSGBOX, !"{ee3366}������� ��������", !"\
                        {FFFFFF}�� ������������� ������ ������ {3366cc}bPhone XX{ffffff} �� {3366cc}5500 ���{ffffff}?\n\
                        ����� ������� ������� ������� (��� ��� �������).\n\
                        {696969}�������� ��� �������� ����� ����������", !"������", !"�����");
                    }
                    case 8: 
                    {
                        ShowPlayerDialog(playerid, 6990, DIALOG_STYLE_INPUT, "{ee3366}������� ������ ��������", !"\
                        {FFFFFF}������� ������ {3366cc}6-�������{ffffff} ����� ��������\n\
                        ����� SIM-����� ������� ������� (��� e� �������).\n\
                        {696969}�������� ��� �������� ����� ����������", !"������", !"�����");
                    }
                    case 9:
					{
						if(PI[playerid][data_FIXCOMPL] >= 5) return SCM(playerid, COLOR_GREY, !"�� �� ������ ���������� ����� 3 ���.����������.");
						if(GetPlayerMoneyID(playerid) < 1500) return SCM(playerid, COLOR_GREY, !"� ��� ������������ ��� �������!");

						cef_emit_event(playerid, "show-notify-no-img", CEFSTR("������� ���.��������"), CEFSTR("fb4949"), CEFSTR("-1500P"));
						SCM(playerid, 0x00AA33FF, !"�� ������ ���.�������� {FF9977}1500� ���{00AA33}. ����� ��� ������������ {FF9977}/fix");

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
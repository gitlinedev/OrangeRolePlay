CMD:setrang(playerid, params[])
{
	if(PI[playerid][pMember] <=0 ) return 0;
    if(PI[playerid][pRang] < 9) return SCM(playerid, COLOR_GREY, !"Отказано в доступе!");
	extract params -> new player:id, rank; else return SCM(playerid, COLOR_LIGHTGREY, !"Используйте: /setrang [ID игрока] [+/-]");

    if(PI[id][pRankUPTime] > gettime()) return SendClientMessage(playerid, COLOR_GREY, !"Повышать игрока можно раз в 24 часа");
    if(PI[id][pRang] == 10) return SCM(playerid, COLOR_GREY, !"Вы не можете изменять ранг лидеру");
    if(PI[playerid][pRang] == 9) 
    {
        if(rank == 43) if(PI[id][pRang]+1 > 8) return SCM(playerid, COLOR_GREY, !"Вы не можете выдать ранг больше 8");
    }
    if(PI[playerid][pRang] <= PI[id][pRang]) return SCM(playerid, COLOR_GREY, !"Вы не можете управлять рангом игрока схожим с Вами");
    if(PI[id][pMember] != PI[playerid][pMember]) return SCM(playerid, COLOR_GREY, !"Игрок находиться в другой организации!");
    if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY, !"Игрок не найден");
	
    static name[24], nametwo[24];
	SetString(nametwo, NameRang(playerid));
	nametwo = NameRang(playerid);

	SetString(name, NameRang(id));
	name = NameRang(id);

    new oldrang = PI[id][pRang];

    if(rank == 43) // повысить
    {
        if(PI[id][pRang]+1 > 9) return SendClientMessagef(playerid, COLOR_LIGHTGREY, !"Вы не можете повысить этого игрока, так как его ранг равен 9 или больше");
        PI[id][pRang]++;
        SetRang("log_setrang", getName(playerid), PI[id][pRang], getName(id), "повысил");
    }
    else if(rank == 45) // понизить
    {
        if(PI[id][pRang]-1 < 1) return SendClientMessagef(playerid, COLOR_LIGHTGREY, !"Вы не можете понизить этого игрока, так как его ранг равен 1");
        PI[id][pRang]--;
        SetRang("log_setrang", getName(playerid), PI[id][pRang], getName(id), "понизил");
    }
	SCMf(id, 0x9eceffFF, "%s %s[%d] %s Ваш ранг до %s", nametwo, getName(playerid), playerid, oldrang < PI[id][pRang] ? ("понизил"):("повысил"), name);
	SCMf(playerid, 0x9eceffFF, "Вы %s ранг %s[%d] до %s", oldrang > PI[id][pRang] ? ("понизили"):("повысили"), getName(id), id, name);
	PI[id][pRang] = rank;
	UpdatePlayerDataInt(id, "rank", rank, 23215);
	UpdatePlayerDataInt(id, "RankUPTime", gettime()+86400, 23215);
	SavePlayerData(id);
	return 1;
}
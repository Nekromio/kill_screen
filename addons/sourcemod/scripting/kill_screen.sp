#pragma semicolon 1
#pragma newdecls required

ConVar
    cvEnable,
    cvColors,
    cvTime;

public Plugin myinfo =
{
	name = "Kill Screen",
	author = "Nek.'a 2x2 | ggwp.site ",
	description = "Цветной экран при убийстве противника",
	version = "1.0.0",
	url = "https://ggwp.site/"
};

public void OnPluginStart()
{
    cvEnable = CreateConVar("sm_kill_screen_enable", "1", "Включить плагин");

    cvColors = CreateConVar("sm_kill_screen_colors", "0 0 255 255", "Цвет RGB");

    cvTime = CreateConVar("sm_kill_screen_duration", "300", "Вродолжительность");

    HookEvent("player_death", Event_PlayerDeath);

    AutoExecConfig(true, "kill_screen");
}

void Event_PlayerDeath(Event hEvent, const char[] name, bool broadcast)
{
    if(!cvEnable.BoolValue)
        return;

    int client = GetClientOfUserId(hEvent.GetInt("attacker"));

    if(!(0 < client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client)))
        return;
    
    char sColors[32], sBuffer[4][6];
    int iColors[4];
    cvColors.GetString(sColors, sizeof(sColors));
	ExplodeString(sColors, " ", sBuffer, sizeof(sBuffer[]), sizeof(sBuffer[]));
    iColors[0] = StringToInt(sBuffer[0]);
	iColors[1] = StringToInt(sBuffer[1]);
    iColors[2] = StringToInt(sBuffer[2]);
    iColors[3] = StringToInt(sBuffer[3]);

    PerformFade(client, cvTime.IntValue, iColors);
}

stock void PerformFade(int client, int duration, int color[4]) 
{
	Handle hFadeClient = StartMessageOne("Fade", client);
	BfWriteShort(hFadeClient, duration);
	BfWriteShort(hFadeClient, 0);
	BfWriteShort(hFadeClient, (0x0001));
	BfWriteByte(hFadeClient, color[0]);
	BfWriteByte(hFadeClient, color[1]);
	BfWriteByte(hFadeClient, color[2]);
	BfWriteByte(hFadeClient, color[3]);
	EndMessage();
}
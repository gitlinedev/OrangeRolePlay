forward CallbackDialogResponse(playerid, const arguments[]);
public CallbackDialogResponse(playerid, const arguments[]) 
{
	new dId, responsed, list, input[64];
	sscanf(arguments, "P< >ddds[64]", dId, responsed, list, input);
	OnDialogResponse(playerid, dId, responsed, list, input);
	return 1;
}

stock CEF__Dialog(playerid, dialogId, dialogType, dHeader[], dText[], button_1[], button_2[]) 
{
 	cef_emit_event(playerid, "show_dialog", CEFINT(dialogId), CEFINT(dialogType), CEFSTR(dHeader), CEFSTR(dText), CEFSTR(button_1), CEFSTR(button_2));
 	return 1;
}
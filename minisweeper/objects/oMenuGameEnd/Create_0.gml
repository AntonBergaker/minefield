height = 700;
width = 700;
timer = 0;

var _guiX = global.guiWidth;
var _guiY = global.guiHeight;

t_lost = "You Lost";
t_won = "You Won";

t_retry = "Retry";
t_again = "Again";

t_menu = "Menu";

t_record = "You Got a New Record!";

lost = false;
newHighscore = false;
destroy = false;
destroyTimer = false;

inputController = instance_find(oInput,0);

introTimer = 2;

firstStep = true;

menuOffsetX = 0;
menuOffsetY = 0;

lastPanX = 0;
lastPanY = 0;
panSpeedX = 0;
panSpeedY = 0;

bounceOffX = 0;
bounceOffY = 0;
bounceOffYSpd = 0;
bounceOffXSpd = 0;
bounceOffTimerX = 0;
bounceOffTimerY = 0;

for (var i=4;i>=0;i--) {
	panDiffsX[i] = 0;
	panDiffsY[i] = 0;
}

//spawn outside the screen
startY = _guiY + height/2

targetY = _guiY/2;

menu = scr_menu_create(-1,-1,0.6,0.6);
menu.handlesStep = false;
menu.depth = depth-1;
scr_menu_set_button_settings(menu,fa_center,fa_middle,fLightMenu,0.5,0.17)
playButton = scr_menu_create_button(menu,0.5,0.55,lost ? t_retry : t_again,"retry",true);

settingsButton = scr_menu_create_button(menu,0.5,0.73,t_menu,"menu",false);
	
scr_menu_set_button_settings(menu,fa_center,fa_middle,fThinMenu,0.9,0.13)
nameLabel = scr_menu_create_label(menu, 0.5, 0.22, lost ? t_lost : t_won);

scr_menu_set_button_settings(menu,fa_center,fa_middle,fThinMenu,0.55,0.13)
backGround = scr_menu_create_sprite(menu, 0.5,0.45,1.7,1.7,sBigBox, ThemeColors.Card);
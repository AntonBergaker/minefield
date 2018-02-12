var _guiX = global.guiWidth;
var _guiY = global.guiHeight;


var _ratio = _guiX/_guiY;

var _i = oInput;


if (_ratio) > 0.6 {
	menu.width = 0.6/_ratio;
} else {
	menu.width = 1;
}

menu.height = 1;

if (fadeOut) {
		fadeIn-= deltaTimeS*2;
		if (fadeIn < 0) {
			instance_destroy();
			exit;
		}
		alpha = fadeIn;
} else {
	if (fadeIn < 1) {
		fadeIn+= deltaTimeS*2;
		if (fadeIn > 1) {
			fadeIn = 1;
		}
		alpha = fadeIn;
	}
}




for ( var i=0;i<5;i++) {
	//Check panning
	if (_i.touchPressed[i]) {
		var _yy1 = _i.touchYGui[i];
		var _yy2 = _i.touchPressYGui[i];

		if (!_i.touchCompleted[i] && _i.touchAction[i] == TouchAction.None) {
	
			if (global.onPhone) {
				var _dpi = global.dpi/7;
			} else {
				var _dpi = 20;
			}
					
			var _timePressed = _i.touchPressTime[i];
					
			if (point_distance(0,_yy1, 0,_yy2) > _dpi/2 && _timePressed > 0.05) {
				_i.touchAction[i] = TouchAction.MenuPan;
				lastPanY = _yy2;
				_i.touchCompleted[i] = true;
			}
		}
	}
}

///panning
for (var i=0;i<5;i++) {
	if (_i.touchAction[i] == TouchAction.MenuPan) {
		var _yy = _i.touchYGui[i]; 
		
		panSpeedY = (lastPanY - _yy);
		
		for (var ii=3;ii>=0;ii--) {
			panDiffsY[ii+1] = panDiffsY[ii];
		}
		

		panDiffsY[i] = (lastPanY - _yy);
		
		lastPanY = _yy;
		bounceOffYSpd = 0;
		
		//If its the last frame set the speed to the last 5 highest,
		//because your movement can stop otherwise when releasing
		if (_i.touchReleased[i]) {
			for (var ii=1;ii<4;ii++) {
				if (abs(panSpeedY) < abs(panDiffsY[ii])) {
					panSpeedY = panDiffsY[ii];	
				}
			}
			panSpeedY = (panSpeedY + array_average(panDiffsY)) / 2;
		}
	}
}


menuOffsetY += panSpeedY/_guiY;



panSpeedY = lerp_time(panSpeedY,0,0.2,deltaTimeS*2.5);

menuOffsetY = clamp(menuOffsetY, 0, menuHeight-menu.height);


menu.alpha = alpha;
menu.x = 0.5-menu.width/2;
menu.y = 0.5-menu.height/2 - menuOffsetY;
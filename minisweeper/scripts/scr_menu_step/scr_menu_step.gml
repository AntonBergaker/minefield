///@param menu
with (argument0) {

	menuTime += deltaTimeS;	
	
	pressColorFilled = c_white;
	pressColor = c_gray

	selected = noone;
	updatedSlider = noone;
	var _i = inputController;

	var _guiW = global.guiWidth;
	var _guiH = global.guiHeight;

	var _width  = 1/(_guiW * width);
	var _height = 1/(_guiH * height);

	var _pressed = false;
	var _pressedIndex = 0;
	var _released = false;
	var _releasedIndex = 0;

	while (!instance_exists(global.menuStack[| 0])) {
		ds_list_delete(global.menuStack, 0);
	}

	var _active = (active && global.menuStack[| 0] == id)

	if (_active) {
		for (var i=0;i<5;i++) {
			if (_i.touchPressed[i]) {	
				_pressed = true;
				_pressedIndex = i;
			}
			if (_i.touchReleased[i]) {
				_released = true;
				_releasedIndex = i;
			}
		}
	}

	#region buttons
	var _len = ds_list_size(buttons);
	if (_pressed && _i.touchCompleted[_pressedIndex] == false) {
		var _x = (_i.touchPressXGui[_pressedIndex]*_width - x/width);
		var _y = (_i.touchPressYGui[_pressedIndex]*_height - y/height);
	
		for (var i=0;i<_len;i++) {
			var _inst = buttons[| i];
			
			if (_inst.enabled && !_inst.locked) {
				if (point_in_rectangle(_x,_y,_inst.x0,_inst.y0,_inst.x1,_inst.y1)) {
					_inst.pressed = true;
					_inst.pressedX = (_x-_inst.x) / _inst.width;
					_inst.pressedY = (_y-_inst.y) / _inst.height;
					_inst.pressedTime = menuTime-_i.touchPressTime[_pressedIndex];
					_inst.pressedFinger = _pressedIndex;
					_inst.clickedFade = 1;
					_i.touchCompleted[_pressedIndex] = true;
				}
			}
		}
	}
	if (_released) {
		var _x = (_i.touchXGui[_releasedIndex]*_width - x/width);
		var _y = (_i.touchYGui[_releasedIndex]*_height - y/height);
	
		for (var i=0;i<_len;i++) {
			var _inst = buttons[| i];	
		
			if (_inst.pressedFinger == _releasedIndex) {
				if (point_in_rectangle(_x,_y,_inst.x0,_inst.y0,_inst.x1,_inst.y1)) {
					if (_inst.enabled && !_inst.locked)
					{ selected = _inst;}
				}
				_inst.clickedFade = 1;
				_inst.pressed = false;
				_inst.pressedFinger = -1;
			}
		}
	}
	#endregion

	#region sliders
	var _len = ds_list_size(sliders);
	for (var i=0;i<_len;i++) {
		var _inst = sliders[| i];
		_inst.updated = false;
	
		if (_inst.enabled) {
			if (!surface_exists(_inst.surf)) {
				_inst.updatedDraw = true;
			}
	
	
			if ((_inst.positionX mod 1) != 0) {
				if (!_inst.pressed) {
					if (abs(_inst.speedX) < deltaTimeS/5) {
						var _target = -_inst.selectedIndex;
						var _diff = abs((_inst.positionX + _inst.speedX) - _target);
						if (_inst.positionX < _target) {
							_inst.speedX += _diff*0.2*deltaTimeS;	
						} else {
							_inst.speedX -= _diff*0.2*deltaTimeS;
						}
			
			
						_inst.updatedDraw = true;
					}
				}
			}
	
			if (abs(_inst.speedX) > 0) {
				_inst.updatedDraw = true;
				_inst.positionX += _inst.speedX;
				_inst.speedX = lerp_time(_inst.speedX,0,0.2,deltaTimeS*1.2);

				_inst.speedX = value_shift(_inst.speedX, 0, deltaTimeS/1000);

				var _preIndex = _inst.selectedIndex;
				_inst.selectedIndex = -round(_inst.positionX);
		
				if (_preIndex != _inst.selectedIndex) {
					if (_inst.usesData) {
						var _max = array_length_1d(_inst.data);
						var _ind = mod_negative(_inst.selectedIndex, _max);
						_inst.selected = _inst.data[_ind];
			
					} else {
						var _ind = mod_negative(_inst.selectedIndex, _inst.boundHigher - _inst.boundLower+1);
						_inst.selected = _ind + _inst.boundLower;	
					}
					updatedSlider = _inst;
				}
			}
		}
	
		if (_inst.pressed) {
			_inst.updatedDraw = true;
			if (_i.touchReleased[_inst.pressedFinger] || !_inst.enabled || _inst.locked) {
				_inst.pressed = false;
				_inst.pressedFinger = -1;
				var _maxSpeed = 0;
			
				_inst.speedX = array_average(_inst.lastSpeedsX);

			} else {
				var _x = (_i.touchXGui[_pressedIndex]*_width - x/width);	
				var _diff = _x - _inst.pressedLastX;
		
				for (var ii=4;ii>=1;ii--) {
					_inst.lastSpeedsX[ii] = _inst.lastSpeedsX[ii-1];
				}
		
				_inst.speedX = _diff/_inst.entrySeperation;
				_inst.lastSpeedsX[0] = _inst.speedX;
				_inst.pressedLastX = _x;
			}
		
		} else if (_pressed && _i.touchCompleted[_pressedIndex] == false && _i.touchAction[_pressedIndex] == TouchAction.None) {
			if (_inst.enabled && !_inst.locked) {
				var _x = (_i.touchPressXGui[_pressedIndex]*_width - x/width);
				var _y = (_i.touchPressYGui[_pressedIndex]*_height - y/height);	
				if (point_in_rectangle(_x,_y,_inst.x0,_inst.y0,_inst.x1,_inst.y1)) {
					_inst.updated = true;
					_inst.pressed = true;
					_inst.pressedFinger = _pressedIndex;
					_inst.pressedLastX = _x;
					_i.touchAction[_pressedIndex] = TouchAction.Slider;
				}
			}
		}
	}
	#endregion 
	#region toggles
	var _len = ds_list_size(toggles);
	if (_pressed) {
		var _x = (_i.touchPressXGui[_pressedIndex]*_width - x/width);
		var _y = (_i.touchPressYGui[_pressedIndex]*_height - y/height);
	
		for (var i=0;i<_len;i++) {
			var _inst = toggles[| i];
		
			if (_inst.enabled && !_inst.locked) {
				if (point_in_rectangle(_x,_y,_inst.x0,_inst.y0,_inst.x1,_inst.y1)) {
					_inst.pressed = true;
					_inst.pressedTime = menuTime-_i.touchPressTime[_pressedIndex];
					_inst.pressedFinger = _pressedIndex;
					_inst.clickedFade = 1;
				}
			}
		}
	}
	if (_released) {
		var _x = (_i.touchXGui[_releasedIndex]*_width - x/width);
		var _y = (_i.touchYGui[_releasedIndex]*_height - y/height);
	
		for (var i=0;i<_len;i++) {
			var _inst = toggles[| i];	
		
			if (_inst.pressedFinger == _releasedIndex) {
				if (point_in_rectangle(_x,_y,_inst.x0,_inst.y0,_inst.x1,_inst.y1)) {
					if (_inst.enabled && !_inst.locked) {
						_inst.checked = !_inst.checked;
						selected = _inst;
					}
				}
				_inst.clickedFade = 1;
				_inst.pressed = false;
				_inst.pressedFinger = -1;
			}
		}
	}
	#endregion
}
if room == rMain {
	
	var _dpiScale = global.dpiScale;
	
	var _off = (min(oGridControl.fieldHeight, height)/global.guiHeight)*70*_dpiScale;
	//Camera offsets so you can always reach the mine under the settings
	var _minY = -_off;
	var _maxY = _off*0.9;
	if (global.showSwitchButton) {
			_maxY += _off;
	}
	
	var _fieldWidth  = oGridControl.fieldWidth;
	var _fieldHeight = oGridControl.fieldHeight - _minY + _maxY;

	//also fit the zoom
	if (width > _fieldWidth && height > _fieldHeight) {
		var _fieldRatio = _fieldWidth/_fieldHeight;
		if (_fieldRatio > global.displayRatio) {
			width = _fieldWidth;
			height = width/global.displayRatio;
		} else {
			height = _fieldHeight;
			width = height*global.displayRatio;
		}
	}
	
	//if it fits
	if (width < _fieldWidth) {
		x = clamp(x, 0, oGridControl.fieldWidth -width );
	} else { //else it sits
		x = (oGridControl.fieldWidth-width)/2;
	}
	if (height < _fieldHeight) {
		y = clamp(y, _minY, oGridControl.fieldHeight-height+_maxY);
	} else {
		y = ((oGridControl.fieldHeight+_minY+_maxY)/2-height/2);	
	}
	
	

	mip = clamp(round(log2(width/global.windowWidth)/1.5),0,3);
	mipScale = power(2,mip);
}
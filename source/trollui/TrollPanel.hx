package trollui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import trollui.TrollComponent.IComponent;

class TrollPanel extends TrollSlicedSprite
{
	public function new(x: Float = 0, y: Float = 0, ?width: Float, ?height: Float){
		super(x, y, width, height);
		active = false;
	}
	
}
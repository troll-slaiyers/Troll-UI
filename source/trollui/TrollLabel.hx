package trollui;

import flixel.text.FlxText;
import flixel.util.FlxColor;

// TODO: Figure, should I implements IComponent?
// Since that's mainly for interactables (cuz of shit like isHovering) and this isn't really interactable
// This is basically just an FlxText with a preset font
// IDK lol

class TrollLabel extends FlxText
{
	public function new(x:Float, y:Float, fieldWidth:Float = 0, text:String = "", variant:String = "semibold") 
	{
		super(x, y, fieldWidth, text, 12);
		setFormat("assets/fonts/ibmplexmono/" + variant + ".ttf", 12, FlxColor.WHITE); // TODO: Change to Paths in troll engine
		antialiasing = true;
		active = false;
	}
}
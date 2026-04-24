package trollui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import trollui.TrollComponent.UIEvent;

class TrollCheckbox extends TrollComponent
{
	public static final CLICK_EVENT = "checked_box";

	public var textIsClickable:Bool = true;

	var back:FlxSprite;
	var checkmark:FlxSprite;
	var label:TrollLabel;

	public var value(default, set):Bool = false;

	function set_value(val:Bool)
	{
		checkmark.visible = val;
		return value = val;
	}

	public function new(x:Float, y:Float, text:String, defaultValue:Bool = false)
	{
		super(x, y);
		back = new FlxSprite(0, 0).loadGraphic("assets/images/checkbox.png");
		add(back);

		checkmark = new FlxSprite(0, 0).loadGraphic("assets/images/checkmark.png");
		add(checkmark);

		label = new TrollLabel(back.width, 0, 0, text, "bold");
		label.alignment = FlxTextAlign.LEFT;
		label.y = (back.height - label.textField.height) / 2;
		add(label);

		value = defaultValue;
	}

	override function isHovering()
	{
		if (!textIsClickable)
			return FlxG.mouse.overlaps(back, getCamera());

		return super.isHovering();
	}

	override function handleInput(event:UIEvent)
	{
		if (event == MOUSE_RELEASED && hovered)
		{
			value = !value;
			uiParent.handleEvent(CLICK_EVENT, this, value);
		}
	}

}
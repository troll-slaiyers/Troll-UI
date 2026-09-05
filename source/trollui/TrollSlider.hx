package trollui;

import flixel.util.FlxStringUtil;
import flixel.util.helpers.FlxRange;
import flixel.util.FlxColor;
import flixel.FlxG;
import trollui.TrollComponent.UIEvent;
import flixel.FlxSprite;

class TrollSlider extends TrollComponent
{
	public static final CHANGE_EVENT = "change_slider";

	public var value(default, set):Float;
	public var minValue(default, null):Float;
	public var maxValue(default, null):Float;
	public var decimals(default, null):Int = 2;

	public var bar:FlxSprite;
	public var knob:FlxSprite;
	public var valueLabel:TrollLabel;

	public var grabbed:Bool = false;
	
	private var _adjustPosition:Bool = false;

	public function new(x:Float = 0.0, y:Float = 0.0, value:Float, minValue:Float, maxValue:Float)
	{
		super(x, y);

		bar = new FlxSprite(0, 0);
		bar.makeGraphic(100, 10, FlxColor.GRAY);
		add(bar);

		knob = new FlxSprite(0, 0);
		knob.makeGraphic(10, 16, FlxColor.WHITE);
		add(knob);
		knob.y = bar.y - (knob.height - bar.height) / 2;

		valueLabel = new TrollLabel(0, 20, 100, '_');
		add(valueLabel);

		this.value = value;
		setValueBounds(minValue, maxValue);
	}

	public function setValueBounds(minValue:Float, maxValue:Float):Void {
		this.minValue = minValue;
		this.maxValue = maxValue;
		enforceValueBounds();
	}

	public function enforceValueBounds():Void
	{
		if (value < minValue)
			value = minValue;
		else if (value > maxValue)
			value = maxValue;
	}

	////
	override function handleInput(event:UIEvent) {
		switch(event) {
			case MOUSE_PRESSED:
				grabbed = true;
			case MOUSE_RELEASED:
				grabbed = false;
			default:
		}
	}

	override function update(elapsed:Float) {
		if (grabbed) {
			var mouseX:Float = FlxG.mouse.screenX;
			var newValue:Float;

			if (mouseX < bar.x)
				newValue = minValue;
			else if (mouseX > bar.x + bar.width)
				newValue = maxValue;
			else
				newValue = minValue + (maxValue - minValue) * ((mouseX - bar.x) / bar.width);

			if (newValue != value) {
				var snap = Math.pow(10, decimals);
				value = Math.round(newValue * snap) / snap;
				uiParent.handleEvent(CHANGE_EVENT, this, value);
			}

			//// Well
			if (FlxG.mouse.justReleased) {
				grabbed = false;
			}
		}

		if (_adjustPosition) {
			_adjustPosition = false;

			var percent:Float = (value - minValue) / (maxValue - minValue);
			knob.x = bar.x + percent * bar.width - knob.width / 2;

			valueLabel.text = formatValue(value);
		}
		
		super.update(elapsed);
	}

	function formatValue(v:Float):String {
		var str = Std.string(v);
		if (decimals > 0) {
			var dotInd = str.lastIndexOf(".");
			var toAdd:Int; 
			
			if (dotInd == -1) {
				toAdd = decimals;
				str += ".";
			}else {
				toAdd = decimals - (str.length - dotInd - 1);
			}

			for (i in 0...toAdd)
				str += "0";
		}
		return str;
	}

	////
	function set_value(v:Float) {
		value = v;
		_adjustPosition = true;
		return value;
	}
}
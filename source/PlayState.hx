package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import trollui.TrollButton;
import trollui.TrollContainer;
import trollui.TrollGroup;
import trollui.TrollLabel;

class PlayState extends FlxState
{
	var parent: TrollGroup;
	var testSprite: FlxSprite;
	override public function create()
	{	
		
		FlxG.camera.bgColor = 0xFF444444;

		parent = new TrollGroup();
		add(parent);
		
		var container: TrollGroup = new TrollContainer(0, 0, 350, 200);
		parent.add(container);

		var text: TrollLabel = new TrollLabel(25, 25, 0, "Test");
		container.add(text);

		var button: TrollButton = new TrollButton(50, 75, "Butt Bad", 100, 25);
		button.color = 0xFFFF0000;
		container.add(button);
	
		var container2: TrollGroup = new TrollContainer(100, 0, 150, 200);
		parent.add(container2);

		var button: TrollButton = new TrollButton(50, 75, "Butt Good", 100, 25);
		button.color = 0xFF00FF00;
		container2.add(button);
	}

	var t:Float = 0;
	override public function update(elapsed:Float)
	{
		t += elapsed;
		
		super.update(elapsed);
	}
}

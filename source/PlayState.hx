package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import trollui.TrollButton;
import trollui.TrollContainer;
import trollui.TrollLabel;
import trollui.TrollUI;

class PlayState extends FlxState
{
	var parent:TrollUI;
	var testSprite: FlxSprite;
	override public function create()
	{	
		FlxG.mouse.useSystemCursor = true;

		FlxG.camera.bgColor = 0xFF444444;

		parent = new TrollUI();
		add(parent);
		
		var container:TrollContainer = new TrollContainer(0, 0, 350, 200);
		parent.add(container);

		var text: TrollLabel = new TrollLabel(25, 25, 0, "Test");
		container.add(text);

		var button:TrollButton = new TrollButton(50, 75, "Butt Bad", 100, 25, FlxColor.RED);
		button.name = "bad_button";
		container.add(button);
	
		var container2:TrollContainer = new TrollContainer(400, 0, 200, 200);
		parent.add(container2);

		var button:TrollButton = new TrollButton(50, 75, "Butt Good", 100, 25, FlxColor.GREEN);

		button.name = "good_button";
		container2.add(button);
		parent.handleEvent = (event, sender, data) ->
		{
			if (event == TrollButton.CLICK_EVENT)
			{
				switch (sender.name)
				{
					case "good_button":
						text.text = "GOOD";
						text.color = 0xFFFF0000;
					case "bad_button":
						text.text = "BAD";
						text.color = 0xFF00FF00;
				}
			}
		}
		
	}

	var t:Float = 0;
	override public function update(elapsed:Float)
	{
		t += elapsed;
		
		super.update(elapsed);
	}
}

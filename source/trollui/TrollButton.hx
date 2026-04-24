package trollui;

import flixel.FlxG;
import flixel.text.FlxText.FlxTextAlign;
import trollui.TrollComponent.UIEvent;

enum PreSsState {
	IDLE;
	PRESSED;
	HOVERED;
}

class ButtonBack extends TrollSlicedSprite
{
	public function new(width: Float, height: Float){
		super(0, 0, width, height);
		loadGraphic("assets/images/button.png", true, 22, 22);
		borderMargins = [5, 5, 5, 5];
		animation.add("idle", [0], 0, false);
		animation.add("hover", [1], 0, false);
		animation.add("press", [2], 0, false);

		this.width = width;
		this.height = height;
	}
}

class TrollButton extends TrollComponent
{
	var state: PreSsState = IDLE;

	var bg: ButtonBack;
	var label: TrollLabel;

	public function new(x: Float, y:Float, text:String, width:Float = 0, height:Float = 0)
	{
		super(x, y);
		cursor = CLICK;
		childrenAcceptInput = false;
		bg = new ButtonBack(width, height);
		add(bg);
		
		label = new TrollLabel(0, 0, width, text);
		label.alignment = FlxTextAlign.CENTER;
		add(label);

		if(width == 0)
			bg.width = label.width;

		if(height == 0)
			bg.height = label.height;

		label.y += (bg.height - label.textField.height) / 2;

		onUnhover();
		
    }
	
	override function isHovering()
		return bg.isHovering();

	override function handleInput(event: UIEvent){
		switch (event) {
			case MOUSE_ENTER:
				onHover();
				state = HOVERED;
			case MOUSE_MOVED:
				if(state == IDLE){
					state = HOVERED;
					onHover();
				}
			case MOUSE_LEAVE:
				onUnhover();
				state = IDLE;
			case MOUSE_PRESSED:
				state = PRESSED;
				onPress();
			case MOUSE_RELEASED:
				state = isHovering() ? HOVERED : IDLE;
				onRelease();
		}
	}
	
	override function update(elapsed: Float)
	{
		updateButtonVisuals();
		super.update(elapsed);
	}

	public function updateButtonVisuals() {
		switch(state){
			case IDLE:
				bg.animation.play("idle", true);
			case HOVERED:
				bg.animation.play("hover", true);
			case PRESSED:
				bg.animation.play("press", true);
		}

	}

	public dynamic function onHover() {}
	public dynamic function onUnhover() {}
	public dynamic function onPress() {}
	public dynamic function onRelease() {}
}
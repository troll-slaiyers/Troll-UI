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
	public static final DOWN_EVENT = "down_button";
	public static final ENTER_EVENT = "enter_button";
	public static final LEAVE_EVENT = "leave_button";
	public static final CLICK_EVENT = "click_button";

	var state: PreSsState = IDLE;

	var bg: ButtonBack;
	var label: TrollLabel;

	var labelCenterX:Float = 0;
	var labelCenterY:Float = 0;
	
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
			bg.width = label.fieldWidth;

		if(height == 0)
			bg.height = label.height;

		labelCenterX = (bg.width - label.fieldWidth) / 2;
		labelCenterY = (bg.height - label.textField.height) / 2;

		onUnhover();
    }
	
	override function isHovering()
		return bg.isHovering();

	override function handleInput(event: UIEvent){
		switch (event) {
			case MOUSE_ENTER:
				onHover();
				state = HOVERED;
				uiParent.handleEvent(ENTER_EVENT, this, null);

			case MOUSE_LEAVE:
				onUnhover();
				state = IDLE;
				uiParent.handleEvent(LEAVE_EVENT, this, null);
			case MOUSE_PRESSED:
				onPress();
				state = PRESSED;
				uiParent.handleEvent(DOWN_EVENT, this, null);
			case MOUSE_RELEASED:
				if (state == PRESSED)
				{
					onRelease();
					state = isHovering() ? HOVERED : IDLE;
					uiParent.handleEvent(CLICK_EVENT, this, null);
				}
			default:
		}
	}
	
	override function update(elapsed: Float)
	{
		updateButtonVisuals();
		super.update(elapsed);
	}

	public function updateButtonVisuals() {
		label.x = x + labelCenterX;
		label.y = y + labelCenterY;
		switch(state){
			case IDLE:
				bg.animation.play("idle", true);
			case HOVERED:
				bg.animation.play("hover", true);
			case PRESSED:
				bg.animation.play("press", true);
				label.y += 1;
		}
	}

	// BRB PISSING

	public dynamic function onHover() {}
	public dynamic function onUnhover() {}
	public dynamic function onPress() {}
	public dynamic function onRelease() {}
}
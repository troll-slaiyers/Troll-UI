package trollui;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import lime.ui.MouseCursor;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import trollui.TrollComponent.IComponent;

enum CursorType
{
	NONE;
	CLICK;
	DRAG;
	TEXT_INPUT;
}

class TrollUI extends FlxTypedGroup<FlxBasic>
{
	public dynamic function handleEvent(name:String, sender:IComponent, data:Dynamic) {}

	public dynamic function handleCursor(cursor:CursorType)
	{
		switch (cursor)
		{
			case NONE:
				Mouse.cursor = MouseCursor.AUTO;
			case DRAG:
				Mouse.cursor = MouseCursor.HAND;
			case TEXT_INPUT:
				Mouse.cursor = MouseCursor.IBEAM;
			case CLICK:
				Mouse.cursor = MouseCursor.BUTTON;
		}
	}
		

	public var objects: Array<IComponent> = [];

	var hoveringComponent: IComponent;
	var hoveringMember: FlxBasic;

	override function add(obj: FlxBasic): FlxBasic
	{
		if(obj is IComponent)
			cast(obj, IComponent).uiParent = this;

		return super.add(obj);
	}

	override function remove(obj: FlxBasic, splice = false): FlxBasic
	{
		if(obj is IComponent)
			cast(obj, IComponent).uiParent = null;

		return super.remove(obj);
	}

	public inline function setHovering(?obj: FlxBasic){
		if(obj == null){
			hoveringMember = null;
			hoveringComponent = null;
			return;
		}
		hoveringMember = obj;
		hoveringComponent = cast obj;
	}

	var oldHoveringComponent: IComponent;

	override function update(deltaTime: Float) {
		setHovering(null);
		super.update(deltaTime);

		for(component in objects){
			var hovering = component == hoveringComponent;
			if(component.hovered != hovering)
				component.handleInput(hovering ? MOUSE_ENTER : MOUSE_LEAVE);

			component.hovered = hovering;
		}

		if(hoveringComponent != null){
			if (FlxG.mouse.justPressed)
				hoveringComponent.handleInput(MOUSE_PRESSED);

			if(FlxG.mouse.justReleased)
				hoveringComponent.handleInput(MOUSE_RELEASED);

			if(FlxG.mouse.justMoved)
				hoveringComponent.handleInput(MOUSE_MOVED);
		}

		if(hoveringComponent != oldHoveringComponent){
			if(hoveringComponent == null)
				handleCursor(NONE);
			else
				handleCursor(hoveringComponent.cursor);
		}

		oldHoveringComponent = hoveringComponent;
	}

}
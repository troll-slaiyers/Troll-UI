package trollui;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import lime.ui.MouseCursor;
import openfl.ui.Mouse;
import trollui.TrollUI.CursorType;

interface IComponent {
	var uiParent(default, set):TrollUI;
	var hovered:Bool;
	var parent:IComponent;
	var cursor:CursorType;

	function isHovering():Bool;
	function getCamera(): FlxCamera;
	function getCameras(): Array<FlxCamera>;
	function handleInput(uiEvent: UIEvent): Void;
	private function checkInput():Void;
}

// I hope this is fsater than reflection lmao
interface IPostDraw
{
	function postDraw():Void;
}

enum UIEvent {
	MOUSE_ENTER;
	MOUSE_LEAVE;
	MOUSE_MOVED;
	MOUSE_PRESSED;
	MOUSE_RELEASED;
}

class TrollComponent extends FlxSpriteGroup implements IComponent
{
	public var childrenAcceptInput:Bool = true;
	public var cursor:CursorType = NONE;

	public function handleInput(event:UIEvent) {}

	@:noCompletion
	public var parent:IComponent;

	public var uiParent(default, set):TrollUI;

	@:noCompletion
	function set_uiParent(ui:TrollUI)
	{
		if (uiParent != null)
		{
			uiParent.remove(this);
			uiParent.objects.remove(this);
		}

		if (ui != null && !ui.objects.contains(this))
			ui.objects.push(this);

		for (member in members)
		{
			if (member is IComponent)
				cast(member, IComponent).uiParent = ui;
		}

		return uiParent = ui;
	}

	@:noCompletion
	public var hovered:Bool = false;

	public inline function getCamera()
	{
		final cameras: Array<FlxCamera> = getCameras();
		return cameras.length == 0 ? camera : cameras[0];
	}

	public inline function getCameras()
		@:privateAccess
		return parent != null ? parent.getCameras() : FlxCamera._defaultCameras;

	public function isHovering()
		return FlxG.mouse.overlaps(this, getCamera());

	override function preAdd(o: FlxSprite)
	{
		if (o is IComponent)
		{
			cast(o, IComponent).parent = this;
			cast(o, IComponent).uiParent = uiParent;
		}

		return super.preAdd(o);
	}

	override function remove(o: FlxSprite, splice: Bool = false)
	{
		if (o is IComponent && members.contains(o))
		{
			cast(o, IComponent).parent = null;
			cast(o, IComponent).uiParent = null;
		}

		return super.remove(o, splice);
	}

	@:allow(TrollComponent)
	private function checkInput()
	{
		if (isHovering())
			uiParent.setHovering(this);
	}

	override function update(deltaTime:Float)
	{
		if (parent == null)
			checkInput();

		if (childrenAcceptInput)
		{
			for (member in members)
				if (member != null && member.active && member.exists && member is IComponent)
					cast(member, IComponent).checkInput();
		}

		super.update(deltaTime);
	}

	override function draw():Void
	{
		@:privateAccess
		final oldDefaultCameras = FlxCamera._defaultCameras;
		if (cameras != null)
		{
			@:privateAccess
			FlxCamera._defaultCameras = getCameras();
		}

		for (basic in members)
		{
			if (basic != null && basic.exists && basic.visible)
				basic.draw();
		}

		for (basic in members)
		{
			if (basic != null && basic.exists && basic.visible && basic is IPostDraw)
				cast(basic, IPostDraw).postDraw();
		}

		@:privateAccess
		FlxCamera._defaultCameras = oldDefaultCameras;
	}

}
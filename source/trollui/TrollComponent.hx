package trollui;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;

interface IComponent {
	var _hovered: Bool;
	var parent:IComponent;
	public function isHovering(): Bool;
	function getCamera(): FlxCamera;
	function getCameras(): Array<FlxCamera>;
	function handleInput(uiEvent: UIEvent): Void;
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
	public function handleInput(event: UIEvent)
	{
		
	}
	
	@:noCompletion
	public var _hovered: Bool = false; // ONLY FOR INTERNAL USE

	public var parent: IComponent;

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
		if(o is IComponent)
			cast(o, IComponent).parent = this;

		return super.preAdd(o);
	}

	override function remove(o: FlxSprite, splice: Bool = false)
	{
		if(o is IComponent && members.contains(o))
			cast(o, IComponent).parent = null;

		return super.remove(o, splice);
	}


	override function destroy() 
	{
		super.destroy();
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

		@:privateAccess
		FlxCamera._defaultCameras = oldDefaultCameras;
	}

}
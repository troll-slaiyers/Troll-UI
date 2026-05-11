package trollui;

import flixel.FlxCamera;
import flixel.FlxG;
import trollui.TrollComponent.IComponent;
import trollui.TrollComponent.UIEvent;
import trollui.TrollUI.CursorType;

using flixel.util.FlxColorTransformUtil;

class TrollSlicedSprite extends SlicedSprite implements IComponent
{	
	public var name:String = "new_component";
	
	public var uiParent(default, set):TrollUI;

	function set_uiParent(ui:TrollUI)
	{
		if (uiParent != null)
		{
			uiParent.remove(this);
			uiParent.objects.remove(this);
		}

		if (ui != null && !ui.objects.contains(this))
			ui.objects.push(this);

		return uiParent = ui;
	}

	public var cursor:CursorType = NONE;
	public function handleInput(event: UIEvent){} // just for the interface
	public var hovered:Bool = false;

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

	private function checkInput()
	{
		if (isHovering())
			uiParent.setHovering(this);
	}

	override function update(deltaTime:Float)
	{
		if (parent == null)
			checkInput();

		super.update(deltaTime);
	}
}

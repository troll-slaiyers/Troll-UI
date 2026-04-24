package trollui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFrame.FlxFrameType;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.tile.FlxDrawQuadsItem;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.geom.ColorTransform;
import trollui.TrollComponent.IComponent;
import trollui.TrollComponent.UIEvent;
import trollui.TrollUI.CursorType;

using flixel.util.FlxColorTransformUtil;

// thanks Swordcube for letting me steal the cliprect shit from their 9slice
// + some small referencing (though i tried to NOT steal code)

class TrollSlicedSprite extends FlxSprite implements IComponent
{	
	@:isVar
	public var uiParent(default, set):TrollUI;

	public function set_uiParent(ui:TrollUI)
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


	// L, T, R, B
	public var borderMargins: Array<Int> = [7, 7, 7, 7];

	public var minSize: FlxPoint;
	public var parent: IComponent;

	public function new(x: Float = 0, y: Float = 0, ?width: Float, ?height: Float, ?graphic: String, ?margins:Array<Int>)
	{
		super(x, y);
		antialiasing = false;
		loadGraphic(graphic ?? "assets/images/panel.png");

		if(margins != null)
			borderMargins = margins;

		this.width = width;
		this.height = height;
	}
	
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

	// How I do 9-slices requires complex rendering
	// So it should never be simple render
	override function isSimpleRender(?camera: FlxCamera):Bool
		return false;	
	
	override function drawComplex(camera: FlxCamera) 
	{
		_frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, false, false);
		getScreenPosition(_point, camera).subtractPoint(offset);

        _point.x -= ((_width * scale.x) - _width) * 0.5;
        _point.y -= ((_height * scale.y) - _height) * 0.5;

		
		final isColored = (colorTransform != null && colorTransform.hasRGBMultipliers());
		final hasColorOffsets:Bool = (colorTransform != null && colorTransform.hasRGBAOffsets());
		final drawItem: FlxDrawQuadsItem = camera.startQuadBatch(_frame.parent, isColored, hasColorOffsets, blend, antialiasing, shader); 
		final originalFrame: FlxRect = FlxRect.get().copyFrom(_frame.frame);

		var slices: Array<Slice> = [];
		
		final leftM: Float 		= borderMargins[0];
		final topM: Float 		= borderMargins[1];
		final rightM: Float 	= borderMargins[2];
		final bottomM: Float 	= borderMargins[3];

		var centerW: Float = frameWidth - (leftM + rightM);
		var centerH: Float = frameHeight - (topM + bottomM);

		var scaleX:Float = (_width - leftM - rightM) / (frameWidth - leftM- rightM);
		var scaleY:Float = (_height - topM - bottomM) / (frameHeight - topM- bottomM);

		for(i in 0...9){
			switch(i){
				case 0:
					slices.push({
						frame: _frame,
						x: 0,
						y: 0,
						w: leftM,
						h: topM,
						sX: 1,
						sY: 1,
						matrix: _matrix
					});
				case 1:
					slices.push({
						frame: _frame,
						xOffset: leftM,
						x: leftM,
						y: 0,
						w: centerW,
						h: topM,
						sX: scaleX,
						sY: 1,
						matrix: _matrix
					});
				case 2:
					slices.push({
						frame: _frame,
						xOffset: _width - rightM,
						x: frameWidth - rightM,
						y: 0,
						w: rightM,
						h: topM,
						sX: 1,
						sY: 1,
						matrix: _matrix
					});
				case 3:
					slices.push({
						frame: _frame,
						yOffset: topM,
						x: 0,
						y: topM,
						w: leftM,
						h: centerH,
						sX: 1,
						sY: scaleY,
						matrix: _matrix
					});
				case 4:
					slices.push({
						frame: _frame,
						xOffset: leftM,
						yOffset: topM,
						x: leftM,
						y: topM,
						w: centerW,
						h: centerH,
						sX: scaleX,
						sY: scaleY,
						matrix: _matrix
					});
				case 5:
					slices.push({
						frame: _frame,
						xOffset: _width - rightM,
						yOffset: topM,
						x: frameWidth - rightM,
						y: topM,
						w: rightM,
						h: centerH,
						sX: 1,
						sY: scaleY,
						matrix: _matrix
					});
				case 6:
					slices.push({
						frame: _frame,
						yOffset: _height - bottomM,
						x: 0,
						y: frameHeight - bottomM,
						w: leftM,
						h: bottomM,
						sX: 1,
						sY: 1,
						matrix: _matrix
					});
				case 7:
					slices.push({
						frame: _frame,
						xOffset: leftM,
						yOffset: _height - bottomM,
						x: leftM,
						y: frameHeight - bottomM,
						w: centerW,
						h: bottomM,
						sX: scaleX,
						sY: 1,
						matrix: _matrix
					});
				case 8:
					slices.push({
						frame: _frame,
						xOffset: _width - rightM,
						yOffset: _height - bottomM,
						x: frameWidth - rightM,
						y: frameHeight - bottomM,
						w: rightM,
						h: bottomM,
						sX: 1,
						sY: 1,
						matrix: _matrix
					});
				default:
					trace("I do not know how you got here.");
			}
		}

		for(slice in slices){
			_matrix.tx = _point.x;
			_matrix.ty = _point.y;
			slice.draw(drawItem, scale, colorTransform, clipRect);
			slice.frame.frame.copyFrom(originalFrame);
		}

		originalFrame.put();
	}
	
	override function initVars(){
		super.initVars();
		minSize = FlxPoint.get(borderMargins[0] + borderMargins[2], borderMargins[1] + borderMargins[3]);
	}



	// The real width/height of the box because FUCK SCALE
	private var _width: Float = 0;
	private var _height: Float = 0;

	// used for updateHitbox to make sure get_width and get_height return the correct values
	private var scaleX: Float = 1;
	private var scaleY: Float = 1;

	override function get_width() {
		return _width * scaleX;
	}

	override function set_width(v: Float) {
		if(minSize != null && v < minSize.x)
			v = minSize.x;
		
		return _width = v;
	}
	
	override function get_height() {
		return _height * scaleY;
	}
	
	override function set_height(v: Float) {
		if(minSize != null && v < minSize.y)
			v = minSize.y;
		return _height = v;
	}

	override function updateHitbox(){
		scaleX = Math.abs(scale.x);
		scaleY = Math.abs(scale.y);

		offset.set(-0.5 * (width - _width), -0.5 * (height - _height));
		centerOrigin();
	}
}

// holds info on a specific slice
@:structInit
class Slice {
	public var frame: FlxFrame;
	public var matrix: FlxMatrix;
	public var xOffset: Float = 0;
	public var yOffset: Float = 0;
	
	public var x: Float;
	public var y: Float;
	public var w: Float;
	public var h: Float;
	public var sX: Float = 1;
	public var sY: Float = 1;

	public function draw(drawItem: FlxDrawQuadsItem, scale: FlxPoint, transform: ColorTransform, ?clipRect: FlxRect)
	{
		final hasClipRect:Bool = clipRect != null;

		frame.frame.x += x;
		frame.frame.y += y;
		frame.frame.width = w;
		frame.frame.height = h;

		//trace("drawing frame @ " + xOffset + ", " + yOffset + ": (" + frame.frame.x + ", " + frame.frame.y + ") (" + frame.frame.width + " x " + frame.frame.height + ")");

		matrix.a = sX * scale.x;
		matrix.d = sY * scale.y;

		final pointX:Float = matrix.tx;
		final pointY:Float = matrix.ty;

		matrix.tx += xOffset * scale.x;
		matrix.ty += yOffset * scale.y;

		// "thank you swordcube" we all say in unison
		if (hasClipRect) {
			final sx:Float = matrix.tx;
			final sy:Float = matrix.ty;
			final sw:Float = frame.frame.width * matrix.a;
			final sh:Float = frame.frame.height * matrix.d;

			final cx:Float = pointX + (clipRect.x * scale.x);
			final cy:Float = pointY + (clipRect.y * scale.y);
			final cw:Float = clipRect.width * scale.x;
			final ch:Float = clipRect.height * scale.y;

			final ix1:Float = Math.max(sx, cx);
			final iy1:Float = Math.max(sy, cy);
			final ix2:Float = Math.min(sx + sw, cx + cw);
			final iy2:Float = Math.min(sy + sh, cy + ch);

			if(ix2 <= ix1 || iy2 <= iy1)
				return;

			final trimL:Float = ix1 - sx;
			final trimT:Float = iy1 - sy;
			final trimR:Float = (sx + sw) - ix2;
			final trimB:Float = (sy + sh) - iy2;

			frame.frame.x += trimL / matrix.a;
			frame.frame.y += trimT / matrix.d;
			frame.frame.width -= (trimL + trimR) / matrix.a;
			frame.frame.height -= (trimT + trimB) / matrix.d;

			matrix.tx = ix1;
			matrix.ty = iy1;
		}


		frame.uv.set(frame.frame.x / frame.parent.width, frame.frame.y / frame.parent.height, frame.frame.right / frame.parent.width, frame.frame.bottom / frame.parent.height);

		drawItem.addQuad(frame, matrix, transform);
	}
}

package trollui;

class TrollContainer extends TrollGroup 
{
	var panel: TrollPanel;
	public function new(x:Float = 0, y:Float = 0, ?width:Float, ?height: Float)
	{
		super(x, y);
		panel = new TrollPanel(0, 0, width, height);
		add(panel);
	}
}
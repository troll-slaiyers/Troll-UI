package trollui;

import flixel.FlxG;
import flixel.FlxSprite;
import trollui.TrollComponent.IComponent;
import trollui.TrollComponent.UIEvent;

// Does input handling etc
// Every UI element should be part of a TrollGroup

class TrollGroup extends TrollComponent {
	var hoveringComponent: IComponent;
	var hoveringMember: FlxSprite;
	override function handleInput(event: UIEvent)
	{
		if(hoveringComponent != null && event != MOUSE_LEAVE && event != MOUSE_ENTER)
			hoveringComponent.handleInput(event);
	}

	
	function inputUpdate(){
		hoveringComponent = null;
		hoveringMember = null;
		var idx:Int = members.length;

		if(parent == null)_hovered = true;
		
		while(idx-- > 0){
			var member: FlxSprite = members[idx];
			if(member is IComponent && member.active){
				var component:IComponent = cast member;
				var hoverState:Bool = (hoveringComponent != null || !_hovered) ? false : component.isHovering();
				if(component._hovered != hoverState)
					component.handleInput(hoverState ? MOUSE_ENTER : MOUSE_LEAVE);

				component._hovered = hoverState;

				if(hoverState){
					hoveringComponent = component;
					hoveringMember = member;
				}
			}
		}

		// Top-level groups need this to send inputs properly
		// If not top level, then we're just passing through inputs from whoever's sending US inputs
		if(parent == null){
			if(hoveringComponent != null){
				if(FlxG.mouse.justPressed)
					handleInput(MOUSE_PRESSED);
				
				if(FlxG.mouse.justReleased)
					handleInput(MOUSE_RELEASED);

				if(FlxG.mouse.justMoved)
					handleInput(MOUSE_MOVED);
			}
		}
	}
	
	override function update(elapsed: Float){
		inputUpdate();
		
		super.update(elapsed);
	}


}
 
package components;

import js.html.MouseEvent;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;

typedef LinkProps = {
	var onClick:Void -> Void;
	var active:Bool;
	var children:Dynamic;
}

class Link extends ReactComponentOfProps<LinkProps>
{
	override public function render()
	{
		if (props.active)
			return jsx('<span>${props.children}</span>');

		return jsx('
			<a href="#" onClick=$onClick>
				${props.children}
			</a>
		');
	}

	function onClick(e:MouseEvent)
	{
		e.preventDefault();
		props.onClick();
	}
}

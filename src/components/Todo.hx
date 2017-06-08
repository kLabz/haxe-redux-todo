package components;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;

typedef TodoProps = {
	var onClick:Dynamic;
	var completed:Bool;
	var text:String;
}

class Todo extends ReactComponentOfProps<TodoProps>
{
	override public function render()
	{
		var style = {
			textDecoration: props.completed ? 'line-through' : 'none'
		};

		return jsx('
			<li onClick=${props.onClick} style=$style>${props.text}</li>
		');
	}
}

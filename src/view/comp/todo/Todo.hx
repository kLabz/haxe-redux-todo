package view.comp.todo;

import react.ReactMacro.jsx;

private typedef Props = {
	var onClick:Dynamic;
	var completed:Bool;
	var text:String;
}

@:jsxStatic('render')
class Todo {
	static var STYLES = Webpack.require('./Todo.scss');

	static public function render(props:Props) {
		var className = props.completed ? 'done' : null;

		return jsx('
			<li onClick=${props.onClick} className=$className>${props.text}</li>
		');
	}
}


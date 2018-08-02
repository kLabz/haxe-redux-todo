package view.comp.todo;

import react.ReactMacro.jsx;

typedef Props = {
	var onClick:Dynamic;
	var completed:Bool;
	var text:String;
}

@:jsxStatic('render')
class Todo {
	#if webpack
	static var STYLES = Webpack.require('./Todo.scss');
	#end

	static public function render(props:Props) {
		var className = props.completed ? 'done' : null;

		return jsx('
			<li onClick=${props.onClick} className=$className>${props.text}</li>
		');
	}
}


package component;

import react.ReactMacro.jsx;

typedef TodoProps = {
	var onClick:Dynamic;
	var completed:Bool;
	var text:String;
}

@:jsxStatic('render')
class Todo {
	static var STYLES = Webpack.require('./Todo.scss');

	static public function render(props:TodoProps) {
		var className = props.completed ? 'done' : null;

		return jsx('
			<li onClick=${props.onClick} className=$className>${props.text}</li>
		');
	}
}


/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#componentstodojs

```
const Todo = ({ onClick, completed, text }) => (
	<li
		onClick={onClick}
		style={{
			textDecoration: completed ? 'line-through' : 'none'
		}}
	>
		{text}
	</li>
)

Todo.propTypes = {
	onClick: PropTypes.func.isRequired,
	completed: PropTypes.bool.isRequired,
	text: PropTypes.string.isRequired
}
```
*/

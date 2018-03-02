package component;

import js.html.InputElement;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.Redux;
import redux.react.ReactConnector;
import thunk.TodoThunk;

using StringTools;

// The connected component will be accessible via `AddTodo.AddTodo` instead of `AddTodo.Connected`
@:jsxStatic('AddTodo')
class AddTodo extends ReactConnector<AddTodoComponent, AddTodoComponentProps> {
	static function mapDispatchToProps(dispatch:Dispatch):AddTodoComponentProps {
		return {
			addTodo: function(todo:String) return dispatch(TodoThunk.add(todo))
		};
	}
}

typedef AddTodoComponentProps = {
	var addTodo:String -> Void;
}

class AddTodoComponent extends ReactComponentOfProps<AddTodoComponentProps> {
	static var STYLES = Webpack.require('./AddTodo.scss');
	var input:InputElement;

	override public function render() {
		return jsx('
			<form onSubmit=$onSubmit>
				<input ref=$onInputRef autoFocus />
				<button type="submit">+</button>
			</form>
		');
	}

	function onInputRef(node:InputElement) {
		input = node;
	}

	function onSubmit(e) {
		e.preventDefault();
		if (input.value.trim() == "") return;

		props.addTodo(input.value);
		input.value = '';
	}
}

/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#containersaddtodojs

```
let AddTodo = ({ dispatch }) => {
	let input

	return (
		<div>
			<form onSubmit={e => {
				e.preventDefault()
				if (!input.value.trim()) {
					return
				}
				dispatch(addTodo(input.value))
				input.value = ''
			}}>
				<input ref={node => {
					input = node
				}} />
				<button type="submit">
					Add Todo
				</button>
			</form>
		</div>
	)
}

AddTodo = connect()(AddTodo)
```
*/

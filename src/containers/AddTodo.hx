package containers;

import js.html.InputElement;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.Redux;
import redux.react.ReactRedux.connect;
import redux.react.ReactConnector;
import thunk.TodoThunk;

using StringTools;

typedef AddTodoProps = {
	var addTodo:String -> Void;
}

@:connect
class AddTodo extends ReactComponentOfProps<AddTodoProps>
{
	static function mapDispatchToProps(dispatch:Dispatch):AddTodoProps
	{
		return {
			addTodo: function(todo:String) return dispatch(TodoThunk.add(todo))
		};
	}

	var input:InputElement;

	override public function render()
	{
		return jsx('
			<div>
				<form onSubmit=$onSubmit>
					<input ref=$onInputRef />
					<button type="submit">Add Todo</button>
				</form>
			</div>
		');
	}

	function onInputRef(node:InputElement)
	{
		input = node;
	}

	function onSubmit(e)
	{
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

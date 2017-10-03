package containers;

import js.html.InputElement;
import react.Partial;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.Redux;
import redux.react.ReactConnect.ReactConnector;
import TodoListStore.TodoAction;

using StringTools;

// The connected component will be accessible via `AddTodo.AddTodo` instead of `AddTodo.Connected`
@:jsxStatic('AddTodo')
class AddTodo extends ReactConnector<AddTodoComponentProps>
{
	static var wrappedComponent:AddTodoComponent;

	@:connect
	static function addTodo(dispatch:Dispatch, todo:String):Void
	{
		dispatch(TodoAction.Add(todo));
	}
}

typedef AddTodoComponentProps = {
	var addTodo:String -> Void;
}

class AddTodoComponent extends ReactComponentOfProps<AddTodoComponentProps>
{
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

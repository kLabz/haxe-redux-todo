package view.comp.todoList;

import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.Redux;
import dto.TodoData;
import store.AppState;
import store.selector.TodoSelector;
import store.thunk.TodoThunk;
import view.comp.todo.Todo;

private typedef Props = {
	var todos:Array<TodoData>;
	var onTodoClick:Int -> Void;
}

@:connect
class TodoList extends ReactComponentOfProps<Props> {
	static var STYLES = Webpack.require('./TodoList.scss');

	static function mapStateToProps() {
		var getVisibleTodos = TodoSelector.makeGetVisibleTodos();

		return function(state:AppState) {
			return {
				todos: getVisibleTodos(state)
			};
		};
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
		return {
			onTodoClick: function(id:Int) return dispatch(TodoThunk.toggle(id))
		};
	}

	override public function render() {
		var todos = props.todos.map(function(todo) return jsx('
			<Todo
				key=${todo.id}
				{...todo}
				onClick=${props.onTodoClick.bind(todo.id)}
			/>
		'));

		return jsx('
			<ul>
				$todos
			</ul>
		');
	}
}


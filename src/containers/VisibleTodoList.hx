package containers;

import react.Partial;
import redux.Redux;
import redux.react.ReactContainer;
import components.TodoList;
import TodoListStore.TodoAction;
import TodoListStore.TodoData;
import TodoListStore.TodoFilter;

class VisibleTodoList extends ReactContainer<TodoList>
{
	static function mapStateToProps(state:ApplicationState, ownProps:Dynamic):Partial<TodoListProps>
	{
		return {
			todos: getVisibleTodos(state.todoList.todos, state.todoList.visibilityFilter)
		}
	}

	static function getVisibleTodos(todos:Array<TodoData>, filter:TodoFilter)
	{
		return switch (filter) {
			case SHOW_ALL: todos;
			case SHOW_COMPLETED: todos.filter(function(t) return t.completed);
			case SHOW_ACTIVE: todos.filter(function(t) return !t.completed);
		}
	}

	@:connect
	static function onTodoClick(dispatch:Dispatch, id:Int):Void
	{
		dispatch(TodoAction.Toggle(id));
	}
}

/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#containersvisibletodolistjs

const getVisibleTodos = (todos, filter) => {
	switch (filter) {
		case 'SHOW_ALL':
			return todos
		case 'SHOW_COMPLETED':
			return todos.filter(t => t.completed)
		case 'SHOW_ACTIVE':
			return todos.filter(t => !t.completed)
	}
}

const mapStateToProps = (state) => {
	return {
		todos: getVisibleTodos(state.todos, state.visibilityFilter)
	}
}

const mapDispatchToProps = (dispatch) => {
	return {
		onTodoClick: (id) => {
			dispatch(toggleTodo(id))
		}
	}
}

const VisibleTodoList = connect(
	mapStateToProps,
	mapDispatchToProps
)(TodoList)
*/

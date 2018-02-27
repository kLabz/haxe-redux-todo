package selectors;

import reselect.Reselect.createSelector;
import TodoListStore.TodoData;
import TodoListStore.TodoFilter;

class TodoSelectors {
	public static function getVisibilityFilter(state:ApplicationState)
		return state.todoList.visibilityFilter;

	public static function getTodos(state:ApplicationState)
		return state.todoList.todos;

	public static var getVisibleTodos = createSelector(
		[getVisibilityFilter, getTodos],
		function getVisibleTodos(filter:TodoFilter, todos:Array<TodoData>) {
			return switch (filter) {
				case SHOW_ALL: todos;
				case SHOW_COMPLETED: todos.filter(function(t) return t.completed);
				case SHOW_ACTIVE: todos.filter(function(t) return !t.completed);
			}
		}
	);
}

package store.selector;

import reselect.Reselect.createSelector;
import dto.TodoData;
import dto.TodoFilter;

class TodoSelector {
	public static function getVisibilityFilter(state:AppState):TodoFilter
		return state.todoList.visibilityFilter;

	public static function getTodos(state:AppState)
		return state.todoList.todos;

	public static function makeGetVisibleTodos() {
		return createSelector(
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
}

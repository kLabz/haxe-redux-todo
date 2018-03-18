package store.reducer;

import redux.IReducer;
import redux.StoreMethods;
import dto.TodoData;
import dto.TodoFilter;
import model.ExtendObject;

typedef TodoListState = ExtendObject<{
	var visibilityFilter:TodoFilter;
	var todos:Array<TodoData>;
}>;

enum TodoAction {
	Add(text:String);
	Toggle(id:Int);
	SetVisibilityFilter(filter:TodoFilter);
}

class TodoListStore implements IReducer<TodoAction, TodoListState> {
	public var store:StoreMethods<AppState>;
	public var initState:TodoListState = {
		visibilityFilter: SHOW_ALL,
		todos: []
	};

	var ID = 0;

	public function new() {}

	public function reduce(state:TodoListState, action:TodoAction):TodoListState {
		return switch(action) {
			case Add(text):
				var newEntry = {id: ++ID, text: text, completed: false};
				state.copy({
					todos: state.todos.concat([newEntry])
				});

			case Toggle(id):
				var foundId = false;
				var newTodos = [
					for (todo in state.todos) {
						if (todo.id != id) {
							todo;
						} else {
							foundId = true;
							{id: todo.id, text: todo.text, completed: !todo.completed};
						}
					}
				];

				if (!foundId) state
				else state.copy({todos: newTodos});

			case SetVisibilityFilter(filter):
				if (filter == state.visibilityFilter) state
				else state.copy({visibilityFilter: filter});
		}
	}
}

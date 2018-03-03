package store;

import react.ReactUtil.copy;
import redux.IReducer;
import redux.StoreMethods;

typedef TodoListState = {
	var visibilityFilter:TodoFilter;
	var todos:Array<TodoData>;
}

typedef TodoData = {
	var id:Int;
	var completed:Bool;
	var text:String;
}

@:enum abstract TodoFilter(String) from String to String {
	var SHOW_ALL = "SHOW_ALL";
	var SHOW_COMPLETED = "SHOW_COMPLETED";
	var SHOW_ACTIVE = "SHOW_ACTIVE";
}

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
				copy(state, {
					todos: state.todos.concat([newEntry])
				});

			case Toggle(id):
				copy(state, {
					todos: [
						for (todo in state.todos)
							if (todo.id != id) todo;
							else {
								id: todo.id,
								text: todo.text,
								completed: !todo.completed
							}
					]
				});

			case SetVisibilityFilter(filter):
				copy(state, {visibilityFilter: filter});
		}
	}
}

package thunk;

import redux.Redux.Action;
import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import TodoListStore.TodoAction;
import TodoListStore.TodoFilter;

class TodoThunk {
	public static function add(todo:String) {
		return Thunk.Action(function(dispatch, getState) {
			return dispatch(TodoAction.Add(todo));
		});
	}

	public static function addIf(todo:String) {
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->ApplicationState) {
			var todos = getState().todoList.todos;

			if (Lambda.exists(todos, function(t) return t.text == todo))
				return null;

			return dispatch(TodoAction.Add(todo));
		});
	}

	public static function toggle(id:Int) {
		return Thunk.Action(function(dispatch, getState) {
			return dispatch(TodoAction.Toggle(id));
		});
	}

	public static function filter(filter:TodoFilter) {
		return Thunk.Action(function(dispatch, getState) {
			return dispatch(TodoAction.SetVisibilityFilter(filter));
		});
	}

	public static function dummy() {
		return Thunk.WithParams(function(dispatch, getState, params) {
			trace(params); // {custom: "data"}
			return null;
		});
	}
}


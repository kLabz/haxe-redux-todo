Pull request on haxe-redux [here](https://github.com/elsassph/haxe-redux/pull/6).

## Redux thunks

Redux thunks (from [redux-thunk](https://github.com/gaearon/redux-thunk), more informations on thunks available [here](https://stackoverflow.com/questions/35411423/how-to-dispatch-a-redux-action-with-a-timeout/35415559#35415559)) are not really compatible with haxe-redux, since they work by dispatching functions instead of actions and catching them in a middleware.

This PR reproduces this behavior, but with actual actions (recognized by haxe-redux) and a haxe-redux middleware. There is no need for redux-thunk library, this is "native".

### Usage

#### Apply middleware

```haxe

var middleware = Redux.applyMiddleware(
	mapMiddleware(Thunk, new ThunkMiddleware())

	// Or, if you want to add custom data like it is possible with redux-thunk:
	mapMiddleware(Thunk, new ThunkMiddleware({custom: "data"}))
);

return createStore(rootReducer, initialState, middleware);
```

#### Create your thunks

```haxe
class TodoThunk {
	public static function add(todo:String) {
		return Thunk.Action(function(dispatch, getState) {
			return dispatch(TodoAction.Add(todo));
		});
	}

	public static function addIf(todo:String) {
		// Add typing if you want autocompletion and proper typing of your state
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->ApplicationState) {
			var todos = getState().todoList.todos;

			if (Lambda.exists(todos, function(t) return t.text == todo))
				return null;

			return dispatch(TodoAction.Add(todo));
		});
	}

	// If you want to consume the custom data from your thunk:
	public static function dummy() {
		return Thunk.WithParams(function(dispatch, getState, params) {
			trace(params); // {custom: "data"}
			return null;
		});
	}
}
```

#### Use them in a container

```haxe
static function mapDispatchToProps(dispatch:Dispatch) {
	return {
		addTodo: function(todo:String) return dispatch(TodoThunk.add(todo))
	};
}
```

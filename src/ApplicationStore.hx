import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;
import redux.thunk.Thunk;
import redux.thunk.ThunkMiddleware;
import TodoListStore;

class ApplicationStore {
	static public function create():Store<ApplicationState> {
		// store model, implementing reducer and middleware logic
		var todoList = new TodoListStore();

		// create root reducer normally, excepted you must use
		// 'StoreBuilder.mapReducer' to wrap the Enum-based reducer
		var rootReducer = Redux.combineReducers({
			todoList: mapReducer(TodoAction, todoList)
		});

		// create middleware normally, excepted you must use
		// 'StoreBuilder.mapMiddleware' to wrap the Enum-based middleware
		var middleware = Redux.applyMiddleware(
			mapMiddleware(Thunk, new ThunkMiddleware({custom: "data"}))
		);

		return createStore(rootReducer, null, middleware);
	}
}

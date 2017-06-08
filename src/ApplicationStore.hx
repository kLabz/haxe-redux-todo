import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;
import TodoListStore;

class ApplicationStore
{
	static public function create():Store<ApplicationState>
	{
		// store model, implementing reducer and middleware logic
		var todoList = new TodoListStore();

		// create root reducer normally, excepted you must use
		// 'StoreBuilder.mapReducer' to wrap the Enum-based reducer
		var rootReducer = Redux.combineReducers({
			todoList: mapReducer(TodoAction, todoList)
		});

		// create middleware normally, excepted you must use
		// 'StoreBuilder.mapMiddleware' to wrap the Enum-based middleware
		// var middleware = Redux.applyMiddleware(
		// 	mapMiddleware(TodoAction, todoList)
		// );

		// user 'StoreBuilder.createStore' helper to automatically wire
		// the Redux devtools browser extension:
		// https://github.com/zalmoxisus/redux-devtools-extension
		return createStore(rootReducer, null); //, middleware
	}
}

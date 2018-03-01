package containers;

import react.Partial;
import react.ReactComponent;
import redux.Redux;
import redux.react.ReactConnector;
import components.TodoList;
import thunk.TodoThunk;
import selectors.TodoSelectors;
import TodoListStore.TodoData;
import TodoListStore.TodoFilter;

class VisibleTodoList extends ReactGenericConnector<TodoListProps> {
	static function mapStateToProps() {
		var getVisibleTodos = TodoSelectors.makeGetVisibleTodos();

		return function(state:ApplicationState):Partial<TodoListProps> {
			return {
				todos: getVisibleTodos(state)
			};
		};
	}

	static function mapDispatchToProps(dispatch:Dispatch):Partial<TodoListProps> {
		return {
			onTodoClick: function(id:Int) return dispatch(TodoThunk.toggle(id))
		};
	}
}

/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#containersvisibletodolistjs
https://redux.js.org/recipes/computing-derived-data

```
const getVisibilityFilter = state => state.visibilityFilter
const getTodos = state => state.todos
 
export const getVisibleTodos = createSelector(
	[getVisibilityFilter, getTodos],
	(visibilityFilter, todos) => {
		switch (visibilityFilter) {
			case 'SHOW_ALL':
				return todos
			case 'SHOW_COMPLETED':
				return todos.filter(t => t.completed)
			case 'SHOW_ACTIVE':
				return todos.filter(t => !t.completed)
		}
	}
)

const mapStateToProps = (state) => {
	return {
		todos: getVisibleTodos(state)
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
```
*/


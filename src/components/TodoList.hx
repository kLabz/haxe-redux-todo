package components;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import components.Todo.TodoProps;
import TodoListStore.TodoData;

typedef TodoListProps = {
	var todos:Array<TodoData>;
	var onTodoClick:Int -> Void;
}

class TodoList extends ReactComponentOfProps<TodoListProps>
{
	override public function render()
	{
		var todos = props.todos.map(function(todo) return jsx('
			<$Todo
				key=${todo.id}
				{...todo}
				onClick=${props.onTodoClick.bind(todo.id)}
			/>
		'));

		return jsx('
			<ul>
				$todos
			</ul>
		');
	}
}

/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#componentstodolistjs

const TodoList = ({ todos, onTodoClick }) => (
	<ul>
		{todos.map(todo =>
			<Todo
				key={todo.id}
				{...todo}
				onClick={() => onTodoClick(todo.id)}
			/>
		)}
	</ul>
)

TodoList.propTypes = {
	todos: PropTypes.arrayOf(PropTypes.shape({
		id: PropTypes.number.isRequired,
		completed: PropTypes.bool.isRequired,
		text: PropTypes.string.isRequired
	}).isRequired).isRequired,
	onTodoClick: PropTypes.func.isRequired
}
*/

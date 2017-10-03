# Haxe React/Redux Todo App

Implementing react-redux's demo from [here](http://redux.js.org/docs/basics/UsageWithReact.html#implementing-container-components) with new features for [haxe-react](https://github.com/massiveinteractive/haxe-react) and [haxe-redux](https://github.com/elsassph/haxe-redux).

Roadmap:
* [[PR pending]](https://github.com/massiveinteractive/haxe-react/pull/81) `@:jsxStatic` for functional components
* [[PR pending]](https://github.com/elsassph/haxe-redux/pull/6) High Order Components
* [TODO] support for [reselect](https://github.com/reactjs/reselect)
* ?

## Added `@:jsxStatic` for functional components

Some components do not really need anything but a `render(props)` function.

With this feature, functional components can be created without extending `ReactComponent` (and so without the whole lifecycle overhead), by adding a `@:jsxStatic('myRenderFunction')` meta to the component's class:

```haxe
@:jsxStatic('myRender')
class Todo
{
	static public function myRender(props:TodoProps)
	{
		return jsx('
			<li onClick=${props.onClick}>${props.text}</li>
		');
	}
}
```

Pull request on haxe-react [here](https://github.com/massiveinteractive/haxe-react/pull/81) (pending).

## High Order Components (HOC)

[haxe-redux](https://github.com/elsassph/haxe-redux) provides `IConnectedComponent` to deal with react-redux's `connect()` (see [documentation on haxe-redux](https://github.com/elsassph/haxe-redux#macro-approach)).

This approach aims to allow the creation of container components as described on [ReactRedux documentation](http://redux.js.org/docs/basics/UsageWithReact.html#implementing-container-components), as an alternative to the `IConnectedComponent` approach.

The HOC approach (already mentioned as a TODO in the current readme) seem closer to the usual React approach, and may make transitioning from React/Redux to haxe-react/haxe-redux easier.

The separation between the HOC and its wrapped component is made clear here, since the HOC can only do its container role, and nothing else. This method may have some positive impact on performance too, since it will only add what's needed through `ReactRedux.connect()` (mapState and/or mapDispatch).

Many compile-time checks are done to ensure typing is correct. Compilation warnings / errors will be issued depending on the issue.

### VisibleTodoList example

#### Haxe version

```haxe
// A ReactConnector providing `TodoListProps`
class VisibleTodoList extends ReactConnector<TodoListProps>
{
	// Default component to wrap
	// If not set, children props will be updated
	// If not set & no children, will render a React empty node
	// If set but children available, children props will be updated instead of using this component
	static var wrappedComponent:TodoList;

	static function mapStateToProps(state:ApplicationState, ownProps:Dynamic):Partial<TodoListProps>
	{
		return {
			todos: getVisibleTodos(state.todoList.todos, state.todoList.visibilityFilter)
		}
	}

	static function getVisibleTodos(todos:Array<TodoData>, filter:TodoFilter)
	{
		return switch (filter) {
			case SHOW_ALL: todos;
			case SHOW_COMPLETED: todos.filter(function(t) return t.completed);
			case SHOW_ACTIVE: todos.filter(function(t) return !t.completed);
		}
	}

	static function mapDispatchToProps(dispatch:Dispatch, ownProps:Dynamic):Partial<TodoListProps>
	{
		return {
			onTodoClick: function(id) {
				return dispatch(TodoAction.Toggle(id));
			}
		};
	}
}
```

```haxe
@:jsxStatic('render')
class TodoList
{
	static public function render(props:TodoListProps)
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
```

You can then call the HOC like this:

```haxe
	override function render()
	{
		return jsx('<$VisibleTodoList />');
	}
```

#### Javascript version

http://redux.js.org/docs/basics/UsageWithReact.html#containersvisibletodolistjs

```javascript
const getVisibleTodos = (todos, filter) => {
	switch (filter) {
		case 'SHOW_ALL':
			return todos
		case 'SHOW_COMPLETED':
			return todos.filter(t => t.completed)
		case 'SHOW_ACTIVE':
			return todos.filter(t => !t.completed)
	}
}

const mapStateToProps = (state) => {
	return {
		todos: getVisibleTodos(state.todos, state.visibilityFilter)
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

http://redux.js.org/docs/basics/UsageWithReact.html#componentstodolistjs

```javascript
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
```

### Reusing the HOC with another wrapped component

In the above example, you can also use another component instead of `TodoList`,
by using it as `children`:

```haxe
	override function render()
	{
		return jsx('
			<$VisibleTodoList>
				<$MyOtherTodoList />
			</$VisibleTodoList>
		');
	}
```

The generated props would be added to every direct child's props,
and will override the default wrapped component.

### HOC's own props

If your HOC needs props, you can extend `ReactConnectorOfProps` instead of `ReactConnector`:

```haxe
class FilterLink extends ReactConnectorOfProps<LinkProps, FilterLinkProps>
{
	static var wrappedComponent:Link;

	static function mapStateToProps(state:ApplicationState, ownProps:FilterLinkProps):Partial<LinkProps>
	{
		return {
			active: ownProps.filter == state.todoList.visibilityFilter
		}
	}

	static function mapDispatchToProps(dispatch:Dispatch, ownProps:FilterLinkProps):Partial<LinkProps>
	{
		return {
			onClick: function() {
				return dispatch(TodoAction.SetVisibilityFilter(ownProps.filter));
			}
		};
	}
}
```

You can then use it like this (String `props.children` will be ignored
since it is not a valid element according to `React.isValidElement()`,
so the default wrapped component will be used):

```haxe
jsx('
	<ul>
		<li>
			<$FilterLink filter="SHOW_ALL">All</$FilterLink>
		</li>
		<li>
			<$FilterLink filter="SHOW_ACTIVE">Active</$FilterLink>
		</li>
		<li>
			<$FilterLink filter="SHOW_COMPLETED">Completed</$FilterLink>
		</li>
	</ul>
');
```

### Using `@:connect` alternative

Instead of declaring `mapDispatchToProps`, you can add a `@:connect` meta to any function
using `dispatch` as first argument (and `ownProps` too if you need access to the HOC's own props).
This will generate `mapDispatchToProps` accordingly.

You can then replace:

```haxe
	static function mapDispatchToProps(dispatch:Dispatch, ownProps:Dynamic):Partial<TodoListProps>
	{
		return {
			onTodoClick: function(id) {
				return dispatch(TodoAction.Toggle(id));
			}
		};
	}
```

By:

```haxe
	@:connect
	static function onTodoClick(dispatch:Dispatch, id:Int):Void
	{
		dispatch(TodoAction.Toggle(id));
	}
```


Pull request on haxe-redux [here](https://github.com/elsassph/haxe-redux/pull/13).

## High Order Components (HOC)

[haxe-redux](https://github.com/elsassph/haxe-redux) provides `IConnectedComponent` to deal with react-redux's `connect()` (see [documentation on haxe-redux](https://github.com/elsassph/haxe-redux#macro-approach)).

This approach aims to allow the creation of container components as described on [ReactRedux documentation](http://redux.js.org/docs/basics/UsageWithReact.html#implementing-container-components), as an alternative to the `IConnectedComponent` approach.

The HOC approach (already mentioned as a TODO in the current readme) seem closer to the usual React approach, and may make transitioning from React/Redux to haxe-react/haxe-redux easier.

The separation between the HOC and its wrapped component is made clear here, since the HOC can only do its container role, and nothing else. This method may have some positive impact on performance too, since it will only add what's needed through `ReactRedux.connect()` (mapState and/or mapDispatch).

Many compile-time checks are done to ensure typing is correct. Compilation warnings / errors will be issued depending on the issue.

### VisibleTodoList example

#### Haxe version

```haxe
// A ReactConnector providing `TodoListProps`, with `TodoList` as default wrapped component
class VisibleTodoList extends ReactConnector<TodoList, TodoListProps>
{
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

### HOC's own props

If your HOC needs props, you can extend `ReactConnectorOfProps` instead of `ReactConnector`:

```haxe
class FilterLink extends ReactConnectorOfProps<Link, LinkProps, FilterLinkProps>
{
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

You can then use it like this:

```haxe
jsx('
	<ul>
		<li>
			<$FilterLink filter="SHOW_ALL" label="All" />
		</li>
		<li>
			<$FilterLink filter="SHOW_ACTIVE" label="Active" />
		</li>
		<li>
			<$FilterLink filter="SHOW_COMPLETED" label="Completed" />
		</li>
	</ul>
');
```

### Reusing the HOC with another wrapped component

In the above example, you can also use another component instead of `TodoList`, by using it as `children`:

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

The generated props would be added to every direct child's props, and will override the default wrapped component.

You can also create HOCs without binding them to specific components, with `ReactGenericConnector<TProps>` or `ReactGenericConnectorOfProps<TProps, TOwnProps>`.
They will return an empty node at runtime if you do not provide any children, and issue a `console.error()` if you compiled with `-debug`.

### HOC composition

#### Composition hardcoded inside a connector

You can use a connector accepting ownProps as `TComponent` for another connector.

#### Composition via jsx

```haxe
jsx('
	<$FirstConnector>
		<$SecondConnector>
			<$Component />
		</$SecondConnector>
	</$FirstConnector>
');
```

### ReactConnector API

```haxe
/**
  A react-redux connector designed for a component TComponent, providing TProps
  from redux store.
*/
typedef ReactConnector<TComponent, TProps> = ReactConnect<TComponent, TProps, TVoid>;

/**
  A react-redux connector designed for a component TComponent, providing TProps
  from redux store and the connector's props (TOwnProps)
*/
typedef ReactConnectorOfProps<TComponent, TComponentProps, TOwnProps> = ReactConnect<TComponent, TComponentProps, TOwnProps>;

/**
  A react-redux connector for use with any component compatible with TProps.
  Will return an empty react node at runtime if used without children, with an
  error message if compiled with -debug.
*/
typedef ReactGenericConnector<TProps> = ReactConnect<TVoid, TProps, TVoid>;

/**
  A react-redux connector for use with any component compatible with TProps.
  This connector also accepts props of type TOwnProps.
  Will return an empty react node at runtime if used without children, with an
  error message if compiled with -debug.
*/
typedef ReactGenericConnectorOfProps<TProps, TOwnProps> = ReactConnect<TVoid, TProps, TOwnProps>;
```

### General notes

 * Explicit typing is needed for `mapStateToProps` and `mapDispatchToProps` functions, to allow macros to check typing
 * There is no way of knowing you application store's state type, so appState is typed as `Dynamic`
 * Connectors cannot use a functional component as default component, unless it's a `@:jsxStatic` class
 * Connectors handle `defaultProps` when they have ownProps
 * `displayName`s are handled, to allow easier debugging with react extension

 * React-redux defaults to `(dispatch) => ({dispatch})` for `mapDispatchToProps` when you pass `null`, meaning `dispatch` will be provided if you do not define a `mapDispatchToProps` returning an object. This behavior has *not* been reproduced here, instead the macro will use a function returning an empty object.

 * This PR needs two PRs from haxe-react:
	 * [#86](https://github.com/massiveinteractive/haxe-react/pull/86) for its JsxStaticMacro refactoring
	 * [#96](https://github.com/massiveinteractive/haxe-react/pull/96) for `ReactUtil.copyWithout()`

### Tests

Tests have been added, using `enzyme`. You can find the sources [here](https://github.com/kLabz/haxe-redux-todo/blob/redux/6/src/test/suite/ReactConnectorTests.hx).


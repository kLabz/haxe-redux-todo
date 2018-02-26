# Haxe React/Redux Todo App

Implementing react-redux's demo from [here](http://redux.js.org/docs/basics/UsageWithReact.html#implementing-container-components) with new features for [haxe-react](https://github.com/massiveinteractive/haxe-react) and [haxe-redux](https://github.com/elsassph/haxe-redux).

Roadmap:
* [[PR merged]](https://github.com/massiveinteractive/haxe-react/pull/81) `@:jsxStatic` for functional components
* [[PR pending]](https://github.com/elsassph/haxe-redux/pull/6) High Order Components
* [[PR pending]](https://github.com/elsassph/haxe-redux/pull/13) Redux thunks
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

Pull request on haxe-react [here](https://github.com/massiveinteractive/haxe-react/pull/81) (merged).

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

#### Note

HOC will not pass automatically their own props to their children, you will have to do so manually (`ReactUtil.copy()` can help).

Example:
```haxe
	static function mapStateToProps(state:ApplicationState, ownProps:FilterLinkProps):Partial<LinkProps>
	{
		return copyWithout(ownProps, {
			active: ownProps.filter == state.todoList.visibilityFilter
		}, ['children']);
	}
```

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

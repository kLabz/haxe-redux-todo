package containers;

import react.Partial;
import redux.Redux;
import redux.react.ReactConnect.ReactConnectorOfProps;
import components.Link;
import TodoListStore.TodoAction;
import TodoListStore.TodoFilter;

typedef FilterLinkProps = {
	var filter:TodoFilter;
}

class FilterLink extends ReactConnectorOfProps<LinkProps, FilterLinkProps>
{
	static var wrappedComponent:Link;

	static function mapStateToProps(state:ApplicationState, ownProps:FilterLinkProps):Partial<LinkProps>
	{
		return {
			active: ownProps.filter == state.todoList.visibilityFilter
		}
	}

	@:connect
	static function onClick(dispatch:Dispatch, ownProps:FilterLinkProps):Void
	{
		dispatch(TodoAction.SetVisibilityFilter(ownProps.filter));
	}

	/*
	Alternative:
	```
	static function mapDispatchToProps(dispatch:Dispatch, ownProps:FilterLinkProps):Partial<LinkProps>
	{
		return {
			onClick: function() {
				return dispatch(TodoAction.SetVisibilityFilter(ownProps.filter));
			}
		};
	}
	```
	*/
}

/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#containersfilterlinkjs

```
const mapStateToProps = (state, ownProps) => {
	return {
		active: ownProps.filter === state.visibilityFilter
	}
}

const mapDispatchToProps = (dispatch, ownProps) => {
	return {
		onClick: () => {
			dispatch(setVisibilityFilter(ownProps.filter))
		}
	}
}

const FilterLink = connect(
	mapStateToProps,
	mapDispatchToProps
)(Link)
```
*/

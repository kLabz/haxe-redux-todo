package containers;

import react.Partial;
import redux.Redux;
import redux.react.ReactConnector;
import components.Link;
import thunk.TodoThunk;
import TodoListStore.TodoFilter;

typedef FilterLinkProps = {
	var filter:TodoFilter;
	var label:String;
}

class FilterLink extends ReactConnectorOfProps<Link, LinkProps, FilterLinkProps>
{
	static function mapStateToProps(state:ApplicationState, ownProps:FilterLinkProps):Partial<LinkProps>
	{
		return {
			active: ownProps.filter == state.todoList.visibilityFilter,
			label: ownProps.label
		}
	}

	static function mapDispatchToProps(dispatch:Dispatch, ownProps:FilterLinkProps):Partial<LinkProps>
	{
		return {
			onClick: function() return dispatch(TodoThunk.filter(ownProps.filter))
		};
	}
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

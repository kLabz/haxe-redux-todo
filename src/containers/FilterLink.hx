package containers;

import react.Partial;
import redux.Redux;
import redux.react.ReactContainer;
import components.Link;
import TodoListStore.TodoAction;
import TodoListStore.TodoFilter;

typedef FilterLinkProps = {
	var filter:TodoFilter;
}

class FilterLink extends ReactContainerWithProps<Link, FilterLinkProps>
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
				dispatch(TodoAction.SetVisibilityFilter(ownProps.filter));
			}
		}
	}
}

/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#containersfilterlinkjs

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
*/

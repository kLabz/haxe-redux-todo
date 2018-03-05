package view.comp.filterLink;

import js.html.MouseEvent;
import react.Partial;
import react.ReactMacro.jsx;
import redux.Redux;
import react.ReactComponent;
import dto.TodoFilter;
import store.AppState;
import store.thunk.TodoThunk;

typedef FilterLinkProps = {
	var filter:TodoFilter;
	var label:String;
}

typedef Props = {
	> FilterLinkProps,
	var onClick:Void -> Void;
	var active:Bool;
}

@:connect
class FilterLink extends ReactComponentOfProps<Props> {
	static function mapStateToProps(state:AppState, ownProps:FilterLinkProps) {
		return {
			active: ownProps.filter == state.todoList.visibilityFilter
		}
	}

	static function mapDispatchToProps(dispatch:Dispatch, ownProps:FilterLinkProps) {
		return {
			onClick: function() return dispatch(TodoThunk.filter(ownProps.filter))
		};
	}

	override public function render() {
		if (props.active)
			return jsx('<span>${props.label}</span>');

		return jsx('
			<a href="#" onClick=$onClick>
				${props.label}
			</a>
		');
	}

	function onClick(e:MouseEvent) {
		e.preventDefault();
		props.onClick();
	}
}


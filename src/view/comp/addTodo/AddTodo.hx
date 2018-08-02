package view.comp.addTodo;

import js.html.InputElement;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.Redux;
import store.thunk.TodoThunk;

using StringTools;

typedef Props = {
	var addTodo:String -> Void;
}

@:connect
class AddTodo extends ReactComponentOfProps<Props> {
	#if webpack
	static var STYLES = Webpack.require('./AddTodo.scss');
	#end

	static function mapDispatchToProps(dispatch:Dispatch) {
		return {
			addTodo: function(todo:String) return dispatch(TodoThunk.add(todo))
		};
	}

	var input:InputElement;

	override public function render() {
		return jsx('
			<form onSubmit=$onSubmit>
				<input ref=$onInputRef autoFocus="autoFocus" />
				<button type="submit">+</button>
			</form>
		');
	}

	function onInputRef(node:InputElement) {
		input = node;
	}

	function onSubmit(e) {
		e.preventDefault();
		if (input.value.trim() == "") return;

		props.addTodo(input.value);
		input.value = '';
	}
}


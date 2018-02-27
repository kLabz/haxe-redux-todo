package test.component;

import react.React.CreateElementType;
import react.ReactComponent;
import react.ReactMacro.jsx;

typedef Props = {comp1:CreateElementType, comp2:CreateElementType};
typedef State = {i:Int};

class WrapperWithState extends ReactComponentOfPropsAndState<Props, State> {
	public function new(props, context) {
		super(props, context);
		state = {i: 0};
	}

	override public function render() {
		var Comp1 = props.comp1;
		var Comp2 = props.comp2;

		return jsx('
			<>
				<Comp1 i={state.i} />
				<Comp2 i={state.i} />
				<button onClick={inc}>{state.i}</button>
			</>
		');
	}

	function inc() {
		setState(function(s) return {i: s.i + 1});
	}
}


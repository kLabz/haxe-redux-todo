package test.component;

import react.ReactComponent;
import react.ReactMacro.jsx;

class BasicComponent extends ReactComponentOfProps<StrIntProps> {
	override public function render() {
		return jsx('<h1>Comp1</h1>');
	}
}


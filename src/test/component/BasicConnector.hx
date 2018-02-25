package test.component;

import react.Partial;
import redux.Redux.Dispatch;
import redux.react.ReactConnector;

class BasicConnector extends ReactConnector<BasicComponent, StrIntProps> {
	static function mapStateToProps(state:Dynamic):Partial<StrIntProps> {
		return {str: "str"};
	}

	static function mapDispatchToProps(dispatch:Dispatch):Partial<StrIntProps> {
		return {int: 42};
	}
}

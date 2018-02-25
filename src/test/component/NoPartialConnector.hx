package test.component;

import redux.react.ReactConnector;

class NoPartialConnector extends ReactConnector<BasicComponent, StrIntProps> {
	static function mapStateToProps(state:Dynamic):StrIntProps {
		return {str: "str", int: 42};
	}
}

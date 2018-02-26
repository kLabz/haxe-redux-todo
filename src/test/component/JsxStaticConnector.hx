package test.component;

import react.Partial;
import redux.Redux.Dispatch;
import redux.react.ReactConnector;

class JsxStaticConnector extends ReactConnector<JsxStaticComponent, StrIntProps> {
	static function mapStateToProps(state:{title:String}):Partial<StrIntProps> {
		return {str: state.title};
	}

	static function mapDispatchToProps(dispatch:Dispatch):Partial<StrIntProps> {
		return {int: 42};
	}
}

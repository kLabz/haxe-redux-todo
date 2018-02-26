package test.component;

import redux.react.ReactConnector;

class ConnectorWithProps extends ReactConnectorOfProps<JsxStaticComponent, StrIntProps, StrIntProps> {
	static var defaultProps:StrIntProps = {
		str: "AAA",
		int: 666
	}

	static function mapStateToProps(state:Dynamic, ownProps:StrIntProps):StrIntProps {
		return {
			str: '[' + ownProps.str + ']',
			int: ownProps.int + ownProps.int
		};
	}
}

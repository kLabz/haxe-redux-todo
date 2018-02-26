package test.component;

import redux.react.ReactConnector;

class GenericConnectorWithProps extends ReactGenericConnectorOfProps<StrIntProps, StrIntProps> {
	static function mapStateToProps(state:Dynamic, ownProps:StrIntProps):StrIntProps {
		return {
			str: ownProps.str + ownProps.str,
			int: ownProps.int + ownProps.int
		};
	}
}


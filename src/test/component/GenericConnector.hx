package test.component;

import redux.react.ReactConnector;

class GenericConnector extends ReactGenericConnector<StrIntProps> {
	static function mapStateToProps(state:Dynamic):StrIntProps {
		return {
			str: 'str',
			int: 42
		};
	}
}


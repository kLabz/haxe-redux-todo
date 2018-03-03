package test;

import buddy.Buddy;
import enzyme.Enzyme.configure;
import enzyme.adapter.React16Adapter as Adapter;
import jsdom.Jsdom;
import test.suite.*;

class Tests implements Buddy<[
	// TODO: auto include tests from components, thunks, selectors, reducers, middlewares
]> {
	static function __init__() {
		JsdomSetup.init();

		configure({
			adapter: new Adapter()
		});
	}
}

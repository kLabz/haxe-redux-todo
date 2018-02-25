package test;

import buddy.Buddy;
import enzyme.Enzyme.configure;
import enzyme.adapter.React16Adapter as Adapter;
import jsdom.Jsdom;
import test.suite.*;

class Tests implements Buddy<[
	ReactConnectorTests
]> {
	static function __init__() {
		JsdomSetup.init();

		configure({
			adapter: new Adapter()
		});
	}
}

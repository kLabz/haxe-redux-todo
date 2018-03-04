package test;

import enzyme.Enzyme.configure;
import enzyme.adapter.React16Adapter as Adapter;
import jsdom.Jsdom;

@:build(test.IncludeTestsMacro.buildTests())
class Tests {
	static function __init__() {
		JsdomSetup.init();

		configure({
			adapter: new Adapter()
		});
	}
}


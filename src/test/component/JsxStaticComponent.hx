package test.component;

import react.ReactMacro.jsx;

@:jsxStatic('render')
class JsxStaticComponent {
	public static function render(props:StrIntProps) {
		return jsx('<h1>${props.str}</h1>');
	}
}

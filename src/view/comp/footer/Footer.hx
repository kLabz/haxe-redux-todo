package view.comp.footer;

import react.ReactMacro.jsx;
import view.comp.filterLink.FilterLink;

@:jsxStatic('render')
class Footer {
	static var STYLES = Webpack.require('./Footer.scss');

	public static function render() {
		var sep = " ⋅ ";

		return jsx('
			<footer>
				<FilterLink filter="SHOW_ALL" label="All" />
				$sep
				<FilterLink filter="SHOW_ACTIVE" label="Todo" />
				$sep
				<FilterLink filter="SHOW_COMPLETED" label="Done" />
			</footer>
		');
	}
}


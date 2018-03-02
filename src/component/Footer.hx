package component;

import react.ReactMacro.jsx;

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

/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#componentsfooterjs

```
const Footer = () => (
	<p>
		Show:
		{" "}
		<FilterLink filter="SHOW_ALL">
			All
		</FilterLink>
		{", "}
		<FilterLink filter="SHOW_ACTIVE">
			Active
		</FilterLink>
		{", "}
		<FilterLink filter="SHOW_COMPLETED">
			Completed
		</FilterLink>
	</p>
)
```
*/

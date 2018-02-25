package components;

import react.ReactMacro.jsx;
import containers.FilterLink;

@:jsxStatic('render')
class Footer
{
	public static function render()
	{
		return jsx('
			<p>
				Show: <$FilterLink filter="SHOW_ALL" label="All" />
				, <$FilterLink filter="SHOW_ACTIVE" label="Active" />
				, <$FilterLink filter="SHOW_COMPLETED" label="Completed" />
			</p>
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

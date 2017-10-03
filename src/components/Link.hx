package components;

import js.html.MouseEvent;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;

typedef LinkProps = {
	var onClick:Void -> Void;
	var active:Bool;
	var children:Dynamic;
}

class Link extends ReactComponentOfProps<LinkProps>
{
	override public function render()
	{
		if (props.active)
			return jsx('<span>${props.children}</span>');

		return jsx('
			<a href="#" onClick=$onClick>
				${props.children}
			</a>
		');
	}

	function onClick(e:MouseEvent)
	{
		e.preventDefault();
		props.onClick();
	}
}

/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#componentslinkjs

```
const Link = ({ active, children, onClick }) => {
	if (active) {
		return <span>{children}</span>
	}

	return (
		<a href="#"
			 onClick={e => {
				 e.preventDefault()
				 onClick()
			 }}
		>
			{children}
		</a>
	)
}

Link.propTypes = {
	active: PropTypes.bool.isRequired,
	children: PropTypes.node.isRequired,
	onClick: PropTypes.func.isRequired
}
```
*/

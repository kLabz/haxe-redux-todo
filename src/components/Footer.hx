package components;

import react.ReactComponent;
import react.ReactMacro.jsx;
import containers.FilterLink;

class Footer extends ReactComponent
{
	override public function render()
	{
		return jsx('
			<p>
				Show: <$FilterLink filter="SHOW_ALL">All</$FilterLink>
				, <$FilterLink filter="SHOW_ACTIVE">Active</$FilterLink>
				, <$FilterLink filter="SHOW_COMPLETED">Completed</$FilterLink>
			</p>
		');
	}
}

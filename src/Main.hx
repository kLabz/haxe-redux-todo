package;

import js.Browser;
import react.ReactDOM;
import react.ReactMacro.jsx;
import redux.Store;
import redux.react.Provider;
import components.Footer;
import containers.AddTodo;
import containers.VisibleTodoList;

class Main
{
	static var store:Store<ApplicationState>;

	public static function main()
	{
		store = ApplicationStore.create();
		render();
	}

	static function render()
	{
		var app = ReactDOM.render(jsx('
			<$Provider store=$store>
				<div>
					<$AddTodo />
					<$VisibleTodoList />
					<$Footer />
				</div>
			</$Provider>
		'), Browser.document.getElementById('app'));
	}
}

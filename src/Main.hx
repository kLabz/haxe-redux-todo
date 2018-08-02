package;

import js.Browser;
import react.ReactDOM;
import react.ReactMacro.jsx;
import redux.react.Provider;
import store.AppStore;
import view.comp.footer.Footer;
import view.comp.addTodo.AddTodo;
import view.comp.todoList.TodoList;

class Main {
	static var STYLES = Webpack.require('App.scss');

	public static function main() {
		var store = AppStore.create();

		var wrapper = Browser.document.createDivElement();
		wrapper.setAttribute("id", "body");
		Browser.document.body.appendChild(wrapper);

		#if (debug && react_hot) var app = #end
		ReactDOM.render(jsx('
			<Provider store=$store>
				<>
					<TodoList />
					<Footer />
					<AddTodo />
				</>
			</Provider>
		'), wrapper);

		#if (debug && react_hot)
		ReactHMR.autoRefresh(app);
		#end
	}
}


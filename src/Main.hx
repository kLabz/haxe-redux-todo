package;

import js.Browser;
import react.ReactDOM;
import react.ReactMacro.jsx;
import redux.Store;
import redux.react.Provider;
import store.AppStore;
import view.comp.footer.Footer;
import view.comp.addTodo.AddTodo;
import view.comp.todoList.TodoList;

class Main {
	static var STYLES = Webpack.require('App.scss');

	public static function main() {
		#if (build_mode == production)
		Browser.document.addEventListener('deviceready', function(?_) {
			render();
		}, false);
		#else
		render();
		#end
	}

	static function render() {
		var store = AppStore.create();

		var wrapper = Browser.document.createDivElement();
		wrapper.setAttribute("id", "body");
		Browser.document.body.appendChild(wrapper);

		#if (debug && cordova)
		Browser.document.body.dataset.target = 'dev-cordova';
		#elseif debug
		Browser.document.body.dataset.target = 'dev-web';
		#end

		var app = ReactDOM.render(jsx('
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


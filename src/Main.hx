package;

import js.Browser;
import react.ReactDOM;
import react.ReactMacro.jsx;
import redux.Store;
import redux.react.Provider;
import component.Footer;
import component.AddTodo;
import component.VisibleTodoList;

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
		var store = ApplicationStore.create();

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
					<VisibleTodoList />
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

/*
JS version:
http://redux.js.org/docs/basics/UsageWithReact.html#componentsappjs
http://redux.js.org/docs/basics/UsageWithReact.html#indexjs

```
const App = () => (
	<div>
		<AddTodo />
		<VisibleTodoList />
		<Footer />
	</div>
)

let store = createStore(todoApp)

render(
	<Provider store={store}>
		<App />
	</Provider>,
	document.getElementById('root')
)
```
*/

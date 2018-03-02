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
		var store = ApplicationStore.create();

		var wrapper = Browser.document.createDivElement();
		wrapper.setAttribute("id", "body");
		Browser.document.body.appendChild(wrapper);

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

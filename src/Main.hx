package;

import js.Browser;
import react.ReactDOM;
import react.ReactMacro.jsx;
import redux.Store;
import redux.react.Provider;
import components.Footer;
import components.TodoList;
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
		/*
		Note:

		We could instead use:
		```
			<$AddTodo />
			<$VisibleTodoList />
			<$Footer />
		```
		But using `<$TodoList />` as `children` shows another ReactConnector feature.
		*/


		var app = ReactDOM.render(jsx('
			<$Provider store=$store>
				<div>
					<$AddTodo />
					<$VisibleTodoList>
						<$TodoList />
					</$VisibleTodoList>
					<$Footer />
				</div>
			</$Provider>
		'), Browser.document.getElementById('app'));
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

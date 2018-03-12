# Haxe React/Redux Todo App

Implementing react-redux's demo from [here](http://redux.js.org/docs/basics/UsageWithReact.html#implementing-container-components). This repository is used as a playground to toy around with new features for [`haxe-react`](https://github.com/massiveinteractive/haxe-react) and [`haxe-redux`](https://github.com/elsassph/haxe-redux).

* [PR merged] [`@:jsxStatic` for functional components](doc/jsx-static.md)
* [PR pending] [Higher Order Components](doc/redux-hoc.md)
* [PR pending] [Redux thunk](doc/redux-thunk.md)


## Installation

Javascript dependencies are handled by npm.
```
npm install
```

For haxe, this project is using [`hmm`](https://github.com/andywhite37/hmm). Hmm helps a lot with dealing with forks and small libraries that this project uses.
```
haxelib run hmm install
```

You can then use webpack dev server with `npm start`. Other scripts (watching without webpack, cordova builds, tests) are available in [package.json](/package.json).

### Libs/forks used to handle new features

* `@:connect` from [`redux-connect`](https://github.com/kLabz/haxe-redux-connect) for lightweight HOCs
* Thunks from [`redux-thunk`](https://github.com/kLabz/haxe-redux-thunk)
* [`tink_hxx`](https://github.com/haxetink/tink_hxx) as jsx parser, from pending haxe-react [PR](https://github.com/massiveinteractive/haxe-react/pull/95)

### Other haxe dependencies

* [`haxe-loader`](https://github.com/jasononeil/webpack-haxe-loader) to work with webpack
* [`reselect`](https://github.com/kLabz/haxe-reselect) to handle redux selectors
* [`event-types`](https://github.com/kLabz/event-types) to avoid magic strings
* [`buddy`](https://github.com/ciscoheat/buddy) and [`enzyme`](https://github.com/kLabz/haxe-enzyme) for tests


## Tests

Tests are using [`buddy`](https://github.com/ciscoheat/buddy) and [`enzyme`](https://github.com/kLabz/haxe-enzyme).

The test runner is handled by a macro which adds all suites in your `src` and does not need to be maintained.
All you have to do is add a file ending with `Tests.hx`, make it a buddy suite (see [TodoSelectorTests.hx](/src/store/selector/TodoSelectorTests.hx) for example) and it will be included.

To run all tests: `npm run test` or `npm run test:watch`.
You can also run or watch a single test suite with `MAIN=store.selector.TodoSelectorTests npm run test:file` (or `test:file:watch`).

Example output:
```
.............
FilterLink component
  should have the correct 'active' prop (Passed)
  should trigger TodoAction.SetVisibilityFilter(filter) (Passed)
AddTodo component
  should trigger TodoAction.Add(todo) (Passed)
TodoList component
  should render the correct number of Todo elements (Passed)
  should provide onTodoClick to Todo elements (Passed)
TodoList reducer
  should handle Add(text) (Passed)
  should handle Toggle(id) (Passed)
  should handle SetVisibilityFilter(filter) (Passed)
TodoSelector
  makeGetVisibleTodos() should return the filtered list (Passed)
  makeGetVisibleTodos() should be memoized (Passed)
TodoThunk
  add(todo) (Passed)
  toggle(id) (Passed)
  filter(filter) (Passed)
13 specs, 0 failures, 0 pending
```

### Tests coverage

You can enable (basic) tests coverage with `-D tests_coverage`.

This will add a new test at the end, verifying that each reducer, middleware, thunk and selector has a corresponding `*Tests.hx` file, by checking the `src/store/{middleware,reducer,selector,thunk}/` directories.

This will *not* check that this is a proper test suite (this would fail at tests compile-time anyway), nor that this test suite is complete in any way.

Example output:
```
[... see previous example output ...]
Tests coverage
  All 1 middlewares should have test suites (FAILED)
    No test suite for: MyMiddleware
  All 1 reducers should have test suites (Passed)
  All 1 selectors should have test suites (Passed)
  All 1 thunks should have test suites (Passed)
17 specs, 1 failures, 0 pending
```


## Architecture

You can browse this repository for an example (although a little incomplete).
Note: this does not include routing and pages (rich views) atm.

* `cordova/` - Cordova project files
	* `www/` - Should not contain sources, as this will be cleared and populated by webpack
* `public/` - Public resources (images, fonts, etc.)
* `res/` - Build resources, to be transformed via webpack
	* `scss/` - SCSS sources not tied to a specific component
	* `index.pug` - Root template for the html output
* `src/` - Haxe (and SCSS) sources
	* `cordova/` - Cordova externs without their own lib
	* `dto/` - Typedefs (and abstract enums) used as data transfer objects
	* `store/` - Redux store files
		* `middleware/`
			* Each middleware will have two files here, `MyMiddleware.hx` and `MyMiddlewareTests.hx`
		* `reducer/`
			* Each reducer will have two files here:
				* `MyReducer.hx`, also containing its state typedef and its action enum
				* `MyReducerTests.hx`
		* `selector/`
			* Each selector will have two files here, `MySelector.hx` and `MySelectorTests.hx`
		* `thunk/`
			* Each thunk will have two files here, `MyThunk.hx` and `MyThunkTests.hx`
		* `AppStore.hx` and `AppState.hx`, the root reducer and its state typedef
	* `test/`
		* `IncludeTestsMacro.hx`, the macro handling the automatic inclusion of test suites
		* `Tests.hx`, the tests entry point
		* `TestUtil.hx`, some utils functions used for testing
		* Misc test suites (files must end with `Tests.hx` to be included)
	* `util/` - Utils to be used anywhere, as static pure functions
	* `view/`
		* `comp/` - React components
			* `myComponent/` - A react component folder, containing:
				* `MyComponent.hx`, the haxe sources
				* `MyComponent.md`, its documentation if needed
				* `MyComponent.scss`, its styles, if any (included with `Webpack.require(...)`)
				* `MyComponentTests.hx`, its test suite, which is mandatory for all *connected* components
		* `page/` - TODO: pages architecture
		* `routing/` - TODO: react routing
	* `Main.hx` - App entry point


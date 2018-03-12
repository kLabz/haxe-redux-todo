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

#### Other haxe dependencies

* [`haxe-loader`](https://github.com/jasononeil/webpack-haxe-loader) to work with webpack
* [`reselect`](https://github.com/kLabz/haxe-reselect) to handle redux selectors
* [`event-types`](https://github.com/kLabz/event-types) to avoid magic strings
* [`buddy`](https://github.com/ciscoheat/buddy) and [`enzyme`](https://github.com/kLabz/haxe-enzyme) for tests


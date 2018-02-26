[[PR merged]](https://github.com/massiveinteractive/haxe-react/pull/81) `@:jsxStatic` for functional components

## Added `@:jsxStatic` for functional components

Some components do not really need anything but a `render(props)` function.

With this feature, functional components can be created without extending `ReactComponent` (and so without the whole lifecycle overhead), by adding a `@:jsxStatic('myRenderFunction')` meta to the component's class:

```haxe
@:jsxStatic('myRender')
class Todo
{
	static public function myRender(props:TodoProps)
	{
		return jsx('
			<li onClick=${props.onClick}>${props.text}</li>
		');
	}
}
```


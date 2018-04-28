package model;

import js.Object;

@:forward
abstract ExtendObject<T:{}>(T) from T to T {
	public inline function copy(?source:Dynamic):ExtendObject<T>
		return Object.assign({}, this, source);

	public function delete(key:String):ExtendObject<T> {
		var obj = this;
		untyped __js__('delete obj[key]');
		return obj;
	}

	public function deleteKeys(keys:Array<String>):ExtendObject<T> {
		var obj = this;
		for (k in keys) untyped __js__('delete obj[k]');
		return obj;
	}

	//
	// Exposed API from Object static functions
	//

	public inline function assign(?source:Dynamic):ExtendObject<T>
		return Object.assign(this, source);

	public inline function defineProperty<TProp>(prop:String, descriptor:ObjectPropertyDescriptor<TProp>):ExtendObject<T>
		return Object.defineProperty(this, prop, descriptor);

	public inline function defineProperties(props:Dynamic<ObjectPropertyDescriptor<Any>>):ExtendObject<T>
		return Object.defineProperties(this, props);

	public inline function entries():Array<Array<Any>>
		return Object.entries(this);

	public inline function freeze():ExtendObject<T>
		return Object.freeze(this);

}

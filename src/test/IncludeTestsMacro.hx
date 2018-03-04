package test;

import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem as FS;

using StringTools;
using haxe.macro.Tools;

class IncludeTestsMacro {
	// Will include all tests suites whose name ends with "Tests"
	public static function buildTests() {
		var path = extractPath();
		if (path == null) Context.error('could not find the sources directory', Context.currentPos());

		var suites = [];
		var suiteFiles = extractTestSuites(path);
		for (s in suiteFiles) suites.push(extractExpr(path, s));

		Context.defineType({
			name: 'TestSuites',
			pack: ['test'],
			params: [],
			fields: [],
			meta: null,
			isExtern: null,
			kind: TDClass(
				null,
				[{
					name: 'Buddy',
					pack: ['buddy'],
					params: [
						TPExpr({expr: EArrayDecl(suites), pos: Context.currentPos()})
					],
					sub: null
				}],
				false
			),
			pos: Context.currentPos()
		});

		var fields = Context.getBuildFields();

		fields.push({
			name: 'main',
			kind: FFun({
				args: [],
				params: null,
				ret: null,
				expr: macro TestSuites.main()
			}),
			access: [APublic, AStatic],
			doc: null,
			meta: null,
			pos: Context.currentPos()
		});

		return fields;
	}

	static function extractPath():String {
		var clsPath = Context.getClassPath();
		for (c in clsPath) {
			var t = c.trim();
			if (t.length > 0 && t.charAt(0) != "#" && t.charAt(0) != "/")
				return c;
		}

		return null;
	}

	static function extractExpr(base:String, path:String):Expr {
		if (path.startsWith(base)) {
			path = path.substring(base.length, path.length - 3);
			path = ~/\//g.replace(path, '.');

			return macro $p{path.split('.')};
		}

		Context.error('invalid test suite: $path', Context.currentPos());
		return macro null;
	}

	static function extractTestSuites(dir:String):Array<String> {
		var suites = [];

		if (FS.isDirectory(dir)) {
			var entries = FS.readDirectory(dir);

			for (entry in entries) {
				var path = dir + entry;

				if (FS.isDirectory(path))
					suites = suites.concat(extractTestSuites(path + '/'));
				else if (entry.length > 8 && entry.endsWith('Tests.hx'))
					suites.push(path);
			}
		}

		return suites;
	}
}

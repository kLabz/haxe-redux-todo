package test;

import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem as FS;

using StringTools;
using haxe.macro.Tools;

typedef CoverageData = {
	total:Int,
	untested:Array<String>
}

typedef SuitesData = {
	suites:Array<String>,
	reducer:CoverageData,
	middleware:CoverageData,
	thunk:CoverageData,
	selector:CoverageData
}

class IncludeTestsMacro {
	static var hxExt = ~/(\.hx$)/;

	// Will include all tests suites whose name ends with "Tests"
	public static function buildTests() {
		var path = extractPath();
		if (path == null) Context.error('could not find the sources directory', Context.currentPos());

		var suites = [];
		var suitesData = extractTestSuites(path, path, {
			suites: [],
			reducer: {total: 0, untested: []},
			middleware: {total: 0, untested: []},
			thunk: {total: 0, untested: []},
			selector: {total: 0, untested: []}
		});

		for (s in suitesData.suites) suites.push(extractExpr(path, s));

		#if tests_coverage
		addCoverage(suites, suitesData);
		#end

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

	static function extractTestSuites(root:String, dir:String, data:SuitesData):SuitesData {
		if (FS.isDirectory(dir)) {
			var entries = FS.readDirectory(dir);

			for (entry in entries) {
				var path = dir + entry;

				if (FS.isDirectory(path)) {
					extractTestSuites(root, path + '/', data);
				} else {
					if (entry.length > 8 && entry.endsWith('Tests.hx')) {
						data.suites.push(path);
					} else if (entry.endsWith('.hx')) {
						var target:Null<CoverageData> = switch (dir.replace(root, '')) {
							case 'store/reducer/': data.reducer;
							case 'store/middleware/': data.middleware;
							case 'store/thunk/': data.thunk;
							case 'store/selector/': data.selector;
							default: null;
						};

						if (target != null) {
							target.total++;
							if (!FS.exists(dir + hxExt.replace(entry, 'Tests.hx')))
								target.untested.push(hxExt.replace(entry, ''));
						}
					}
				}
			}
		}

		return data;
	}

	static function addCoverage(suites:Array<Expr>, suitesData:SuitesData):Void {
		var tests = [];
		tests.push(generateCoverage(suitesData.middleware, "middlewares"));
		tests.push(generateCoverage(suitesData.reducer, "reducers"));
		tests.push(generateCoverage(suitesData.selector, "selectors"));
		tests.push(generateCoverage(suitesData.thunk, "thunks"));

		Context.defineType(macro class CoverageTests extends buddy.BuddySuite {
			public function new() {
				describe("Tests coverage", {
					$a{tests};
				});
			}
		});

		suites.push(macro CoverageTests);
	}

	static function generateCoverage(coverage:CoverageData, id:String):Expr {
		var def = 'All ${coverage.total} ${id} should have test suites';

		if (coverage.untested.length == 0) {
			return generatePassingCase(def);
		} else {
			var fail = 'No test suite for: ${coverage.untested.join(", ")}';
			return generateFailingCase(def, fail);
		}
	}

	static function generatePassingCase(def:String):Expr {
		return macro it($v{def}, {
			buddy.SuitesRunner.currentTest(true, '', []);
		});
	}

	static function generateFailingCase(def:String, message:String):Expr {
		return macro it($v{def}, {
			buddy.SuitesRunner.currentTest(false, $v{message}, []);
		});
	}
}

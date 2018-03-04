package store.selector;

import buddy.SingleSuite;
import dto.TodoData;
import dto.TodoFilter;

using buddy.Should;

class TodoSelectorTests extends SingleSuite {
	public function new() {
		describe("TodoSelector", {
			var todos = [
				{id: 1, text: 'todo 1', completed: false},
				{id: 2, text: 'todo 2', completed: true},
				{id: 3, text: 'todo 3', completed: false},
				{id: 4, text: 'todo 4', completed: false},
				{id: 5, text: 'todo 5', completed: true}
			];

			var stateAll:AppState = {
				todoList: {
					todos: todos,
					visibilityFilter: TodoFilter.SHOW_ALL
				}
			};

			var stateCompleted:AppState = {
				todoList: {
					todos: todos,
					visibilityFilter: TodoFilter.SHOW_COMPLETED
				}
			};

			var stateActive:AppState = {
				todoList: {
					todos: todos,
					visibilityFilter: TodoFilter.SHOW_ACTIVE
				}
			};

			it("makeGetVisibleTodos() should return the filtered list", {
				var getVisibleTodos = TodoSelector.makeGetVisibleTodos();

				var todos:Array<TodoData> = getVisibleTodos(stateAll);
				todos.length.should.be(5);
				printIds(todos).should.be('12345');

				todos = getVisibleTodos(stateCompleted);
				todos.length.should.be(2);
				printIds(todos).should.be('25');

				todos = getVisibleTodos(stateActive);
				todos.length.should.be(3);
				printIds(todos).should.be('134');
			});

			it("makeGetVisibleTodos() should be memoized", {
				var getVisibleTodos = TodoSelector.makeGetVisibleTodos();

				var todos1:Array<TodoData> = getVisibleTodos(stateAll);
				var todos2:Array<TodoData> = getVisibleTodos(stateAll);

				todos1.should.be(todos2);
			});
		});
	}

	static function printIds(todos:Array<TodoData>):String {
		return Lambda.fold(todos, function(todo, fold) return '${fold}${todo.id}', '');
	}
}


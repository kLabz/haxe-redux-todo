package store.thunk;

import buddy.SingleSuite;
import dto.TodoFilter;
import store.TodoListStore.TodoAction;
import test.TestUtil.computeThunkActions;

using buddy.Should;

class TodoThunkTests extends SingleSuite {
	public function new() {
		var state:AppState = {
			todoList: {
				todos: [
					{id: 1, text: "todo", completed: false}
				],
				visibilityFilter: TodoFilter.SHOW_ALL
			}
		};

		describe("TodoThunk", {
			it("add(todo)", {
				var addTodo = TodoThunk.add(" todo");
				var actions = computeThunkActions(addTodo, state);
				actions.length.should.be(0);

				addTodo = TodoThunk.add("    ");
				addTodo.should.equal(null);

				addTodo = TodoThunk.add("todo 2 ");
				actions = computeThunkActions(addTodo, state);
				actions.length.should.be(1);
				actions[0].type.should.be(TodoAction.getName());
				(actions[0].value :EnumValue).should.equal(TodoAction.Add("todo 2"));
			});

			it("toggle(id)", {
				var toggleTodo = TodoThunk.toggle(1);
				var actions = computeThunkActions(toggleTodo, state);
				actions.length.should.be(1);
				actions[0].type.should.be(TodoAction.getName());
				(actions[0].value :EnumValue).should.equal(TodoAction.Toggle(1));
			});

			it("filter(filter)", {
				var updateFilter = TodoThunk.filter(SHOW_COMPLETED);
				var actions = computeThunkActions(updateFilter, state);
				actions.length.should.be(1);
				actions[0].type.should.be(TodoAction.getName());
				(actions[0].value :EnumValue).should.equal(TodoAction.SetVisibilityFilter(SHOW_COMPLETED));
			});
		});
	}
}


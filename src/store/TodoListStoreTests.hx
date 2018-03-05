package store;

import buddy.SingleSuite;
import dto.TodoFilter;

using buddy.Should;

@:access(store.TodoListStore)
class TodoListStoreTests extends SingleSuite {
	public function new() {
		describe("TodoList reducer", {
			var store = new TodoListStore();

			it("should handle Add(text)", {
				var prevID = store.ID;

				var state = store.reduce(store.initState, Add("todo 1"));
				state.todos.length.should.be(1);

				var todo = state.todos[0];
				todo.id.should.be(prevID + 1);
				todo.text.should.be("todo 1");
				todo.completed.should.be(false);

				state = store.reduce(state, Add("todo 2"));
				state.todos.length.should.be(2);

				// Should keep existing items
				todo = state.todos[0];
				todo.id.should.be(prevID + 1);
				todo.text.should.be("todo 1");
				todo.completed.should.be(false);

				todo = state.todos[1];
				todo.id.should.be(prevID + 2);
				todo.text.should.be("todo 2");
				todo.completed.should.be(false);

				// Should not alter visibility filter
				state.visibilityFilter.should.be(TodoFilter.SHOW_ALL);
			});

			it("should handle Toggle(id)", {
				var initState = {
					visibilityFilter: SHOW_ALL,
					todos: [
						{id: 1, text: "todo 1", completed: false},
						{id: 2, text: "todo 2", completed: false}
					]
				};

				var state = store.reduce(initState, Toggle(1));
				state.todos.length.should.be(2);
				state.todos[0].completed.should.be(true);
				state.todos[1].completed.should.be(false);

				state = store.reduce(state, Toggle(1));
				state.todos.length.should.be(2);
				state.todos[0].completed.should.be(false);
				state.todos[1].completed.should.be(false);

				state = store.reduce(state, Toggle(2));
				state.todos.length.should.be(2);
				state.todos[0].completed.should.be(false);
				state.todos[1].completed.should.be(true);

				// Invalid ids should not alter state
				var newState = store.reduce(state, Toggle(3));
				newState.should.be(state); // Should keep reference
				newState.todos.length.should.be(2);
				newState.todos[0].completed.should.be(false);
				newState.todos[1].completed.should.be(true);
			});

			it("should handle SetVisibilityFilter(filter)", {
				var initState = {
					visibilityFilter: SHOW_ALL,
					todos: [
						{id: 1, text: "todo 1", completed: false},
						{id: 2, text: "todo 2", completed: false}
					]
				};

				var state = store.reduce(initState, SetVisibilityFilter(SHOW_ACTIVE));
				state.todos.length.should.be(2);
				state.visibilityFilter.should.be(TodoFilter.SHOW_ACTIVE);

				state = store.reduce(initState, SetVisibilityFilter(SHOW_COMPLETED));
				state.todos.length.should.be(2);
				state.visibilityFilter.should.be(TodoFilter.SHOW_COMPLETED);

				state = store.reduce(initState, SetVisibilityFilter(SHOW_ALL));
				state.todos.length.should.be(2);
				state.visibilityFilter.should.be(TodoFilter.SHOW_ALL);

				// Should keep the reference when value is not changed
				var newState = store.reduce(state, SetVisibilityFilter(state.visibilityFilter));
				newState.should.be(state);
			});
		});
	}
}



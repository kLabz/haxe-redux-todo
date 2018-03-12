package view.comp.todoList;

import buddy.SingleSuite;
import enzyme.EnzymeRedux;
import enzyme.EnzymeRedux.mountWithStore as mount;
import eventtypes.MouseEventType;
import react.ReactMacro.jsx;
import dto.TodoFilter;
import store.AppState;
import store.reducer.TodoListStore.TodoAction;
import test.TestUtil;
import view.comp.todo.Todo;

using buddy.Should;
using enzyme.EnzymeMatchers;

class TodoListTests extends SingleSuite {
	public function new() {
		describe("TodoList component", {
			var todos = [
				{id: 1, text: "todo 1", completed: false},
				{id: 2, text: "todo 2", completed: true},
				{id: 3, text: "todo 3", completed: false},
				{id: 4, text: "todo 4", completed: false},
				{id: 5, text: "todo 5", completed: true}
			];

			var state:AppState = {
				todoList: {
					todos: todos,
					visibilityFilter: TodoFilter.SHOW_ALL
				}
			};

			var store = EnzymeRedux.createMockedStore(state);

			it("should render the correct number of Todo elements", {
				var wrapper = mount(jsx('<TodoList />'), store);
				var todoElements = wrapper.find(Todo.render);
				todoElements.length.should.be(5);

				state.todoList.visibilityFilter = SHOW_ACTIVE;
				wrapper = mount(jsx('<TodoList />'), store);
				todoElements = wrapper.find(Todo.render);
				todoElements.length.should.be(3);

				state.todoList.visibilityFilter = SHOW_COMPLETED;
				wrapper = mount(jsx('<TodoList />'), store);
				todoElements = wrapper.find(Todo.render);
				todoElements.length.should.be(2);

			});

			it("should provide onTodoClick to Todo elements", {
				// Reset visibility filter
				state.todoList.visibilityFilter = SHOW_ALL;

				var wrapper = mount(jsx('<TodoList />'), store);
				var todoElements = wrapper.find(Todo.render);
				var todo = todoElements.first();
				todo.find("li").simulate(MouseEventType.Click);

				var actions = store.getActions();
				actions.length.should.be(1);

				var actions = TestUtil.computeThunkActions(actions[0].value, store.getState());
				actions.length.should.be(1);
				actions.shift().should.equal(TodoAction.Toggle(1));
			});
		});
	}
}


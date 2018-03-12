package view.comp.addTodo;

import js.html.InputElement;
import buddy.SingleSuite;
import enzyme.EnzymeRedux;
import enzyme.EnzymeRedux.mountWithStore as mount;
import eventtypes.FormEventType;
import react.ReactMacro.jsx;
import dto.TodoFilter;
import store.AppState;
import store.reducer.TodoListStore.TodoAction;
import test.TestUtil;

using buddy.Should;
using enzyme.EnzymeMatchers;

class AddTodoTests extends SingleSuite {
	public function new() {
		describe("AddTodo component", {
			it("should trigger TodoAction.Add(todo)", {
				var state:AppState = {
					todoList: {
						todos: [],
						visibilityFilter: TodoFilter.SHOW_ALL
					}
				};

				var store = EnzymeRedux.createMockedStore(state);
				var wrapper = mount(jsx('<AddTodo />'), store);

				var input:InputElement = cast wrapper.find("input").getDOMNode();
				input.value = "test";
				wrapper.find("form").simulate(FormEventType.Submit);

				var actions = store.getActions();
				actions.length.should.be(1);

				var actions = TestUtil.computeThunkActions(actions[0].value, store.getState());
				actions.length.should.be(1);
				actions.shift().should.equal(TodoAction.Add("test"));
			});
		});
	}
}


package view.comp.filterLink;

import buddy.SingleSuite;
import enzyme.EnzymeRedux;
import enzyme.EnzymeRedux.mountWithStore as mount;
import eventtypes.MouseEventType;
import react.ReactMacro.jsx;
import dto.TodoFilter;
import store.AppState;
import store.reducer.TodoListStore.TodoAction;
import util.TestUtil;

using buddy.Should;
using enzyme.EnzymeMatchers;

class FilterLinkTests extends SingleSuite {
	public function new() {
		describe("FilterLink component", {
			it("should have the correct 'active' prop", {
				var state:AppState = {
					todoList: {
						todos: [],
						visibilityFilter: TodoFilter.SHOW_ALL
					}
				};

				var store = EnzymeRedux.createMockedStore(state);

				var wrapper = mount(jsx('<FilterLink filter=${SHOW_ALL} label="all" />'), store);
				var comp = wrapper.find(FilterLink);
				comp.length.should.be(1);
				comp.props().active.should.be(true);
				wrapper.find("a").length.should.be(0);
				wrapper.find("span").length.should.be(1);

				wrapper = mount(jsx('<FilterLink filter=${SHOW_COMPLETED} label="done" />'), store);
				comp = wrapper.find(FilterLink);
				comp.props().active.should.be(false);
				wrapper.find("a").length.should.be(1);
				wrapper.find("span").length.should.be(0);

				state.todoList.visibilityFilter = TodoFilter.SHOW_COMPLETED;
				wrapper = mount(jsx('<FilterLink filter=${SHOW_COMPLETED} label="done" />'), store);
				comp = wrapper.find(FilterLink);
				comp.props().active.should.be(true);
			});

			it("should trigger TodoAction.SetVisibilityFilter(filter)", {
				var state:AppState = {
					todoList: {
						todos: [],
						visibilityFilter: TodoFilter.SHOW_ACTIVE
					}
				};

				var store = EnzymeRedux.createMockedStore(state);
				var wrapper = mount(jsx('<FilterLink filter=${SHOW_ALL} label="all" />'), store);

				wrapper.find("a").simulate(MouseEventType.Click);
				var actions = store.getActions();
				actions.length.should.be(1);

				var actions = TestUtil.computeThunkActions(actions[0].value, store.getState());
				actions.length.should.be(1);
				actions.shift().should.equal(TodoAction.SetVisibilityFilter(SHOW_ALL));
			});
		});
	}
}


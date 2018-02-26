package test.suite;

import buddy.SingleSuite;
import redux.react.Provider;

import enzyme.EnzymeRedux.mountWithState as mount;
import react.ReactMacro.jsx;
import react.ReactComponent;
import react.ReactUtil;
import test.component.*;

using buddy.Should;
using enzyme.EnzymeMatchers;

class ReactConnectorTests extends SingleSuite {
	public function new() {
		describe("ReactConnector<TComponent, TProps>", {
			it("should combine mapStateToProps and mapDispatchToProps", {
				var wrapper = mount(jsx('<BasicConnector />'), {});

				// The component should have been wrapped inside the container
				var comp = wrapper.find(BasicComponent);
				comp.length.should.be(1);

				// And should have str="str" int=42 as props
				ReactUtil
					.shallowCompare({str: "str", int: 42}, comp.props())
					.should.be(true);
			});

			it("should handle whole TProps objects", {
				var wrapper = mount(jsx('<NoPartialConnector />'), {});

				// The component should have been wrapped inside the container
				var comp = wrapper.find(BasicComponent);
				comp.length.should.be(1);

				// And should have str="str" int=42 as props
				ReactUtil
					.shallowCompare({str: "str", int: 42}, comp.props())
					.should.be(true);
			});

			it("should accept children instead of its component", {
				var wrapper = mount(jsx('
					<BasicConnector>
						<JsxStaticComponent />
					</BasicConnector>
				'), {});

				var comp = wrapper.find('h1');
				comp.length.should.be(1);
				comp.text().should.be('str');
			});

			it("should work with @:jsxStatic components", {
				var wrapper = mount(jsx('<JsxStaticConnector />'), {title: 'title'});

				var comp = wrapper.find('h1');
				comp.length.should.be(1);
				comp.text().should.be('title');
			});
		});

		describe("ReactConnectorOfProps<TComponent, TProps, TOwnProps>", {
			it("should handle TOwnProps", {
				var wrapper = mount(jsx('<ConnectorWithProps str="k" />'), {});

				var comp = wrapper.find('h1');
				comp.length.should.be(1);
				comp.text().should.be('[k]');
			});

			it("should handle defaultProps", {
				var wrapper = mount(jsx('<ConnectorWithProps />'), {});

				var comp = wrapper.find('h1');
				comp.length.should.be(1);
				comp.text().should.be('[AAA]');
			});

			it("should be independant from other instances", {
				var store = enzyme.EnzymeRedux.createMockedStore();

				var wrapper = mount(jsx('
					<Provider store=${store}>
					<>
						<ConnectorWithProps str="a">
							<JsxStaticComponent />
						</ConnectorWithProps>
						<ConnectorWithProps str="b">
							<JsxStaticComponent />
						</ConnectorWithProps>
					</>
					</Provider>
				'), {});

				var comps = wrapper.find('h1');
				comps.length.should.be(2);

				var comp = comps.first();
				comp.text().should.be('[a]');

				comp = comps.last();
				comp.text().should.be('[b]');
			});
		});

		describe("ReactGenericConnector<TProps>", {
			it("should render null without child elements", {
				// This will generate a runtime error when compiled with -debug
				var wrapper = mount(jsx('<GenericConnector />'), {});
				wrapper.html().should.be(null);
			});

			it("should pass computed props to child element(s)", {
				var wrapper = mount(jsx('
					<GenericConnector>
						<JsxStaticComponent />
						<p/>
						Test
						<JsxStaticComponent />
					</GenericConnector>
				'), {});

				var comps = wrapper.find('h1');
				comps.length.should.be(2);
				comps.first().text().should.be('str');
				comps.last().text().should.be('str');
			});

			it("should merge computed props with child elements' props", {
				var wrapper = mount(jsx('
					<GenericConnector>
						<BasicComponent initialProp="value" />
						<BasicComponent initialProp="value2" />
					</GenericConnector>
				'), {});

				var comp = wrapper.find(BasicComponent);
				var props:{str:String, int:Int, initialProp:String} = comp.first().props();
				props.initialProp.should.be("value");
				props.str.should.be("str");
				props.int.should.be(42);

				var props:{str:String, int:Int, initialProp:String} = comp.last().props();
				props.initialProp.should.be("value2");
				props.str.should.be("str");
				props.int.should.be(42);
			});
		});

		describe("ReactGenericConnectorOfProps<TProps, TOwnProps>", {
			it("should handle TOwnProps", {
				var wrapper = mount(jsx('
					<GenericConnectorWithProps str="a">
						<JsxStaticComponent />
					</GenericConnectorWithProps>
				'), {});

				var comp = wrapper.find('h1');
				comp.length.should.be(1);
				comp.text().should.be('aa');
			});
		});

		describe("ReactConnector composition", {
			it("should handle composition via TComponent", {
				var wrapper = mount(jsx('
					<ParentConnector str="a" />
				'), {});

				var comp = wrapper.find('h1');
				comp.length.should.be(1);
				comp.text().should.be('[aa]');
			});

			it("should handle composition via children", {
				var wrapper = mount(jsx('
					<GenericConnectorWithProps str="a">
						<ConnectorWithProps str="b">
							<JsxStaticComponent />
						</ConnectorWithProps>
					</GenericConnectorWithProps>
				'), {});

				var comp = wrapper.find('h1');
				comp.length.should.be(1);
				comp.text().should.be('[aa]');
			});
		});
	}
}

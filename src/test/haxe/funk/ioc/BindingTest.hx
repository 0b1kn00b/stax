package funk.ioc;

import massive.munit.Assert;
import unit.Asserts;

using funk.types.extensions.Strings;
using massive.munit.Assert;
using unit.Asserts;

class BindingTest {

	private var module : Module;

	@Before
	public function setup() {
		module = new Module();
		Injector.initialize(module);
	}

	@After
	public function tearDown() { 
		Injector.dispose(module);
	}

	@Test
	public function create_new_binding_should_not_throw_error() {
		var binding = new Binding(new Module(), None);
		binding.isNotNull();
	}

	@Test
	public function create_new_binding_should_throw_error_if_module_is_null() {
		var called = try {
			new Binding(null, None);
			false;
		} catch (error : Dynamic) {
			true;
		}
		
		called.isTrue();
	}

	@Test
	public function binding_with_to_with_null_should_throw_Error() {
		var binding = new Binding(new Module(), None);

		var called = try {
			binding.to(null);
			false;
		} catch (error : Dynamic) {
			true;
		}

		called.isTrue();
	}

	@Test
	public function binding_with_to_should_return_a_scope() {
		var binding = new Binding(new Module(), None);
		binding.to(String).areEqual(binding);
	}

	@Test
	public function binding_with_to_and_calling_getInstance_should_return_now_string() {
		var binding = new Binding(module, None);
		binding.to(String);
		binding.getInstance().areEqual(new String("").unbox());
	}

	@Test
	public function binding_with_to_and_calling_getInstance_asSingleton_should_return_provided_object() {		
		var binding = new Binding(module, None);
		binding.to(Array).asSingleton();
		
		var instance = binding.getInstance();
		binding.getInstance().areEqual(instance);
	}

	@Test
	public function binding_with_toInstance_with_null_should_throw_Error() {
		var binding = new Binding(new Module(), None);

		var called = try {
			binding.toInstance(null);
			false;
		} catch (error : Dynamic) {
			true;
		}

		called.isTrue();
	}

	@Test
	public function binding_with_toInstance_should_return_a_scope() {
		var binding = new Binding(new Module(), None);
		binding.toInstance(String).areEqual(binding);
	}

	@Test
	public function binding_with_toInstance_and_calling_getInstance_should_return_same_instance() {
		var instance = Date.now();
		var binding = new Binding(module, None);
		binding.toInstance(instance);
		binding.getInstance().areEqual(instance);
	}

	@Test
	public function binding_with_toInstance_and_calling_getInstance_asSingleton_should_return_provided_object() {		
		var binding = new Binding(module, None);
		binding.toInstance(Date.now()).asSingleton();
		
		var instance = binding.getInstance();
		binding.getInstance().areEqual(instance);
	}

	@Test
	public function binding_with_toProvider_with_null_should_throw_Error() {
		var binding = new Binding(new Module(), None);

		var called = try {
			binding.toProvider(null);
			false;
		} catch (error : Dynamic) {
			true;
		}

		called.isTrue();
	}

	@Test
	public function binding_with_toProvider_with_invalid_provider_should_throw_Error() {
		var binding = new Binding(new Module(), None);

		var called = try {
			binding.toProvider(InvalidMockProvider);
			false;
		} catch (error : Dynamic) {
			true;
		}

		called.isTrue();
	}

	@Test
	public function binding_with_toProvider_should_return_a_scope() {
		var binding = new Binding(new Module(), None);
		binding.toProvider(MockProvider).areEqual(binding);
	}

	@Test
	public function binding_with_toProvider_and_calling_getInstance_should_return_provided_object() {
		MockProvider.instance = Date.now();

		var binding = new Binding(module, None);
		binding.toProvider(MockProvider);
		binding.getInstance().areEqual(MockProvider.instance);
	}

	@Test
	public function binding_with_toProvider_and_calling_getInstance_asSingleton_should_return_provided_object() {		
		var binding = new Binding(module, None);
		binding.toProvider(MockProvider).asSingleton();
		
		MockProvider.instance = Date.now();

		var instance = binding.getInstance();

		MockProvider.instance = Date.now();

		binding.getInstance().areEqual(instance);
	}

}

class InvalidMockProvider {
	public function new() {
		
	}
}

class MockProvider<T> {

	public static var instance : Dynamic;

	public function new() {
	}

	public function get() : T {
		return MockProvider.instance;
	}
}

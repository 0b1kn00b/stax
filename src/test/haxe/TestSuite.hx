import massive.munit.TestSuite;

import funk.actors.ActorRefTest;
import funk.actors.ActorSystemTest;
import funk.actors.ActorTest;
import funk.actors.events.EventStreamTest;
import funk.actors.patterns.ActSupportTest;
import funk.actors.patterns.AskSupportTest;
import funk.actors.patterns.MVCSupportTest;
import funk.actors.patterns.WorkerActorSupportTest;
import funk.actors.PropsTest;
import funk.actors.ReactorTest;
import funk.actors.routing.RoundRobinRouterTest;
import funk.actors.SchedulerTest;
import funk.actors.StashActorTest;
import funk.arrows.ArrowTest;
import funk.ds.CollectionDropableTest;
import funk.ds.CollectionFoldableTest;
import funk.ds.CollectionReducibleTest;
import funk.ds.CollectionTest;
import funk.ds.immutable.BinaryTreeTest;
import funk.ds.immutable.ListCollectionsTest;
import funk.ds.immutable.ListDropableTest;
import funk.ds.immutable.ListFoldableTest;
import funk.ds.immutable.ListReducibleTest;
import funk.ds.immutable.ListTest;
import funk.ds.immutable.MapTest;
import funk.ds.ParallelTest;
import funk.futures.DeferredTest;
import funk.futures.PromiseTest;
import funk.io.http.BaseLoaderTest;
import funk.io.http.JsonLoaderTest;
import funk.io.http.UriLoaderTest;
import funk.io.http.XmlLoaderTest;
import funk.io.logging.LogTest;
import funk.ioc.BindingTest;
import funk.ioc.InjectorTest;
import funk.ioc.InjectTest;
import funk.ioc.ModuleTest;
import funk.net.http.UriTest;
import funk.reactives.CollectionTest;
import funk.reactives.events.EventsTest;
import funk.reactives.events.KeyboardEventsTest;
import funk.reactives.events.MouseEventsTest;
import funk.reactives.events.RenderEventsTest;
import funk.reactives.StreamAsyncTest;
import funk.reactives.StreamTest;
import funk.reactives.StreamTypesTest;
import funk.reactives.StreamValuesTest;
import funk.signals.PrioritySignal0Test;
import funk.signals.PrioritySignal1Test;
import funk.signals.PrioritySignal2Test;
import funk.signals.PrioritySignal3Test;
import funk.signals.PrioritySignal4Test;
import funk.signals.PrioritySignal5Test;
import funk.signals.Signal0Test;
import funk.signals.Signal1Test;
import funk.signals.Signal2Test;
import funk.signals.Signal3Test;
import funk.signals.Signal4Test;
import funk.signals.Signal5Test;
import funk.signals.Slot0Test;
import funk.signals.Slot1Test;
import funk.signals.Slot2Test;
import funk.signals.Slot3Test;
import funk.signals.Slot4Test;
import funk.signals.Slot5Test;
import funk.types.AnyTest;
import funk.types.AttemptTest;
import funk.types.EitherTest;
import funk.types.Function0Test;
import funk.types.Function1Test;
import funk.types.Function2Test;
import funk.types.Function3Test;
import funk.types.Function4Test;
import funk.types.Function5Test;
import funk.types.OptionTest;
import funk.types.PartialFunction1Test;
import funk.types.PartialFunction2Test;
import funk.types.PartialFunction3Test;
import funk.types.PartialFunction4Test;
import funk.types.PartialFunction5Test;
import funk.types.Predicate0Test;
import funk.types.Predicate1Test;
import funk.types.Predicate2Test;
import funk.types.Predicate3Test;
import funk.types.Predicate4Test;
import funk.types.Predicate5Test;
import funk.types.SelectorTest;
import funk.types.StringsTest;
import funk.types.Tuple1Test;
import funk.types.Tuple2Test;
import funk.types.Tuple3Test;
import funk.types.Tuple4Test;
import funk.types.Tuple5Test;
import funk.types.WildcardTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(funk.actors.ActorRefTest);
		add(funk.actors.ActorSystemTest);
		add(funk.actors.ActorTest);
		add(funk.actors.events.EventStreamTest);
		add(funk.actors.patterns.ActSupportTest);
		add(funk.actors.patterns.AskSupportTest);
		add(funk.actors.patterns.MVCSupportTest);
		add(funk.actors.patterns.WorkerActorSupportTest);
		add(funk.actors.PropsTest);
		add(funk.actors.ReactorTest);
		add(funk.actors.routing.RoundRobinRouterTest);
		add(funk.actors.SchedulerTest);
		add(funk.actors.StashActorTest);
		add(funk.arrows.ArrowTest);
		add(funk.ds.CollectionDropableTest);
		add(funk.ds.CollectionFoldableTest);
		add(funk.ds.CollectionReducibleTest);
		add(funk.ds.CollectionTest);
		add(funk.ds.immutable.BinaryTreeTest);
		add(funk.ds.immutable.ListCollectionsTest);
		add(funk.ds.immutable.ListDropableTest);
		add(funk.ds.immutable.ListFoldableTest);
		add(funk.ds.immutable.ListReducibleTest);
		add(funk.ds.immutable.ListTest);
		add(funk.ds.immutable.MapTest);
		add(funk.ds.ParallelTest);
		add(funk.futures.DeferredTest);
		add(funk.futures.PromiseTest);
		add(funk.io.http.BaseLoaderTest);
		add(funk.io.http.JsonLoaderTest);
		add(funk.io.http.UriLoaderTest);
		add(funk.io.http.XmlLoaderTest);
		add(funk.io.logging.LogTest);
		add(funk.ioc.BindingTest);
		add(funk.ioc.InjectorTest);
		add(funk.ioc.InjectTest);
		add(funk.ioc.ModuleTest);
		add(funk.net.http.UriTest);
		add(funk.reactives.CollectionTest);
		add(funk.reactives.events.EventsTest);
		add(funk.reactives.events.KeyboardEventsTest);
		add(funk.reactives.events.MouseEventsTest);
		add(funk.reactives.events.RenderEventsTest);
		add(funk.reactives.StreamAsyncTest);
		add(funk.reactives.StreamTest);
		add(funk.reactives.StreamTypesTest);
		add(funk.reactives.StreamValuesTest);
		add(funk.signals.PrioritySignal0Test);
		add(funk.signals.PrioritySignal1Test);
		add(funk.signals.PrioritySignal2Test);
		add(funk.signals.PrioritySignal3Test);
		add(funk.signals.PrioritySignal4Test);
		add(funk.signals.PrioritySignal5Test);
		add(funk.signals.Signal0Test);
		add(funk.signals.Signal1Test);
		add(funk.signals.Signal2Test);
		add(funk.signals.Signal3Test);
		add(funk.signals.Signal4Test);
		add(funk.signals.Signal5Test);
		add(funk.signals.Slot0Test);
		add(funk.signals.Slot1Test);
		add(funk.signals.Slot2Test);
		add(funk.signals.Slot3Test);
		add(funk.signals.Slot4Test);
		add(funk.signals.Slot5Test);
		add(funk.types.AnyTest);
		add(funk.types.AttemptTest);
		add(funk.types.EitherTest);
		add(funk.types.Function0Test);
		add(funk.types.Function1Test);
		add(funk.types.Function2Test);
		add(funk.types.Function3Test);
		add(funk.types.Function4Test);
		add(funk.types.Function5Test);
		add(funk.types.OptionTest);
		add(funk.types.PartialFunction1Test);
		add(funk.types.PartialFunction2Test);
		add(funk.types.PartialFunction3Test);
		add(funk.types.PartialFunction4Test);
		add(funk.types.PartialFunction5Test);
		add(funk.types.Predicate0Test);
		add(funk.types.Predicate1Test);
		add(funk.types.Predicate2Test);
		add(funk.types.Predicate3Test);
		add(funk.types.Predicate4Test);
		add(funk.types.Predicate5Test);
		add(funk.types.SelectorTest);
		add(funk.types.StringsTest);
		add(funk.types.Tuple1Test);
		add(funk.types.Tuple2Test);
		add(funk.types.Tuple3Test);
		add(funk.types.Tuple4Test);
		add(funk.types.Tuple5Test);
		add(funk.types.WildcardTest);
	}
}
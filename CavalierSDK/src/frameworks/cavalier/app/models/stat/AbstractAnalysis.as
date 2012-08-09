package frameworks.cavalier.app.models.stat
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AbstractAnalysis extends EventDispatcher
	{
		[Bindable]
		public var key:Object;
		
		[Bindable]
		public var value:Object;
		
		[Bindable]
		public var label:String;
		
		/**
		 * Constructor
		 */
		public function AbstractAnalysis(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}
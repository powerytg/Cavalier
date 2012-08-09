package frameworks.cavalier.plugin
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Action extends EventDispatcher
	{
		/**
		 * Constructor
		 */
		public function Action(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		 public function doAction(localMessageBus:EventDispatcher = null):void{
			 // Override this method in your class
		 }
	}
}
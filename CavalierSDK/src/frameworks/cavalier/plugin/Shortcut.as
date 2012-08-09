package frameworks.cavalier.plugin
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Shortcut extends EventDispatcher
	{
		/**
		 * Constructor
		 */
		public function Shortcut(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		 public function doAction():void{
			 // Override this method in your class
		 }
	}
}
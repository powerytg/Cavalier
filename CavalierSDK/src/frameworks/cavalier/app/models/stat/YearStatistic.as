package frameworks.cavalier.app.models.stat
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class YearStatistic extends EventDispatcher
	{
		/**
		 * @public
		 */
		[Bindable]
		public var year:Number;
		
		/**
		 * @public
		 */
		[Bindable]
		public var numPlaylists:Number;
		
		/**
		 * @public
		 */
		[Bindable]
		public var numClips:Number;
		
		/**
		 * @public
		 */
		public var months:Dictionary = new Dictionary();
		
		/**
		 * Constructor
		 */
		public function YearStatistic(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}
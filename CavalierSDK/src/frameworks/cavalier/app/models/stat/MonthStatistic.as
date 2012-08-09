package frameworks.cavalier.app.models.stat
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MonthStatistic extends EventDispatcher
	{
		/**
		 * @public
		 */
		public var month:Number;
		
		/**
		 * @public
		 */
		public var year:Number;
		
		/**
		 * @public
		 */
		public var date:Date;
		
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
		 * Constructor
		 */
		public function MonthStatistic(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}
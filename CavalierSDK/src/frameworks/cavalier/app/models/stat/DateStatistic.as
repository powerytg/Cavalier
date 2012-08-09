package frameworks.cavalier.app.models.stat
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class DateStatistic extends EventDispatcher
	{
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
		[Bindable]
		public var years:Dictionary = new Dictionary();
		 
		/**
		 * Constructor
		 */
		public function DateStatistic(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}
package frameworks.cavalier.app.events
{
	import flash.events.Event;
	
	public class StatisticEvent extends Event
	{
		/**
		 * @public
		 */
		public static const ALL_TIME_PLAYLIST_STAT_CHANGE:String = "allTimePlaylistStatChange";

		/**
		 * @public
		 */
		public static const ALL_TIME_CLIP_STAT_CHANGE:String = "allTimeClipStatChange";

		/**
		 * Constructor
		 */
		public function StatisticEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package frameworks.cavalier.app.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.SearchEventPayload;
	import frameworks.cavalier.app.models.query.QueryCondition;
	
	public class SearchEvent extends Event
	{
		/**
		 * @public
		 */
		public static const PLAYLIST_SEARCH_RESULT:String = "playlistSearchResult";

		/**
		 * @public
		 */
		public static const CLIP_SEARCH_RESULT:String = "clipSearchResult";

		/**
		 * @public
		 */
		public static const AD_SEARCH_RESULT:String = "adSearchResult";

		/**
		 * @public
		 */
		public static const CONDITION_CHANGE:String = "conditionChange";
		
		/**
		 * @public
		 */
		public var payload:SearchEventPayload;
		
		/**
		 * @public
		 */
		public var condition:QueryCondition;
		
		/**
		 * Constructor
		 */
		public function SearchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
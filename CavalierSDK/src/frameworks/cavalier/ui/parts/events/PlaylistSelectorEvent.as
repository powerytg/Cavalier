package frameworks.cavalier.ui.parts.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.Playlist;
	
	public class PlaylistSelectorEvent extends Event
	{
		/**
		 * @public
		 */
		public static const PLAYLIST_SELECTION_CHANGE:String = "playlistSelectionChange";
		
		/**
		 * @public
		 */
		public static const PLAYLIST_DELETED:String = "playlistDeleted";
		
		/**
		 * @public
		 */
		public var selectedItem:Playlist;

		/**
		 * Constructor
		 */
		public function PlaylistSelectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
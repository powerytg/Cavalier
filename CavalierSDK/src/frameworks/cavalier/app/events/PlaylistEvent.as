package frameworks.cavalier.app.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.Playlist;
	
	public class PlaylistEvent extends Event
	{
		/**
		 * @public
		 */
		public static const PLAYLIST_LOADED:String = "playlistLoaded";

		/**
		 * Constructor
		 */
		public function PlaylistEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
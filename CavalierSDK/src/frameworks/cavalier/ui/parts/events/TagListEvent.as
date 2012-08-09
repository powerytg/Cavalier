package frameworks.cavalier.ui.parts.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.Tag;
	
	public class TagListEvent extends Event
	{
		/**
		 * @public
		 */
		public static const TAG_SELECTION_CHANGE:String = "tagSelectionChange";
		
		/**
		 * @public
		 */
		public var selectedTag:Tag;
		
		/**
		 * Constructor
		 */
		public function TagListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
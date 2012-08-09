package frameworks.cavalier.ui.parts.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.Clip;
	
	public class ClipSelectorEvent extends Event
	{
		/**
		 * @public
		 */
		public static const CLIP_SELECTION_CHANGE:String = "clipSelectionChange";
		
		/**
		 * @public
		 */
		public static const CLIP_DELETED:String = "clipDeleted";
		
		/**
		 * @public
		 */
		public var selectedItem:Clip;

		/**
		 * Constructor
		 */
		public function ClipSelectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
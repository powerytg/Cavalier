package frameworks.cavalier.ui.parts.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.Ad;
	
	public class AdSelectorEvent extends Event
	{
		/**
		 * @public
		 */
		public static const AD_SELECTION_CHANGE:String = "adSelectionChange";
		
		/**
		 * @public
		 */
		public static const AD_DELETED:String = "adDeleted";
		
		/**
		 * @public
		 */
		public var selectedItem:Ad;

		/**
		 * Constructor
		 */
		public function AdSelectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
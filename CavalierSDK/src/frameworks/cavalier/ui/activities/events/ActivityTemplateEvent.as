package frameworks.cavalier.ui.activities.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.plugin.core.UIPartDescriptor;
	import frameworks.cavalier.ui.activities.supportClasses.UIPartHolder;
	
	public class ActivityTemplateEvent extends Event
	{
		/**
		 * @public
		 */
		public static const LAYOUT_CHANGE:String = "layoutChange";
		
		/**
		 * @public
		 */
		public static const ACTIVITY_DISCARDED:String = "activityDiscarded";
		
		/**
		 * @public
		 */
		public static const CHOOSE_UI_PART:String = "chooseUIPart";
		
		/**
		 * @public
		 */
		public static const UI_PART_SELECTED:String = "uiPartSelected";

		/**
		 * @public
		 */
		public static const UI_PART_SELECTION_CANCELED:String = "uiPartSelectionCanceled";

		/**
		 * @public
		 */
		public var selectedLayoutClass:Class;
		
		/**
		 * @public
		 */
		public var selectedUIPartHolder:UIPartHolder;
		
		/**
		 * @public
		 */
		public var selectedUIPartDescriptor:UIPartDescriptor;
		
		/**
		 * @public
		 */
		public var title:String;
		
		/**
		 * Constructor
		 */
		public function ActivityTemplateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
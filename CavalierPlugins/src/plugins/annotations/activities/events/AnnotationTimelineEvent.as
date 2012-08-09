package plugins.annotations.activities.events
{
	import flash.events.Event;
	
	public class AnnotationTimelineEvent extends Event
	{
		
		/**
		 * @public
		 */
		public static const TOGGLE_DETAILED_TIMELINE:String = "toggleDetailedTimeline";
		
		/**
		 * Constructor
		 */
		public function AnnotationTimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
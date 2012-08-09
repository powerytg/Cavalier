package plugins.annotations.activities.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.Annotation;
	
	public class ExpandedAnnotationMarkerEvent extends Event
	{
		/**
		 * @public
		 */
		public static const ANNOTATION_CONTENT_CHANGE:String = "annotationContentChange";
		
		/**
		 * @public
		 */
		public var annotation:Annotation;
		
		/**
		 * @public
		 */
		public var newContent:String;
		
		/**
		 * Constructor
		 */
		public function ExpandedAnnotationMarkerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
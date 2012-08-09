package plugins.annotations.activities.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.Annotation;
	
	import plugins.annotations.activities.supportClasses.AnnotationWidget;
	
	public class AnnotationWidgetEvent extends Event
	{
		/**
		 * @public
		 */
		public static const ANNOTATION_CHANGED:String = "annotationChanged";
		
		/**
		 * @public
		 */
		public var widget:AnnotationWidget;
		
		/**
		 * Constructor
		 */
		public function AnnotationWidgetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
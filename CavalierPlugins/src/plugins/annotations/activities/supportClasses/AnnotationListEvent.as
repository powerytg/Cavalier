package plugins.annotations.activities.supportClasses
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.Annotation;
	
	public class AnnotationListEvent extends Event
	{
		/**
		 * @public
		 */
		public static const ITEM_DELETE:String = "itemDelete";
		
		/**
		 * @public
		 */
		public var annotation:Annotation;
		
		/**
		 * Constructor
		 */
		public function AnnotationListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
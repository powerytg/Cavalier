package plugins.resources.parts.supportClasses
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.Clip;
	
	public class ClipRendererEvent extends Event
	{
		/**
		 * @public
		 */
		public static const REMOVE_BUTTON_CLICK:String = "removeButtonClick";
		
		/**
		 * @public
		 */
		public var clip:Clip;
		
		/**
		 * Constructor
		 */
		public function ClipRendererEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package frameworks.cavalier.app.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.jobs.Job;
	
	public class JobEvent extends Event
	{
		/**
		 * @public
		 */
		public static const SUCCESS:String = "success";
		
		/**
		 * @public
		 */
		public static const FAILED:String = "failed";
		
		/**
		 * @public
		 */
		public var job:Job;
		
		/**
		 * Constructor
		 */
		public function JobEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
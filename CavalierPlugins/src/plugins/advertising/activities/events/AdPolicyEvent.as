package plugins.advertising.activities.events
{
	import flash.events.Event;
	
	public class AdPolicyEvent extends Event
	{
		public function AdPolicyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package ui.messagePanel.supportClasses.indicators
{
	import frameworks.cavalier.messaging.models.MessageBase;
	import frameworks.cavalier.messaging.models.MessageStatus;
	
	public class ActivityMonitor extends MessageBase
	{
		/**
		 * Constructor
		 */
		public function ActivityMonitor()
		{
			super();
			status = MessageStatus.ALWAYS_ON;
			renderer = ActivityMonitorRenderer;
		}
	}
}
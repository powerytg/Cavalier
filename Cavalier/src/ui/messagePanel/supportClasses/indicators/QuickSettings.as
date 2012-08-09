package ui.messagePanel.supportClasses.indicators
{
	import frameworks.cavalier.messaging.models.MessageBase;
	import frameworks.cavalier.messaging.models.MessageStatus;
	
	public class QuickSettings extends MessageBase
	{
		/**
		 * Constructor
		 */
		public function QuickSettings()
		{
			super();
			status = MessageStatus.ALWAYS_ON;
			renderer = QuickSettingsRenderer;
		}
	}
}
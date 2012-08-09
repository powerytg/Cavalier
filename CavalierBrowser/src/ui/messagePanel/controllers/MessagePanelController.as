package ui.messagePanel.controllers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	
	import mx.events.FlexEvent;
	
	import ui.messagePanel.ClearAllWindow;
	import ui.messagePanel.MessagePanel;
	import ui.messagePanel.events.MessagePanelEvent;
	
	public class MessagePanelController extends EventDispatcher
	{
		/**
		 * @public
		 */
		public var messagePanel:MessagePanel = null;
		
		/**
		 * Constructor
		 */
		public function MessagePanelController(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		public function createMessagePanel():MessagePanel{
			messagePanel = new MessagePanel();
			messagePanel.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			return messagePanel;
		}
		
		/**
		 * @public
		 */
		public function destroyMessagePanel():void{
			messagePanel = null;
		}
		
		/**
		 * @private
		 */
		protected function onCreationComplete(evt:FlexEvent):void{
			messagePanel.closeButton.addEventListener(MouseEvent.CLICK, onClose);
			messagePanel.removeAllButton.addEventListener(MouseEvent.CLICK, onRemoveAll);
			messagePanel.openInActivityButton.addEventListener(MouseEvent.CLICK, onOpenInActivity);
		}
		
		/**
		 * @private
		 */
		protected function onClose(evt:MouseEvent):void{
			dispatchEvent(new MessagePanelEvent(MessagePanelEvent.MESSAGE_PANEL_CLOSE));
		}

		/**
		 * @private
		 */
		protected function onRemoveAll(evt:MouseEvent):void{
			var win:ClearAllWindow = new ClearAllWindow();
			win.popOut();
			
			win.confirmButton.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
				win.close();
				SystemBus.systemBus.clearAllActiveMessages();
			});
			
			win.cancelButton.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
				win.close();
			});
		}

		/**
		 * @private
		 */
		protected function onOpenInActivity(evt:MouseEvent):void{
			ActivityManager.activityManager.lookAtOrCreateNewByClassName("MessageActivity");
		}
		
	}
}
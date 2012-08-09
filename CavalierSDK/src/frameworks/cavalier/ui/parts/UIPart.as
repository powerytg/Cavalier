package frameworks.cavalier.ui.parts
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	import frameworks.cavalier.plugin.core.UIPartDescriptor;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	import frameworks.crescent.activity.Activity;
	import frameworks.crescent.activity.events.ActivityContainerEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.SkinnableContainer;
	
	public class UIPart extends SkinnableContainer
	{
		/**
		 * @public
		 */
		[Bindable]
		public var affectedDomain:String = UIPartAffectedDomain.LOCAL;
		
		/**
		 * @public
		 */
		[Bindable]
		public var canPopOut:Boolean = false;
		
		/**
		 * @public
		 * 
		 * A reference to the host activity's message bus
		 */
		public var localMessageBus:EventDispatcher;
		
		/**
		 * Constructor
		 */
		public function UIPart()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
		}
		
		/**
		 * @protected
		 */
		protected function onCreationComplete(evt:FlexEvent):void{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			var p:DisplayObject = this;
			while(p.parent != null){
				if(p.parent is Activity){
					localMessageBus = (p.parent as Activity).localMessageBus;
					localMessageBus.addEventListener(ActivityContainerEvent.ACTIVITIED, onActivited, false, 0, true);
					localMessageBus.addEventListener(ActivityContainerEvent.DEACTIVITIED, onDeactivited, false, 0, true);
					localMessageBus.addEventListener(ActivityContainerEvent.DESTROY, onDestroy, false, 0, true);
					return;
				}
				
				p = p.parent;
			}
		}
		
		/**
		 * @public
		 * 
		 * Send out a "pop-out" request
		 */
		public function popOut():void{
			ActivityManager.activityManager.createActivityWithUIPart(this);
		}
		
		/**
		 * @public
		 */
		public function createClone():UIPart{
			return null;
		}
		
		/**
		 * @public
		 */
		public function destroy():void{
			trace("UIPart [" + this.className + "] destroyed");
			
			localMessageBus.removeEventListener(ActivityContainerEvent.ACTIVITIED, onActivited);
			localMessageBus.removeEventListener(ActivityContainerEvent.DEACTIVITIED, onDeactivited);
			localMessageBus.removeEventListener(ActivityContainerEvent.DESTROY, onDestroy);
			localMessageBus = null;

		}
		
		/**
		 * @private
		 */
		protected function onActivited(evt:ActivityContainerEvent):void{
			
		}

		/**
		 * @private
		 */
		protected function onDeactivited(evt:ActivityContainerEvent):void{
			
		}

		/**
		 * @private
		 */
		protected function onDestroy(evt:ActivityContainerEvent):void{
			destroy();
		}
		
	}
}
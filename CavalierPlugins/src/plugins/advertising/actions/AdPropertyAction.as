package plugins.advertising.actions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	
	public class AdPropertyAction extends Action
	{
		public function AdPropertyAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function doAction(localMessageBus:EventDispatcher=null):void{
			ActivityManager.activityManager.lookAtOrCreateNewByClassName("AdEditorActivity");
		}
	}
}
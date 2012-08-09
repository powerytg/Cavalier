package plugins.annotations.actions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	
	public class EditAnnotationAction extends Action
	{
		public function EditAnnotationAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function doAction(localMessageBus:EventDispatcher=null):void{
			ActivityManager.activityManager.lookAtOrCreateNewByClassName("AnnotationActivity");
		}
	}
}
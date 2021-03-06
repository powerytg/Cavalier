package plugins.resources.actions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	
	public class ClipPropertyAction extends Action
	{
		/**
		 * Constructor
		 */
		public function ClipPropertyAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function doAction(localMessageBus:EventDispatcher=null):void{
			ActivityManager.activityManager.lookAtOrCreateNewByClassName("ClipEditorActivity");
		}
		
	}
}
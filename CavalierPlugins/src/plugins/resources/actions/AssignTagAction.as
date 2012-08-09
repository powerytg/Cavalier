package plugins.resources.actions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	import frameworks.cavalier.ui.messaging.InfoIndicator;
	
	import plugins.resources.activities.AssignTagsActivity;
	
	public class AssignTagAction extends Action
	{
		public function AssignTagAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function doAction(localMessageBus:EventDispatcher=null):void{
			if(!Aggregator.aggregator.selectedClip){
				var info:InfoIndicator = new InfoIndicator();
				info.text = "You should select a clip before adding tags";
				info.show();
				
				return;
			}
			
			var assignTagsActivity:AssignTagsActivity = new AssignTagsActivity();
			assignTagsActivity.clip = Aggregator.aggregator.selectedClip;
			ActivityManager.activityManager.addActivityToFront(assignTagsActivity);

		}
			
	}
}
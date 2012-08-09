package plugins.advertising.actions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	import frameworks.cavalier.ui.messaging.InfoIndicator;
	
	import plugins.advertising.activities.AssignTagsToAdActivity;
	
	public class AdAssignTagAction extends Action
	{
		public function AdAssignTagAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function doAction(localMessageBus:EventDispatcher=null):void{
			if(!Aggregator.aggregator.selectedAd){
				var info:InfoIndicator = new InfoIndicator();
				info.text = "You should select an ad before adding tags";
				info.show();
				
				return;
			}
			
			var assignTagsActivity:AssignTagsToAdActivity = new AssignTagsToAdActivity();
			assignTagsActivity.ad = Aggregator.aggregator.selectedAd;
			ActivityManager.activityManager.addActivityToFront(assignTagsActivity);
		}
	}
}
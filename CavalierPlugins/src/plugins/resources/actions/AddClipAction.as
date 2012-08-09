package plugins.resources.actions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	
	import plugins.resources.activities.AddToPlaylistActivity;
	
	public class AddClipAction extends Action
	{
		public function AddClipAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function doAction(localMessageBus:EventDispatcher=null):void{
			if(!Aggregator.aggregator.selectedPlaylist)
				return;
			
			var clipChooser:AddToPlaylistActivity = new AddToPlaylistActivity();
			clipChooser.playlist = Aggregator.aggregator.selectedPlaylist;
			ActivityManager.activityManager.addActivityToFront(clipChooser);
		}
	}
}
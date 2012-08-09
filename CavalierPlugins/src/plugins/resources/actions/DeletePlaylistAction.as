package plugins.resources.actions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.JobController;
	import frameworks.cavalier.app.models.Playlist;
	import frameworks.cavalier.app.models.jobs.CRUDAction;
	import frameworks.cavalier.app.models.jobs.PlaylistJob;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.ui.parts.events.PlaylistSelectorEvent;
	
	import mx.collections.ArrayCollection;
	
	public class DeletePlaylistAction extends Action
	{
		public function DeletePlaylistAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function doAction(localMessageBus:EventDispatcher=null):void{
			var playlists:ArrayCollection = Aggregator.aggregator.playlists;
			var playlist:Playlist = Aggregator.aggregator.selectedPlaylist;
			
			// Update views
			// Update views
			if(localMessageBus){
				var evt:PlaylistSelectorEvent = new PlaylistSelectorEvent(PlaylistSelectorEvent.PLAYLIST_DELETED);
				evt.selectedItem = playlist;
				
				localMessageBus.dispatchEvent(evt);
			}
			
			var job:PlaylistJob = new PlaylistJob();
			job.action = CRUDAction.DELETE;
			job.payload = playlist;
			JobController.jobController.submitJob(job);
		}
	}
}
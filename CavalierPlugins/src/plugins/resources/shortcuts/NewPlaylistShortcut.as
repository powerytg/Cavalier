package plugins.resources.shortcuts
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.JobController;
	import frameworks.cavalier.app.models.Playlist;
	import frameworks.cavalier.app.models.jobs.CRUDAction;
	import frameworks.cavalier.app.models.jobs.PlaylistJob;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.plugin.Shortcut;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	
	public class NewPlaylistShortcut extends Shortcut
	{
		/**
		 * Constructor
		 */
		public function NewPlaylistShortcut(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		override public function doAction():void{
			// Create an empty playlist
			var playlist:Playlist = new Playlist();
			playlist.name = "untitled playlist";
			
			// Also submit a job
			var job:PlaylistJob = new PlaylistJob();
			job.action = CRUDAction.CREATE;
			job.payload = playlist;
			JobController.jobController.submitJob(job);
			
			// Create a new activity for editing the playlist
			Aggregator.aggregator.selectedPlaylist = playlist;
			ActivityManager.activityManager.lookAtOrCreateNewByClassName("PlaylistEditorActivity");

		}
		
	}
}
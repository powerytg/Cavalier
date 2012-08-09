package plugins.resources.shortcuts
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.JobController;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.jobs.CRUDAction;
	import frameworks.cavalier.app.models.jobs.ClipJob;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.plugin.Shortcut;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	
	public class ImportClipShortcut extends Shortcut
	{
		/**
		 * Constructor
		 */
		public function ImportClipShortcut(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		override public function doAction():void{
			// Create an empty clip
			var clip:Clip = new Clip();
			clip.name = "untitled clip";
			
			// Also submit a job
			var job:ClipJob = new ClipJob();
			job.action = CRUDAction.CREATE;
			job.payload = clip;
			JobController.jobController.submitJob(job);
			
			// Create a new activity for editing the playlist
			Aggregator.aggregator.selectedClip = clip;
			ActivityManager.activityManager.lookAtOrCreateNewByClassName("ClipEditorActivity");

		}
		
	}
}
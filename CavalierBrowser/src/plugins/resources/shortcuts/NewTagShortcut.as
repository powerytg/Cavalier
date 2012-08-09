package plugins.resources.shortcuts
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.JobController;
	import frameworks.cavalier.app.models.Tag;
	import frameworks.cavalier.app.models.jobs.CRUDAction;
	import frameworks.cavalier.app.models.jobs.TagJob;
	import frameworks.cavalier.plugin.Shortcut;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	
	public class NewTagShortcut extends Shortcut
	{
		/**
		 * Constructor
		 */
		public function NewTagShortcut(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		override public function doAction():void{
			// Create an empty tag
			var tag:Tag = new Tag();
			tag.name = "untitled tag";
			
			// Also submit a job
			var job:TagJob = new TagJob();
			job.action = CRUDAction.CREATE;
			job.payload = tag;
			JobController.jobController.submitJob(job);
			
			// Create a new activity for editing the playlist
//			ActivityManager.activityManager.lookAtOrCreateNewByClassName("ManageTagsActivity");
		}
		
	}
}
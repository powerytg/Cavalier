package plugins.advertising.shortcuts
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.JobController;
	import frameworks.cavalier.app.models.Ad;
	import frameworks.cavalier.app.models.jobs.AdJob;
	import frameworks.cavalier.app.models.jobs.CRUDAction;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.plugin.Shortcut;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	
	public class ImportAdShortcut extends Shortcut
	{
		/**
		 * Constructor
		 */
		public function ImportAdShortcut(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		override public function doAction():void{
			// Create an empty playlist
			var ad:Ad = new Ad();
			ad.name = "untitled ad";
			
			// Also submit a job
			var job:AdJob = new AdJob();
			job.action = CRUDAction.CREATE;
			job.payload = ad;
			JobController.jobController.submitJob(job);
			
			// Create a new activity for editing the playlist
			Aggregator.aggregator.selectedAd = ad;
			ActivityManager.activityManager.lookAtOrCreateNewByClassName("AdEditorActivity");
			
		}
		
	}
}
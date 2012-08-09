package frameworks.cavalier.app.controllers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.models.ModelBase;
	import frameworks.cavalier.app.models.jobs.CRUDAction;
	import frameworks.cavalier.app.models.jobs.Job;
	import frameworks.cavalier.ui.messaging.InfoIndicator;
	
	import mx.collections.ArrayCollection;
	
	public class JobController extends EventDispatcher
	{
		/**
		 * @public
		 */
		[Bindable]
		public var jobs:ArrayCollection = new ArrayCollection();
		
		/**
		 * @private
		 */
		private static var _jobController:JobController;
		
		/**
		 * @public
		 */
		public static function get jobController():JobController
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():JobController
		{
			if (_jobController == null){
				_jobController = new JobController();
			}
			return _jobController;
		}
		
		/**
		 * Constructor
		 */
		public function JobController()
		{
			super();
			if( _jobController != null ) throw new Error("Error:JobController already initialised.");
			if( _jobController == null ) _jobController = this;
		}
		
		/**
		 * @public
		 */
		public function submitJob(target:Job):void{
			for each(var job:Job in jobs){
				if(job == target){
					resolveConflict(job, target);
					return;
				}
				else if(job.payload.id == target.payload.id && job.modelType == target.modelType){
					resolveConflict(job, target);
					return;
				}
			}
			
			// If there's no conflict, then we simply append the new job into the job list
			jobs.addItem(target);
			target.onSubmit();
		}
		
		/**
		 * @public
		 */
		public function cancelJob(target:Job):void{
			for each(var job:Job in jobs){
				if(job == target){
					target.revert();
					return;
				}
			}
		}
		
		/**
		 * @public
		 * 
		 * Rules: 
		 * 
		 * CREATE will override UPDATE (all updates are merged into one 'create' action)
		 * DELETE will override UPDATE (since the resource is to be deleted, there's no need to update it any more)
		 * DELETE will cancel CREATE, if the resource is newly created in the UI but yet to be submitted to the server. Such resource doesn't have an ID
		 * (because the resource doesn't exsit on the server yet, there's no need to report the action to the server anyway)
		 * 
		 * UPDATE will override ealier UPDATE (we always keep one single payload, so any changes made into it is always 'newest')
		 */
		public function resolveConflict(oldJob:Job, newJob:Job):void{
			if(oldJob.action == CRUDAction.CREATE && newJob.action == CRUDAction.UPDATE)
				oldJob.payload = newJob.payload;
			else if(oldJob.action == CRUDAction.UPDATE && newJob.action == CRUDAction.DELETE){
				jobs.removeItemAt(jobs.getItemIndex(oldJob));
				jobs.addItem(newJob);
				newJob.onSubmit();
			}
			else if(oldJob.action == CRUDAction.CREATE && newJob.action == CRUDAction.DELETE){
				oldJob.revert();
			}
			else if(oldJob.action == CRUDAction.UPDATE && newJob.action == CRUDAction.UPDATE){
				// Keep the old job's clone
				newJob.originalClone = oldJob.originalClone;
				jobs.setItemAt(newJob, jobs.getItemIndex(oldJob));
				newJob.onSubmit();
			}
		}
		
		/**
		 * @public
		 */
		public function commit():void{
			var numJobs:Number = jobs.length;
			for each(var job:Job in jobs){
				job.doAction();
			}
			
			if(numJobs != 0){
				var notification:InfoIndicator = new InfoIndicator();
				notification.text = numJobs.toString() + " jobs have been commited to server";
				notification.show();
			}
		}
		
		/**
		 * @public
		 */
		public function findJobByPayload(payload:ModelBase):Job{
			for each(var job:Job in jobs){
				if(job.payload == payload)
					return job;
			}
			
			return null;
		}
		
	}
}
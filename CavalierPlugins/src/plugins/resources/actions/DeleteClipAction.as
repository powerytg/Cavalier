package plugins.resources.actions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.JobController;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.jobs.CRUDAction;
	import frameworks.cavalier.app.models.jobs.ClipJob;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.ui.parts.events.ClipSelectorEvent;
	
	import mx.collections.ArrayCollection;
	
	public class DeleteClipAction extends Action
	{
		public function DeleteClipAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function doAction(localMessageBus:EventDispatcher=null):void{
			var clips:ArrayCollection = Aggregator.aggregator.clips;
			var clip:Clip = Aggregator.aggregator.selectedClip;
			
			// Update views
			if(localMessageBus){
				var evt:ClipSelectorEvent = new ClipSelectorEvent(ClipSelectorEvent.CLIP_DELETED);
				evt.selectedItem = clip;
					
				localMessageBus.dispatchEvent(evt);
			}
			
			var job:ClipJob = new ClipJob();
			job.action = CRUDAction.DELETE;
			job.payload = clip;
			JobController.jobController.submitJob(job);
		}
	}
}
package plugins.advertising.actions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.JobController;
	import frameworks.cavalier.app.models.Ad;
	import frameworks.cavalier.app.models.jobs.AdJob;
	import frameworks.cavalier.app.models.jobs.CRUDAction;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.ui.parts.events.AdSelectorEvent;
	
	import mx.collections.ArrayCollection;
	
	public class DeleteAdAction extends Action
	{
		public function DeleteAdAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function doAction(localMessageBus:EventDispatcher=null):void{
			var ads:ArrayCollection = Aggregator.aggregator.ads;
			var ad:Ad = Aggregator.aggregator.selectedAd;
			
			// Update views
			if(localMessageBus){
				var evt:AdSelectorEvent = new AdSelectorEvent(AdSelectorEvent.AD_DELETED);
				evt.selectedItem = ad;
				
				localMessageBus.dispatchEvent(evt);
			}
			
			var job:AdJob = new AdJob();
			job.action = CRUDAction.DELETE;
			job.payload = ad;
			JobController.jobController.submitJob(job);
		}
	}
}
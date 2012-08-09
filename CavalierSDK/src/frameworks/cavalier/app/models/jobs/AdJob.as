package frameworks.cavalier.app.models.jobs
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.AdController;
	import frameworks.cavalier.app.models.Ad;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.MessageLevel;
	
	public class AdJob extends Job
	{
		/**
		 * Constructor
		 */
		public function AdJob(target:IEventDispatcher=null)
		{
			super(target);
			modelType = "Ad";
		}
		
		/**
		 * @public
		 */
		public function get ad():Ad{
			return payload as Ad;
		}
		
		/**
		 * @public
		 */
		override public function onSubmit():void{
			super.onSubmit();
			
			switch(action){
				case CRUDAction.CREATE:
					Aggregator.aggregator.pendingAds.addItem(ad);
					break;
				case CRUDAction.DELETE:
					Aggregator.aggregator.selectedAd = null;
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doCreateAction():void{
			AdController.adController.createOrUpdateAd(ad, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function revert():void{
			super.revert();
			
			switch(action){
				case CRUDAction.CREATE:
					if(Aggregator.aggregator.ads.contains(ad))
						Aggregator.aggregator.ads.removeItemAt(Aggregator.aggregator.ads.getItemIndex(ad));
					
					if(Aggregator.aggregator.pendingAds.contains(ad))
						Aggregator.aggregator.pendingAds.removeItemAt(Aggregator.aggregator.pendingAds.getItemIndex(ad));
					break;
				case CRUDAction.DELETE:
					var adIndex:Number = Aggregator.aggregator.ads.getItemIndex(ad);
					Aggregator.aggregator.ads.setItemAt(originalClone, adIndex);
					originalClone.status = ModelStatus.NORMAL;
					break;
				case CRUDAction.UPDATE:
					ad.cloneFrom(originalClone);
					ad.status = ModelStatus.NORMAL;
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doUpdateAction():void{
			AdController.adController.createOrUpdateAd(ad, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function doDeleteAction():void{
			AdController.adController.deleteAd(ad, onSuccess, onFault);
		}
		
		/**
		 * @private
		 */
		override protected function onSuccess():void{
			super.onSuccess();
			
			if(Aggregator.aggregator.pendingAds.contains(ad))
				Aggregator.aggregator.pendingAds.removeItemAt(Aggregator.aggregator.pendingAds.getItemIndex(ad));
			
			SystemBus.systemBus.newLog("[" + action + "]" + " on ad(id=" + ad.id + ") is successful.", MessageLevel.SUCCESSFUL);
		}
		
		/**
		 * @private
		 */
		override protected function onFault(message:String = null):void{
			super.onFault(message);
			SystemBus.systemBus.newLog("[" + action + "]" + " on ad(id=" + ad.id + ") failed.", MessageLevel.FAILED);
		}
		
	}
}
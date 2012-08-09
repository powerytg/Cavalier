package frameworks.cavalier.app.models.jobs
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.TrackingController;
	import frameworks.cavalier.app.models.BeaconDistributionRule;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.MessageLevel;
	
	public class BeaconDistroRuleJob extends Job
	{
		/**
		 * Constructor
		 */
		public function BeaconDistroRuleJob(target:IEventDispatcher=null)
		{
			super(target);
			modelType = "BeaconDistroRule";
		}
		
		/**
		 * @public
		 */
		public function get rule():BeaconDistributionRule{
			return payload as BeaconDistributionRule;
		}
		
		/**
		 * @public
		 */
		override public function onSubmit():void{
			super.onSubmit();
			
			switch(action){
				case CRUDAction.CREATE:
					TrackingController.trackingController.pendingDistributionMatrix.addItem(rule);
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doCreateAction():void{
			TrackingController.trackingController.createOrUpdateBeaconDistroRule(rule, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function revert():void{
			super.revert();
			
			switch(action){
				case CRUDAction.CREATE:
					if(TrackingController.trackingController.distributionMatrix.contains(rule))
						TrackingController.trackingController.distributionMatrix.removeItemAt(TrackingController.trackingController.distributionMatrix.getItemIndex(rule));
					
					if(TrackingController.trackingController.pendingDistributionMatrix.contains(rule))
						TrackingController.trackingController.pendingDistributionMatrix.removeItemAt(TrackingController.trackingController.pendingDistributionMatrix.getItemIndex(rule));
					
					break;
				case CRUDAction.DELETE:
					var ruleIndex:Number = TrackingController.trackingController.distributionMatrix.getItemIndex(rule);
					TrackingController.trackingController.distributionMatrix.setItemAt(originalClone, ruleIndex);
					originalClone.status = ModelStatus.NORMAL;
					break;
				case CRUDAction.UPDATE:
					rule.cloneFrom(originalClone);
					rule.status = ModelStatus.NORMAL;
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doUpdateAction():void{
			TrackingController.trackingController.createOrUpdateBeaconDistroRule(rule, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function doDeleteAction():void{
			TrackingController.trackingController.deleteBeaconDistroRule(rule, onSuccess, onFault);
		}
		
		/**
		 * @private
		 */
		override protected function onSuccess():void{
			super.onSuccess();
			
			if(TrackingController.trackingController.pendingDistributionMatrix.contains(rule))
				TrackingController.trackingController.pendingDistributionMatrix.removeItemAt(TrackingController.trackingController.pendingDistributionMatrix.getItemIndex(rule));
			
			SystemBus.systemBus.newLog("[" + action + "]" + " on beacon distribution rule(id=" + rule.id + ") is successful.", MessageLevel.SUCCESSFUL);
		}
		
		/**
		 * @private
		 */
		override protected function onFault(message:String = null):void{
			super.onFault(message);
			SystemBus.systemBus.newLog("[" + action + "]" + " on beacon distribution rule(id=" + rule.id + ") failed.", MessageLevel.FAILED);
		}
		
	}
}
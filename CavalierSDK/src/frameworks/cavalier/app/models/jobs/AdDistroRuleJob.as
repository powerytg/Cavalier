package frameworks.cavalier.app.models.jobs
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.AdController;
	import frameworks.cavalier.app.models.AdDistributionRule;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.MessageLevel;
	
	public class AdDistroRuleJob extends Job
	{
		/**
		 * Constructor
		 */
		public function AdDistroRuleJob(target:IEventDispatcher=null)
		{
			super(target);
			modelType = "AdDistroRule";
		}
		
		/**
		 * @public
		 */
		public function get rule():AdDistributionRule{
			return payload as AdDistributionRule;
		}
		
		/**
		 * @public
		 */
		override public function onSubmit():void{
			super.onSubmit();
			
			switch(action){
				case CRUDAction.CREATE:
					AdController.adController.pendingDistributionMatrix.addItem(rule);
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doCreateAction():void{
			AdController.adController.createOrUpdateAdDistroRule(rule, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function revert():void{
			super.revert();
			
			switch(action){
				case CRUDAction.CREATE:
					if(AdController.adController.distributionMatrix.contains(rule))
						AdController.adController.distributionMatrix.removeItemAt(AdController.adController.distributionMatrix.getItemIndex(rule));
					
					if(AdController.adController.pendingDistributionMatrix.contains(rule))
						AdController.adController.pendingDistributionMatrix.removeItemAt(AdController.adController.pendingDistributionMatrix.getItemIndex(rule));
					
					break;
				case CRUDAction.DELETE:
					var ruleIndex:Number = AdController.adController.distributionMatrix.getItemIndex(rule);
					AdController.adController.distributionMatrix.setItemAt(originalClone, ruleIndex);
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
			AdController.adController.createOrUpdateAdDistroRule(rule, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function doDeleteAction():void{
			AdController.adController.deleteAdDistroRule(rule, onSuccess, onFault);
		}
		
		/**
		 * @private
		 */
		override protected function onSuccess():void{
			super.onSuccess();
			
			if(AdController.adController.pendingDistributionMatrix.contains(rule))
				AdController.adController.pendingDistributionMatrix.removeItemAt(AdController.adController.pendingDistributionMatrix.getItemIndex(rule));
			
			SystemBus.systemBus.newLog("[" + action + "]" + " on ad distribution rule(id=" + rule.id + ") is successful.", MessageLevel.SUCCESSFUL);
		}
		
		/**
		 * @private
		 */
		override protected function onFault(message:String = null):void{
			super.onFault(message);
			SystemBus.systemBus.newLog("[" + action + "]" + " on ad distribution rule(id=" + rule.id + ") failed.", MessageLevel.FAILED);
		}
		
	}
}
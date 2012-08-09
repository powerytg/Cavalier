package frameworks.cavalier.app.models.jobs
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.TrackingController;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.MessageLevel;
	import frameworks.cavalier.polkit.Policy;
	
	public class TrackingPolicyJob extends Job
	{
		/**
		 * Constructor
		 */
		public function TrackingPolicyJob(target:IEventDispatcher=null)
		{
			super(target);
			modelType = "AdminPolicy";
		}
		
		/**
		 * @public
		 */
		public function get policy():Policy{
			return payload as Policy;
		}
		
		/**
		 * @public
		 */
		override public function get description():String
		{
			return "Policy[" + policy.key + "] will be changed to " + policy.value.toString();
		}
		
		/**
		 * @public
		 */
		override public function revert():void{
			super.revert();
			
			switch(action){
				case CRUDAction.UPDATE:
					policy.cloneFrom(originalClone);
					policy.status = ModelStatus.NORMAL;
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doUpdateAction():void{
			TrackingController.trackingController.changePolicy(policy, onSuccess, onFault);
		}
		
		/**
		 * @private
		 */
		override protected function onSuccess():void{
			super.onSuccess();
			
			SystemBus.systemBus.newLog("[" + action + "]" + " on policy(key=" + policy.key + ") is successful.", MessageLevel.SUCCESSFUL);
		}
		
		/**
		 * @private
		 */
		override protected function onFault(message:String = null):void{
			super.onFault(message);
			SystemBus.systemBus.newLog("[" + action + "]" + " on policy(key=" + policy.key + ") failed.", MessageLevel.FAILED);
		}
		
	}
}
package ui.chrome.controllers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.polkit.Policy;
	import frameworks.cavalier.polkit.PolicyKind;
	import frameworks.cavalier.polkit.PolicyKit;
	
	public class PolicyController extends EventDispatcher
	{
		/**
		 * Constructor
		 */
		public function PolicyController(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		public function installPredefinedPolicies():void{
			// CrescentUI policies
//			var policy:Policy = new Policy();
//			policy.key = "frameworks.crescent.policies.ActivityScrollingStyle";
//			policy.kind = PolicyKind.ENUMERABLE;
//			policy.title = "Activity Scrolling Style";
//			policy.enumerableItems = ["fluid", "swipe", "optimized"];
//			policy.value = "optimized";
//			PolicyKit.policyKit.installPolicy(policy);
//			
//			policy = new Policy();
//			policy.key = "frameworks.crescent.policies.ActivityScrollingStyle";
//			policy.title = "Activity Creation Policy";
//			policy.kind = PolicyKind.ENUMERABLE;
//			policy.enumerableItems = ["deffered", "immediate"];
//			policy.value = "immediate";
//			PolicyKit.policyKit.installPolicy(policy);
//			
//			// Application policies
//			policy = new Policy();
//			policy.key = "app.ui.background.UseDynamicBackground";
//			policy.title = "Use Dynamic Background";
//			policy.kind = PolicyKind.BOOLEAN;
//			policy.value = true;
//			PolicyKit.policyKit.installPolicy(policy);
			
		}
		
	}
}
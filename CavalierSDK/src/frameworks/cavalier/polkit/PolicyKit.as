package frameworks.cavalier.polkit
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import frameworks.cavalier.polkit.events.PolicyKitEvent;
	
	import mx.collections.ArrayCollection;
	
	public class PolicyKit extends EventDispatcher
	{

		/**
		 * @public
		 */
		public var catagories:Dictionary = new Dictionary();
		
		/**
		 * @private
		 */
		private static var _policyKit:PolicyKit;
		
		/**
		 * @public
		 */
		public static function get policyKit():PolicyKit
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():PolicyKit
		{
			if (_policyKit == null){
				_policyKit = new PolicyKit();
			}
			return _policyKit;
		}
		
		/**
		 * Constructor
		 */
		public function PolicyKit()
		{
			super();
			if( _policyKit != null ) throw new Error("Error:PolicyKit already initialised.");
			if( _policyKit == null ) _policyKit = this;
		}
		
		/**
		 * @public
		 */
		public function installCatagory(group:Dictionary, cat:String):void{
			catagories[cat] = group;
		}
		
		/**
		 * @public
		 */
		public function getCatagory(cat:String):Dictionary{
			return catagories[cat];
		}
		
		/**
		 * @public
		 */
		public function installPolicy(policy:Policy, cat:String):void{
			var catagory:Dictionary = getCatagory(cat);
			
			if(catagory)
				catagory[policy.key] = policy;
		}
		
		/**
		 * @public
		 */
		public function getPolicy(key:String, cat:String):Policy{
			var catagory:Dictionary = getCatagory(cat);
			
			if(!catagory)
				return null;
			
			if(catagory[key]){
				var policy:Policy = catagory[key] as Policy;
				return policy;
			}

			return null;
		}
		
		/**
		 * @public
		 */
		public function changePolicy(key:String, newValue:Object, cat:String):void{
			var policy:Policy = getPolicy(key, cat);
			
			if(!policy)
				return;
			
			var oldValue:Object = policy.value;
			policy.value = newValue;
			
			var evt:PolicyKitEvent = new PolicyKitEvent(PolicyKitEvent.POLICY_CHANGE);
			evt.policy = policy;
			evt.oldValue = oldValue;
			evt.newValue = newValue;
			evt.catagory = cat;
			
			dispatchEvent(evt);
		}
		
	}
}
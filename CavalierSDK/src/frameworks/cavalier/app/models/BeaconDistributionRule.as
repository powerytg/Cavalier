package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	public class BeaconDistributionRule extends ModelBase
	{
		/**
		 * @public
		 */
		[Bindable]
		public var startPoint:Number;

		/**
		 * @public
		 */
		[Bindable]
		public var endPoint:Number;
		
		/**
		 * @public
		 */
		[Bindable]
		public var numBeacons:Number;

		/**
		 * Constructor
		 */
		public function BeaconDistributionRule(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		override public function createClone():ModelBase{
			var rule:BeaconDistributionRule = new BeaconDistributionRule();
			rule.id = id;
			rule.startPoint = startPoint;
			rule.endPoint = endPoint;
			rule.numBeacons = numBeacons;
			return rule;
		}
		
		/**
		 * @public
		 */
		override public function cloneFrom(target:ModelBase):void{
			var rule:BeaconDistributionRule = target as BeaconDistributionRule;
			startPoint = rule.startPoint;
			endPoint = rule.endPoint;
			numBeacons = rule.numBeacons;
		}
		
	}
}
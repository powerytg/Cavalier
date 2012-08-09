package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	public class AdDistributionRule extends ModelBase
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
		public var numAds:Number;

		/**
		 * Constructor
		 */
		public function AdDistributionRule(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		override public function createClone():ModelBase{
			var rule:AdDistributionRule = new AdDistributionRule();
			rule.id = id;
			rule.startPoint = startPoint;
			rule.endPoint = endPoint;
			rule.numAds = numAds;
			return rule;
		}
		
		/**
		 * @public
		 */
		override public function cloneFrom(target:ModelBase):void{
			var rule:AdDistributionRule = target as AdDistributionRule;
			startPoint = rule.startPoint;
			endPoint = rule.endPoint;
			numAds = rule.numAds;
		}
		
	}
}
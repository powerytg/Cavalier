package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	public class CDN extends ModelBase
	{
		
		/**
		 * @public
		 */
		[Bindable]
		public var name:String;
		
		/**
		 * @public
		 */
		public function CDN(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		override public function createClone():ModelBase{
			var cdn:CDN = new CDN();
			cdn.id = id;
			cdn.name = name;
			return cdn;
		}
	}
}
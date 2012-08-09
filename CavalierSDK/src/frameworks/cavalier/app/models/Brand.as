package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	/**
	 * The Brand class describes video provider (companies) info
	 */
	public class Brand extends ModelBase
	{
		
		/**
		 * @public
		 */
		[Bindable]
		public var name:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var waterMarkUrl:String;
		
		/**
		 * Constructor
		 */
		public function Brand(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		override public function createClone():ModelBase{
			var brand:Brand = new Brand();
			brand.id = id;
			brand.name = name;
			brand.waterMarkUrl = waterMarkUrl;
			
			return brand;
		}
	}
}
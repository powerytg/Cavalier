package frameworks.cavalier.polkit
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.models.ModelBase;
	
	public class Policy extends ModelBase
	{
		/**
		 * @public
		 * 
		 * The display name, not to be confused as keys
		 */
		[Bindable]
		public var name:String;
		
		/**
		 * @public
		 */
		public var key:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var value:Object;
		
		/**
		 * @public
		 */
		public var kind:String = PolicyKind.NUMERIC_OR_STRING;
		
		/**
		 * @public
		 * 
		 * If kind is "enumerable", then this array provides possible values
		 */
		public var enumerableItems:Array = [];
		
		/**
		 * Constructor
		 */
		public function Policy()
		{
			super();
		}
		
		/**
		 * @public
		 */
		override public function createClone():ModelBase{
			var policy:Policy = new Policy();
			policy.id = id;
			policy.name = name;
			policy.key = key;
			policy.value = value;
			policy.kind = kind;
			policy.enumerableItems = [];
			
			for each(var item:Object in enumerableItems){
				policy.enumerableItems.push(item);
			}
			
			return policy;
		}
		
		/**
		 * @public
		 */
		override public function cloneFrom(target:ModelBase):void{
			var policy:Policy = target as Policy;
			id = policy.id;
			name = policy.name;
			key = policy.key;
			value = policy.value;
			kind = policy.kind;
			
			enumerableItems = [];
			for each(var item:Object in policy.enumerableItems){
				enumerableItems.push(item);
			}
		}
	}
}
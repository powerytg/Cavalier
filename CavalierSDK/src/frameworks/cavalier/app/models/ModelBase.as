package frameworks.cavalier.app.models
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ModelBase extends EventDispatcher
	{
		/**
		 * @public
		 */
		public var status:String = ModelStatus.NORMAL;
		
		/**
		 * @public
		 */
		[Bindable]
		public var id:String;
		
		/**
		 * Constructor
		 */
		public function ModelBase(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		public function createClone():ModelBase{
			return null;
		}
		
		/**
		 * @public
		 */
		public function cloneFrom(target:ModelBase):void{
			
		}
		
	}
}
package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	public class Comment extends ModelBase
	{
		/**
		 * @public
		 */
		public var content:String;
		
		/**
		 * @public
		 */
		public var date:String;

		/**
		 * Constructor
		 */
		public function Comment(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}
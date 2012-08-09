package frameworks.cavalier.app.models
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Tag extends ModelBase
	{
		
		/**
		 * @public
		 */
		[Bindable]
		public var name:String;
		
		/**
		 * @public
		 * 
		 * Number of clips that share this tag
		 */
		[Bindable]
		public var numClips:Number = 0;
		
		/**
		 * @public
		 * 
		 * Number of tags that share this tag
		 */
		[Bindable]
		public var numAds:Number = 0;
		
		/**
		 * Constructor
		 */
		public function Tag(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		override public function createClone():ModelBase{
			var tag:Tag = new Tag();
			tag.id = id;
			tag.name = name;
			tag.numClips = numClips;
			tag.numAds = numAds;
			
			return tag;
		}
		
		/**
		 * @public
		 */
		override public function cloneFrom(target:ModelBase):void{
			var tag:Tag = target as Tag;
			id = tag.id;
			name = tag.name;
			numClips = tag.numClips;
			numAds = tag.numAds;
		}
		
	}
}
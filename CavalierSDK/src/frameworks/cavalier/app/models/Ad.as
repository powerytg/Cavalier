package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class Ad extends ModelBase implements IAnalysisModel
	{
		/**
		 * @public
		 */
		public static const VAST_TYPE_LINEAR:String = "linear";
		
		/**
		 * @public
		 */
		public static const VAST_TYPE_NONLINEAR:String = "non-linear";
		
		/**
		 * @public
		 */
		[Bindable]
		public var name:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var url:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var longAd:Boolean;
		
		/**
		 * @public
		 */
		[Bindable]
		public var vastType:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var numClips:Number;
		
		/**
		 * @public
		 */
		[Bindable]
		public var tags:ArrayCollection = new ArrayCollection();
		
		/**
		 * Constructor
		 */
		public function Ad(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function createClone():ModelBase{
			var ad:Ad = new Ad();
			ad.name = name;
			ad.url = url;
			ad.longAd = longAd;
			ad.vastType = vastType;
			ad.numClips = numClips;
			
			for each(var tag:Tag in tags){
				ad.tags.addItem(tag);
			}
			
			return ad;
		}
		
		public function get resourceType():String
		{
			return "ad";
		}
		
		public function get resourceId():String
		{
			return id;
		}
		
		public function get graphColor():Number{
			return 0xff0b5b;
		}
	}
}
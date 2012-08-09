package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class Playlist extends ModelBase implements IAnalysisModel
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
		public var creationDate:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var numClips:Number;
		
		/**
		 * @public
		 */
		[Bindable]
		public var previewUrl:String = "";
		
		/**
		 * @public
		 */
		[Bindable]
		public var clips:ArrayCollection = new ArrayCollection();
			
		/**
		 * Constructor
		 */
		public function Playlist(target:IEventDispatcher=null)
		{
			super(target);
		}
	
		/**
		 * @public
		 */
		override public function createClone():ModelBase{
			var playlist:Playlist = new Playlist();
			playlist.id = id;
			playlist.name = name;
			playlist.creationDate = creationDate;
			playlist.numClips = numClips;
			
			playlist.clips = new ArrayCollection();
			for each(var clip:Clip in clips){
				playlist.clips.addItem(clip);
			}
			
			return playlist;
		}
	
		/**
		 * @public
		 */
		override public function cloneFrom(target:ModelBase):void{
			var playlist:Playlist = target as Playlist;
			id = playlist.id;
			name = playlist.name;
			creationDate = playlist.creationDate;
			numClips = playlist.numClips;
			
			clips.removeAll();
			clips.addAll(playlist.clips);
		}
		
		public function get resourceType():String
		{
			return "playlist";
		}
		
		public function get resourceId():String
		{
			return id;
		}

		public function get graphColor():Number{
			return 0x0099ff;
		}

	}
}
package frameworks.cavalier.app.models.sync
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.models.Ad;
	import frameworks.cavalier.app.models.Annotation;
	import frameworks.cavalier.app.models.CDN;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.Comment;
	import frameworks.cavalier.app.models.IAnalysisModel;
	import frameworks.cavalier.app.models.ModelBase;
	import frameworks.cavalier.app.models.Playlist;
	import frameworks.cavalier.app.models.Tag;
	import frameworks.cavalier.app.models.stat.DateStatistic;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * The one! The only! The central!
	 * The resource hub of the Cavalier!
	 */
	public class Aggregator extends EventDispatcher
	{
		/**
		 * @public
		 * 
		 * All tags
		 */
		[Bindable]
		public var tags:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 */
		[Bindable]
		public var pendingTags:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * All CDNs
		 */
		[Bindable]
		public var cdns:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * All brands
		 */
		[Bindable]
		public var brands:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * All video clips
		 */
		[Bindable]
		public var clips:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * Clips that newly created, but yet written into databases
		 */
		[Bindable]
		public var pendingClips:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * All playlists
		 */
		[Bindable]
		public var playlists:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * Playlists that newly created, but yet written into databases
		 */
		[Bindable]
		public var pendingPlaylists:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * All ads
		 */
		[Bindable]
		public var ads:ArrayCollection = new ArrayCollection();

		/**
		 * @public
		 */
		[Bindable]
		public var pendingAds:ArrayCollection = new ArrayCollection();

		/**
		 * @public
		 * 
		 * All-time playlist stat
		 */
		[Bindable]
		public var allTimeStatistic:DateStatistic = new DateStatistic();
		
		/**
		 * @public
		 * 
		 * All-time clip stat
		 */
		[Bindable]
		public var allTimeClipStatistic:DateStatistic = new DateStatistic();
		
		/**
		 * @public
		 * 
		 * The yearStatList is a translated ArrayCollection generated from allTimeStatistic, 
		 * which is an dictionary. Because it's easier to render an ArrayCollection than a dictionary,
		 * each time we update allTimeStatistic we also update yearStatList, strictly syncing the two 
		 * data sets.
		 * 
		 * The first entry of yearStatList is called "all", which sums up all the values in the list
		 */
		[Bindable]
		public var allTimeStatisticList:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 */
		[Bindable]
		public var allTimeClipStatisticList:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 */
		[Bindable]
		public var tagStatisticList:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * The last "selected" item, either is a playlist or a clip
		 */
		[Bindable]
		public var lastSelectedResource:ModelBase;
		
		/**
		 * @public
		 */
		[Bindable]
		public var lastSelectedAnalysisResource:IAnalysisModel;
		
		/**
		 * @public
		 */
		private var _selectedPlaylist:Playlist;

		/**
		 * @public
		 */
		[Bindable]
		public function get selectedPlaylist():Playlist
		{
			return _selectedPlaylist;
		}

		/**
		 * @private
		 */
		public function set selectedPlaylist(value:Playlist):void
		{
			_selectedPlaylist = value;
			lastSelectedResource = _selectedPlaylist;
			lastSelectedAnalysisResource = _selectedPlaylist;
		}

		/**
		 * @public
		 */
		private var _selectedClip:Clip;

		/**
		 * @public
		 */
		[Bindable]
		public function get selectedClip():Clip
		{
			return _selectedClip;
		}

		/**
		 * @private
		 */
		public function set selectedClip(value:Clip):void
		{
			_selectedClip = value;
			lastSelectedResource = _selectedClip;
			lastSelectedAnalysisResource = _selectedClip;
		}

		/**
		 * @private
		 */
		private var _selectedAd:Ad;

		/**
		 * @public
		 */
		[Bindable]
		public function get selectedAd():Ad
		{
			return _selectedAd;
		}

		/**
		 * @private
		 */
		public function set selectedAd(value:Ad):void
		{
			_selectedAd = value;
			lastSelectedAnalysisResource = _selectedAd;
		}

		
		/**
		 * @private
		 */
		private static var _aggregator:Aggregator;
		
		/**
		 * @private
		 */
		public static function get aggregator():Aggregator
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():Aggregator
		{
			if (_aggregator == null){
				_aggregator = new Aggregator();
			}
			return _aggregator;
		}
		
		/**
		 * Constructor
		 */
		public function Aggregator(target:IEventDispatcher = null)
		{
			super(target);
			if( _aggregator != null ) throw new Error("Error:Aggregator already initialised.");
			if( _aggregator == null ) _aggregator = this;
		}
		
		/**
		 * @public
		 */
		public function getPlaylistById(id:String):Playlist{
			for each(var playlist:Playlist in playlists){
				if(playlist.id == id)
					return playlist;
			}
			
			return null;
		}
		
		/**
		 * @public
		 */
		public function getClipById(id:String):Clip{
			for each(var clip:Clip in clips){
				if(clip.id == id)
					return clip;
			}
			
			return null;
		}
		
		/**
		 * @public
		 */
		public function getCDNById(id:String):CDN{
			for each(var cdn:CDN in cdns){
				if(cdn.id == id)
					return cdn;
			}
			
			return null;
		}
		
		/**
		 * @public
		 */
		public function getTagById(id:String):Tag{
			for each(var tag:Tag in tags){
				if(tag.id == id)
					return tag;
			}
			
			return null;
		}
		
		/**
		 * @public
		 */
		public function getAdById(id:String):Ad{
			for each(var ad:Ad in ads){
				if(ad.id == id)
					return ad;
			}
			
			return null;
		}
		
		/**
		 * @public
		 */
		public function reset():void{
			selectedAd = null;
			selectedClip = null;
			selectedPlaylist = null;
			lastSelectedAnalysisResource = null;
			lastSelectedResource = null;
			
			clips.removeAll();
			ads.removeAll();
			playlists.removeAll();
			cdns.removeAll();
			brands.removeAll();
			tags.removeAll();
			
			pendingAds.removeAll();
			pendingPlaylists.removeAll();
			pendingClips.removeAll();
			pendingTags.removeAll();
			
			allTimeStatistic = new DateStatistic();
			allTimeStatisticList.removeAll();
			allTimeClipStatistic = new DateStatistic();
			allTimeClipStatisticList.removeAll();
			tagStatisticList.removeAll();
		}
	}
}
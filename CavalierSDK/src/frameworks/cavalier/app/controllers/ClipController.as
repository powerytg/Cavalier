package frameworks.cavalier.app.controllers
{
	import flash.events.EventDispatcher;
	
	import frameworks.cavalier.app.env.Environment;
	import frameworks.cavalier.app.events.SearchEvent;
	import frameworks.cavalier.app.models.AdCuePointEntry;
	import frameworks.cavalier.app.models.Brand;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.Playlist;
	import frameworks.cavalier.app.models.SearchEventPayload;
	import frameworks.cavalier.app.models.Tag;
	import frameworks.cavalier.app.models.sync.Aggregator;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ClipController extends EventDispatcher
	{
		/**
		 * @private
		 */
		private static var _clipController:ClipController;
		
		/**
		 * @public
		 */
		public static function get clipController():ClipController
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():ClipController
		{
			if (_clipController == null){
				_clipController = new ClipController();
			}
			return _clipController;
		}
		
		/**
		 * Constructor
		 */
		public function ClipController()
		{
			super();
			if( _clipController != null ) throw new Error("Error:ClipController already initialised.");
			if( _clipController == null ) _clipController = this;
		}
		
		/**
		 * @public
		 */
		public function parseClipXml(clipXml:XML):Clip{
			var clipId:String = String(clipXml.id);
			var clip:Clip = Aggregator.aggregator.getClipById(clipId);
			
			if(!clip){
				clip = new Clip();
				clip.id = clipId;
				Aggregator.aggregator.clips.addItem(clip);
			}
			
			if(clip.status == ModelStatus.NORMAL){
				clip.name = String(clipXml.name);
				clip.duration = Number(clipXml.duration);
				clip.company = String(clipXml.company);
				clip.releaseDate = String(clipXml.release_date);
				clip.description = String(clipXml.description);
				clip.url = String(clipXml.url);
				clip.previewUrl = String(clipXml.preview_url);
				clip.allowComment = String(clipXml.allow_comment) == "true" ? true: false;
				clip.live = String(clipXml.live) == "true" ? true: false;
				clip.dvr = String(clipXml.dvr) == "true" ? true: false;
				
				// Get brand info (optional)
				var brands:XMLList = XMLList(clipXml.child("brand"));
				if(brands.children().length() != 0){
					var brand:Brand = new Brand();
					brand.id = String(brands.id);
					brand.name = String(brands[0].name[0]);
					clip.brand = brand;
				}
				
				// Get CDN info (required)
				clip.cdn = CDNController.cdnController.parseCDNXml(clipXml.cdn);
				
				// Get tags info (optional)
				clip.tags.removeAll();
				clip.tags.addAll(TagController.tagController.parseTagXml(clipXml.tags));
				
				// Hash tags (optional)
				clip.hashtags.removeAll();
				var hashtagString:String = String(clipXml.hashtags);
				if(hashtagString != ""){
					var htags:Array = hashtagString.split("+");
					for each(var hashtag:String in htags){
						if(hashtag.charAt(0) != "#")
							hashtag = "#" + hashtag;
						
						clip.hashtags.addItem(hashtag);
					}					
				}
				
				// Get ads info (optional)
				clip.ads = AdController.adController.parseAdXml(clipXml.ads);
				
				// Get comment & annotation info (optional)
				CommentController.commentController.parseComments(clipXml.comments, clip);	
			}
			
			return clip;
		}
		
		/**
		 * @public
		 */
		public function parseClipXmlList(rawClipXml:XMLList):Array{
			var clips:Array = [];
			
			for each(var clipXml:XML in rawClipXml.children()){
				var clip:Clip = parseClipXml(clipXml);				
				clips.push(clip);				
			}
			
			return clips;
		}
		
		/**
		 * @public
		 */
		public function searchClip(page:Number = 1, itemsPerPage:Number = 9, keywords:String = "all", tag:Tag = null, year:Number = NaN, month:Number = NaN):EventDispatcher{
			var params:Object = new Object();
			params.page = page == 0 ? 1 : page;
			params.per_page = itemsPerPage;
			params.keywords = keywords;
			
			if(!isNaN(year))
				params.year = year;
			
			if(!isNaN(month))
				params.month = month;
			
			if(tag)
				params.tag = tag.id;
			
			var dispatcher:EventDispatcher = new EventDispatcher();
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/playlist/power_search";
			service.resultFormat = "e4x";
			service.send(params);
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onSearchClipResult(evt.result, dispatcher);			
			});
			
			return dispatcher;
		}
		
		/**
		 * @private
		 */
		protected function onSearchClipResult(resultObject:Object, dispatcher:EventDispatcher):void{
			var result:XML = resultObject as XML;
			var keywords:String = String(result.query_term);
			var numPages:Number = Number(result.total_pages);
			var page:Number = Number(result.page);
			var itemsPerPage:Number = Number(result.per_page);
			var totalItems:Number = Number(result.total_items);
			var resultCollection:ArrayCollection = new ArrayCollection();
			
			// Parse playlists
			for each(var clipXml:XML in result.clips.children()){
				// Fetch the entry from allPlaylists, or create a new one to fit in
				var id:String = String(clipXml.id);
				var clip:Clip = Aggregator.aggregator.getClipById(id);
				if(!clip){
					clip = new Clip();
					clip.id = id;
					Aggregator.aggregator.clips.addItem(clip);
				}
				
				// Only update the info on "clean" resources, ignoring "dirty" and "deleted" resources
				if(clip.status == ModelStatus.NORMAL){
					clip.name = String(clipXml.name);
					clip.previewUrl = String(clipXml.preview_url);
					clip.duration = Number(clipXml.duration);
				}
				
				if(clip.status == ModelStatus.NORMAL || clip.status == ModelStatus.DIRTY)
					resultCollection.addItem(clip);
			}
			
			// Fire up an event to update UI components
			var payload:SearchEventPayload = new SearchEventPayload();
			payload.result = resultCollection;
			payload.numPages = numPages;
			payload.totalItems = totalItems;
			
			var event:SearchEvent = new SearchEvent(SearchEvent.CLIP_SEARCH_RESULT);
			event.payload = payload;
			dispatcher.dispatchEvent(event);
		}
		
		/**
		 * @public
		 */
		public function getClip(clip:Clip):void{
			var params:Object = new Object();
			params.id = clip.id;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/get_clip";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, onGetClipResult);
			service.send(params);
		}
		
		/**
		 * @private
		 */
		protected function onGetClipResult(evt:ResultEvent):void{
			var result:XML = evt.result as XML;
			parseClipXml(result);
		}
		
		/**
		 * @public
		 */
		public function createOrUpdateClip(clip:Clip, successHandler:Function = null, faultHandler:Function = null):void{
			var params:Object = new Object();
			if(clip.id && clip.id != "")
				params.id = clip.id;
			
			// Push tags
			if(clip.tags.length != 0){
				var tagIds:Array = [];
				for each(var tag:Tag in clip.tags){
					tagIds.push(tag.id);
				}
				
				params.tags = tagIds.join(";");
			}
			
			// Push hashtags
			for each(var hashtag:String in clip.hashtags){
				if(hashtag.charAt(0) != "#")
					hashtag = "#" + hashtag;
			}
			
			params.hashtags = clip.hashtags.toArray().join("+");

			// Push ads
			var adArray:Array = [];
			for each(var adEntry:AdCuePointEntry in clip.ads){
				var adString:String = adEntry.ad.id + "@" + adEntry.time.toString();
				adArray.push(adString);
			}
			
			if(adArray.length != 0)
				params.ads = adArray.join(";");
			
			// Other fields
			params.name = clip.name;
			params.url = clip.url;
			params.duration = clip.duration;
			params.preview_url = clip.previewUrl;
			params.preview_enabled = true;
			params.streaming = true;
			params.live = clip.live;
			params.dvr = clip.dvr;
			params.description = clip.description;
			params.release_date = clip.releaseDate;
			
			if(clip.cdn)
				params.cdn_id = clip.cdn.id;
			
			params.allow_comment = clip.allowComment;

			// Make API call
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/create_or_update_clip";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onCreateOrUpdateClip(clip, evt.result);
				if(successHandler != null)
					successHandler();
			}, false, 0, true);
			
			// These are one-time only handlers. 
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler();
			}, false, 0, true);
			
			service.send(params);
		}
		
		/**
		 * @private
		 */
		protected function onCreateOrUpdateClip(clip:Clip, resultObject:Object):void{
			var result:XML = XML(resultObject);
			
			var clipId:String = String(result.id);
			if(clip.id != clipId)
				clip.id = clipId;
			
			// Refresh playlist statistic
			StatisticController.statisticController.getClipStatByAllTime();
		}

		/**
		 * @public
		 */
		public function deleteClip(clip:Clip, successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/delete_clip?id=" + clip.id;
			service.resultFormat = "e4x";
			
			// These are one-time only handlers. 
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onDeleteClip(evt.result);
				if(successHandler != null)
					successHandler();
			}, false, 0, true);
			
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler();
			}, false, 0, true);
			
			service.send();
		}
		
		/**
		 * @private
		 */
		protected function onDeleteClip(resultObject:Object):void{
			var result:XML = XML(resultObject);
			var clip:Clip = Aggregator.aggregator.getClipById(String(result.id));
			if(clip){
				// Remove all the references from playlists
				for each(var playlist:Playlist in Aggregator.aggregator.playlists){
					if(playlist.clips.contains(clip))
						playlist.clips.removeItemAt(playlist.clips.getItemIndex(clip));
				}

				for each(playlist in Aggregator.aggregator.pendingPlaylists){
					if(playlist.clips.contains(clip))
						playlist.clips.removeItemAt(playlist.clips.getItemIndex(clip));
				}

				Aggregator.aggregator.clips.removeItemAt(Aggregator.aggregator.clips.getItemIndex(clip));
			}
			
		}
		
	}
}
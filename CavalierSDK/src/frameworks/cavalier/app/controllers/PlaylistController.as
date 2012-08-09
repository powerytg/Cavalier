package frameworks.cavalier.app.controllers
{
	import flash.events.EventDispatcher;
	
	import frameworks.cavalier.app.env.Environment;
	import frameworks.cavalier.app.events.PlaylistEvent;
	import frameworks.cavalier.app.events.SearchEvent;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.Playlist;
	import frameworks.cavalier.app.models.SearchEventPayload;
	import frameworks.cavalier.app.models.sync.Aggregator;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	
	public class PlaylistController extends EventDispatcher
	{
		/**
		 * @private
		 */
		private static var _playlistController:PlaylistController;
		
		/**
		 * @private
		 */
		public static function get playlistController():PlaylistController
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():PlaylistController
		{
			if (_playlistController == null){
				_playlistController = new PlaylistController();
			}
			return _playlistController;
		}
		
		/**
		 * Constructor
		 */
		public function PlaylistController()
		{
			super();
			if( _playlistController != null ) throw new Error("Error:PlaylistController already initialised.");
			if( _playlistController == null ) _playlistController = this;
		}
		
		/**
		 * @public
		 */
		public function searchPlaylist(page:Number = 1, itemsPerPage:Number = 9, keywords:String = "all", year:Number = NaN, month:Number = NaN):EventDispatcher{
			var params:Object = new Object();
			params.page = page == 0 ? 1 : page;
			params.per_page = itemsPerPage;
			params.keywords = keywords;
			
			if(!isNaN(year))
				params.year = year;
			
			if(!isNaN(month))
				params.month = month;
			
			var dispatcher:EventDispatcher = new EventDispatcher();
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/playlist/search_playlist";
			service.resultFormat = "e4x";
			service.send(params);
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onSearchPlaylistResult(evt.result, dispatcher);			
			});
			
			return dispatcher;
		}
		
		/**
		 * @private
		 */
		protected function onSearchPlaylistResult(resultObject:Object, dispatcher:EventDispatcher):void{
			var result:XML = resultObject as XML;
			var keywords:String = String(result.query_term);
			var numPages:Number = Number(result.total_pages);
			var page:Number = Number(result.page);
			var itemsPerPage:Number = Number(result.per_page);
			var totalItems:Number = Number(result.total_items);
			var resultCollection:ArrayCollection = new ArrayCollection();
			
			// Parse playlists
			for each(var playlistXml:XML in result.playlists.children()){
				// Fetch the entry from allPlaylists, or create a new one to fit in
				var id:String = String(playlistXml.id);
				var playlist:Playlist = Aggregator.aggregator.getPlaylistById(id);
				if(!playlist){
					playlist = new Playlist();
					playlist.id = id;
					Aggregator.aggregator.playlists.addItem(playlist);
				}
				
				// Only update the info on "clean" resources, ignoring "dirty" and "deleted" resources
				if(playlist.status == ModelStatus.NORMAL){
					playlist.name = String(playlistXml.name);
					playlist.numClips = Number(playlistXml.num_clips);
					playlist.previewUrl = String(playlistXml.preview_url);					
				}
				
				if(playlist.status == ModelStatus.NORMAL || playlist.status == ModelStatus.DIRTY)
					resultCollection.addItem(playlist);
			}
			
			// Fire up an event to update UI components
			var payload:SearchEventPayload = new SearchEventPayload();
			payload.result = resultCollection;
			payload.numPages = numPages;
			payload.totalItems = totalItems;
			
			var event:SearchEvent = new SearchEvent(SearchEvent.PLAYLIST_SEARCH_RESULT);
			event.payload = payload;
			dispatcher.dispatchEvent(event);
		}
		
		/**
		 * @public
		 */
		public function getPlaylist(playlist:Playlist):void{
			var params:Object = new Object();
			params.id = playlist.id;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/get_playlist";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, onGetPlaylistResult);
			service.send(params);
		}
		
		/**
		 * @private
		 */
		protected function onGetPlaylistResult(evt:ResultEvent):void{
			var result:XML = XML(evt.result);
			
			var playlistId:String = String(result.id);
			var playlist:Playlist = Aggregator.aggregator.getPlaylistById(playlistId);
			
			// Since the name and id of the playlist is already there (see getAllPlaylist()), 
			// all we need to do is to fill the rest of the information
			playlist.clips.removeAll();			
			playlist.numClips = result.clips.children().length();
			playlist.creationDate = String(result.creation_date);
			
			// Parse clips
			var clips:Array = ClipController.clipController.parseClipXmlList(result.clips);
			for each(var clip:Clip in clips){
				playlist.clips.addItem(clip);
			}
			
			// Send an event
			playlist.dispatchEvent(new PlaylistEvent(PlaylistEvent.PLAYLIST_LOADED));
		}
		
		/**
		 * @public
		 */
		public function createOrUpdatePlaylist(playlist:Playlist, successHandler:Function = null, faultHandler:Function = null):void{
			var params:Object = new Object();
			if(playlist.id && playlist.id != "")
				params.id = playlist.id;
			
			if(playlist.clips.length != 0){
				var ids:Array = [];
				for each(var clip:Clip in playlist.clips){
					ids.push(clip.id);
				}
				
				params.clip_ids = ids.join(";");
			}
			
			params.name = playlist.name;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/create_or_update_playlist";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onCreateOrUpdatePlaylist(playlist, evt.result);
				if(successHandler != null)
					successHandler();
			});

			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler();
			});

			service.send(params);
		}
		
		/**
		 * @private
		 */
		protected function onCreateOrUpdatePlaylist(playlist:Playlist, resultObject:Object):void{
			var result:XML = XML(resultObject);
			
			playlist.id = String(result.id);
			playlist.name = String(result.name);
			playlist.creationDate = String(result.creation_date);
			playlist.numClips = Number(result.num_clips);
			
			// Refresh playlist statistic
			StatisticController.statisticController.getStatByAllTime();
		}
		
		/**
		 * @public
		 */
		public function deletePlaylist(playlist:Playlist, successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/delete_playlist?id=" + playlist.id;
			service.resultFormat = "e4x";
			
			// These are one-time only handlers. 
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onDeletePlaylist(evt.result);
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
		protected function onDeletePlaylist(resultObject:Object):void{
			var result:XML = XML(resultObject);
			var id:String = String(result.id);
			
			var playlist:Playlist = Aggregator.aggregator.getPlaylistById(id);
			if(playlist)
				Aggregator.aggregator.playlists.removeItemAt(Aggregator.aggregator.playlists.getItemIndex(playlist));
			
		}
		
	}
}
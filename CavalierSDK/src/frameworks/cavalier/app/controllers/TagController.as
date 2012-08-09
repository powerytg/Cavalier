package frameworks.cavalier.app.controllers
{
	import flash.events.EventDispatcher;
	
	import frameworks.cavalier.app.env.Environment;
	import frameworks.cavalier.app.models.Ad;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.Tag;
	import frameworks.cavalier.app.models.stat.SpecialStatisticEntries;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.Log;
	import frameworks.cavalier.messaging.models.MessageLevel;
	import frameworks.cavalier.messaging.models.MessageStatus;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class TagController extends EventDispatcher
	{
		
		/**
		 * @private
		 */
		private static var _tagController:TagController;
		
		/**
		 * @private
		 */
		public static function get tagController():TagController
		{
			return initialize();
		}
		
		/**
		 * @private
		 */
		public static function initialize():TagController
		{
			if (_tagController == null){
				_tagController = new TagController();
			}
			return _tagController;
		}
		
		/**
		 * Constructor
		 */
		public function TagController()
		{
			super();
			if( _tagController != null ) throw new Error("Error:TagController already initialised.");
			if( _tagController == null ) _tagController = this;
		}
		
		/**
		 * @public
		 */
		public function getAllTags():void{
			var service:HTTPService = new HTTPService();
			service.resultFormat = "e4x";
			service.url = Environment.serverUrl + "/admin/get_all_tag";			
			service.send();			
			
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				log.content = "Tag list retrieved";
				onGetAllTags(evt.result as XML);
			});
			
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				log.level = MessageLevel.ALERT;
				log.status = MessageStatus.ACTIVE;
				log.content = "Error while retrieving tags";
			});
			
			var log:Log = SystemBus.systemBus.newLog("Retrieving tag list...");
		}
		
		/**
		 * @private
		 */
		protected function onGetAllTags(result:XML):void{
			// Rebuild the tag statistic list
			Aggregator.aggregator.tagStatisticList.removeAll();
			
			// Add a special "all" entry
			var allEntry:Tag = new Tag();
			allEntry.id = SpecialStatisticEntries.ALL.toString();
			allEntry.name = "all";
			allEntry.numClips = Number(result.all.num_all_clips);
			allEntry.numAds = Number(result.all.num_all_ads);
			Aggregator.aggregator.tagStatisticList.addItem(allEntry);
			
			// Add a special "pending" entry
			var pendingEntry:Tag = new Tag();
			pendingEntry.id = SpecialStatisticEntries.PENDING.toString();
			pendingEntry.name = "pending";
			Aggregator.aggregator.tagStatisticList.addItem(pendingEntry);
			
			// Add the rest of the entries from XML
			for each(var tagXml:XML in result.tags.children()){
				var tagId:String = String(tagXml.id);
				var tag:Tag = Aggregator.aggregator.getTagById(tagId);
				if(!tag){
					tag = new Tag();
					tag.id = tagId;
					Aggregator.aggregator.tags.addItem(tag);
				}
				
				if(tag.status == ModelStatus.NORMAL){
					tag.name = String(tagXml.name);
					tag.numClips = Number(tagXml.num_clips);
					tag.numAds = Number(tagXml.num_ads);
				}
			}
			
			Aggregator.aggregator.tagStatisticList.addAll(Aggregator.aggregator.tags);
		}
	
		/**
		 * @public
		 */
		public function parseTagXml(tagXmlList:XMLList):ArrayCollection{
			var tags:ArrayCollection = new ArrayCollection();
			
			for each(var tagXml:XML in tagXmlList.children()){
				var tagId:String = String(tagXml.id);
				var tag:Tag = Aggregator.aggregator.getTagById(tagId);
				if(!tag){
					tag = new Tag();
					tag.id = tagId;
					Aggregator.aggregator.tags.addItem(tag);
				}
				
				if(tag.status == ModelStatus.NORMAL){
					tag.name = String(tagXml.name);
				}
				
				tags.addItem(tag);
			}

			return tags;
		}
	
		/**
		 * @public
		 */
		public function createOrUpdateTag(tag:Tag, successHandler:Function = null, faultHandler:Function = null):void{
			var params:Object = new Object();
			if(tag.id && tag.id != "")
				params.id = tag.id;
			
			params.name = tag.name;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/create_or_update_tag";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onCreateOrUpdateTag(tag, evt.result);
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
		protected function onCreateOrUpdateTag(tag:Tag, resultObject:Object):void{
			var result:XML = XML(resultObject);
			
			var tagId:String = String(result.id);
			if(tag.id != tagId)
				tag.id = tagId;
			
		}
		
		/**
		 * @public
		 */
		public function deleteTag(tag:Tag, successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/delete_tag?id=" + tag.id;
			service.resultFormat = "e4x";
			
			// These are one-time only handlers. 
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onDeleteTag(evt.result);
				if(successHandler != null)
					successHandler();
			}, false, 0, true);
			
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler(evt.fault.faultString);
			}, false, 0, true);
			
			service.send();
		}
		
		/**
		 * @private
		 */
		protected function onDeleteTag(resultObject:Object):void{
			var result:XML = XML(resultObject);
			var tag:Tag = Aggregator.aggregator.getTagById(String(result.id));
			if(tag){
				// Remove all the references from clips
				for each(var clip:Clip in Aggregator.aggregator.clips){
					if(clip.tags.contains(tag))
						clip.tags.removeItemAt(clip.tags.getItemIndex(tag));
				}

				// Remove all the references from ads
				for each(var ad:Ad in Aggregator.aggregator.ads){
					if(ad.tags.contains(tag))
						ad.tags.removeItemAt(ad.tags.getItemIndex(tag));
				}

				for each(clip in Aggregator.aggregator.pendingClips){
					if(clip.tags.contains(tag))
						clip.tags.removeItemAt(clip.tags.getItemIndex(tag));
				}
				
				// Remove all the references from ads
				for each(ad in Aggregator.aggregator.pendingAds){
					if(ad.tags.contains(tag))
						ad.tags.removeItemAt(ad.tags.getItemIndex(tag));
				}

				Aggregator.aggregator.tags.removeItemAt(Aggregator.aggregator.tags.getItemIndex(tag));
			}
			
		}

	}
}
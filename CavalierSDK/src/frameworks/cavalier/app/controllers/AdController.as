package frameworks.cavalier.app.controllers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import frameworks.cavalier.app.env.Environment;
	import frameworks.cavalier.app.events.SearchEvent;
	import frameworks.cavalier.app.models.Ad;
	import frameworks.cavalier.app.models.AdCuePointEntry;
	import frameworks.cavalier.app.models.AdDistributionRule;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.SearchEventPayload;
	import frameworks.cavalier.app.models.Tag;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.app.utils.ColorUtils;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.Log;
	import frameworks.cavalier.messaging.models.MessageLevel;
	import frameworks.cavalier.messaging.models.MessageStatus;
	import frameworks.cavalier.polkit.Policy;
	import frameworks.cavalier.polkit.PolicyKind;
	import frameworks.cavalier.polkit.PolicyKit;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class AdController extends EventDispatcher
	{
		/**
		 * @public
		 */
		public static const POLICY_CATAGORY:String = "plugins.advertising";

		/**
		 * @public
		 */
		[Bindable]
		public var distributionMatrix:ArrayCollection;
		
		/**
		 * @public
		 */
		[Bindable]
		public var pendingDistributionMatrix:ArrayCollection = new ArrayCollection();
		
		/**
		 * @private
		 */
		private static var _adController:AdController;
		
		/**
		 * @private
		 */
		public static function get adController():AdController
		{
			return initialize();
		}
		
		/**
		 * @private
		 */
		public static function initialize():AdController
		{
			if (_adController == null){
				_adController = new AdController();
			}
			return _adController;
		}
		
		/**
		 * @constructor
		 */
		public function AdController()
		{
			super();
			if( _adController != null ) throw new Error("Error:AdController already initialised.");
			if( _adController == null ) _adController = this;
			
			// Initialize pre-defined ad policies
			installAdPolicies();
		}
		
		/**
		 * @private
		 */
		protected function installAdPolicies():void{
			var adPolicyCatagory:Dictionary = new Dictionary();
			PolicyKit.policyKit.installCatagory(adPolicyCatagory, POLICY_CATAGORY);
			
			var policy:Policy = new Policy();
			policy.key = "ad_enabled";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Enable Ad Plugin?";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "banner_enabled";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Enable Banner Plugin?";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);

			policy = new Policy();
			policy.key = "num_max_ads";
			policy.kind = PolicyKind.NUMERIC_OR_STRING;
			policy.name = "Maximum Number of Ads Allowed per Clip";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);

			policy = new Policy();
			policy.key = "num_max_banners";
			policy.kind = PolicyKind.NUMERIC_OR_STRING;
			policy.name = "Maximum Number of Banners Allowed per Clip";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);

			policy = new Policy();
			policy.key = "min_clip_length_qualified_for_long_ad";
			policy.kind = PolicyKind.NUMERIC_OR_STRING;
			policy.name = "Use 'Long Ad' if Clip Length Exceeds";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "orchestrate_by_tag";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Try to Match Ads using Tags";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "live_ad_interval";
			policy.kind = PolicyKind.NUMERIC_OR_STRING;
			policy.name = "Ad Interval for Live Streams";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);

			policy = new Policy();
			policy.key = "allow_orchestrating_long_ads";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Allow Orchestrating Long Ads";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
		}
		
		/**
		 * @public
		 */
		public function parseAdXml(adXmlList:XMLList):ArrayCollection{
			var ads:ArrayCollection = new ArrayCollection();
			for each(var adXml:XML in adXmlList.children()){
				var adId:String = String(adXml.id);
				var ad:Ad = Aggregator.aggregator.getAdById(adId);
				if(!ad){
					ad = new Ad();
					ad.id = adId;
					Aggregator.aggregator.ads.addItem(ad);
				}
				
				var adEntry:AdCuePointEntry = new AdCuePointEntry();
				if(ad.status == ModelStatus.NORMAL){
					ad.name = String(adXml.name);
					ad.url = String(adXml.url);
					ad.longAd = String(adXml.long_ad) == "true" ? true : false;
					ad.vastType = String(adXml.vast_type);
					ad.numClips = Number(adXml.num_clips);
				}
				
				// Create wrappers for the ad with additional cuePoint property
				adEntry.ad = ad;
				adEntry.cuePoint = Number(adXml.cue_point);
				adEntry.color = ColorUtils.getRandomColor();
				ads.addItem(adEntry);
			}
		
			return ads;
		}
		
		/**
		 * @public
		 * 
		 * Get advertising policies from server
		 */
		public function getAdPolicies(successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/get_ad_policy";
			service.resultFormat = "e4x";
			service.send();			
			
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				log.content = "Advertising policies retrieved";
				onGetAdPolicies(evt.result as XML);
				
				if(successHandler != null)
					successHandler();

			}, false, 0, true);
			 
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				log.level = MessageLevel.ALERT;
				log.status = MessageStatus.ACTIVE;
				log.content = "Error while retrieving advertising policies";
				
				if(faultHandler != null)
					faultHandler();

			}, false, 0, true);
			
			var log:Log = SystemBus.systemBus.newLog("Retrieving advertising policies...");
		}
		
		/**
		 * @private
		 */
		protected function onGetAdPolicies(result:XML):void{
			// Parse ad policies
			for each(var policyXml:XML in result.policies.children()){
				var policy:Policy = PolicyKit.policyKit.getPolicy(String(policyXml.@key), POLICY_CATAGORY);
				policy.id = String(policyXml.@id);
				
				var value:String = String(policyXml.@value);
				if(value == "true")
					policy.value = true;
				else if(value == "false")
					policy.value = false;
				else
					policy.value = value;
			}
			
			// Parse distribution rules
			if(!distributionMatrix)
				distributionMatrix = new ArrayCollection();
			
			for each(var ruleXml:XML in result.rules.children()){
				var ruleId:String = String(ruleXml.id);
				var rule:AdDistributionRule = getDistributionRuleById(ruleId);
				
				if(!rule){
					rule = new AdDistributionRule();
					rule.id = ruleId;
					distributionMatrix.addItem(rule);
				}
				
				if(rule.status == ModelStatus.NORMAL){
					rule.startPoint = Number(ruleXml.start_point);
					rule.endPoint = Number(ruleXml.end_point);
					rule.numAds = Number(ruleXml.num_ads);
				}
			}
		}
		
		/**
		 * @public
		 */
		public function changePolicy(policy:Policy, successHandler:Function = null, faultHandler:Function = null):void{
			var params:Object = new Object();
			params.policy = policy.key;
			params.value = policy.value;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/change_ad_policy";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
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
		 * @public
		 */
		public function getDistributionRuleById(id:String):AdDistributionRule{
			for each(var rule:AdDistributionRule in distributionMatrix){
				if(rule.id == id)
					return rule;
			}
			
			return null;
		}

		/**
		 * @public
		 */
		public function createOrUpdateAdDistroRule(rule:AdDistributionRule, successHandler:Function = null, faultHandler:Function = null):void{
			var params:Object = new Object();
			if(rule.id && rule.id != "")
				params.id = rule.id;
			
			params.start_point = rule.startPoint;
			params.end_point = rule.endPoint;
			params.num_ads = rule.numAds;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/add_or_update_ad_distro_rule";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onCreateOrUpdateAdDistroRule(rule, evt.result);
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
		protected function onCreateOrUpdateAdDistroRule(rule:AdDistributionRule, resultObject:Object):void{
			var result:XML = XML(resultObject);
			
			var ruleId:String = String(result.id);
			if(rule.id != ruleId)
				rule.id = ruleId;
			
		}
		
		/**
		 * @public
		 */
		public function deleteAdDistroRule(rule:AdDistributionRule, successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/delete_single_ad_distro_rule?id=" + rule.id;
			service.resultFormat = "e4x";
			
			// These are one-time only handlers. 
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onDeleteAdDistroRule(evt.result);
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
		protected function onDeleteAdDistroRule(resultObject:Object):void{
			var result:XML = XML(resultObject);
			var rule:AdDistributionRule = getDistributionRuleById(String(result.id));
			if(rule)
				distributionMatrix.removeItemAt(distributionMatrix.getItemIndex(rule));
		}

		/**
		 * @public
		 */
		public function searchAd(page:Number = 1, itemsPerPage:Number = 9, keywords:String = "all", tag:Tag = null):EventDispatcher{
			var params:Object = new Object();
			params.page = page == 0 ? 1 : page;
			params.per_page = itemsPerPage;
			params.keywords = keywords;
			
			if(tag)
				params.tag = tag.id;
			
			var dispatcher:EventDispatcher = new EventDispatcher();
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/search_ad";
			service.resultFormat = "e4x";
			service.send(params);
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onSearchAdResult(evt.result, dispatcher);			
			});
			
			return dispatcher;
		}
		
		/**
		 * @private
		 */
		protected function onSearchAdResult(resultObject:Object, dispatcher:EventDispatcher):void{
			var result:XML = resultObject as XML;
			var keywords:String = String(result.query_term);
			var numPages:Number = Number(result.total_pages);
			var page:Number = Number(result.page);
			var itemsPerPage:Number = Number(result.per_page);
			var totalItems:Number = Number(result.total_items);
			var resultCollection:ArrayCollection = new ArrayCollection();
			
			// Parse playlists
			for each(var adXml:XML in result.ads.children()){
				// Fetch the entry from allPlaylists, or create a new one to fit in
				var id:String = String(adXml.id);
				var ad:Ad = Aggregator.aggregator.getAdById(id);
				if(!ad){
					ad = new Ad();
					ad.id = id;
					Aggregator.aggregator.ads.addItem(ad);
				}
				
				// Only update the info on "clean" resources, ignoring "dirty" and "deleted" resources
				if(ad.status == ModelStatus.NORMAL){
					ad.name = String(adXml.name);
					ad.url = String(adXml.url);
					ad.vastType = String(adXml.vast_type);
					ad.longAd = String(adXml.long_ad) == "true" ? true : false;
					ad.numClips = Number(adXml.num_clips);
					
					// Tags
					ad.tags.removeAll();
					ad.tags.addAll(TagController.tagController.parseTagXml(adXml.tags));
				}
				
				if(ad.status == ModelStatus.NORMAL || ad.status == ModelStatus.DIRTY)
					resultCollection.addItem(ad);
			}
			
			// Fire up an event to update UI components
			var payload:SearchEventPayload = new SearchEventPayload();
			payload.result = resultCollection;
			payload.numPages = numPages;
			payload.totalItems = totalItems;
			
			var event:SearchEvent = new SearchEvent(SearchEvent.AD_SEARCH_RESULT);
			event.payload = payload;
			dispatcher.dispatchEvent(event);
		}
		
		/**
		 * @public
		 */
		public function createOrUpdateAd(ad:Ad, successHandler:Function = null, faultHandler:Function = null):void{
			var params:Object = new Object();
			if(ad.id && ad.id != "")
				params.id = ad.id;
			
			// Push tags
			if(ad.tags.length != 0){
				var tagIds:Array = [];
				for each(var tag:Tag in ad.tags){
					tagIds.push(tag.id);
				}
				
				params.tags = tagIds.join(";");
			}
			
			// Other fields
			params.name = ad.name;
			params.url = ad.url;
			params.long_ad = ad.longAd;
			params.vast_type = ad.vastType;
			
			// Make API call
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/create_or_update_ad";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onCreateOrUpdateAd(ad, evt.result);
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
		protected function onCreateOrUpdateAd(ad:Ad, resultObject:Object):void{
			var result:XML = XML(resultObject);
			
			var adId:String = String(result.id);
			if(ad.id != adId)
				ad.id = adId;
		}
		
		/**
		 * @public
		 */
		public function deleteAd(ad:Ad, successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/delete_ad_new?id=" + ad.id;
			service.resultFormat = "e4x";
			
			// These are one-time only handlers. 
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onDeleteAd(evt.result);
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
		protected function onDeleteAd(resultObject:Object):void{
			var result:XML = XML(resultObject);
			var ad:Ad = Aggregator.aggregator.getAdById(String(result.id));
			if(ad){
				// Remove all the references from clips
				for each(var clip:Clip in Aggregator.aggregator.clips){
					if(clip.ads.contains(ad))
						clip.ads.removeItemAt(clip.ads.getItemIndex(ad));
				}
				
				for each(clip in Aggregator.aggregator.pendingClips){
					if(clip.ads.contains(ad))
						clip.ads.removeItemAt(clip.ads.getItemIndex(ad));
				}
				
				Aggregator.aggregator.ads.removeItemAt(Aggregator.aggregator.ads.getItemIndex(ad));
			}
			
		}
		
	}
}
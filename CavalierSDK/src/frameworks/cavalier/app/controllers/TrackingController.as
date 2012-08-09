package frameworks.cavalier.app.controllers 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import frameworks.cavalier.app.env.Environment;
	import frameworks.cavalier.app.models.BeaconDistributionRule;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.IAnalysisModel;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.stat.AbstractAnalysis;
	import frameworks.cavalier.app.models.stat.ClipAnalysisResult;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.Log;
	import frameworks.cavalier.messaging.models.MessageLevel;
	import frameworks.cavalier.messaging.models.MessageStatus;
	import frameworks.cavalier.polkit.Policy;
	import frameworks.cavalier.polkit.PolicyKind;
	import frameworks.cavalier.polkit.PolicyKit;
	import frameworks.cavalier.ui.messaging.InfoIndicator;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class TrackingController extends EventDispatcher
	{
		/**
		 * @public
		 */
		public static const POLICY_CATAGORY:String = "plugins.tracking";

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
		private static var _trackingController:TrackingController;
		
		/**
		 * @private
		 */
		public static function get trackingController():TrackingController
		{
			return initialize();
		}
		
		/**
		 * @private
		 */
		public static function initialize():TrackingController
		{
			if (_trackingController == null){
				_trackingController = new TrackingController();
			}
			return _trackingController;
		}
		
		/**
		 * Constructor
		 */
		public function TrackingController()
		{
			super();
			if( _trackingController != null ) throw new Error("Error:TrackingController already initialised.");
			if( _trackingController == null ) _trackingController = this;
			
			// Install the admin/tracking policies
			installPolicies();
		}
	
		/**
		 * @private
		 */
		protected function installPolicies():void{
			var trackingPolicyCatagory:Dictionary = new Dictionary();
			PolicyKit.policyKit.installCatagory(trackingPolicyCatagory, POLICY_CATAGORY);
			
			var policy:Policy = new Policy();
			policy.key = "enable_native_tracking";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Enable Sample Tracking Plugin in OSMF";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "enable_playlist_tracking";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Enable Playlist Tracking";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "enable_clip_tracking";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Enable Clip Tracking";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "enable_ad_tracking";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Enable Advertising Tracking";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "enable_cdn_tracking";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Enable CDN Tracking";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "enable_nielsen";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Use Nielsen Plugin in OSMF";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "enable_comscore";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Enable Comscore Plugin in OSMF";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
			
			policy = new Policy();
			policy.key = "enable_conviva";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Enable Conviva Plugin in OSMF";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);

			policy = new Policy();
			policy.key = "ripple_delete_tag";
			policy.kind = PolicyKind.BOOLEAN;
			policy.name = "Ripple Delete Dependent Records";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);

			policy = new Policy();
			policy.key = "server_url";
			policy.kind = PolicyKind.NUMERIC_OR_STRING;
			policy.name = "Root URL";
			PolicyKit.policyKit.installPolicy(policy, POLICY_CATAGORY);
		}
		
		/**
		 * Get the resource hits in all years
		 */
		public function analysisHitsByAllYears(resource:IAnalysisModel, successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();			
			service.url = Environment.serverUrl + "/tracking/analysis_hits_by_all_time?" + resource.resourceType + "_id=" + resource.resourceId;
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				if(successHandler != null)
					successHandler(parseHits(evt.result.activities));
			}, false, 0, true);
			
			// These are one-time only handlers. 
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler();
			}, false, 0, true);

			service.send();
		}
		
		/**
		 * Get the clip hits in a year
		 */
		public function analysisHitsByYear(resource:IAnalysisModel, year:Number, successHandler:Function = null, faultHandler:Function = null):void{
			var param:Object = new Object();
			var queryId:String = resource.resourceType + "_id";
			param[queryId] = resource.resourceId;
			param.year = year;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/tracking/analysis_hits_by_year";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				if(successHandler != null)
					successHandler(parseHits(evt.result.activities));
			}, false, 0, true);
			
			// These are one-time only handlers. 
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler();
			}, false, 0, true);

			service.send(param);
		}
		
		/**
		 * Get the clip hits in all years
		 */
		public function analysisHitsByMonth(resource:IAnalysisModel, year:Number, month:Number, successHandler:Function = null, faultHandler:Function = null):void{
			var param:Object = new Object();
			var queryId:String = resource.resourceType + "_id";
			param[queryId] = resource.resourceId;
			
			param.year = year;
			param.month = month;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/tracking/analysis_hits_by_month";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				if(successHandler != null)
					successHandler(parseHits(evt.result.activities));
			}, false, 0, true);
			
			// These are one-time only handlers. 
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler();
			}, false, 0, true);

			service.send(param);
		}
		
		/**
		 * @private
		 */
		private function parseHits(entries:XMLList):ArrayCollection{
			var dataCollection:ArrayCollection = new ArrayCollection();
			
			for(var i:uint = 0 ; i < entries.children().length(); i++){
				var valueObject:AbstractAnalysis = new AbstractAnalysis();
				valueObject.label = String(entries.activity[i].label);
				valueObject.value = Number(entries.activity[i].value);
				
				dataCollection.addItem(valueObject);
			}
			
			return dataCollection;
		}	

		/**
		 * @public
		 * 
		 * Get tracking/admin policies from server
		 */
		public function getTrackingPolicies(successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/get_admin_policy";
			service.resultFormat = "e4x";
			service.send();			
			
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				log.content = "Tracking policies retrieved";
				onGetTrackingPolicies(evt.result as XML);
				
				if(successHandler != null)
					successHandler();
				
			}, false, 0, true);
			
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				log.level = MessageLevel.ALERT;
				log.status = MessageStatus.ACTIVE;
				log.content = "Error while retrieving tracking policies";
				
				if(faultHandler != null)
					faultHandler();
				
			}, false, 0, true);
			
			var log:Log = SystemBus.systemBus.newLog("Retrieving tracking policies...");
		}
		
		/**
		 * @private
		 */
		protected function onGetTrackingPolicies(result:XML):void{
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
				var rule:BeaconDistributionRule = getDistributionRuleById(ruleId);
				
				if(!rule){
					rule = new BeaconDistributionRule();
					rule.id = ruleId;
					distributionMatrix.addItem(rule);
				}
				
				if(rule.status == ModelStatus.NORMAL){
					rule.startPoint = Number(ruleXml.start_point);
					rule.endPoint = Number(ruleXml.end_point);
					rule.numBeacons = Number(ruleXml.num_beacons);
				}
			}
		}
		
		/**
		 * @public
		 */
		public function getDistributionRuleById(id:String):BeaconDistributionRule{
			for each(var rule:BeaconDistributionRule in distributionMatrix){
				if(rule.id == id)
					return rule;
			}
			
			return null;
		}

		/**
		 * @public
		 */
		public function changePolicy(policy:Policy, successHandler:Function = null, faultHandler:Function = null):void{
			var params:Object = new Object();
			params.policy = policy.key;
			params.value = policy.value;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/change_admin_policy";
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
		public function createOrUpdateBeaconDistroRule(rule:BeaconDistributionRule, successHandler:Function = null, faultHandler:Function = null):void{
			var params:Object = new Object();
			if(rule.id && rule.id != "")
				params.id = rule.id;
			
			params.start_point = rule.startPoint;
			params.end_point = rule.endPoint;
			params.num_beacons = rule.numBeacons;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/add_or_update_beacon_distro_rule";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onCreateOrUpdateBeaconDistroRule(rule, evt.result);
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
		protected function onCreateOrUpdateBeaconDistroRule(rule:BeaconDistributionRule, resultObject:Object):void{
			var result:XML = XML(resultObject);
			
			var ruleId:String = String(result.id);
			if(rule.id != ruleId)
				rule.id = ruleId;
			
		}
		
		/**
		 * @public
		 */
		public function deleteBeaconDistroRule(rule:BeaconDistributionRule, successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/admin/delete_single_beacon_distro_rule?id=" + rule.id;
			service.resultFormat = "e4x";
			
			// These are one-time only handlers. 
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				onDeleteBeaconDistroRule(evt.result);
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
		protected function onDeleteBeaconDistroRule(resultObject:Object):void{
			var result:XML = XML(resultObject);
			var rule:BeaconDistributionRule = getDistributionRuleById(String(result.id));
			if(rule)
				distributionMatrix.removeItemAt(distributionMatrix.getItemIndex(rule));
		}

		/**
		 * @public
		 */
		public function getHeatmap(clip:Clip, successHandler:Function = null, faultHandler:Function = null):void{
			if(!clip.id || clip.status == ModelStatus.PENDING)
				return;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/tracking/get_heatmap?clip_id=" + clip.id;
			service.resultFormat = "e4x";
			
			// These are one-time only handlers. 
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				if(successHandler != null)
					successHandler(onGetHeatmap(evt.result.heatmap as XMLList));
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
		protected function onGetHeatmap(result:XMLList):ArrayCollection{
			var dataCollection:ArrayCollection = new ArrayCollection();
			
			for each(var entry:XML in result.children()){
				var valueObject:AbstractAnalysis = new AbstractAnalysis();
				valueObject.label = String(entry.time);
				valueObject.value = Number(entry.hits);
				
				dataCollection.addItem(valueObject);
			}
			
			return dataCollection;
		}
		
		/**
		 * @public
		 * 
		 * Get the tracking database usage for a single clip
		 */
		public function analysisDBUsageForClip(clip:Clip, successHandler:Function = null, faultHandler:Function = null):void{
			if(!clip.id || clip.status == ModelStatus.PENDING)
				return;
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/tracking/analysis_db_usage_for_clip?clip_id=" + clip.id;
			service.resultFormat = "e4x";
			service.send();
			
			// These are one-time only handlers. 
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				if(successHandler != null)
					successHandler(onAnalysisDBUsageForClip(XML(evt.result)));
			}, false, 0, true);
			
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler(evt.fault.faultString);
			}, false, 0, true);
		}
		
		/**
		 * @private
		 */
		protected function onAnalysisDBUsageForClip(result:XML):ClipAnalysisResult{
			var vo:ClipAnalysisResult = new ClipAnalysisResult();
			vo.heatmapPercentage = Number(result.heatmap_percentage);
			vo.trackingClipPercentage = Number(result.tracking_clip_percentage);
			
			return vo;
		}
		
		/**
		 * @public
		 * 
		 * Get the tracking database usage
		 */
		public function analysisDBUsage(successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/tracking/analysis_db";
			service.resultFormat = "e4x";
			
			// These are one-time only handlers. 
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				if(successHandler != null)
					successHandler(onAnalysisDBUsage(XML(evt.result)));
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
		protected function onAnalysisDBUsage(result:XML):ArrayCollection{
			var usage:ArrayCollection = new ArrayCollection();
			for each(var analysisXml:XML in result.children()){
				var item:AbstractAnalysis = new AbstractAnalysis();
				item.label = String(analysisXml.@label);
				item.value = Number(analysisXml.@value);
				usage.addItem(item);
			}
			
			return usage;
		}
		
		/**
		 * @public
		 * 
		 * Clear all tracking data
		 */
		public function clearAllTrackingData():void{
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/tracking/clear_all_tracking_data";
			service.resultFormat = "text";
			service.addEventListener(ResultEvent.RESULT, onTrackingDataCleared);
			service.send();
		}
		
		private function onTrackingDataCleared(evt:ResultEvent):void{
			var notification:InfoIndicator = new InfoIndicator();
			notification.text = "Tracking data has been cleared";
			notification.show();
		}
		
		/**
		 * @public
		 * 
		 * Clear all tracking data for a resource
		 */
		public function clearAllTrackingDataForClip(resource:IAnalysisModel):void{
			if(!resource.resourceId)
				return;

			var param:Object = new Object();
			var queryId:String = resource.resourceType + "_id";
			param[queryId] = resource.resourceId;

			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/tracking/clear_tracking_data_for_resource";
			service.resultFormat = "text";
			service.addEventListener(ResultEvent.RESULT, onTrackingDataCleared);
			service.send(param);
		}
		
	}
}

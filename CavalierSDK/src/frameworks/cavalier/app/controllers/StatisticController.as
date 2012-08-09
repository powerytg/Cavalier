package frameworks.cavalier.app.controllers
{
	import flash.events.EventDispatcher;
	
	import frameworks.cavalier.app.env.Environment;
	import frameworks.cavalier.app.events.StatisticEvent;
	import frameworks.cavalier.app.models.stat.MonthStatistic;
	import frameworks.cavalier.app.models.stat.SpecialStatisticEntries;
	import frameworks.cavalier.app.models.stat.YearStatistic;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.Log;
	import frameworks.cavalier.messaging.models.MessageLevel;
	import frameworks.cavalier.messaging.models.MessageStatus;
	import frameworks.cavalier.messaging.models.TextMessage;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	/**
	 * When the statistic of all-time playlist changes
	 */
	[Event(name="allTimePlaylistStatChange", type="frameworks.cavalier.app.events.StatisticEvent")]

	public class StatisticController extends EventDispatcher
	{
		/**
		 * @private
		 */
		private static var _statisticController:StatisticController;
		
		/**
		 * @private
		 */
		public static function get statisticController():StatisticController
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():StatisticController
		{
			if (_statisticController == null){
				_statisticController = new StatisticController();
			}
			return _statisticController;
		}
		
		/**
		 * Constructor
		 */
		public function StatisticController()
		{
			super();
			if( _statisticController != null ) throw new Error("Error:StatisticController already initialised.");
			if( _statisticController == null ) _statisticController = this;
		}
		
		/**
		 * @public
		 */
		public function getStatByAllTime(successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.resultFormat = "e4x";
			service.url = Environment.serverUrl + "/find/get_playlist_stat_by_all_time";			
			service.send();			
			
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				log.content = "Calendar fetched (playlist)";
				onGetStatByAllTime(evt.result as XML);
				
				if(successHandler != null)
					successHandler();
			});
			
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				log.level = MessageLevel.ALERT;
				log.status = MessageStatus.ACTIVE;
				log.content = "Error while fetching calendar (playlist)";
				
				if(faultHandler != null)
					faultHandler();
				else
					throw(new Error("Fatal DB Error"));
			});

			var log:Log = SystemBus.systemBus.newLog("Fetching calendar data...");
		}
		
		/**
		 * @private
		 */
		protected function onGetStatByAllTime(result:XML):void{
			Aggregator.aggregator.allTimeStatisticList.removeAll();
			Aggregator.aggregator.allTimeStatistic.numPlaylists = Number(result.@num_total);
			
			// Insert an "all" entry into the allTimeStatisticList
			var allStat:MonthStatistic = new MonthStatistic();
			allStat.month = SpecialStatisticEntries.ALL;
			allStat.numPlaylists = Number(result.@num_total);
			Aggregator.aggregator.allTimeStatisticList.addItem(allStat);
			
			// Insert a special "pending" entry
			var pendingStat:MonthStatistic = new MonthStatistic();
			pendingStat.month = SpecialStatisticEntries.PENDING;
			pendingStat.numPlaylists = Aggregator.aggregator.pendingPlaylists.length;
			Aggregator.aggregator.allTimeStatisticList.addItem(pendingStat);
			
			// Parse the rest of the list
			for each(var yearXml:XML in result.children()){
				// Parse year
				var year:Number = Number(yearXml.@year);
				var yearStat:YearStatistic;
				if(Aggregator.aggregator.allTimeStatistic.years.hasOwnProperty(year))
					yearStat = Aggregator.aggregator.allTimeStatistic.years[year] as YearStatistic;
				else{
					yearStat = new YearStatistic();
					yearStat.year = year;
					Aggregator.aggregator.allTimeStatistic.years[year] = yearStat;
				}
				
				yearStat.numPlaylists = Number(yearXml.@num);
				Aggregator.aggregator.allTimeStatisticList.addItem(yearStat);
				
				// Parse month
				for each(var monthXml:XML in yearXml.children()){
					var month:Number = Number(monthXml.@month);
					var monthStat:MonthStatistic;
					if(yearStat.months.hasOwnProperty(month))
						monthStat = yearStat.months[month] as MonthStatistic;
					else{
						monthStat = new MonthStatistic();
						monthStat.month = month;
						monthStat.year = year;
						monthStat.date = new Date(year, month);
						yearStat.months[month] = monthStat;
					}
					
					monthStat.numPlaylists = Number(monthXml.@num);
					Aggregator.aggregator.allTimeStatisticList.addItem(monthStat);
				}
			}
			
			// Update UI
			var event:StatisticEvent = new StatisticEvent(StatisticEvent.ALL_TIME_PLAYLIST_STAT_CHANGE);
			Aggregator.aggregator.dispatchEvent(event);
		}
		
		/**
		 * @public
		 */
		public function getClipStatByAllTime(successHandler:Function = null, faultHandler:Function = null):void{
			var service:HTTPService = new HTTPService();
			service.resultFormat = "e4x";
			service.url = Environment.serverUrl + "/find/get_clip_stat_by_all_time";			
			service.send();			
			
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				log.content = "Calendar fetched (clip)";
				onGetClipStatByAllTime(evt.result as XML);
				
				if(successHandler != null)
					successHandler();
			});
			
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				log.level = MessageLevel.ALERT;
				log.status = MessageStatus.ACTIVE;
				log.content = "Error while fetching calendar (clip)";
				
				if(faultHandler != null)
					faultHandler();
				else
					throw(new Error("Fatal DB Error"));

			});
			
			var log:Log = SystemBus.systemBus.newLog("Fetching calendar data...");
		}
		
		/**
		 * @private
		 */
		protected function onGetClipStatByAllTime(result:XML):void{
			Aggregator.aggregator.allTimeClipStatisticList.removeAll();
			Aggregator.aggregator.allTimeClipStatistic.numPlaylists = Number(result.@num_total);
			
			// Insert an "all" entry into the allTimeStatisticList
			var allStat:MonthStatistic = new MonthStatistic();
			allStat.month = SpecialStatisticEntries.ALL;
			allStat.numClips = Number(result.@num_total);
			Aggregator.aggregator.allTimeClipStatisticList.addItem(allStat);

			// Insert a special "pending" entry
			var pendingStat:MonthStatistic = new MonthStatistic();
			pendingStat.month = SpecialStatisticEntries.PENDING;
			pendingStat.numClips = Aggregator.aggregator.pendingClips.length;
			Aggregator.aggregator.allTimeClipStatisticList.addItem(pendingStat);
			
			// Parse the rest of the list
			for each(var yearXml:XML in result.children()){
				// Parse year
				var year:Number = Number(yearXml.@year);
				var yearStat:YearStatistic;
				if(Aggregator.aggregator.allTimeClipStatistic.years.hasOwnProperty(year))
					yearStat = Aggregator.aggregator.allTimeClipStatistic.years.hasOwnProperty(year) as YearStatistic;
				else{
					yearStat = new YearStatistic();
					yearStat.year = year;
					Aggregator.aggregator.allTimeClipStatistic.years[year] = yearStat;
				}
				
				yearStat.numClips = Number(yearXml.@num);
				Aggregator.aggregator.allTimeClipStatisticList.addItem(yearStat);
				
				// Parse month
				for each(var monthXml:XML in yearXml.children()){
					var month:Number = Number(monthXml.@month);
					var monthStat:MonthStatistic;
					if(yearStat.months.hasOwnProperty(month))
						monthStat = yearStat.months[month] as MonthStatistic;
					else{
						monthStat = new MonthStatistic();
						monthStat.month = month;
						monthStat.year = year;
						monthStat.date = new Date(year, month);
						yearStat.months[month] = monthStat;
					}
					
					monthStat.numClips = Number(monthXml.@num);
					Aggregator.aggregator.allTimeClipStatisticList.addItem(monthStat);
				}
			}
			
			// Update UI
			var event:StatisticEvent = new StatisticEvent(StatisticEvent.ALL_TIME_CLIP_STAT_CHANGE);
			Aggregator.aggregator.dispatchEvent(event);
		}
		
	}
}
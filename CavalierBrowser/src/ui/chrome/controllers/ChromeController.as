package ui.chrome.controllers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import frameworks.cavalier.app.events.ChromeEvent;
	import frameworks.cavalier.plugin.events.PluginManagerEvent;
	import frameworks.cavalier.plugin.managers.PluginManager;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	import frameworks.crescent.activity.Activity;
	import frameworks.crescent.activity.events.ActivityDeckEvent;
	
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import plugins.advertising.AdvertisingPlugin;
	import plugins.annotations.AnnotationPlugin;
	import plugins.awesomeSearch.AwesomeSearchPlugin;
	import plugins.dashboard.DashboardPlugin;
	import plugins.resources.ResourcesPlugin;
	import plugins.tracking.TrackingPlugin;
	import plugins.videoMetrics.VideoMetricsPlugin;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	
	import ui.chrome.Chrome;
	import ui.messagePanel.MessagePanel;
	import ui.messagePanel.controllers.MessagePanelController;
	import ui.messagePanel.events.MessagePanelEvent;
	import ui.sidePanel.controllers.SidePanelController;
	import ui.taskPanel.TaskPanelController;
	
	public class ChromeController extends EventDispatcher
	{
		/**
		 * @public
		 * 
		 * Plugin classes to load
		 */
		public var pluginsToLoad:Vector.<Class> = Vector.<Class>([AwesomeSearchPlugin, DashboardPlugin, ResourcesPlugin, 
			VideoMetricsPlugin, AdvertisingPlugin, TrackingPlugin, AnnotationPlugin]);
		
		/**
		 * @public
		 * 
		 * A reference to the app chrome
		 */
		public var chrome:Chrome;
		
		/**
		 * @public
		 * 
		 * Controller for SidePanel
		 */
		public var sidePanelController:SidePanelController = new SidePanelController();

		/**
		 * @public
		 * 
		 * Controller for TidePanel
		 */
		public var taskPanelController:TaskPanelController = new TaskPanelController();

		/**
		 * @public
		 * 
		 * Controller for the message panel
		 */
		public var messagePanelController:MessagePanelController = new MessagePanelController();
		
		/**
		 * @public
		 */
		public var policyController:PolicyController = new PolicyController();
		
		/**
		 * @private
		 */
		private var sidePanelShaded:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function ChromeController(target:IEventDispatcher=null)
		{
			super(target);
			
			// Plugin events
			PluginManager.pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOADED, onPluginLoaded);
		}
		
		/**
		 * @public
		 */
		public function initialize():void{
			// Install policies
			policyController.installPredefinedPolicies();
			
			// Initialize side panel
			sidePanelController.sidePanel = chrome.sidePanel;
			sidePanelController.initialize();
			
			// Initialize task panel
			taskPanelController.taskPanel = chrome.taskPanel;
			taskPanelController.initialize();
			
			// Chrome events
			chrome.sidePanel.toggleSidePanelButton.addEventListener(MouseEvent.CLICK, onSidePanelToggleClick);
			chrome.fullScreenButton.addEventListener(MouseEvent.CLICK, onFullScreenButtonClick);
			chrome.activityDeck.addEventListener(ActivityDeckEvent.ACTIVITY_CHANGED, function(evt:ActivityDeckEvent):void{
				var selectedIndex:Number = chrome.activityDeck.activities.getItemIndex(evt.selectedActivity);
				chrome.pagerSlider.selectedIndex = selectedIndex;
				
				// Animate the slider
				var animate:Animate = new Animate(chrome.pagerSlider);
				var mp:SimpleMotionPath = new SimpleMotionPath("value");
				mp.valueTo = (selectedIndex / chrome.activityDeck.activities.length) * 100;
				animate.motionPaths = Vector.<MotionPath>([mp]);
				animate.play();
				
				if(selectedIndex == 0)
					chrome.previousButton.alpha = 0.3;
				else
					chrome.previousButton.alpha = 1;
				
				if(selectedIndex == chrome.activityDeck.activities.length - 1)
					chrome.nextButton.alpha = 0.3;
				else
					chrome.nextButton.alpha = 1;
			});

			// Pager slider
			chrome.pagerSlider.addEventListener(Event.CHANGE, function(evt:Event):void{
				if(chrome.activityDeck.currentState != "transition")
					chrome.activityDeck.currentState = "transition";
				
				chrome.activityDeck.proxyGroup.horizontalScrollPosition = chrome.pagerSlider.value / 100 * chrome.activityDeck.proxyGroup.contentWidth;
			});

			chrome.pagerSlider.addEventListener(FlexEvent.CHANGE_END, function(evt:FlexEvent):void{
				var targetActivity:Activity = chrome.activityDeck.getNearestActivity();
				chrome.activityDeck.lookAt(targetActivity);
				
				// Play a smooth animation to lock the slider to the proper position
				var animate:Animate = new Animate(chrome.pagerSlider);
				var mp:SimpleMotionPath = new SimpleMotionPath("value");
				mp.valueTo = (chrome.activityDeck.activities.getItemIndex(targetActivity) / chrome.activityDeck.activities.length) * 100;
				animate.motionPaths = Vector.<MotionPath>([mp]);
				animate.play();
			});

			
			chrome.previousButton.addEventListener(MouseEvent.CLICK, onPreviousButtonClick);
			chrome.nextButton.addEventListener(MouseEvent.CLICK, onNextButtonClick);
			
			chrome.taskPanel.messageButton.addEventListener(MouseEvent.CLICK, onMessageButtonClick);
			
			 //	Message panel
			messagePanelController.addEventListener(MessagePanelEvent.MESSAGE_PANEL_CLOSE, hideMessagePanel); 
			
			// Load plugins
			for each(var pluginClass:Class in pluginsToLoad){
				PluginManager.pluginManager.loadPlugin(pluginClass);
			}
			
			// Bind the chrome's activityDeck to ActivityManager
			ActivityManager.activityManager.activityDeck = chrome.activityDeck;
			
			// Wallpaper events
			chrome.addEventListener(ChromeEvent.CHANGE_BACKGROUND, function(evt:ChromeEvent):void{
				evt.stopPropagation();
				chrome.background.source = evt.backgroundFace;
			});
		}
		
		/**
		 * @private
		 */
		protected function onPluginLoaded(evt:PluginManagerEvent):void{
			for each(var activityClass:Class in evt.plugin.mandatoryActivities){
				var activity:Activity = new activityClass();
				chrome.activityDeck.addActivity(activity);
			}
		}
		
		/**
		 * @private
		 */
		protected function onSidePanelToggleClick(evt:MouseEvent):void{
			if(sidePanelShaded)
				expandSidePanel();
			else
				shadeSidePanel();
		}

		/**
		 * @public
		 */
		public function expandSidePanel():void{
			sidePanelShaded = false;
			
			var animate:Animate = new Animate();
			animate.targets = [chrome.sidePanel, chrome.activityDeck];
			var mp:SimpleMotionPath = new SimpleMotionPath("left");
			mp.valueBy = 200;
			animate.motionPaths = Vector.<MotionPath>([mp]);
			animate.play();
			animate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				chrome.activityDeck.resize();
			});
		}
		
		/**
		 * @public
		 */
		public function shadeSidePanel():void{
			sidePanelShaded = true;
			
			var animate:Animate = new Animate();
			animate.targets = [chrome.sidePanel, chrome.activityDeck];
			var mp:SimpleMotionPath = new SimpleMotionPath("left");
			mp.valueBy = -200;
			animate.motionPaths = Vector.<MotionPath>([mp]);
			animate.play();
			animate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				chrome.activityDeck.resize();
			});
		}
		
		/**
		 * @private
		 */
		private function onFullScreenButtonClick(evt:MouseEvent):void{
			if(chrome.activityDeck.fullScreenMode)
				exitFullScreenMode();
			else
				enterFullScreenMode();
		}
		
		/**
		 * @private
		 */
		public function enterFullScreenMode():void{			
			// Hide side panel
			var sidePanelAnimate:Animate = new Animate(chrome.sidePanel);
			var sidePanelMp:SimpleMotionPath = new SimpleMotionPath("left");
			sidePanelMp.valueTo = -chrome.sidePanel.width;
			sidePanelAnimate.motionPaths = Vector.<MotionPath>([sidePanelMp]);
			sidePanelAnimate.play();
			sidePanelAnimate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				chrome.sidePanel.visible = false;
			});
			
			// Hide logo
			var logoAnimate:Animate = new Animate(chrome.logo);
			var logoMp:SimpleMotionPath = new SimpleMotionPath("top");
			logoMp.valueTo = -chrome.logo.height;
			logoAnimate.motionPaths = Vector.<MotionPath>([logoMp]);
			logoAnimate.play();
			logoAnimate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				chrome.logo.visible = false;
			});
			
			// Hide pager
			var pagerAnimate:Animate = new Animate(chrome.pagerGroup);
			var pagerMp:SimpleMotionPath = new SimpleMotionPath("bottom");
			pagerMp.valueTo = -chrome.pagerGroup.height;
			pagerAnimate.motionPaths = Vector.<MotionPath>([pagerMp]);
			pagerAnimate.play();
			pagerAnimate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				chrome.pagerGroup.visible = false;
			});
			
			// Maximize activities
			var deckAnimate:Animate = new Animate(chrome.activityDeck);
			var leftMp:SimpleMotionPath = new SimpleMotionPath("left");
			leftMp.valueTo = 0;
			var topMp:SimpleMotionPath = new SimpleMotionPath("top");
			topMp.valueTo = 50;
			var bottomMp:SimpleMotionPath = new SimpleMotionPath("bottom");
			bottomMp.valueTo = 95;
			deckAnimate.motionPaths = Vector.<MotionPath>([leftMp, topMp, bottomMp]);
			deckAnimate.play();
			deckAnimate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				chrome.activityDeck.enterFullScreen();
			});
		}

		/**
		 * @private
		 */
		public function exitFullScreenMode():void{		
			// Resize activities
			var deckAnimate:Animate = new Animate(chrome.activityDeck);
			var leftMp:SimpleMotionPath = new SimpleMotionPath("left");
			leftMp.valueTo = 315;
			var topMp:SimpleMotionPath = new SimpleMotionPath("top");
			topMp.valueTo = 90;
			var bottomMp:SimpleMotionPath = new SimpleMotionPath("bottom");
			bottomMp.valueTo = 140;
			deckAnimate.motionPaths = Vector.<MotionPath>([leftMp, topMp, bottomMp]);
			deckAnimate.play();
			deckAnimate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				chrome.activityDeck.exitFullScreen();
			});
			
			// Show side panel
			chrome.sidePanel.visible = true;
			var sidePanelAnimate:Animate = new Animate(chrome.sidePanel);
			var sidePanelMp:SimpleMotionPath = new SimpleMotionPath("left");
			sidePanelMp.valueTo = 0;
			sidePanelAnimate.motionPaths = Vector.<MotionPath>([sidePanelMp]);
			sidePanelAnimate.play();
			
			// Hide logo
			chrome.logo.visible = true;
			var logoAnimate:Animate = new Animate(chrome.logo);
			var logoMp:SimpleMotionPath = new SimpleMotionPath("top");
			logoMp.valueTo = 0;
			logoAnimate.motionPaths = Vector.<MotionPath>([logoMp]);
			logoAnimate.play();
			
			// Hide pager
			chrome.pagerGroup.visible = true;
			var pagerAnimate:Animate = new Animate(chrome.pagerGroup);
			var pagerMp:SimpleMotionPath = new SimpleMotionPath("bottom");
			pagerMp.valueTo = 95;
			pagerAnimate.motionPaths = Vector.<MotionPath>([pagerMp]);
			pagerAnimate.play();
		}
		
		/**
		 * @private
		 */
		protected function onPreviousButtonClick(evt:MouseEvent):void{
			if(chrome.activityDeck.selectedIndex > 0)
				chrome.activityDeck.lookAt(chrome.activityDeck.activities.getItemAt(chrome.activityDeck.selectedIndex - 1) as Activity);
		}

		/**
		 * @private
		 */
		protected function onNextButtonClick(evt:MouseEvent):void{
			if(chrome.activityDeck.selectedIndex < chrome.activityDeck.activities.length - 1)
				chrome.activityDeck.lookAt(chrome.activityDeck.activities.getItemAt(chrome.activityDeck.selectedIndex + 1) as Activity);
		}

		/**
		 * @private
		 */
		protected function onMessageButtonClick(evt:MouseEvent):void{
			if(!chrome.messagePanelHolder.visible)
				showMessagePanel();
			else
				hideMessagePanel();
		}
		
		/**
		 * @public
		 */
		public function showMessagePanel():void{
			chrome.contentGroup.autoLayout = false;
			
			chrome.messagePanelHolder.width = 280;
			chrome.messagePanelHolder.visible = true;
			
			var mp:SimpleMotionPath = new SimpleMotionPath("x");
			mp.valueBy = -chrome.messagePanelHolder.width;
			var animate:Animate = new Animate(chrome);
			animate.motionPaths = Vector.<MotionPath>([mp]);
			animate.play();
			animate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				var messagePanel:MessagePanel = messagePanelController.createMessagePanel();
				chrome.messagePanelHolder.addElement(messagePanel);
				chrome.contentGroup.autoLayout = true;
			});
		}
		
		/**
		 * @public
		 */
		public function hideMessagePanel(evt:Event = null):void{
			chrome.contentGroup.autoLayout = false;
			
			var mp:SimpleMotionPath = new SimpleMotionPath("x");
			mp.valueBy = chrome.messagePanelHolder.width;
			var animate:Animate = new Animate(chrome);
			animate.motionPaths = Vector.<MotionPath>([mp]);
			animate.play();
			animate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				chrome.messagePanelHolder.visible = false;
				chrome.messagePanelHolder.width = 0;
				chrome.messagePanelHolder.removeAllElements();
				messagePanelController.destroyMessagePanel();
				chrome.contentGroup.autoLayout = true;
			});
		}
		
	}
}
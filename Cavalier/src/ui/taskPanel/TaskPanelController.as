package ui.taskPanel
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import frameworks.cavalier.app.events.ChromeEvent;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.events.IndicatorEvent;
	import frameworks.cavalier.messaging.events.SystemBusEvent;
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.ActivityDescriptor;
	import frameworks.cavalier.plugin.managers.PluginManager;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	import frameworks.cavalier.ui.messaging.IndicatorBase;
	import frameworks.crescent.activity.Activity;
	
	import mx.events.EffectEvent;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.events.IndexChangeEvent;
	
	public class TaskPanelController extends EventDispatcher
	{
		/**
		 * @public
		 * 
		 * A reference to the task panel
		 */
		public var taskPanel:TaskPanel;
		
		/**
		 * Constructor
		 */
		public function TaskPanelController(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		public function initialize():void{
			taskPanel.activityList.addEventListener(IndexChangeEvent.CHANGE, onTaskSelectionChange);
			
			taskPanel.newActivityButton.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
				ActivityManager.activityManager.createActivityTempalte();
			});

			taskPanel.closeAllButton.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
				ActivityManager.activityManager.closeAllActivities();
			});
			
			taskPanel.hyperVisionButton.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
				ActivityManager.activityManager.lookAtOrCreateNewByClassName("HyperVisionActivity");
			});
			
			// Indicator events
			SystemBus.systemBus.addEventListener(SystemBusEvent.ADD_INDICATOR_REQUEST, onAddIndicatorRequest);
			SystemBus.systemBus.addEventListener(SystemBusEvent.REMOVE_INDICATOR_REQUEST, onRemoveIndicatorRequest);
		}
		
		/**
		 * @private
		 */
		protected function onTaskSelectionChange(evt:IndexChangeEvent):void{
			ActivityManager.activityManager.lookAt(taskPanel.activityList.selectedItem as Activity);
		}
		
		/**
		 * @private
		 */
		private function onAddIndicatorRequest(evt:SystemBusEvent):void{
			// Remove previous indicators
			removeAllIndicators();
			
			// Switch to indicator view
			taskPanel.indicatorGroup.addElement(evt.indicator);
			showIndicators();
		}
		
		/**
		 * @private
		 */
		private function onRemoveIndicatorRequest(evt:SystemBusEvent):void{
			showTasks();
		}
		
		/**
		 * @public
		 */
		public function showIndicators():void{
			var animate:Animate = new Animate(taskPanel.scroller.viewport);
			var mp:SimpleMotionPath = new SimpleMotionPath("verticalScrollPosition");
			mp.valueTo = taskPanel.height - 15;
			animate.motionPaths = Vector.<MotionPath>([mp]);
			animate.play();
			
			// One time only event
			animate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				if(taskPanel.indicatorGroup.numElements != 0){
					var indicator:IndicatorBase = taskPanel.indicatorGroup.getElementAt(0) as IndicatorBase;
					indicator.dispatchEvent(new IndicatorEvent(IndicatorEvent.ADDED_TO_CHROME));
				}				
			}, false, 0, true);
		}
		
		/**
		 * @public
		 */
		public function showTasks():void{
			var animate:Animate = new Animate(taskPanel.scroller.viewport);
			var mp:SimpleMotionPath = new SimpleMotionPath("verticalScrollPosition");
			mp.valueTo = 0;
			animate.motionPaths = Vector.<MotionPath>([mp]);
			animate.play();
			
			// One time only event
			animate.addEventListener(EffectEvent.EFFECT_END, function(evt:EffectEvent):void{
				removeAllIndicators();			
			}, false, 0, true);
			
		}
		
		/**
		 * @private
		 */
		private function removeAllIndicators():void{
			if(taskPanel.indicatorGroup.numElements != 0){
				for(var i:uint = 0; i < taskPanel.indicatorGroup.numElements; i++){
					var indicator:IndicatorBase = taskPanel.indicatorGroup.getElementAt(i) as IndicatorBase;
					indicator.dispatchEvent(new IndicatorEvent(IndicatorEvent.REMOVED_FROM_CHROME));
				}
				
				taskPanel.indicatorGroup.removeAllElements();
			}
		}
		
	}
}
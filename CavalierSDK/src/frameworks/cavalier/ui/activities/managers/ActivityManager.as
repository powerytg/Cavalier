package frameworks.cavalier.ui.activities.managers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.ActivityDescriptor;
	import frameworks.cavalier.plugin.managers.PluginManager;
	import frameworks.cavalier.ui.activities.ActivityTemplate;
	import frameworks.cavalier.ui.parts.UIPart;
	import frameworks.crescent.activity.Activity;
	import frameworks.crescent.activity.ActivityDeck;
	
	import mx.collections.ArrayCollection;
	
	public class ActivityManager extends EventDispatcher
	{
		/**
		 * @public
		 */
		[Bindable]
		public var activityDeck:ActivityDeck;
		
		/**
		 * @private
		 */
		private static var _activityManager:ActivityManager;
		
		/**
		 * @private
		 */
		public static function get activityManager():ActivityManager
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():ActivityManager
		{
			if (_activityManager == null){
				_activityManager = new ActivityManager();
			}
			return _activityManager;
		}
		
		/**
		 * Constructor
		 */
		public function ActivityManager()
		{
			super();
			if( _activityManager != null ) throw new Error("Error:ActivityManager already initialised.");
			if( _activityManager == null ) _activityManager = this;
		}

		/**
		 * @public
		 */
		public function lookAt(activity:Activity):void{
			activityDeck.lookAt(activity);
		}
		
		/**
		 * @public
		 */
		public function removeActivities(activitiesToBeClosed:Array):void{
			activityDeck.removeActivities(activitiesToBeClosed);
		}
		
		/**
		 * @public
		 */
		public function removeActivity(activity:Activity):void{
			activityDeck.removeActivity(activity);
		}
		
		/**
		 * @public
		 */
		public function addActivity(activity:Activity):void{
			activityDeck.addActivity(activity);
		}
		
		/**
		 * @public
		 */
		public function addActivityBefore(activity:Activity, target:Activity):void{
			activityDeck.addActivityBefore(activity, target);
		}
		
		/**
		 * @public
		 */
		public function addActivityToFront(activity:Activity):void{
			activityDeck.addActivityToFront(activity);
		}
		
		/**
		 * @public
		 */
		public function closeAllActivities():void{
			var activitiesToBeClosed:Array = [];
			for each(var activity:Activity in activityDeck.activities){
				if(activity.canClose)
					activitiesToBeClosed.push(activity);
			}
			
			activityDeck.removeActivities(activitiesToBeClosed);
		}

		/**
		 * @public
		 */
		public function createActivityWithUIPart(part:UIPart):void{
			var activity:Activity = new Activity();
			var clone:UIPart = part.createClone();
			clone.percentWidth = 100;
			clone.percentHeight = 100;
			activity.addElement(clone);
			activityDeck.addActivityBefore(activity, activityDeck.currentActivity);
		}
		
		/**
		 * @public
		 */
		public function createActivityTempalte():void{
			var activity:ActivityTemplate = new ActivityTemplate();
			activityDeck.addActivityBefore(activity, activityDeck.currentActivity);
		}
		
		/**
		 * @public
		 */
		public function lookAtOrCreateNewByClassName(className:String):void{
			for each(var activity:Activity in activityDeck.activities){
				if(activity.className == className){
					activityDeck.lookAt(activity)
					return;
				}
			}
			
			// Otherwise, create a new specified activity
			for each(var plugin:Plugin in PluginManager.pluginManager.plugins){
				var desc:ActivityDescriptor = plugin.getActivityDescriptorByClassName(className);
				if(desc){
					var activityClass:Class = desc.activityClass;
					activity = new activityClass();
					addActivityToFront(activity);
					return;
				}
			}
		}
		
	}
}
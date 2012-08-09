package plugins.dashboard
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.ActivityDescriptor;
	
	import plugins.dashboard.activities.AboutActivity;
	import plugins.dashboard.activities.DashboardActivity;
	import plugins.dashboard.activities.HyperVisionActivity;
	import plugins.dashboard.activities.JobCenterActivity;
	import plugins.dashboard.activities.MessageActivity;
	
	public class DashboardPlugin extends Plugin
	{
		/**
		 * Constructor
		 */
		public function DashboardPlugin(target:IEventDispatcher = null)
		{
			super(target);
			
			_faceColor = 0x008582;
			_pluginName = "dashboard";
			_activityDescriptors.push(new ActivityDescriptor("dashboard", DashboardActivity, "DashboardActivity"));
			_activityDescriptors.push(new ActivityDescriptor("hyper vision", HyperVisionActivity, "HyperVisionActivity"));
			_activityDescriptors.push(new ActivityDescriptor("notifications", MessageActivity, "MessageActivity"));
			_activityDescriptors.push(new ActivityDescriptor("job hub", JobCenterActivity, "JobCenterActivity"));
			_activityDescriptors.push(new ActivityDescriptor("about cavalier",  AboutActivity, "AboutActivity", false));
			mandatoryActivities.push(DashboardActivity);
		}
	}
}
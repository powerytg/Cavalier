package plugins.tracking
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.ActivityDescriptor;
	import frameworks.cavalier.plugin.core.UIPartCatagory;
	import frameworks.cavalier.plugin.core.UIPartDescriptor;
	
	import plugins.tracking.activities.BeaconDistributionActivity;
	import plugins.tracking.activities.DBUsageActivity;
	import plugins.tracking.activities.ResourceInsightActivity;
	import plugins.tracking.activities.TrackingPolicyActivity;
	import plugins.tracking.parts.ClipDBUsage;
	import plugins.tracking.parts.ClipTimeline;
	import plugins.tracking.parts.Heatmap;
	import plugins.tracking.parts.HitsByAllTime;
	import plugins.tracking.parts.HitsByMonth;
	import plugins.tracking.parts.HitsByYear;
	import plugins.tracking.parts.PlaylistTimeline;
	
	public class TrackingPlugin extends Plugin
	{
		public function TrackingPlugin(target:IEventDispatcher=null)
		{
			super(target);
			_faceColor = 0xd49231;
			_pluginName = "tracking";

			// Activities
			_activityDescriptors.push(new ActivityDescriptor("policies", TrackingPolicyActivity, "TrackingPolicyActivity"));
			_activityDescriptors.push(new ActivityDescriptor("distribution matrix", BeaconDistributionActivity, "BeaconDistributionActivity"));
			_activityDescriptors.push(new ActivityDescriptor("resource insight", ResourceInsightActivity , "ResourceInsightActivity"));
			_activityDescriptors.push(new ActivityDescriptor("db usage", DBUsageActivity , "DBUsageActivity"));
			
			
			// UI Parts
			_uiPartDescriptors.push(new UIPartDescriptor("Timeline (Clip)", null, UIPartCatagory.CALENDAR, ClipTimeline));
			_uiPartDescriptors.push(new UIPartDescriptor("Timeline (Playlist)", null, UIPartCatagory.CALENDAR, PlaylistTimeline));
			_uiPartDescriptors.push(new UIPartDescriptor("Insight (Historical)", null, UIPartCatagory.ANALYSIS, HitsByAllTime));
			_uiPartDescriptors.push(new UIPartDescriptor("Insight (Year)", null, UIPartCatagory.ANALYSIS, HitsByYear));
			_uiPartDescriptors.push(new UIPartDescriptor("Insight (Month)", null, UIPartCatagory.ANALYSIS, HitsByMonth));
			_uiPartDescriptors.push(new UIPartDescriptor("Heatmap (Clip)", null, UIPartCatagory.ANALYSIS, Heatmap));
			_uiPartDescriptors.push(new UIPartDescriptor("Tracking DB Usage (Clip)", null, UIPartCatagory.ANALYSIS, ClipDBUsage));
		}
	}
}
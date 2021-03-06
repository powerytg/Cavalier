package plugins.advertising
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.ActivityDescriptor;
	import frameworks.cavalier.plugin.core.ShortcutDescriptor;
	import frameworks.cavalier.plugin.core.UIPartCatagory;
	import frameworks.cavalier.plugin.core.UIPartDescriptor;
	
	import plugins.advertising.activities.AdBrowserActivity;
	import plugins.advertising.activities.AdCuePointEditorActivity;
	import plugins.advertising.activities.AdCuePointFullEditorActivity;
	import plugins.advertising.activities.AdDistributionActivity;
	import plugins.advertising.activities.AdEditorActivity;
	import plugins.advertising.activities.AdPolicyActivity;
	import plugins.advertising.parts.AdEditor;
	import plugins.advertising.parts.AdSelector;
	import plugins.advertising.parts.ConjointAdSelector;
	import plugins.advertising.shortcuts.ImportAdShortcut;
	
	public class AdvertisingPlugin extends Plugin
	{
		/**
		 * Constructor
		 */
		public function AdvertisingPlugin(target:IEventDispatcher=null)
		{
			super(target);
			_faceColor = 0xc85422;
			_pluginName = "advertising";

			// Pre-defined activities
			_activityDescriptors.push(new ActivityDescriptor("policies", AdPolicyActivity, "AdPolicyActivity"));
			_activityDescriptors.push(new ActivityDescriptor("distribution matrix", AdDistributionActivity, "AdDistributionActivity"));
			_activityDescriptors.push(new ActivityDescriptor("manage ads", AdBrowserActivity, "AdBrowserActivity"));
			_activityDescriptors.push(new ActivityDescriptor("ad editor", AdEditorActivity, "AdEditorActivity", false));
			_activityDescriptors.push(new ActivityDescriptor("ad cuepoint editor", AdCuePointEditorActivity, "AdCuePointEditorActivity", false));
			_activityDescriptors.push(new ActivityDescriptor("ad cuepoint editor", AdCuePointFullEditorActivity, "AdCuePointFullEditorActivity", false));

			// UI Parts
			_uiPartDescriptors.push(new UIPartDescriptor("Ad Selector", null, UIPartCatagory.SELECTOR, AdSelector));
			_uiPartDescriptors.push(new UIPartDescriptor("Tag + Ad", null, UIPartCatagory.SELECTOR, ConjointAdSelector));
			_uiPartDescriptors.push(new UIPartDescriptor("Ad Editor", null, UIPartCatagory.EDITOR, AdEditor));
			
			// Shortcuts
			_shortcutDescriptors.push(new ShortcutDescriptor(true, "Import Ad", null, ImportAdShortcut, "ImportAdShortcut"));
		}
	}
}
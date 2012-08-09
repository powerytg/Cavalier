package plugins.resources
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.ActivityDescriptor;
	import frameworks.cavalier.plugin.core.ShortcutDescriptor;
	import frameworks.cavalier.plugin.core.UIPartCatagory;
	import frameworks.cavalier.plugin.core.UIPartDescriptor;
	
	import plugins.resources.activities.ClipBrowserActivity;
	import plugins.resources.activities.ClipEditorActivity;
	import plugins.resources.activities.ManageTagsActivity;
	import plugins.resources.activities.PlaylistBrowserActivity;
	import plugins.resources.activities.PlaylistEditorActivity;
	import plugins.resources.activities.PreviewActivity;
	import plugins.resources.parts.ClipCalendar;
	import plugins.resources.parts.ClipEditor;
	import plugins.resources.parts.ClipSelector;
	import plugins.resources.parts.ConjointClipSelector;
	import plugins.resources.parts.ConjointPlaylistSelector;
	import plugins.resources.parts.PlaylistCalendar;
	import plugins.resources.parts.PlaylistEditor;
	import plugins.resources.parts.PlaylistSelector;
	import plugins.resources.parts.TagList;
	import plugins.resources.parts.TagListWithAdBadge;
	import plugins.resources.parts.TagListWithClipAndAdBadge;
	import plugins.resources.parts.TagListWithClipBadge;
	import plugins.resources.parts.VideoPreview;
	import plugins.resources.shortcuts.ImportClipShortcut;
	import plugins.resources.shortcuts.NewPlaylistShortcut;
	import plugins.resources.shortcuts.NewTagShortcut;
	
	/**
	 * The Resources plugin manages video clips, playlists, tags, etc.
	 */
	public class ResourcesPlugin extends Plugin
	{
		/**
		 * Constructor
		 */
		public function ResourcesPlugin(target:IEventDispatcher = null)
		{
			super(target);
			
			_faceColor = 0x59921c;
			_pluginName = "resources";
			
			// Pre-defined activities
			_activityDescriptors.push(new ActivityDescriptor("manage playlists", PlaylistBrowserActivity, "PlaylistBrowserActivity"));
			_activityDescriptors.push(new ActivityDescriptor("playlist editor", PlaylistEditorActivity, "PlaylistEditorActivity", false));
			_activityDescriptors.push(new ActivityDescriptor("manage clips", ClipBrowserActivity, "ClipBrowserActivity"));
			_activityDescriptors.push(new ActivityDescriptor("clip editor", ClipEditorActivity, "ClipEditorActivity", false));
			_activityDescriptors.push(new ActivityDescriptor("video preview", PreviewActivity, "PreviewActivity", false));
			_activityDescriptors.push(new ActivityDescriptor("metadata & tags", ManageTagsActivity, "ManageTagsActivity"));
			
			// Pre-defined UI parts
			_uiPartDescriptors.push(new UIPartDescriptor("Calendar (Playlist)", null, UIPartCatagory.CALENDAR, PlaylistCalendar));
			_uiPartDescriptors.push(new UIPartDescriptor("Calendar (Clip)", null, UIPartCatagory.CALENDAR, ClipCalendar));
			_uiPartDescriptors.push(new UIPartDescriptor("Playlist Selector", null, UIPartCatagory.SELECTOR, PlaylistSelector));
			_uiPartDescriptors.push(new UIPartDescriptor("Clip Selector", null, UIPartCatagory.SELECTOR, ClipSelector));
			_uiPartDescriptors.push(new UIPartDescriptor("Calendar + Playlist", null, UIPartCatagory.SELECTOR, ConjointPlaylistSelector));
			_uiPartDescriptors.push(new UIPartDescriptor("Playlist Editor", null, UIPartCatagory.EDITOR, PlaylistEditor));
			_uiPartDescriptors.push(new UIPartDescriptor("Clip Editor", null, UIPartCatagory.EDITOR, ClipEditor));
			_uiPartDescriptors.push(new UIPartDescriptor("Video Preview", null, UIPartCatagory.EDITOR, VideoPreview));
			_uiPartDescriptors.push(new UIPartDescriptor("Tag List", null, UIPartCatagory.CALENDAR, TagList));
			_uiPartDescriptors.push(new UIPartDescriptor("Tag List (Clip Statistic)", null, UIPartCatagory.CALENDAR, TagListWithClipBadge));
			_uiPartDescriptors.push(new UIPartDescriptor("Tag List (Ad Statistic)", null, UIPartCatagory.CALENDAR, TagListWithAdBadge));
			_uiPartDescriptors.push(new UIPartDescriptor("Tag List (Clip + Ad Statistic)", null, UIPartCatagory.CALENDAR, TagListWithClipAndAdBadge));
			_uiPartDescriptors.push(new UIPartDescriptor("Calendar/Tag + Clip", null, UIPartCatagory.SELECTOR, ConjointClipSelector));
			
			// Provided shortcuts
			_shortcutDescriptors.push(new ShortcutDescriptor(true, "New Playlist", null, NewPlaylistShortcut, "NewPlaylistShortcut"));
			_shortcutDescriptors.push(new ShortcutDescriptor(true, "New Clip", null, ImportClipShortcut, "ImportClipShortcut"));
			_shortcutDescriptors.push(new ShortcutDescriptor(false, "New Tag", null, NewTagShortcut, "NewTagShortcut"));
		}
	}
}
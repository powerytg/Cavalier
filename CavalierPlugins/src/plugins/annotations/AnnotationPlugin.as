package plugins.annotations
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.ActionDescriptor;
	import frameworks.cavalier.plugin.core.ActivityDescriptor;
	
	import plugins.annotations.actions.EditAnnotationAction;
	import plugins.annotations.activities.AnnotationEditorActivity;
	
	public class AnnotationPlugin extends Plugin
	{
		/**
		 * @private
		 */
		[Embed(source="/images/PopOut.png")]
		private var actionIcon:Class;
		
		/**
		 * Constructor
		 */
		public function AnnotationPlugin(target:IEventDispatcher=null)
		{
			super(target);
			_faceColor = 0x5e0245;
			_pluginName = "annotation";
			visible = false;
			
			// Activities
			_activityDescriptors.push(new ActivityDescriptor("annotation editor", AnnotationEditorActivity, "AnnotationActivity", false));
			
			// Actions
			_actionDescriptors.push(new ActionDescriptor("clip", "EditAnnotationAction", EditAnnotationAction, "Annotations", actionIcon));
		}
	}
}
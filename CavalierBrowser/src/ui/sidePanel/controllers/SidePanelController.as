package ui.sidePanel.controllers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.ActivityDescriptor;
	import frameworks.cavalier.plugin.core.ShortcutDescriptor;
	import frameworks.cavalier.plugin.events.PluginManagerEvent;
	import frameworks.cavalier.plugin.managers.PluginManager;
	import frameworks.cavalier.plugin.managers.ShortcutManager;
	import frameworks.cavalier.ui.activities.managers.ActivityManager;
	import frameworks.crescent.components.AccordionSection;
	import frameworks.crescent.components.List;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.events.ItemClickEvent;
	
	import spark.layouts.VerticalLayout;
	
	import ui.sidePanel.SidePanel;
	import ui.sidePanel.supportClasses.SidePanelActivityRenderer;
	
	public class SidePanelController extends EventDispatcher
	{
		/**
		 * @public
		 * 
		 * Reference to the SidePanel
		 */
		public var sidePanel:SidePanel;
		
		/**
		 * Constructor
		 */
		public function SidePanelController(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		public function initialize():void{
			// Scan the loaded plugins and show them in the side panel
			for each(var plugin:Plugin in PluginManager.pluginManager.plugins){
				addPluginSection(plugin);
			}
			
			// Monitor the add/removal of plugins
			PluginManager.pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOADED, onPluginLoaded, false, 0, true);
			sidePanel.shortcutList.addEventListener(ItemClickEvent.ITEM_CLICK, onShortcutClick, false, 0, true);
		}
		
		/**
		 * @public
		 */
		public function addPluginSection(plugin:Plugin):void{
			var section:AccordionSection = new AccordionSection();
			section.percentWidth = 100;
			section.title = plugin.pluginName;
			section.titleBarStyleName = "sidePanelAccordionTitleBar";
			sidePanel.pluginAccordion.addElement(section);
			
			// Create a list of activities provided by the plugin
			var activities:ArrayCollection = new ArrayCollection();
			for each(var descriptor:ActivityDescriptor in plugin.activities){
				if(descriptor.visible)
					activities.addItem(descriptor);
			}
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.variableRowHeight = true;
			
			var list:List = new List();
			list.itemRenderer = new ClassFactory(SidePanelActivityRenderer);
			list.percentWidth = 100;
			list.setStyle("verticalScrollPolicy", "off");
			list.dataProvider = activities;
			list.layout = layout;
			list.addEventListener(ItemClickEvent.ITEM_CLICK, onSelectActivity);
			section.addElement(list);
		}
		
		/**
		 * @private
		 */
		protected function onPluginLoaded(evt:PluginManagerEvent):void{
			if(evt.plugin.visible)
				addPluginSection(evt.plugin);
		}
		
		/**
		 * @private
		 */
		protected function onSelectActivity(evt:ItemClickEvent):void{
			var selectedActivityDescriptor:ActivityDescriptor = evt.target.data as ActivityDescriptor;
			ActivityManager.activityManager.lookAtOrCreateNewByClassName(selectedActivityDescriptor.className);
		}
		
		/**
		 * @private
		 */
		protected function onShortcutClick(evt:ItemClickEvent):void{
			var desc:ShortcutDescriptor = evt.item as ShortcutDescriptor;
			ShortcutManager.shortcutManager.evokeShortcutByClassName(desc.className);
		}
		
	}
}
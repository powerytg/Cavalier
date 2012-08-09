package frameworks.cavalier.ui.components.supportClasses
{
	import mx.core.UIComponent;

	public interface ITimelineMarker
	{
		function get data():ITimelineMarkerMetadata;
		function set data(value:ITimelineMarkerMetadata):void;
		function get resizer():UIComponent;
	}
}
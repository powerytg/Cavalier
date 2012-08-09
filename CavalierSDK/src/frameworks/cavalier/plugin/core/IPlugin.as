package frameworks.cavalier.plugin.core
{

	public interface IPlugin
	{
		function get pluginName():String;
		function get description():String;
		function get faceColor():Number;
		function get activities():Vector.<ActivityDescriptor>;
	}
}
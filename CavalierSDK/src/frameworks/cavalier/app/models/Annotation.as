package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.utils.ColorUtils;
	import frameworks.cavalier.ui.components.supportClasses.ITimelineMarkerMetadata;
	
	public class Annotation extends ModelBase implements ITimelineMarkerMetadata
	{
		/**
		 * @public
		 */
		[Bindable]
		public var content:String;
		
		/**
		 * @public
		 */
		public var date:String;
		
		/**
		 * @public
		 */
		public var layout:AnnotationLayout = new AnnotationLayout();
		
		/**
		 * @public
		 */
		[Bindable]
		public var cuePoint:Number;
		
		/**
		 * @public
		 */
		[Bindable]
		public var duration:Number;
		
		/**
		 * @public
		 */
		[Bindable]
		public var color:Number = 0;		
		
		/**
		 * Constructor
		 */
		public function Annotation(target:IEventDispatcher=null)
		{
			super(target);
			color = ColorUtils.getRandomColor();
		}
		
		/**
		 * @public
		 */
		override public function createClone():ModelBase{
			var annotation:Annotation = new Annotation();
			annotation.id = id;
			annotation.date = date;
			annotation.cuePoint = cuePoint;
			annotation.duration = duration;
			annotation.content = content;
			annotation.layout = layout;
			
			return annotation;
		}
		
		/**
		 * @public
		 */
		public function get time():Number
		{
			return cuePoint;
		}
		
		/**
		 * @public
		 */
		public function get length():Number
		{
			return duration;
		}
	}
}
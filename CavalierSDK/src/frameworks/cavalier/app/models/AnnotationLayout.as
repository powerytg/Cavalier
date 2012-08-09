package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	public class AnnotationLayout extends ModelBase
	{
		/**
		 * @public
		 */
		public static const HORIZONTAL_ALIGN:String = "horizontalAlign";

		/**
		 * @public
		 */
		public static const VERTICAL_ALIGN:String = "verticalAlign";
		
		/**
		 * @public
		 */
		public static const CENTER_ALIGN:String = "centerAlign";
		
		/**
		 * @public
		 */
		public static const TOP:String = "top";
		
		/**
		 * @public
		 */
		public static const BOTTOM:String = "bottom";

		/**
		 * @public
		 */
		public static const LEFT:String = "left";

		/**
		 * @public
		 */
		public static const RIGHT:String = "right";

		/**
		 * @public
		 * 
		 * Possible values are: HORIZONTAL_ALIGN, VERTICAL_ALIGN and CENTER_ALIGN
		 */
		public var alignMethod:String;
		
		/**
		 * @public
		 * 
		 * Possible values are: LEFT and RIGHT
		 */
		public var horizontalAlign:String
		
		/**
		 * @public
		 * 
		 * Possible values are: TOP and BOTTOM
		 */
		public var verticalAlign:String;
		
		/**
		 * @public
		 * 
		 * Horizontal distance to edge
		 */
		public var horizontalPadding:Number;
		
		/**
		 * @public
		 * 
		 * Vertical distance to edge
		 */
		public var verticalPadding:Number;
		
		/**
		 * @public
		 */
		public var width:Number;
		
		/**
		 * @public
		 */
		public var height:Number;
		
		/**
		 * Constructor
		 */
		public function AnnotationLayout(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		override public function createClone():ModelBase{
			var layout:AnnotationLayout = new AnnotationLayout();
			
			layout.alignMethod = alignMethod;
			layout.horizontalAlign = horizontalAlign;
			layout.verticalAlign = verticalAlign;
			layout.horizontalPadding = horizontalPadding;
			layout.verticalPadding = verticalPadding;
			layout.width = width;
			layout.height = height;
			
			return layout;
		}
		
	}
}
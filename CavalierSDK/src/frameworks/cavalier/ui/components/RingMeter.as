package frameworks.cavalier.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	
	import mx.core.UIComponent;
	import mx.graphics.BitmapScaleMode;
	
	import spark.components.Group;
	import spark.primitives.BitmapImage;
	
	public class RingMeter extends UIComponent
	{
		/**
		 * @private
		 */
		[Embed(source="skins/images/RingMeterGlow.png")]
		private var glowFace:Class;
		
		/**
		 * @private
		 */
		protected var glow:BitmapImage;
		
		/**
		 * @private
		 */
		protected var glowHolder:Group;
		
		/**
		 * @public
		 */
		private var _percentage:Number = 50;

		/**
		 * @public
		 */
		[Bindable]
		public function get percentage():Number
		{
			return _percentage;
		}

		/**
		 * @private
		 */
		public function set percentage(value:Number):void
		{
			_percentage = value;
			invalidateDisplayList();
		}

		/**
		 * @public
		 */
		private var _thickness:Number = 15;

		/**
		 * @public
		 */
		[Bindable]
		public function get thickness():Number
		{
			return _thickness;
		}

		/**
		 * @public
		 */
		public function set thickness(value:Number):void
		{
			_thickness = value;
			invalidateDisplayList();
		}

		/**
		 * @public
		 */
		private var _innerRadius:Number = 24;

		/**
		 * @public
		 */
		[Bindable]
		public function get innerRadius():Number
		{
			return _innerRadius;
		}

		/**
		 * @private
		 */
		public function set innerRadius(value:Number):void
		{
			_innerRadius = value;
			invalidateDisplayList();
		}

		/**
		 * @private
		 */
		private var _faceColor:Number = 0x1f5975;

		/**
		 * @private
		 */
		[Bindable]
		public function get faceColor():Number
		{
			return _faceColor;
		}

		/**
		 * @private
		 */
		public function set faceColor(value:Number):void
		{
			_faceColor = value;
			invalidateDisplayList();
		}

		
		/**
		 * Constructor
		 */
		public function RingMeter()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			glowHolder = new Group();
			addChild(glowHolder);
			
			glow = new BitmapImage();
			glow.scaleMode = BitmapScaleMode.STRETCH;
			glow.source = glowFace;
			glow.percentHeight = 100;
			glow.percentWidth = 100;
			glowHolder.addElement(glow);
		}
		
		/**
		 * @prviate
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// Align the glow background
			glowHolder.width = unscaledWidth * 2;
			glowHolder.height = unscaledHeight * 2;
			glowHolder.x = unscaledWidth / 2 - glowHolder.width / 2;
			glowHolder.y = unscaledHeight / 2 - glowHolder.height / 2;
			
			var g:Graphics = graphics;
			g.clear();
			
			// Inner circle
			g.beginFill(faceColor);
			g.drawCircle(unscaledWidth / 2, unscaledHeight / 2, innerRadius);
			g.endFill();
			
			// Medium ring
			var outterRadius:Number = (unscaledWidth + unscaledHeight) / 4;
			var mediumRadius:Number = outterRadius - thickness / 2;
			g.lineStyle(1, 0xffffff, 0.8);
			g.drawCircle(unscaledWidth / 2, unscaledHeight / 2, mediumRadius); 
			
			// Outter ring (arc)
			var arcInnerRadius:Number = outterRadius - thickness;
			 
			var steps:Number = 20;
			var arcStep:Number = percentage / 100 * Math.PI * 2 / steps;
			var startX:Number = unscaledWidth / 2 + Math.cos(arcStep) * arcInnerRadius;
			var startY:Number = unscaledHeight / 2 + Math.sin(arcStep) * arcInnerRadius;
			
			g.moveTo(startX, startY);
			g.lineStyle(1, 0xffffff, 0);
			g.beginFill(0xffffff, 0.3);
			
			for(var i:uint = 1; i <= steps; i++){
				var ang:Number = arcStep * i;
				
				var pointX:Number = unscaledWidth / 2 + Math.cos(ang) * arcInnerRadius;
				var pointY:Number = unscaledHeight / 2 + Math.sin(ang) * arcInnerRadius;
				g.lineTo(pointX, pointY);
			}
			
			// Outter arc
			var endAngle:Number = percentage / 100 * Math.PI * 2;
			for(i=0; i<=steps; i++){
				ang = (endAngle - i * arcStep);
				pointX = unscaledWidth / 2 + Math.cos(ang) * outterRadius;
				pointY = unscaledHeight / 2 + Math.sin(ang) * outterRadius;
				g.lineTo(pointX, pointY);
			}
			
			// Close arc
			g.lineTo(startX, startY);
		}
		
	}
}
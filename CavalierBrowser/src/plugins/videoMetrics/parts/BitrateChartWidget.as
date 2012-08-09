package plugins.videoMetrics.parts
{
	import flash.events.VideoEvent;
	
	import frameworks.cavalier.app.events.MetricsEvent;
	
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.IAxis;
	
	import plugins.videoMetrics.parts.core.BaseChartWidget;
	import plugins.videoMetrics.skins.BitrateChartWidgetSkin;
	
	import spark.components.Label;
	import spark.formatters.NumberFormatter;

	[SkinState("multibitrate")]
	/**
	 * 
	 * 
	 * @author Nathan Weber
	 */
	public class BitrateChartWidget extends BaseChartWidget
	{
		//----------------------------------------
		//
		// Skin Parts
		//
		//----------------------------------------
		
		[SkinPart(required='false')]
		public var verticalLinearAxis:LinearAxis;
		
		[SkinPart(required='false')]
		public var timeToSwitchLabel:Label;
		
		[SkinPart(required='false')]
		public var bufferLengthAxis:LinearAxis;
		
		//****************************************
		//
		//			Private Variables
		//
		//****************************************
		private var verticalLinearAxisMax:Number = 0;
		private var bufferLengthAxisMax:Number = 0;
		private var numFormatter:NumberFormatter;
		
		//****************************************
		//
		//			Constants
		//
		//****************************************
		private const MAX_BUFFER_LENGTH:Number = 16;
		private const INTERVAL_SPACER:Number = 3;
		
		private static const MULTIBITRATE_STATE:String = 'multibitrate';
		private static const NORMAL_STATE:String = "normal";
		
		private static const TIME_TO_SWITCH_PRE_TEXT:String = '~';
		private static const TIME_TO_SWITCH_END_TEXT:String = 's Until Bitrate Change';
		
		private static const THOUSAND_KB:Number = 1000;
		private static const KB_LABEL:String = "K";
		private static const MB_LABEL:String = "M";
		private static const PRECISION_POINT:Number = 1;
		
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------
		
		private var _isMBR:Boolean = false;
		
		//----------------------------------------
		//
		// Properties
		//
		//----------------------------------------
		
		public function get isMBR():Boolean {
			return _isMBR;
		}
		
		public function set isMBR( value:Boolean ):void {
			if ( _isMBR == value ) {
				return;
			}
			
			_isMBR = value;
			trace(_isMBR);
			invalidateSkinState();
		}
		
		//----------------------------------------
		//
		// Internal Methods
		//
		//----------------------------------------
		
		override protected function getCurrentSkinState():String {
			
			if ( isMBR ) {
				return MULTIBITRATE_STATE;
			}
			else {
				return NORMAL_STATE;
			}
		}
		
		private function verticalAxisLabelFunction( labelValue:Object, previousValue:Object, axis:IAxis ):String {
			var axisLabel:Number = Number(labelValue);
			
			axisLabel = Math.round(axisLabel)
			if( axisLabel < THOUSAND_KB ) {
				return axisLabel.toString() + KB_LABEL;
			}
			
			axisLabel = axisLabel / THOUSAND_KB;
			
			return axisLabel.toFixed(PRECISION_POINT) + MB_LABEL;
		}
		
		private function bufferLengthAxisLabelFunction( labelValue:Object, previousValue:Object, axis:IAxis ):String
		{
			var bufferAxisLabel:Number = Number(labelValue);
			
			bufferAxisLabel = Math.round(bufferAxisLabel);
			
			return bufferAxisLabel.toFixed();
		}
		
		/**
		 * @private 
		 */		
		override protected function onMetricsUpdate( event:MetricsEvent ):void {
			super.onMetricsUpdate(event);
			
			if ( timeToSwitchLabel ) {
				timeToSwitchLabel.text = getTimeToSwitchText();
			}
			
			isMBR = metrics.calculateBitrateMetrics;

		}
		
		protected function getTimeToSwitchText():String {
			if ( !isNaN(metrics.timeUntilSwitch) ) {
				return String( TIME_TO_SWITCH_PRE_TEXT + formatNumber( metrics.timeUntilSwitch ) + TIME_TO_SWITCH_END_TEXT );
			}
			
			return null;
		}
		
		protected function formatNumber( value:Number ):String {
			if( !numFormatter ) {
				numFormatter = new NumberFormatter();
				numFormatter.trailingZeros = true;
				numFormatter.fractionalDigits = PRECISION_POINT;
			}
			return numFormatter.format( value );
		}
		
		/**
		 * @private 
		 */		
		override protected function generatePoint( time:Number ):Object {
			var p:Object = new Object();
			p.time = time;
			p.currentBitrate = metrics.currentBitrate;
			p.maximumBitrate = metrics.maxBitrate;
			p.bufferLength = metrics.bufferLength;
			//p.backBufferLength = videoMetrics.backBufferLength;
			
			return p;
		}
		protected override function updateSkinParts():void
		{	
			if(verticalLinearAxis)
			{
				var newVerticalLinearMax:Number = metrics.maxStreamBitrate;
				if(verticalLinearAxisMax != newVerticalLinearMax)
				{
					verticalLinearAxis.maximum = verticalLinearAxisMax = newVerticalLinearMax;
					verticalLinearAxis.interval = verticalLinearAxisMax / INTERVAL_SPACER;
				}
			}
			
			if(bufferLengthAxis)
			{
				var newBufferLengthMax:Number = metrics.bufferLength;
				
				if(bufferLengthAxisMax != newBufferLengthMax)
				{
					bufferLengthAxis.maximum = bufferLengthAxisMax = Math.max(newBufferLengthMax, MAX_BUFFER_LENGTH);
					bufferLengthAxis.interval = bufferLengthAxisMax / INTERVAL_SPACER;
				}
			}
			
			super.updateSkinParts();
		}
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		protected function handleBitrateChange( event:VideoEvent ):void {
			dispatchEvent( event.clone() );
		}
		
		protected override function partAdded( partName:String, instance:Object ):void {
			super.partAdded( partName, instance );
			
			if ( instance == verticalLinearAxis ) {
				verticalLinearAxis.labelFunction = verticalAxisLabelFunction;				
			}
			else if ( instance == bufferLengthAxis ){
				bufferLengthAxis.labelFunction = bufferLengthAxisLabelFunction;
			}
		}
		
		
		
		protected override function partRemoved( partName:String, instance:Object ):void {
			super.partRemoved( partName, instance );
			
			if ( instance == verticalLinearAxis ) {
				verticalLinearAxis.labelFunction = null;
			}
			else if ( instance == bufferLengthAxis ) {
				bufferLengthAxis.labelFunction = null;
			}
		}
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		/**
		 * Constructor. 
		 */		
		public function BitrateChartWidget() {
			super();
			setStyle("skinClass", BitrateChartWidgetSkin);
		}
	}
}
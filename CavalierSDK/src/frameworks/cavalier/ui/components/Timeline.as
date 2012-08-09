package frameworks.cavalier.ui.components
{
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import frameworks.cavalier.app.utils.TimeUtil;
	import frameworks.cavalier.ui.components.events.TimelineEvent;
	import frameworks.cavalier.ui.components.supportClasses.ITimelineMarker;
	import frameworks.cavalier.ui.components.supportClasses.ITimelineMarkerMetadata;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.DragManager;
	
	import org.osmf.metadata.TimelineMarker;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.primitives.BitmapImage;
	
	/**
	 * When an item (of type ITimelineMetadata) is dropped onto the timeline
	 */
	[Event(name="itemDrop", type="frameworks.cavalier.ui.components.events.TimelineEvent")]

	/**
	 * When a marker moves along the timeline
	 */
	[Event(name="itemMove", type="frameworks.cavalier.ui.components.events.TimelineEvent")]

	/**
	 * When a marker is resized
	 */
	[Event(name="itemResize", type="frameworks.cavalier.ui.components.events.TimelineEvent")]

	/**
	 * When a marker is selected
	 */
	[Event(name="itemSelect", type="frameworks.cavalier.ui.components.events.TimelineEvent")]
	
	public class Timeline extends Group
	{
		/**
		 * @private
		 */
		[Embed(source="skins/images/TimelineThumb.png")]
		public var thumbFace:Class;
		
		/**
		 * @public
		 */
		public var thumb:BitmapImage;
		
		/**
		 * @public
		 */
		public var showThumb:Boolean = true;
		
		/**
		 * @private
		 */
		private var tickGroup:Group;
		
		/**
		 * @private
		 */
		private var labelGroup:Group;
		
		/**
		 * @private
		 */
		private var markerGroup:Group;
		
		/**
		 * @public
		 */
		public var minGap:Number = 3;
		
		/**
		 * @public
		 */
		public var minTickInterval:Number = 1;
		
		/**
		 * @public
		 */
		public var minLabelInterval:Number = 5;
		
		/**
		 * @public
		 */
		public var gapIncrement:Number = 3;
		
		/**
		 * @public
		 */
		public var tickIncrement:Number = 5;
		
		/**
		 * @public
		 */
		public var labelIncrement:Number = 5;
		
		/**
		 * @private
		 */
		private var tickMeasurementChanged:Boolean = true;
		
		/**
		 * @private
		 */
		private var labelMeasurementChanged:Boolean = true;

		/**
		 * @private
		 */
		private var _totalTime:Number = 100;
		
		/**
		 * @public
		 */
		[Bindable]
		public function get totalTime():Number
		{
			return _totalTime;
		}
		
		/**
		 * @private
		 */
		public function set totalTime(value:Number):void
		{
			if(_totalTime != value){
				_totalTime = value;
				
				tickMeasurementChanged = true;
				labelMeasurementChanged = true;
				invalidateDisplayList();
			}
		}
		
		/**
		 * @private
		 */
		private var _gapPerSecond:Number = 3;
		
		/**
		 * @public
		 * 
		 * Gap between each second
		 */
		[Bindable]
		public function get gapPerSecond():Number
		{
			return _gapPerSecond;
		}
		
		/**
		 * @private
		 */
		public function set gapPerSecond(value:Number):void
		{
			var v:Number = Math.max(value, minGap);
			if(_gapPerSecond != v){
				_gapPerSecond = v;
				
				tickMeasurementChanged = true;
				labelMeasurementChanged = true;
				invalidateDisplayList();
			}
		}
		
		/**
		 * @private
		 */
		private var _secondsPerTick:Number = 10;
		
		/**
		 * @public
		 * 
		 * Over how many seconds do we draw a tick 
		 */
		[Bindable]
		public function get secondsPerTick():Number
		{
			return _secondsPerTick;
		}
		
		/**
		 * @private
		 */
		public function set secondsPerTick(value:Number):void
		{
			var v:Number = Math.max(value, minTickInterval);
			if(_secondsPerTick != v){
				_secondsPerTick = v;
				
				tickMeasurementChanged = true;
				invalidateDisplayList();
			}
		}
		
		/**
		 * @private
		 */
		private var _secondsPerLabel:Number = 30;
		
		/**
		 * @public
		 * 
		 * Over how many seconds do we draw a label
		 */
		[Bindable]
		public function get secondsPerLabel():Number
		{
			return _secondsPerLabel;
		}
		
		/**
		 * @private
		 */
		public function set secondsPerLabel(value:Number):void
		{
			var v:Number = Math.max(value, minLabelInterval);
			if(_secondsPerLabel != v){
				
				labelMeasurementChanged = true;
				invalidateDisplayList();
			}
		}
		
		/**
		 * @private
		 */
		private var _dataProvider:ArrayCollection;

		/**
		 * @private
		 */
		[Bindable]
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:ArrayCollection):void
		{
			if(_dataProvider != value){
				// Clear previous data
				if(_dataProvider)
					_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange);
				
				_dataProvider = value;
				if(_dataProvider)
					_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange, false, 0, true);
				
				// Clear previous markers
				if(markerGroup){
					markerGroup.removeAllElements();
					for each(var data:ITimelineMarkerMetadata in _dataProvider){
						addMarker(data);
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function onDataProviderChange(evt:CollectionEvent):void{
			var item:ITimelineMarkerMetadata;
			
			switch(evt.kind){
				case CollectionEventKind.ADD:
					for each(item in evt.items){
						addMarker(item);
					}
					break;
				case CollectionEventKind.REMOVE:
					for each(item in evt.items){
					removeMarker(item);
					}
					break;
			}
		}
		
		/**
		 * @public
		 */
		public var markerClass:Class;
		
		/**
		 * @private
		 */
		protected var markerLookup:Dictionary = new Dictionary(true);
		
		/**
		 * @private
		 */
		protected var dataLookup:Dictionary = new Dictionary(true);
		
		/**
		 * @public
		 */
		public var clustered:Boolean = true;
		
		/**
		 * @public
		 */
		public var verticalGap:Number = 5;
		
		/**
		 * @public
		 */
		public var selectedMarker:ITimelineMarker;
		
		/**
		 * @private
		 */
		private var mouseOrigin:Point;
		
		/**
		 * @private
		 */
		private var _currentTime:Number;

		/**
		 * @private
		 */
		[Bindable]
		public function get currentTime():Number
		{
			return _currentTime;
		}

		/**
		 * @private
		 */
		public function set currentTime(value:Number):void
		{
			_currentTime = value;
			if(thumb){
				thumb.x = gapPerSecond * _currentTime;
			}
		}

		
		/**
		 * Constructor
		 */		
		public function Timeline()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
			
			// Drag events
			addEventListener(DragEvent.DRAG_ENTER, onDragEnter, false, 0, true);
			addEventListener(DragEvent.DRAG_DROP, onDragDrop, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function init(evt:FlexEvent):void{
			// Ensure adding markers, if they are not already there
			if(_dataProvider && _dataProvider.length != 0 && markerGroup.numChildren != _dataProvider.length){
				markerGroup.removeAllElements();
				for each(var data:ITimelineMarkerMetadata in _dataProvider){
					addMarker(data);
				}
			}
		}
		
		/**
		 * @public
		 */
		public function zoomIn():void{
			if(secondsPerTick - tickIncrement >= minTickInterval
				&& secondsPerLabel - labelIncrement >= minLabelInterval){
				
				gapPerSecond += gapIncrement;
				secondsPerTick -= tickIncrement;				
				secondsPerLabel -= labelIncrement;
				
				// Adjust markers
				for each(var data:ITimelineMarkerMetadata in _dataProvider){
					var marker:ITimelineMarker = markerLookup[data] as ITimelineMarker;
					updateMarker(marker);
				}
			}
		}
		
		/**
		 * @public
		 */
		public function zoomOut():void{
			if(gapPerSecond - gapIncrement >= minGap){
				gapPerSecond -= gapIncrement;
				secondsPerTick += tickIncrement;
				secondsPerLabel += labelIncrement;
				
				// Adjust markers
				for each(var data:ITimelineMarkerMetadata in _dataProvider){
					var marker:ITimelineMarker = markerLookup[data] as ITimelineMarker;
					updateMarker(marker);
				}

			}
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(!tickGroup || !labelGroup)
				return;
			
			if(tickMeasurementChanged){
				tickMeasurementChanged = false;
				generateTicks();
			}
			
			if(labelMeasurementChanged){
				labelMeasurementChanged = false;
				generateLabels();
			}
		}
		
		/**
		 * @public
		 */
		public function generateLabels():void{
			labelGroup.removeAllElements();
			
			var numLabels:Number = totalTime / secondsPerLabel;
			for(var i:Number = 0; i < numLabels; i++){
				var label:Label = new Label();
				
				// Calculate the time represent by this label
				var time:Number = i * secondsPerLabel;
				label.text = TimeUtil.getTimeCode(time);
				
				// Calculate the position of the label
				label.x = time * gapPerSecond;
				
				labelGroup.addElement(label);
			}
		}
		
		/**
		 * @public
		 */
		public function generateTicks():void{
			var numTicks:Number = totalTime / secondsPerTick;
			var g:Graphics = tickGroup.graphics;
			g.clear();
			g.lineStyle(1, 0x333333);
			for(var i:Number = 0; i < numTicks; i++){
				var time:Number = i * secondsPerTick;
				var xPosition:Number = time * gapPerSecond;
				g.moveTo(xPosition, 0);
				g.lineTo(xPosition, tickGroup.height);
			}
		}

		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			// Ticks
			tickGroup = new Group();
			tickGroup.height = 20;
			addElement(tickGroup);
			
			// Labels
			labelGroup = new Group();
			labelGroup.top = 3;
			labelGroup.left = 3;
			addElement(labelGroup);
			
			// Thumb
			thumb = new BitmapImage();
			thumb.source = thumbFace;
			thumb.percentHeight = 100;
			thumb.visible = showThumb;
			addElement(thumb);
			
			// Markers
			markerGroup = new Group();			
			markerGroup.percentHeight = 100;
			
			addElement(markerGroup);
		}
		
		/**
		 * @public
		 */
		public function addMarker(data:ITimelineMarkerMetadata):void{
			var marker:ITimelineMarker = new markerClass();
			marker.data = data;
			updateMarker(marker);
			
			// Add to references
			markerLookup[data] = marker;
			dataLookup[marker] = data;
			
			// Add to group
			markerGroup.addElement(marker as IVisualElement);
			
			// Prevent bubbling mouse events
			(marker as UIComponent).addEventListener(MouseEvent.MOUSE_DOWN, onMarkerMouseDown, false, 0, true);
			
			// Resize events, if there is a "resizer" object defined
			if(marker.resizer != null){
				marker.resizer.addEventListener(MouseEvent.MOUSE_DOWN, onResizerMouseDown, false, 0, true);
			}
			
			// Listen to the change event to the metatdata, so that multiple timelines can sync with each other
			(data as EventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onMetadataChange);
		}
		
		/**
		 * @private
		 */
		private function onMetadataChange(evt:PropertyChangeEvent):void{
			var marker:ITimelineMarker = markerLookup[evt.source];
			if(marker)
				updateMarker(marker);
		}
		
		/**
		 * @public
		 */
		public function removeMarker(data:ITimelineMarkerMetadata):void{
			var marker:ITimelineMarker = markerLookup[data];
			if(marker){
				(marker as UIComponent).removeEventListener(MouseEvent.MOUSE_DOWN, onMarkerMouseDown);
				if(marker.resizer != null){
					marker.resizer.removeEventListener(MouseEvent.MOUSE_DOWN, onResizerMouseDown);
				}

				markerGroup.removeElement(marker as IVisualElement);
			}
			
			// Remove sync event
			(data as EventDispatcher).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onMetadataChange);
			
			delete markerLookup[data];
			delete dataLookup[marker];
			
			data = null;
			marker = null;
		}
		
		/**
		 * @public
		 */
		public function updateMarker(marker:ITimelineMarker):void{
			// Calculate the marker position and size based on current metrics
			var markerElement:IVisualElement = marker as IVisualElement;
			var animate:Animate = new Animate(markerElement);
			
			var xMp:SimpleMotionPath = new SimpleMotionPath("x");
			xMp.valueTo = marker.data.time * _gapPerSecond;
			
			var widthMp:SimpleMotionPath = new SimpleMotionPath("width");
			widthMp.valueTo = marker.data.length * _gapPerSecond;;
			
			
			var verticalMp:SimpleMotionPath;
			
			if(clustered){
				verticalMp = new SimpleMotionPath("height");
				verticalMp.valueTo = markerGroup.height;
			}
			else{
				verticalMp = new SimpleMotionPath("y");
				var index:Number = dataProvider.getItemIndex(marker.data);
				verticalMp.valueTo = index * (markerElement.height + verticalGap);
			}
			
			animate.motionPaths = Vector.<MotionPath>([xMp, widthMp, verticalMp]);
			animate.play();
		}
		
		/**
		 * @private
		 */
		private function onMarkerMouseDown(evt:MouseEvent):void{
			evt.stopPropagation();
			
			selectedMarker = evt.currentTarget as ITimelineMarker;
			mouseOrigin = new Point(evt.localX, evt.localY);
			
			// Initial dragging of marker
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMarkerMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMarkerMouseUp, false, 0, true);
			
			// Select the marker
			var selectEvent:TimelineEvent = new TimelineEvent(TimelineEvent.ITEM_SELECT, true);
			selectEvent.markerMetadata = selectedMarker.data;
			dispatchEvent(selectEvent);
		}

		/**
		 * @private
		 */
		private function onMarkerMouseMove(evt:MouseEvent):void{
			var markerGroupLocalPosition:Point = markerGroup.globalToLocal(new Point(evt.stageX, evt.stageY));
			
			(selectedMarker as IVisualElement).x = markerGroupLocalPosition.x - mouseOrigin.x;				
		}

		/**
		 * @private
		 */
		private function onMarkerMouseUp(evt:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMarkerMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMarkerMouseUp);

			// Fire up an update event to notify data providers
			var markerElement:IVisualElement = selectedMarker as IVisualElement;
			var time:Number = Math.floor((markerElement.x) / gapPerSecond);
			
			// Provide a valide time code
			time = Math.max(time, 0);
			time = Math.min(time, totalTime);
			
			var event:TimelineEvent = new TimelineEvent(TimelineEvent.ITEM_MOVE);
			event.markerMetadata = selectedMarker.data;
			event.time = time;
			dispatchEvent(event);
		}
		
		/**
		 * @private
		 */
		private function onDragEnter(evt:DragEvent):void{
			if(evt.dragSource.hasFormat("markerMetadata"))
				DragManager.acceptDragDrop(this);
		}
		
		/**
		 * @private
		 */
		private function onDragDrop(evt:DragEvent):void{
			// Calculate the time by mouse position
			var time:Number = Math.floor(mouseX / gapPerSecond);
			time = Math.min(time, totalTime);
			
			// Create a cue point metadata
			var cuePoint:ITimelineMarkerMetadata = evt.dragSource.dataForFormat("markerMetadata") as ITimelineMarkerMetadata; 
			var event:TimelineEvent = new TimelineEvent(TimelineEvent.ITEM_DROP);
			event.markerMetadata = cuePoint;
			event.time = time;
			dispatchEvent(event);
		}
		
		/**
		 * @private
		 */
		private function onResizerMouseDown(evt:MouseEvent):void{
			evt.stopPropagation();
			
			selectedMarker = evt.currentTarget.parent as ITimelineMarker;
			mouseOrigin = new Point(evt.localX, evt.localY);
			
			// Initial dragging of marker
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onResizerMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onResizerMouseUp, false, 0, true);
			
			// Select the marker
			var selectEvent:TimelineEvent = new TimelineEvent(TimelineEvent.ITEM_SELECT, true);
			selectEvent.markerMetadata = selectedMarker.data;
			dispatchEvent(selectEvent);
		}
		
		/**
		 * @private
		 */
		private function onResizerMouseMove(evt:MouseEvent):void{
			var markerGroupLocalPosition:Point = markerGroup.globalToLocal(new Point(evt.stageX, evt.stageY));
			var markerElement:IVisualElement = selectedMarker as IVisualElement;
			
			markerElement.width = Math.max(50, markerGroupLocalPosition.x - markerElement.x + mouseOrigin.x);				
		}
		
		/**
		 * @private
		 */
		private function onResizerMouseUp(evt:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onResizerMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onResizerMouseUp);
			
			// Fire up an update event to notify data providers
			var markerElement:IVisualElement = selectedMarker as IVisualElement;
			var newDuration:Number = Math.floor((markerElement.width) / gapPerSecond);
			
			// Provide a valide time code
			newDuration = Math.max(newDuration, 0);
			newDuration = Math.min(newDuration, totalTime);
			
			var event:TimelineEvent = new TimelineEvent(TimelineEvent.ITEM_RESIZE);
			event.markerMetadata = selectedMarker.data;
			event.time = newDuration;
			dispatchEvent(event);
		}
	}
}
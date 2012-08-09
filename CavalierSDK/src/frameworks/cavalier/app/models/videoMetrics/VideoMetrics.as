package frameworks.cavalier.app.models.videoMetrics
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.osmf.media.MediaPlayer;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;

	/**
	 * 
	 * 
	 * @author Nathan Weber
	 */
	public class VideoMetrics extends BaseMetrics
	{
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------
		
		public static var USING_STAGE_VIDEO_CHANGE:String = "usingStageVideoChange";
		public static var STAGE_VIDEO_RENDER_STATE_CHANGE:String = "stageVideoRenderStateChange";
		
		public var calculateDrmEndDate:Boolean = false;
		public var calculateFPSMetrics:Boolean = true;
		public var calculateBitrateMetrics:Boolean = false;
		public var calculateTimeMetrics:Boolean = false;
		public var calculateDisplayMetrics:Boolean = false;
		public var calculateBufferMetrics:Boolean = true;
		
		protected var mediaPlayer:MediaPlayer;
		protected var netStream:NetStream;
		
		private var _explicitFPS:Number;
		private var _currentFPS:Number;
		private var _currentStreamIndex:int;
		private var _currentBitrate:Number;
		private var _maxStreamIndex:int = -1;
		private var _maxAvailableStreamIndex:int = -1;
		private var _maxBitrate:int;
		private var _numDynamicStreams:int;
		private var _duration:Number;
		private var _displayWidth:Number;
		private var _displayHeight:Number;
		private var _displayAspectRatio:Number;
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		private var _screenAspectRatio:Number;
		private var _currentTime:Number;
		private var _bufferTime:Number;
		private var _bufferLength:Number;
		//private var _backBufferLength:Number;
		private var _drmEndDate:Date;
		private var _secondsUntilSwitch:Number = NaN;
		
		private var switchingBitrates:Boolean = false;
		
		private var _usingStageVideo:Boolean = false;
		private var _stageVideoRenderState:String = "";
		private var _maxStreamBitrate:Number;

		//----------------------------------------
		//
		// Properties
		//
		//----------------------------------------
		
		public function get maxStreamBitrate():Number
		{
			return _maxStreamBitrate;
		}

		public function set maxStreamBitrate(value:Number):void
		{
			_maxStreamBitrate = value;
		}

		/**
		 * The current FPS of the <code>NetStream</code>. 
		 */		
		public function get currentFPS():Number {
			if ( !isNaN( _explicitFPS ) ) {
				return _explicitFPS;
			}
			
			return _currentFPS;
		}
		
		/**
		 * @private 
		 */		
		public function set currentFPS( value:Number ):void {
			_explicitFPS = value;
		}
		
		/**
		 * The current bitrate index. 
		 */		
		public function get currentStreamIndex():int {
			return _currentStreamIndex;
		}
		
		/**
		 * The current bitrate value. 
		 */		
		public function get currentBitrate():Number {
			return _currentBitrate;
		}
		
		/**
		 * The maximum allowed bitrate index. 
		 */		
		public function get maxStreamIndex():int {
			return _maxStreamIndex;
		}
		
		public function get maxAvailableStreamIndex():int{
			return _maxAvailableStreamIndex;
		}
		
		public function set maxAvailableStreamIndex(value:int):void{
			_maxAvailableStreamIndex = value;
		}
		
		/**
		 * The maximum allowed bitrate value. 
		 */		
		public function get maxBitrate():int {
			return _maxBitrate;
		}

        /**
         *
         */
        public function get numDynamicStreams():int {
            return _numDynamicStreams;
        }

        /**
         *
         */
        public function get bufferLength():Number {
            return _bufferLength;
        }
		
		/*public function get backBufferLength():Number {
			return _backBufferLength;
		}*/

        /**
         *
         */
        public function get bufferTime():Number {
            return _bufferTime;
        }

        /**
         *
         */
        public function get currentTime():Number {
            return _currentTime;
        }

        /**
         *
         */
        public function get screenAspectRatio():Number {
            return _screenAspectRatio;
        }

        /**
         *
         */
        public function get screenHeight():Number {
            return _screenHeight;
        }

        /**
         *
         */
        public function get screenWidth():Number {
            return _screenWidth;
        }

        /**
         *
         */
        public function get displayAspectRatio():Number {
            return _displayAspectRatio;
        }

        /**
         *
         */
        public function get displayHeight():Number {
            return _displayHeight;
        }

        /**
         *
         */
        public function get displayWidth():Number {
            return _displayWidth;
        }

        /**
         *
         */
        public function get duration():Number {
            return _duration;
        }
		
		public function get drmEndDate():Date {
			return _drmEndDate;
		}
		
		/**
		 *
		 */
		public function get timeUntilSwitch():Number {
			return _secondsUntilSwitch;
		}
		
		[Bindable(event="usingStageVideoChange")]
		public function get usingStageVideo():Boolean{
			return _usingStageVideo;
		}
		
		public function set usingStageVideo(value:Boolean):void{
			if (_usingStageVideo == value){
				return;
			}
			
			_usingStageVideo = value;
			dispatchEvent(new Event("usingStageVideoChange"));
		}
		
		[Bindable(event="stageVideoRenderStateChange")]
		public function get stageVideoRenderState():String{
			return _stageVideoRenderState;
		}
		
		public function set stageVideoRenderState(value:String):void{
			if( _stageVideoRenderState == value){
				return;
			}

			_stageVideoRenderState = value;
			dispatchEvent(new Event("stageVideoRenderStateChange"));
		}
		
		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------
		
		public function refresh():void {
			updateMetrics();
		}
		
		public function getBitrateForStreamIndex( index:int ):Number {
			return mediaPlayer.getBitrateForDynamicStreamIndex( index );
		}
		
		//----------------------------------------
		//
		// Internal Methods
		//
		//----------------------------------------
		
		/**
		 * @private 
		 */		
		override protected function updateMetrics():void {
			if( calculateFPSMetrics ) {
				updateFPSMetrics();
			}
			if( calculateBitrateMetrics ) {
				updateBitrateMetrics();
			}
			if( calculateTimeMetrics ) {
				updateTimeMetrics();
			}
			if( calculateDisplayMetrics ) {
				updateDisplayMetrics();
			}
			if( calculateBufferMetrics ) {
				updateBufferMetrics();
			}
			if( calculateDrmEndDate ) {
				updateDrmEndDate();
			}
			
			super.updateMetrics();
		}
		
		private function updateDrmEndDate():void {
			if( mediaPlayer ) {
				_drmEndDate = mediaPlayer.drmEndDate;
			}
		}
		
		private function updateFPSMetrics():void {
			if( netStream ) {
				_currentFPS = netStream.currentFPS;
			}
		}
		
		private function updateBitrateMetrics():void {
			if( mediaPlayer ) {
				_currentStreamIndex = mediaPlayer.currentDynamicStreamIndex;
				_currentBitrate = mediaPlayer.getBitrateForDynamicStreamIndex( _currentStreamIndex );
				
				_maxStreamIndex = mediaPlayer.maxAllowedDynamicStreamIndex;	
				_numDynamicStreams = mediaPlayer.numDynamicStreams;
				
				if(numDynamicStreams > 0)
				{
					_maxStreamBitrate = getBitrateForStreamIndex(numDynamicStreams - 1);
				}
				_maxBitrate = mediaPlayer.getBitrateForDynamicStreamIndex( _maxStreamIndex );
				
				
				// If we are in the process of switching, a switch won't occur until we've played out the entire buffer.
				if ( switchingBitrates ) {
					_secondsUntilSwitch -= ( DEFAULT_UPDATE_INTERVAL / 1000 ); // update interval is in milliseconds
				}
				
				if ( _secondsUntilSwitch <= 0 || _currentStreamIndex == _maxStreamIndex ) {
					switchingBitrates = false;
					_secondsUntilSwitch = NaN;
				}
			}
		}
		
		private function updateTimeMetrics():void {
			if ( mediaPlayer ) {
				_duration = mediaPlayer.duration;
			}
		}
		
		private function updateDisplayMetrics():void {
			if ( mediaPlayer && mediaPlayer.media ) {
				if( mediaPlayer.media.hasTrait(MediaTraitType.DISPLAY_OBJECT) ){
					var doTrait:DisplayObjectTrait = mediaPlayer.media.getTrait( MediaTraitType.DISPLAY_OBJECT ) as DisplayObjectTrait;
					
					if( doTrait ){
						var displayObject:DisplayObject = doTrait.displayObject;
						if(displayObject){
							
							_displayWidth = displayObject.width;
							_displayHeight = displayObject.height;
							_displayAspectRatio = _displayWidth / _displayHeight;
							
							var stage:Stage = displayObject.stage;
							if (stage)
							{
								_screenWidth = stage.fullScreenWidth;
								_screenHeight = stage.fullScreenHeight;
								_screenAspectRatio = _screenWidth / _screenHeight;
								
								//NOTE: could add fullscreen details	
							}
						}
					}
				}
			}
		}
		
		private function updateBufferMetrics():void {
			if( netStream ){
				_currentTime = netStream.time;
				_bufferTime = netStream.bufferTime;
				_bufferLength = netStream.bufferLength;
				//_backBufferLength = netStream.backBufferLength;
			}
		}
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		protected function handleNetStatus( event:NetStatusEvent ):void {
			switch ( event.info.code ) {
				case NetStreamCodes.NETSTREAM_PLAY_TRANSITION:
					switchingBitrates = true;
					_secondsUntilSwitch = bufferLength;
					break;
				case NetStreamCodes.NETSTREAM_PLAY_START:
					//startMetrics();
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STOP:
					//stopMetrics();
					break;
			}
		}
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		/**
		 * Constructor.
		 *  
		 * @param mediaPlayer
		 * @param netStream
		 */		
		public function VideoMetrics( mediaPlayer:MediaPlayer, netStream:NetStream ) {
			super();
			
			this.mediaPlayer = mediaPlayer;
			this.netStream = netStream;
			
			if( netStream ) {
				netStream.addEventListener( NetStatusEvent.NET_STATUS, handleNetStatus, false, 0, true );
			}
		}
	}
}
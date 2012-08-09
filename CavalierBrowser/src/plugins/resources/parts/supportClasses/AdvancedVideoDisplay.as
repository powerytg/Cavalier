package plugins.resources.parts.supportClasses
{
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.net.NetStream;
	
	import frameworks.cavalier.app.events.MetricsEvent;
	import frameworks.cavalier.app.models.videoMetrics.VideoMetrics;
	
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfoResource;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetStreamLoadTrait;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.smil.SMILPluginInfo;
	import org.osmf.traits.MediaTraitType;
	
	import spark.components.VideoDisplay;
	
	use namespace mx_internal;
	
	public class AdvancedVideoDisplay extends VideoDisplay
	{
		/**
		 * @private
		 */
		protected var smilPlugin:SMILPluginInfo;
		
		/**
		 * @private
		 */
		protected var metrics:VideoMetrics;
		
		/**
		 * Constructor
		 */
		public function AdvancedVideoDisplay()
		{
			super();
		
			initPlugins();
			
			// Init media player
			mediaPlayer.autoDynamicStreamSwitch = true;
			
			addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onMediaPlayerStateChange);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		/**
		 * @private
		 */
		protected function initPlugins():void{
			smilPlugin = new SMILPluginInfo();
			var smilPluginResource:MediaResourceBase = new PluginInfoResource(smilPlugin);
			mx_internal::mediaFactory.loadPlugin(smilPluginResource);
		}
		
		/**
		 * @private
		 */
		private function onCreationComplete(evt:FlexEvent):void{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			if(systemManager.stage)
				systemManager.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);
		}
		
		/**
		 * @private
		 */
		private function onStageVideoAvailability(evt:StageVideoAvailabilityEvent):void{
			var stageVideoAvailable:Boolean = (evt.availability == StageVideoAvailability.AVAILABLE);
			if(stageVideoAvailable)
				addStageVideoListeners();
			else
				removeStageVideoListeners();
		}
		
		/**
		 * @private
		 */
		protected function addStageVideoListeners():void{
			if (systemManager.stage && systemManager.stage.stageVideos && systemManager.stage.stageVideos.length > 0){
				var stageVideo:StageVideo = systemManager.stage.stageVideos[0] as StageVideo;
				stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoRenderStateHandler, false, 0, true);
			}
		}
		
		/**
		 * @private
		 */
		protected function removeStageVideoListeners():void{
			if (systemManager.stage && systemManager.stage.stageVideos && systemManager.stage.stageVideos.length > 0){
				var stageVideo:StageVideo = systemManager.stage.stageVideos[0] as StageVideo;
				stageVideo.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoRenderStateHandler);
			}
		}

		/**
		 * @private
		 */		
		protected function stageVideoRenderStateHandler(event:StageVideoEvent):void{
			metrics.stageVideoRenderState = event.status;	
		}
		
		/**
		 * @public
		 */
		public function get mediaElement():MediaElement{
			return mediaPlayer? mediaPlayer.media : null;
		}
		
		private function getMediaResourceFromElement():MediaResourceBase {
			if( !mediaElement ) {
				return null;
			}
			
			var resource:MediaResourceBase;
			var proxiedElement:MediaElement = getProxiedElement();
			
			if( proxiedElement ) {
				return proxiedElement.resource;
			}
			else {
				return mediaElement.resource;
			}
		}
		
		private function getProxiedElement():MediaElement {
			var proxiedElement:MediaElement;
			
			if( mediaElement && mediaElement.hasOwnProperty( "proxiedElement" ) ) {
				proxiedElement = mediaElement[ "proxiedElement" ];
			}
			else {
				proxiedElement = null;
			}
			
			return proxiedElement;
		}
		
		/**
		 * @private
		 */
		protected function get mediaPlayer():MediaPlayer {
			return mx_internal::videoPlayer;
		}
		
		/**
		 * @private
		 */
		public function get netStream():NetStream
		{ 
			if( mediaElement ) {
				var loadTrait:NetStreamLoadTrait = mediaElement.getTrait( MediaTraitType.LOAD ) as NetStreamLoadTrait;
				if( loadTrait ) {
					return loadTrait.netStream;
				}
				else {
					return null;
				}
			}
			else {
				return null;
			}
		}
		
		/**
		 * Sets up the video metrics. 
		 */	
		protected function createMetrics():VideoMetrics {
			var metrics:VideoMetrics = new VideoMetrics( mediaPlayer, netStream );				
			
			var evt:MetricsEvent = new MetricsEvent(MetricsEvent.READY);
			evt.metrics = metrics;
			dispatchEvent(evt);
			
			return metrics;
		}

		/**
		 * @private
		 */
		protected function onMediaPlayerStateChange( event:MediaPlayerStateChangeEvent ):void {
			switch( event.state ) {
				case MediaPlayerState.READY:
					onMediaPlayerReady();
					break;
				case MediaPlayerState.PLAYING:
					onMediaPlayerPlaying();
					break;
				case MediaPlayerState.UNINITIALIZED:
					onMediaPlayerUninitialized();
					break;
				case MediaPlayerState.PAUSED:
					onMediaPlayerPaused();
					break;
			}
		}
		
		/**
		 * @private
		 */
		protected function onMediaPlayerReady():void {
			if ( !metrics ) {
				metrics = createMetrics();
			}
			
			updateMetricsCapabilities();
		}
		
		/**
		 * @private
		 */
		protected function onMediaPlayerPlaying():void {
			if ( !metrics ) {
				metrics = createMetrics();
			}
			
			metrics.startMetrics();
		}
		
		/**
		 * @private
		 */
		protected function onMediaPlayerUninitialized():void {
			if(metrics){
				metrics.stopMetrics();
				metrics = null;
			}			
		}
		
		/**
		 * @private
		 */
		protected function onMediaPlayerPaused():void {
			metrics.stopMetrics();			
		}
		
		/**
		 * @private
		 */
		protected function updateMetricsCapabilities():void{
			var resource:StreamingURLResource = getMediaResourceFromElement() as StreamingURLResource;
			if(metrics && resource)
				metrics.calculateBitrateMetrics = resource.hasOwnProperty("streamItems") && resource["streamItems"].length > 1;
			else
				metrics.calculateBitrateMetrics = false;
		}
		
	}
}
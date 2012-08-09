package frameworks.cavalier.app.models.jobs
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.ClipController;
	import frameworks.cavalier.app.controllers.JobController;
	import frameworks.cavalier.app.models.CDN;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.Playlist;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.MessageLevel;
	
	public class ClipJob extends Job
	{
		/**
		 * Constructor
		 */
		public function ClipJob(target:IEventDispatcher=null)
		{
			super(target);
			modelType = "Clip";
		}
		
		/**
		 * @public
		 */
		public function get clip():Clip{
			return payload as Clip;
		}
		
		/**
		 * @public
		 */
		override public function onSubmit():void{
			super.onSubmit();
			
			switch(action){
				case CRUDAction.CREATE:
					Aggregator.aggregator.pendingClips.addItem(clip);
					clip.cdn = Aggregator.aggregator.cdns.getItemAt(0) as CDN;
					break;
				case CRUDAction.DELETE:
					Aggregator.aggregator.selectedClip = null;
					
					// Remove any references from any playlists, and mark them dirty
					for each(var playlist:Playlist in Aggregator.aggregator.playlists){
						if(playlist.clips.contains(clip)){
							var job:PlaylistJob = new PlaylistJob();
							job.action = CRUDAction.UPDATE;
							job.payload = playlist;
							JobController.jobController.submitJob(job);
							
							playlist.clips.removeItemAt(playlist.clips.getItemIndex(clip));
						}
					}
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doCreateAction():void{
			ClipController.clipController.createOrUpdateClip(clip, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function revert():void{
			super.revert();
			
			switch(action){
				case CRUDAction.CREATE:
					if(Aggregator.aggregator.clips.contains(clip))
						Aggregator.aggregator.clips.removeItemAt(Aggregator.aggregator.clips.getItemIndex(clip));
					
					if(Aggregator.aggregator.pendingClips.contains(clip))
						Aggregator.aggregator.pendingClips.removeItemAt(Aggregator.aggregator.pendingClips.getItemIndex(clip));
					break;
				case CRUDAction.DELETE:
					var clipIndex:Number = Aggregator.aggregator.clips.getItemIndex(clip);
					Aggregator.aggregator.clips.setItemAt(originalClone, clipIndex);
					originalClone.status = ModelStatus.NORMAL;
					break;
				case CRUDAction.UPDATE:
					clip.cloneFrom(originalClone);
					clip.status = ModelStatus.NORMAL;
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doUpdateAction():void{
			ClipController.clipController.createOrUpdateClip(clip, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function doDeleteAction():void{
			ClipController.clipController.deleteClip(clip, onSuccess, onFault);
		}
		
		/**
		 * @private
		 */
		override protected function onSuccess():void{
			super.onSuccess();
			
			if(Aggregator.aggregator.pendingClips.contains(clip))
				Aggregator.aggregator.pendingClips.removeItemAt(Aggregator.aggregator.pendingClips.getItemIndex(clip));
			
			SystemBus.systemBus.newLog("[" + action + "]" + " on clip(id=" + clip.id + ") is successful.", MessageLevel.SUCCESSFUL);
		}
		
		/**
		 * @private
		 */
		override protected function onFault(message:String = null):void{
			super.onFault(message);
			SystemBus.systemBus.newLog("[" + action + "]" + " on clip(id=" + clip.id + ") failed.", MessageLevel.FAILED);
		}
		
	}
}
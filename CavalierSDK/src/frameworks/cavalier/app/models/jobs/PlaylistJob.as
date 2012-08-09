package frameworks.cavalier.app.models.jobs
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.PlaylistController;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.Playlist;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.MessageLevel;
	
	public class PlaylistJob extends Job
	{
		/**
		 * Constructor
		 */
		public function PlaylistJob(target:IEventDispatcher=null)
		{
			super(target);
			modelType = "Playlist";
		}
		
		/**
		 * @public
		 */
		public function get playlist():Playlist{
			return payload as Playlist;
		}
		
		/**
		 * @public
		 */
		override public function onSubmit():void{
			super.onSubmit();
			
			switch(action){
				case CRUDAction.CREATE:
					Aggregator.aggregator.pendingPlaylists.addItem(playlist);
					break;
				case CRUDAction.DELETE:
					Aggregator.aggregator.selectedPlaylist = null;
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doCreateAction():void{
			PlaylistController.playlistController.createOrUpdatePlaylist(playlist, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function revert():void{
			super.revert();
			
			switch(action){
				case CRUDAction.CREATE:
					if(Aggregator.aggregator.playlists.contains(playlist))
						Aggregator.aggregator.playlists.removeItemAt(Aggregator.aggregator.playlists.getItemIndex(playlist));
					
					if(Aggregator.aggregator.pendingPlaylists.contains(playlist))
						Aggregator.aggregator.pendingPlaylists.removeItemAt(Aggregator.aggregator.pendingPlaylists.getItemIndex(playlist));
					break;
				case CRUDAction.DELETE:
					var playlistIndex:Number = Aggregator.aggregator.playlists.getItemIndex(playlist);
					Aggregator.aggregator.playlists.setItemAt(originalClone, playlistIndex);
					originalClone.status = ModelStatus.NORMAL;
					break;
				case CRUDAction.UPDATE:
					playlist.cloneFrom(originalClone);
					playlist.status = ModelStatus.NORMAL;
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doUpdateAction():void{
			PlaylistController.playlistController.createOrUpdatePlaylist(playlist, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function doDeleteAction():void{
			PlaylistController.playlistController.deletePlaylist(playlist, onSuccess, onFault);
		}
		
		/**
		 * @private
		 */
		override protected function onSuccess():void{
			super.onSuccess();
			
			if(Aggregator.aggregator.pendingPlaylists.contains(playlist))
				Aggregator.aggregator.pendingPlaylists.removeItemAt(Aggregator.aggregator.pendingPlaylists.getItemIndex(playlist));
			
			SystemBus.systemBus.newLog("[" + action + "]" + " on playlist(id=" + playlist.id + ") is successful.", MessageLevel.SUCCESSFUL);
		}
		
		/**
		 * @private
		 */
		override protected function onFault(message:String = null):void{
			super.onFault(message);
			SystemBus.systemBus.newLog("[" + action + "]" + " on playlist(id=" + playlist.id + ") failed.", MessageLevel.FAILED);
		}
		
	}
}
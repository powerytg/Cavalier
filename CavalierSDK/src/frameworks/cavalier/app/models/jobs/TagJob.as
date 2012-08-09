package frameworks.cavalier.app.models.jobs
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.TagController;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.Tag;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.MessageLevel;
	
	public class TagJob extends Job
	{
		/**
		 * Constructor
		 */
		public function TagJob(target:IEventDispatcher=null)
		{
			super(target);
			modelType = "Tag";
		}
		
		/**
		 * @public
		 */
		public function get tag():Tag{
			return payload as Tag;
		}
		
		/**
		 * @public
		 */
		override public function onSubmit():void{
			super.onSubmit();
			
			switch(action){
				case CRUDAction.CREATE:
					Aggregator.aggregator.pendingTags.addItem(tag);
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doCreateAction():void{
			TagController.tagController.createOrUpdateTag(tag, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function revert():void{
			super.revert();
			
			switch(action){
				case CRUDAction.CREATE:
					if(Aggregator.aggregator.tags.contains(tag))
						Aggregator.aggregator.tags.removeItemAt(Aggregator.aggregator.tags.getItemIndex(tag));
					
					if(Aggregator.aggregator.pendingTags.contains(tag))
						Aggregator.aggregator.pendingTags.removeItemAt(Aggregator.aggregator.pendingTags.getItemIndex(tag));
					break;
				case CRUDAction.DELETE:
					var tagIndex:Number = Aggregator.aggregator.tags.getItemIndex(tag);
					Aggregator.aggregator.tags.setItemAt(originalClone, tagIndex);
					originalClone.status = ModelStatus.NORMAL;
					break;
				case CRUDAction.UPDATE:
					tag.cloneFrom(originalClone);
					tag.status = ModelStatus.NORMAL;
					break;
			}
		}
		
		/**
		 * @public
		 */
		override public function doUpdateAction():void{
			TagController.tagController.createOrUpdateTag(tag, onSuccess, onFault);
		}
		
		/**
		 * @public
		 */
		override public function doDeleteAction():void{
			TagController.tagController.deleteTag(tag, onSuccess, onFault);
		}
		
		/**
		 * @private
		 */
		override protected function onSuccess():void{
			super.onSuccess();
			
			if(Aggregator.aggregator.pendingTags.contains(tag))
				Aggregator.aggregator.pendingTags.removeItemAt(Aggregator.aggregator.pendingTags.getItemIndex(tag));
			
			SystemBus.systemBus.newLog("[" + action + "]" + " on tag(id=" + tag.id + ") is successful.", MessageLevel.SUCCESSFUL);
		}
		
		/**
		 * @private
		 */
		override protected function onFault(message:String = null):void{
			super.onFault(message);
			SystemBus.systemBus.newLog("[" + action + "]" + " on tag(id=" + tag.id + ") failed.", MessageLevel.FAILED);
		}
		
	}
}
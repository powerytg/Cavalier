package frameworks.cavalier.app.models.jobs
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.CommentController;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.ModelBase;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.MessageLevel;
	
	import mx.collections.ArrayCollection;
	
	public class AnnotationJob extends Job
	{
		/**
		 * @public
		 */
		public function get clip():Clip{
			return payload as Clip;
		}

		/**
		 * Constructor
		 */
		public function AnnotationJob(target:IEventDispatcher=null)
		{
			super(target);
			modelType = "Clip";
		}
		
		/**
		 * @public
		 */
		override public function get description():String{
			return "Annotations for clip(id=" + clip.id + ") has been modified";
		}
		
		/**
		 * @public
		 */
		override public function doUpdateAction():void{
			CommentController.commentController.updateAnnotations(clip, onSuccess, onFault);
		}
	
		/**
		 * @public
		 */
		override public function revert():void{
			super.revert();
			
			switch(action){
				case CRUDAction.UPDATE:
					clip.cloneFrom(originalClone);
					clip.status = ModelStatus.NORMAL;
					break;
			}
		}
		
		
		/**
		 * @private
		 */
		override protected function onSuccess():void{
			super.onSuccess();
			
			SystemBus.systemBus.newLog("Annotations have been updated for clip(id=" + clip.id + ").", MessageLevel.SUCCESSFUL);
		}
		
		/**
		 * @private
		 */
		override protected function onFault(message:String = null):void{
			super.onFault(message);
			SystemBus.systemBus.newLog("Updating annotations on clip(id=" + clip.id + ") failed.", MessageLevel.FAILED);
		}
	}
}
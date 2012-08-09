package frameworks.cavalier.app.models.jobs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.controllers.JobController;
	import frameworks.cavalier.app.models.ModelBase;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.ui.messaging.AlertIndicator;
	
	public class Job extends EventDispatcher
	{
		/**
		 * @public
		 * 
		 * One of the CRUD actions
		 */
		public var action:String;

		/**
		 * @public
		 */
		public var modelType:String = "Resource";
		
		/**
		 * @private
		 */
		private var _description:String = null;

		/**
		 * @public
		 */
		[Bindable]
		public function get description():String
		{
			if(_description == null){
				if(action == CRUDAction.CREATE)
					return modelType + " will be created";
				else if(action == CRUDAction.DELETE)
					return modelType + " (id=" + payload.id + ") will be removed";
				else if(action == CRUDAction.UPDATE)
					return modelType + " (id=" + payload.id + ") is set to be updated";
			}
			
			return _description;
		}

		/**
		 * @private
		 */
		public function set description(value:String):void
		{
			_description = value;
		}

		
		/**
		 * @public
		 */
		public var status:String = JobStatus.PENDING;
		
		/**
		 * @private
		 */
		protected var _payload:ModelBase;

		/**
		 * @public
		 * 
		 * The current living payload that exsits in Aggregrator
		 */
		public function get payload():ModelBase
		{
			return _payload;
		}

		/**
		 * @private
		 */
		public function set payload(value:ModelBase):void
		{
			_payload = value;
			originalClone = _payload.createClone();
		}

		
		/**
		 * @public
		 * 
		 * The 'original' payload before making changes. This is made into a clone before calling changes
		 */
		public var originalClone:ModelBase;
		
		/**
		 * Constructor
		 */
		public function Job(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		public function onSubmit():void{
			switch(action){
				case CRUDAction.CREATE:
					_payload.status = ModelStatus.PENDING;
					break;
				case CRUDAction.UPDATE:
					_payload.status = ModelStatus.DIRTY;
					break;
				case CRUDAction.DELETE:
					_payload.status = ModelStatus.DELETED;
					break;
			}
		}
		
		/**
		 * @public
		 */
		public function revert():void{
			var index:Number = JobController.jobController.jobs.getItemIndex(this);
			if(index != -1)
				JobController.jobController.jobs.removeItemAt(index);
		}
		
		/**
		 * @public
		 */
		public function doCreateAction():void{
			
		}
		
		/**
		 * @public
		 */
		public function doUpdateAction():void{
			
		}
		
		/**
		 * @public
		 */
		public function doDeleteAction():void{
			
		}
		
		/**
		 * @private
		 */
		protected function onSuccess():void{
			status = JobStatus.SUCCESS;
			_payload.status = ModelStatus.NORMAL;
			var index:Number = JobController.jobController.jobs.getItemIndex(this);
			if(index != -1)
		    	JobController.jobController.jobs.removeItemAt(index);
		}
		
		/**
		 * @private
		 */
		protected function onFault(message:String = null):void{
			status = JobStatus.FAILED;
			if(message){
				var indicator:AlertIndicator = new AlertIndicator();
				indicator.text = message;
				indicator.show();
			}
		}
		
		/**
		 * @public
		 */
		public function doAction():void{
			status = JobStatus.RUNNING;
			
			switch(action){
				case CRUDAction.CREATE:
					doCreateAction();
					break;
				case CRUDAction.DELETE:
					doDeleteAction();
					break;
				case CRUDAction.UPDATE:
					doUpdateAction();
					break;
			}
		}
		
	}
}
package frameworks.cavalier.app.controllers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.env.Environment;
	import frameworks.cavalier.app.models.Annotation;
	import frameworks.cavalier.app.models.AnnotationLayout;
	import frameworks.cavalier.app.models.Clip;
	import frameworks.cavalier.app.models.Comment;
	import frameworks.cavalier.app.models.CommentType;
	import frameworks.cavalier.app.models.sync.Aggregator;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class CommentController extends EventDispatcher
	{
		/**
		 * @private
		 */
		private static var _commentController:CommentController;
		
		/**
		 * @private
		 */
		public static function get commentController():CommentController
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():CommentController
		{
			if (_commentController == null){
				_commentController = new CommentController();
			}
			return _commentController;
		}
		
		/**
		 * Constructor
		 */
		public function CommentController()
		{
			super();
			if( _commentController != null ) throw new Error("Error:CommentController already initialised.");
			if( _commentController == null ) _commentController = this;
		}

		/**
		 * @public
		 */
		public function parseComments(commentCollectionXml:XMLList, clip:Clip):void{
			clip.comments.removeAll();
			clip.annotations.removeAll();
			
			for each(var commentXml:XML in commentCollectionXml.children()){
				var kind:String = String(commentXml.kind);
				var commentId:String = String(commentXml.id);
				if(kind == CommentType.COMMENT){
					var comment:Comment = new Comment();
					comment.id = commentId;					
					comment.content = String(commentXml.content);
					comment.date = comment.id = String(commentXml.date);
					clip.comments.addItem(comment);
				}
				else if(kind == CommentType.ANNOTATION){
					var annotation:Annotation = new Annotation();
					annotation.id = commentId;
					annotation.date = String(commentXml.date);
					annotation.content = String(commentXml.content);
					annotation.cuePoint = Number(commentXml.cue_point);
					annotation.duration = Number(commentXml.duration);
					
					var annotationLayout:AnnotationLayout = new AnnotationLayout();
					annotationLayout.horizontalAlign = String(commentXml.h_align);
					annotationLayout.verticalAlign = String(commentXml.v_align);
					annotationLayout.horizontalPadding = Number(commentXml.h_padding);
					annotationLayout.verticalPadding = Number(commentXml.v_padding);
					annotationLayout.width = Number(commentXml.width);
					annotationLayout.height = Number(commentXml.height);
					
					annotation.layout = annotationLayout;
					clip.annotations.addItem(annotation);
				}
			}
			
		}
		
		/**
		 * @public
		 */
		public function updateAnnotations(clip:Clip, successHandler:Function, faultHandler:Function):void{
			var xml:XML = <annotations></annotations>;
			
			// Translate annotations
			for each(var annotation:Annotation in clip.annotations){
				var node:XML = <annotation></annotation>;
				node.@content = annotation.content;
				node.@kind = "annotation";
				node.@cue_point = annotation.cuePoint;
				node.@duration = annotation.duration;
				node.@h_align = annotation.layout.horizontalAlign;
				node.@h_padding = annotation.layout.horizontalPadding;
				node.@v_align = annotation.layout.verticalAlign;
				node.@v_padding = annotation.layout.verticalPadding;
				node.@width = annotation.layout.width;
				node.@height = annotation.layout.height;
				
				xml.appendChild(node);
			}
			
			var params:Object = new Object();
			params.clip_id = clip.id;
			params.annotations = xml;	
			
			var service:HTTPService = new HTTPService();
			service.url = Environment.serverUrl + "/comment/update_annotations";
			service.resultFormat = "e4x";
			
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				if(successHandler != null)
					successHandler();
			}, false, 0, true);
			
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler();
			}, false, 0, true);
			
			service.send(params);			
		}
		
	}
}
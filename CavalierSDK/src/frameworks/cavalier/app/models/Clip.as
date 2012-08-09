package frameworks.cavalier.app.models
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	public class Clip extends ModelBase implements IAnalysisModel
	{
		
		/**
		 * @public
		 * 
		 * The title of the clip
		 */
		[Bindable]
		public var name:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var url:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var previewUrl:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var live:Boolean;
		
		/**
		 * @public
		 */
		[Bindable]
		public var dvr:Boolean;
		
		/**
		 * @public
		 */
		[Bindable]
		public var releaseDate:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var company:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var description:String;
		
		/**
		 * @public
		 * 
		 * Unit: seconds
		 */ 
		[Bindable]
		public var duration:Number = 0;
		
		/**
		 * @public
		 */
		[Bindable]
		public var brand:Brand;

		/**
		 * @public
		 */
		[Bindable]
		public var tags:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 */
		[Bindable]
		public var hashtags:ArrayCollection = new ArrayCollection(["#OSMF", "#FMS"]);
		
		/**
		 * @private
		 * 
		 * The combination of tags and hashtags
		 */
		[Bindable]
		public var combinedTags:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * Note that this is the "admin specified" ads. If this value is null, then the server will use its default rules to
		 * orchestrate the ads
		 */
		[Bindable]
		public var ads:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * A reference to the CDN
		 */
		[Bindable]
		public var cdn:CDN;
		
		/**
		 * @public
		 * 
		 * Comment collection
		 */
		[Bindable]
		public var comments:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * Annotation collection
		 */
		[Bindable]
		public var annotations:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 * 
		 * Whether to allow user comments
		 */
		[Bindable]
		public var allowComment:Boolean = true;
		
		/**
		 * Constructor
		 */
		public function Clip(target:IEventDispatcher=null)
		{
			super(target);
			tags.addEventListener(CollectionEvent.COLLECTION_CHANGE, onTagCollectionChange, false, 0, true);
			hashtags.addEventListener(CollectionEvent.COLLECTION_CHANGE, onTagCollectionChange, false, 0, true);
		}
		
		/**
		 * Copy all the properties (except id) from another clip
		 */
		override public function createClone():ModelBase{
			var clip:Clip = new Clip();
			clip.name = name;
			clip.url = url;
			clip.duration = duration;
			clip.previewUrl = previewUrl;
			clip.live = live;
			clip.dvr = dvr;
			clip.brand = brand;
			clip.allowComment = allowComment;
			clip.cdn = cdn;
			
			// Copy tags
			for each(var tag:Tag in tags){
				clip.tags.addItem(tag);
			}
			
			// Copy ads
			for each(var ad:AdCuePointEntry in ads){
				clip.ads.addItem(ad);
			}
			
			// Copy the comments
			for each(var comment:Comment in comments){
				clip.comments.addItem(comment);
			}
			
			// Copy annotations
			for each(var annotation:Annotation in annotations){
				clip.annotations.addItem(annotation);
			}
			
			// Copy hashtags
			clip.hashtags.removeAll();
			for each(var hashtag:String in hashtags){
				clip.hashtags.addItem(hashtag);
			}

			return clip;
		}

		/**
		 * Copy all the properties (except id) from another clip
		 */
		override public function cloneFrom(target:ModelBase):void{
			var clip:Clip = target as Clip;
			name = clip.name;
			url = clip.url;
			duration = clip.duration;
			previewUrl = clip.previewUrl;
			live = clip.live;
			dvr = clip.dvr;
			brand = clip.brand;
			allowComment = clip.allowComment;
			cdn = clip.cdn;
			
			// Copy tags
			tags.removeAll();
			tags.addAll(clip.tags);
			
			// Copy ads
			ads.removeAll();
			ads.addAll(clip.ads);
			
			// Copy the comments
			comments.removeAll();
			comments.addAll(clip.comments);
			
			// Copy annotations
			annotations.removeAll();
			annotations.addAll(clip.annotations);
			
			// Copy hashtags
			hashtags.removeAll();
			hashtags.addAll(clip.hashtags);
		}

		/**
		 * @private
		 *
		 */
		private function onTagCollectionChange(evt:CollectionEvent):void{
			switch(evt.kind){
				case CollectionEventKind.ADD:
					for each(var item:Object in evt.items){
						if(!combinedTags.contains(item)){
							combinedTags.addItem(item);
						}
					}
					break;
				
				case CollectionEventKind.REMOVE:
					for each(item in evt.items){
					if(combinedTags.contains(item))
						combinedTags.removeItemAt(combinedTags.getItemIndex(item));
				}
					break;
					
			}
		}
		
		/**
		 * @public
		 */
		public function getCommentById(id:String):Comment{
			for each(var comment:Comment in comments){
				if(comment.id == id)
					return comment;
			}
			
			return null;
		}
		
		/**
		 * @public
		 */
		public function getAnnotationById(id:String):Annotation{
			for(var i:uint = 0; i < annotations.length; i++){
				var annotation:Annotation = annotations.getItemAt(i) as Annotation;
				if(annotation.id == id)
					return annotation;
			}
			
			return null;
		}
		
		public function get resourceType():String
		{
			return "clip";
		}
		
		public function get resourceId():String
		{
			return id;
		}

		public function get graphColor():Number{
			return 0x07f0c7;
		}
	}
}
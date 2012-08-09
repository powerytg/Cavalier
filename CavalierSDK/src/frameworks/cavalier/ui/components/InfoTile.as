package frameworks.cavalier.ui.components
{
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;

	/**
	 * The info tile shows additional information on the surface. The title is always on
	 * the bottom right, while info is listed on top-left
	 */
	public class InfoTile extends ActionTile
	{
		/**
		 * @public
		 */
		public var title:String;
		
		/**
		 * @public
		 */
		public var infoContent:IVisualElement; 
		
		/**
		 * Constructor
		 */
		public function InfoTile()
		{
			super();
		}
	}
}
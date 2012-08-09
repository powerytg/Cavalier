package frameworks.cavalier.ui.components
{
	import frameworks.crescent.components.Tile;
	
	public class ActionTile extends Tile
	{
		/**
		 * @public
		 */
		[Bindable]
		public var icon:Class;
		
		/**
		 * Constructor
		 */
		public function ActionTile()
		{
			super();
			actAsButton = true;
		}
	}
}
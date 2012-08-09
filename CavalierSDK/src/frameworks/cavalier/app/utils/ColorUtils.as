package frameworks.cavalier.app.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ColorUtils extends EventDispatcher
	{
		/**
		 * @public
		 * 
		 * A pre-defined color sequence, used for coloring the field buttons
		 */
//		public static var colorScheme:Array = [0xf87d9c, 0xf8917d, 0xf8b87d, 0xf8d17d, 0xf8e97d,
//			0xd7e071, 0x8fc664, 0x64c692, 0x64a1c6, 0x6476c6,
//			0x8864c6, 0xd36ad3, 0xf59dab, 0xa1f0f5, 0x39d5e2,
//			0xd0ffbc, 0xbcddff
//		];
		
		public static var colorScheme:Array = [0xf369ff, 0xa669ff, 0x69c3ff, 0xfb8325, 0x82e4b6, 0xfe0c48];
		
		/**
		 * Constructor
		 */
		public function ColorUtils(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		public static function getRandomColor():Number{
			return colorScheme[MathUtils.randomRange(0, colorScheme.length - 1)];
		}
		
	}
}
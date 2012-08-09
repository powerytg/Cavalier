package frameworks.cavalier.app.utils
{
	public class DateUtil
	{
		/**
		 * @public
		 */
		public static const monthNames:Array = ["Oh My God", "January", "Feburary", "March", "April",
												"May", "June", "July", "August", "September",
												"October", "November", "December"];
		
		/**
		 * @public
		 */
		public static const COMMON_YEAR_DAYS_IN_MONTH:Array = [null, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			
		/**
		 * Constructor
		 */
		public function DateUtil()
		{
		}
		
		/**
		 * @public
		 */
		public static function getMonthName(month:Number):String{
			return monthNames[month];
		}
		
		/**
		 * @public
		 */
		public static function isGregorianLeap(year:Number):Boolean{
			return ( year % 4 == 0 ) && ( ( year % 100 != 0 ) || ( year % 400 == 0 ) );
		}
	
		/**
		 * @public
		 */
		public static function numDaysInMonth(month:Number, year:Number):Number{
			if(month == 2 && isGregorianLeap(year))
				return 29;
			else
				return COMMON_YEAR_DAYS_IN_MONTH[month];
		}
		
	}
}
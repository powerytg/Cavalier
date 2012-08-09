package frameworks.cavalier.ui.parts
{
	/**
	 * A StatisticUIPart is typically a date-time filter component, allowing to narrow down the range
	 * of selections. These UI parts will always be local based, meaning that their selection change does not 
	 * go beyond the host activity
	 */
	public class StatisticUIPart extends UIPart
	{
		/**
		 * Constructor
		 */
		public function StatisticUIPart()
		{
			super();
			affectedDomain = UIPartAffectedDomain.LOCAL;
		}
	}
}
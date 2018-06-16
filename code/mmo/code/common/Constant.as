package mmo.code.common
{
	public class Constant
	{
		public static const PJ_FOLDER:String = "E:/vstsworkspace/project2009/source/assets/";
		
		public static function getFileDir(fileName:String):String
		{
			return PJ_FOLDER + fileName;
		}
		
		public function Constant()
		{
		}
	}
}
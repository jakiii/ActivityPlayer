package mmo.code.scene
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mmo.play.scene.res.sceneitem.SceneItemConfigReader;
	
	public class Scene extends MovieClip
	{
		private const SCENE_ITEM_START_POSITION:Point = new Point(150,50);
		private const SCENE_ITEM_ROW_NUM:int = 14;
		
		public function Scene()
		{
			super();
			this.initSceneItemButtons();
		}
		
		private function initSceneItemButtons():void
		{
			var sceneItemDatas:Array = SceneItemConfigReader.instance.getSceneItemDatas("scene3");
			var buttons:Array = getSceneItemButtons(sceneItemDatas);
			var button:SceneItemButton = null;
			for(var i:int = 0;i < buttons.length;i++)
			{
				
				button = buttons[i];
				button.x = SCENE_ITEM_START_POSITION.x + button.width * int(i / SCENE_ITEM_ROW_NUM);
				button.y = SCENE_ITEM_START_POSITION.y + button.height * (i % SCENE_ITEM_ROW_NUM);
				this.addChild(button);
			}
		}
		
		private function getSceneItemButtons(sceneItemDatas:Array):Array
		{
			var list:Array = [];
			var button:SceneItemButton = null;
			for(var i:int = 0;i < sceneItemDatas.length;i++)
			{
				button = new SceneItemButton();
				button.setData(sceneItemDatas[i]);
				list.push(button);
			}
			return list.sortOn("actDate",Array.NUMERIC | Array.DESCENDING);
		}
	}
}
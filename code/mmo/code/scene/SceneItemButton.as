package mmo.code.scene
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import mmo.common.DateUtil;
	import mmo.loader.common.datastructures.ResourceObject;
	import mmo.play.activity.helper.Panel_Helper;
	import mmo.play.scene.res.sceneitem.SceneItemData;
	
	public class SceneItemButton extends MovieClip
	{
		private var _data:* = null;
		private var _actDate:int = 0;
		private var _isOutDate:Boolean = false;
		
		public function SceneItemButton()
		{
			super();
			this.buttonMode = true;
			this.mouseChildren = false;
			this.gotoAndStop(1);
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseOverListener);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseOutListener);
			this.addEventListener(MouseEvent.CLICK, onClickButtion);
		}
		
		private function onClickButtion(e:MouseEvent):void
		{
			var d:SceneItemData = _data;
			var fileXml:XML = (d.getActionParams().res as XMLList)[0] as XML;
			var res:ResourceObject = new ResourceObject(fileXml.@file, fileXml.@cls);
			Panel_Helper.loadResAndShow(res.resPath,res.clsName);
		}
		
		private function onMouseOutListener(e:MouseEvent):void
		{
			setNormalState();
		}
		
		private function setNormalState():void
		{
			if(_isOutDate)
			{
				this.gotoAndStop(2);
			}
			else
			{
				this.gotoAndStop(1);
			}
		}
		
		private function setOverState():void
		{
			if(_isOutDate)
			{
				this.gotoAndStop(2);
			}
			else
			{
				this.gotoAndStop(3);
			}
		}
		
		private function onMouseOverListener(e:MouseEvent):void
		{
			setOverState();
		}
		
		public function setData(data:*):void
		{
			_data = data;
			this.name = _data.getItemName();
			_actDate = getActDate(_data.getArrowKey());
			var todayDate:int = getTodayDate();
			_isOutDate = _actDate < todayDate;
			
			Panel_Helper.setTextValue(this,"txtchname",getButtonDesc());
			
			setNormalState();
		}
		
		private function getTodayDate():int
		{
			var date:Date = DateUtil.getServerTime();
			var todayDateStr:String = getDoubleStrNum(date.fullYear) + getDoubleStrNum(date.month+1) + getDoubleStrNum(date.date);
			return parseInt(todayDateStr);
		}
		
		private function getDoubleStrNum(num:int):String
		{
			var str:String = "000" + num;
			return str.substr(str.length-2);
		}
		
		private function getButtonDesc():String
		{
			var desc:String = getActName();
			if(_actDate > 0)
			{
				if(_isOutDate)
				{
					desc = "过期" + "|" + desc;
				}
				else
				{
					desc = _actDate.toString().substr(2) + "|" + desc;
				}
			}
			return desc;
		}
		
		private function getActName():String
		{
			var actName:String = "";
			if(_data.actChName.length > 0)
			{
				return _data.actChName;
			}
			else
			{
				return _data.getTips().split(" ")[0];
			}
		}
		
		private function getActDate(arrowKey:String):Number
		{
			var theDate:Number = 0;
			if(arrowKey != null && arrowKey.indexOf("_") != -1)
			{
				theDate = parseInt(arrowKey.split("_")[1]); 
			}
			return theDate;
		}
		
		public function get actDate():int
		{
			return _actDate;
		}
		
		public function get data():*
		{
			return _data;
		}
	}
}
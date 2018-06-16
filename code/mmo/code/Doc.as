package mmo.code
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mmo.ServerClient;
	import mmo.code.common.BinaryLoader;
	import mmo.code.common.Constant;
	import mmo.code.common.LoadService;
	import mmo.code.scene.Scene;
	import mmo.config.ConfigReader;
	import mmo.framework.comm.SocketClient;
	import mmo.loader.layer.LayerManager;
	import mmo.loader.scheduler.VersManager;
	import mmo.play.scene.res.sceneitem.SceneItemConfigReader;
	
	public class Doc extends Sprite
	{
		private var files:Array = [];
		private var fileNum:int = -1;
		private var config:XML;
		
		public function Doc()
		{
			init();
		}
		
		private function init():void
		{
			this.loadLoader();
		}
		
		private function loadLoader():void
		{
			new BinaryLoader(afterLoadedLoader).load(Constant.getFileDir("loader.swf"));
		}
		
		private function afterLoadedLoader(l:LoaderInfo):void
		{
			addChild(l.content);
			this.loadConfig();
		}
		
		private function loadConfig():void
		{
			VersManager.setVersionXml("", new XML(), new XML());
			ConfigReader.instance.addEventListener("onConfigLoadSuccess", onLoadConfig);
			ConfigReader.instance.loadConfig("config.xml");
		}
		
		private function onLoadConfig(evt:Event):void {
			this.files = ConfigReader.instance.libs;
			this.files.push("play");
			this.files.push("loader_res");
			this.loadSocket();
		}
		
		private function onConfigLoadFailure(e:Event):void
		{
			trace("load config.xml failed");
		}
		
		private function loadSocket():void 
		{
			var i:int = files.indexOf("library/socketserver");
			this.files.splice(i, 1);
			this.files = this.files.concat(ConfigReader.instance.playFiles);
			this.files = this.files.concat(ConfigReader.instance.playFiles1);
			this.files = this.files.concat(ConfigReader.instance.playFiles2);
			var stream:URLStream = new URLStream();
			stream.addEventListener(Event.COMPLETE, onLoadSocket);
			stream.load(new URLRequest(Constant.PJ_FOLDER + "library/socketserver1.swf"));
		}
		
		private function onLoadSocket(evt:Event):void
		{
			var stream:URLStream = evt.target as URLStream;
			var bytes:ByteArray = new ByteArray();
			stream.readBytes(new ByteArray(), 0, 8);
			stream.readBytes(bytes);
			stream.close();
			stream.removeEventListener(Event.COMPLETE, onLoadSocket);
			var classLoader:Loader = new Loader();
			classLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderClassComplete);
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			classLoader.loadBytes(bytes, loaderContext);
		}
		
		private function onLoaderClassComplete(evt:Event):void
		{
			LoaderInfo(evt.currentTarget).removeEventListener(Event.COMPLETE,onLoaderClassComplete);
			this.loadLibs();
		}
		
		private function loadLibs():void
		{						
			this.loadNext(null);
		}
		
		private function loadNext(evt:*):void
		{
			fileNum++;
			if (fileNum < files.length)
			{
				new BinaryLoader(loadNext).load(Constant.getFileDir(files[fileNum] + ".swf"));
			}
			else
			{
				this.onLoadAll();
			}
		}
		
		private function onLoadAll():void
		{
			this.initInstance();
		}
		
		private function initScene():void
		{
//			addChild(new Scene());
			LayerManager.getBaseScene().addChild(new Scene());
		}
		
		private function initServcies():void
		{
			var services:Array = ConfigReader.instance.services;
			services = services.concat(ConfigReader.instance.services1);
			services = services.concat(ConfigReader.instance.services2);
			new LoadService(services).initServices();
		}
		
		private function initInstance():void
		{
			SceneItemConfigReader.instance.loadConfig(this.initScene);
			ConfigReader.instance.initLocation();
			//serverIP:String, port:int, zone:String, userName:String, password:String, debug:Boolean = false
			ServerClient.instance.login("127.0.0.1",8888,"1","502359","111111");
			SocketClient.instance.init();
			LayerManager.init();
			this.initServcies();
		}
		
	}
}
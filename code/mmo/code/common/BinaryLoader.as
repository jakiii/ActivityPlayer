package mmo.code.common
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class BinaryLoader extends EventDispatcher
	{
		private var loaderSwfBtyes:ByteArray;
		private var callback:Function;
		
		public function BinaryLoader(callback:Function)
		{
			this.callback = callback;
		}
		
		public function load(file:String):void
		{
			var urlRequest:URLRequest = new URLRequest(file);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, onURLLoadSuccess);
			urlLoader.load(urlRequest);
		}
		
		private function onURLLoadSuccess(evt:Event):void
		{
			var urlLoader:URLLoader = evt.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onURLLoadSuccess);
			this.loaderSwfBtyes = urlLoader.data;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSuccess);
			loader.loadBytes(this.loaderSwfBtyes, new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function onLoadSuccess(evt:Event):void
		{
			var l:LoaderInfo = evt.target as LoaderInfo;
			l.removeEventListener(Event.COMPLETE, onLoadSuccess);
			this.callback.apply(null,[l]);
		}
	}
}
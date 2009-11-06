﻿package net.tw.util.air {
	import flash.events.*;
	import flash.filesystem.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	/**
	 * @author Quentin T - http://toki-woki.net
	 * @link http://elromdesign.com/blog/2009/01/14/adobe-air-15-downloadmanager-api-download-files-from-web-server-to-your-local-drive/
	 * @link http://www.flashrealtime.com/play-currently-downloading-video-in-air-filestream-and-bytearray/
	 */
	public class DownloadHelper {
		protected var _url:URLRequest;
		protected var _destination:File;
		protected var _stream:URLStream;
		//
		public function DownloadHelper(u:URLRequest=null, dest:File=null) {
			url=u;
			destination=dest;
			_stream=new URLStream();
		}
		public function set url(u:URLRequest):void {
			_url=u;
		}
		public function get url():URLRequest {
			return _url;
		}
		public function set destination(dest:File):void {
			_destination=dest;
		}
		public function get destination():File {
			return _destination;
		}
		public function get stream():URLStream {
			return _stream;
		}
		//
		public function start():void {
			_stream.addEventListener(Event.COMPLETE, onComplete);
			_stream.load(url);
		}
		protected function stop():void {
			_stream.close();
			_stream.removeEventListener(Event.COMPLETE, onComplete);
		}
		public function cancel():void {
			if (!_stream.connected) return;
			stop();
		}
		protected function onComplete(e:Event):void {
			var fs:FileStream=new FileStream();
			fs.open(_destination, FileMode.WRITE);
			//
			var ba:ByteArray=new ByteArray();
			_stream.readBytes(ba, 0, _stream.bytesAvailable);
			fs.writeBytes(ba, 0, ba.length);
			fs.close();
			//
			stop();
			ba.clear();
		}
	}
}
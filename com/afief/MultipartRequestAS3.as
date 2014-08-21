package com.afief {
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	public class MultipartRequestAS3 {
		
		private var arString:Array;
		private var arByte:Array;
		private var ure:URLRequest;
		private var boundary:String;

		public function MultipartRequestAS3(_url:String) {
			// constructor code
			
			arString = new Array();
			arByte = new Array();
			
			boundary = "bound" + new Date().time.toString() + Math.floor(Math.random() * 100);
			
			ure = new URLRequest(_url);
			ure.contentType = "multipart/form-data; boundary=" + boundary;
		}
		public function addHeader(name:String, value:String):void {
			ure.requestHeaders.push(new URLRequestHeader(name, value));
		}
		
		public function set url(_url:String):void {
			ure.url = _url;
		}
		public function get url():String {
			return ure.url;
		}
		public function set method(_method:String):void {
			ure.method = _method;
		}
		public function get method():String {
			return ure.method;
		}
		
		public function reset():void 	{
			ure = new URLRequest();
			arString = new Array();
			arByte = new Array();
		}

		public function addString(key:String, value:String, mimeType:String = "text/plain"):void {
			arString.push({key: key, value: value, mimeType: mimeType});
		}
		public function addByte(key:String, byte:ByteArray, mimeType:String = "image/jpeg", fileName:String = ""):void  {
			if (fileName == "") {
				fileName += "files_" + arByte.length + ".jpg";
			}
			
			arByte.push({key: key, value: byte, mimeType: mimeType, fileName: fileName});
		}
		
		public function get request():URLRequest
		{
			var dataBound:ByteArray = new ByteArray();
			
			function addDataFromString(_str:String):void {
				var ba:ByteArray = new ByteArray();
				ba.writeMultiByte(_str, "ascii");
				dataBound.writeBytes(ba, 0, ba.length);
			}
			function addDataFromByteArray(_byte:ByteArray):void {
				_byte.position = 0;
				dataBound.writeBytes(_byte, 0, _byte.length);
			}
			
			//create boundary file to dataBound variable
			for (var i = 0; i < arString.length; i++) {
				addDataFromString("--" + boundary + "\r\n"
						 +	"Content-Disposition: form-data; name='" + arString[i].key + "'\r\n"
						 +	"Content-Type: '" + arString[i].mimeType + "'\r\n\r\n"
						 +	arString[i].value + "\r\n");
			}
			for (i = 0; i < arByte.length; i++) {
				addDataFromString("--" + boundary + "\r\n"
						 +	"Content-Disposition: form-data; name='" + arByte[i].key + "'; filename='" + arByte[i].fileName + "'\r\n"
						 +	"Content-Type: '" + arByte[i].mimeType + "'\r\n\r\n");
				addDataFromByteArray(arByte[i].value);
				addDataFromString("\r\n");
			}
			addDataFromString('--' + boundary + '--\r\n');

			ure.data = dataBound;

			return ure;
		}
	}
	
}

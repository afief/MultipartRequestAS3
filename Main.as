package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.afief.MultipartRequestAS3;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import com.adobe.images.PNGEncoder;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	public class Main extends MovieClip {
		
		var multipart:MultipartRequestAS3;
		
		public function Main() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event) {
			
			var bmpd:BitmapData = new BitmapData(gambar.width, gambar.height, true);
			bmpd.draw(gambar);
			
			var byte:ByteArray = PNGEncoder.encode(bmpd);
			
			multipart = new MultipartRequestAS3("http://localhost/as3multipart/");
			multipart.method = URLRequestMethod.POST;
			multipart.addHeader("hello", "afief");
			
			multipart.addString("username", "afief");
			multipart.addString("password", "afynr");
			
			multipart.addByte("gambar", byte, "image/png", "fotouing.png");
			multipart.addByte("gambar2", byte, "image/png", "fotouing2.png");
			
			var urlo:URLLoader = new URLLoader();
			urlo.addEventListener(Event.COMPLETE, loaderCompleted);
			
			function loaderCompleted(e:Event):void {
				trace(urlo.data);
			}
			urlo.load(multipart.request);
		}
		
	}
	
}

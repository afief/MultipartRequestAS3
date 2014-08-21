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
			bmpd.draw(gambar); //create some movieclip from shape or anything, and set instance name to "gambar"
			
			var byte:ByteArray = PNGEncoder.encode(bmpd);
			
			multipart = new MultipartRequestAS3("http://localhost/as3multipart/");
			multipart.method = URLRequestMethod.POST;
			
			//you can add header to URLRequest inside the multipart class
			multipart.addHeader("about", "testing");
			
			//add string field, if you using PHP on server, it can acceessed from $_POST/$_GET variable, depends on URLRequest Method
			multipart.addString("username", "afief");
			
			//add byteArray as an image, if you using PHP on server, it can accessed from $_FILES variables
			multipart.addByte("gambar", byte, "image/png", "fotouing.png");
			
			//use URLLoader to send the request
			var urlo:URLLoader = new URLLoader();
			urlo.addEventListener(Event.COMPLETE, loaderCompleted);
			function loaderCompleted(e:Event):void {
				trace(urlo.data);
			}
			
			//don't forget to load from multipart.request
			urlo.load(multipart.request);
		}
		
	}
	
}

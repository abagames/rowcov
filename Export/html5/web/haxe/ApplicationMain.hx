#if nme


import com.abagames.rowcov.Main;
import nme.display.Bitmap;
import nme.display.Loader;
import nme.events.Event;
import nme.media.Sound;
import nme.net.URLLoader;
import nme.net.URLRequest;
import nme.net.URLLoaderDataFormat;
import nme.Assets;
import nme.Lib;


class ApplicationMain {
	
	
	private static var completed:Int;
	private static var preloader:NMEPreloader;
	private static var total:Int;
	
	public static var loaders:Hash <Loader>;
	public static var urlLoaders:Hash <URLLoader>;
	
	
	public static function main () {
		
		completed = 0;
		loaders = new Hash <Loader> ();
		urlLoaders = new Hash <URLLoader> ();
		total = 0;
		
		
		
		
		preloader = new NMEPreloader ();
		
		Lib.current.addChild (preloader);
		preloader.onInit ();
		
		
		
		if (total == 0) {
			
			begin ();
			
		} else {
			
			for (path in loaders.keys ()) {
				
				var loader:Loader = loaders.get (path);
				loader.contentLoaderInfo.addEventListener ("complete", loader_onComplete);
				loader.load (new URLRequest (path));
				
			}
			
			for (path in urlLoaders.keys ()) {
				
				var urlLoader:URLLoader = urlLoaders.get (path);
				urlLoader.addEventListener ("complete", loader_onComplete);
				urlLoader.load (new URLRequest (path));
				
			}
			
		}
		
	}
	
	
	private static function begin ():Void {
		
		preloader.addEventListener (Event.COMPLETE, preloader_onComplete);
		preloader.onLoaded ();
		
	}
	

   public static function getAsset(inName:String):Dynamic {
	   
		
		return null;
		
   }
   
   
   
   
   // Event Handlers
   
   
   
   
	private static function loader_onComplete (event:Event):Void {
		
		completed ++;
		
		preloader.onUpdate (completed, total);
		
		if (completed == total) {
			
			begin ();
			
		}
	   
	}
	
	
	private static function preloader_onComplete (event:Event):Void {
		
		preloader.removeEventListener (Event.COMPLETE, preloader_onComplete);
		
		Lib.current.removeChild(preloader);
		preloader = null;
		
		if (Reflect.field(com.abagames.rowcov.Main, "main") == null)
		{
			var mainDisplayObj = new com.abagames.rowcov.Main();
			if (Std.is(mainDisplayObj, jeash.display.DisplayObject))
				nme.Lib.current.addChild(cast mainDisplayObj);
		}
		else
		{
			Reflect.callMethod (com.abagames.rowcov.Main, Reflect.field (com.abagames.rowcov.Main, "main"), []);
		}
		
	}
   
   
}





#else


import com.abagames.rowcov.Main;


class ApplicationMain {
	
	
	public static function main () {
		
		if (Reflect.field(com.abagames.rowcov.Main, "main") == null) {
			
			new com.abagames.rowcov.Main();
			
		} else {
			
			Reflect.callMethod (com.abagames.rowcov.Main, Reflect.field (com.abagames.rowcov.Main, "main"), []);
			
		}
		
	}
	
	
}


#end
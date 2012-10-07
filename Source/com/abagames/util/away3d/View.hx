package com.abagames.util.away3d;
import com.abagames.util.Vector;
import nme.Lib;
import away3d.containers.View3D;
import away3d.containers.Scene3D;
import away3d.entities.Mesh;
import away3d.filters.BloomFilter3D;
import away3d.filters.DepthOfFieldFilter3D;
import away3d.lights.DirectionalLight;
import away3d.materials.lightpickers.StaticLightPicker;
class View {
	public var camera:Camera;
	public var view:View3D;
	public var light:DirectionalLight;
	public var lightPicker:StaticLightPicker;
	var scene:Scene3D;
	public function new() {
		view = new View3D();
		view.width = Lib.stage.stageWidth;
		view.height = Lib.stage.stageHeight;
		view.backgroundColor = 0;
		Lib.current.addChild(view);
		scene = view.scene;
		var bf = new BloomFilter3D(20, 20, 0.1, 4);
		view.filters3d = [bf];
		light = new DirectionalLight(-0.25, -0.5, 1);
		light.diffuse = 0.5;
		light.specular = 0.5;
		light.ambient = 0.2;
		view.scene.addChild(light);
		lightPicker = new StaticLightPicker([light]);
		camera = new Camera(view.camera);
	}
	public function render() {
		view.render();
	}
	public function addChild(mesh:Mesh):Void {
		scene.addChild(mesh);
	}
	public function removeChild(mesh:Mesh):Void {
		scene.removeChild(mesh);
	}
	public function reset():Void {
		while (scene.numChildren > 1) {
			var o = scene.getChildAt(1);
			scene.removeChild(o);
			o.dispose();
		}
	}
}
package com.abagames.util.threejs;
import com.abagames.util.Vector;
import nme.Lib;
class View {
	public var camera:Camera;
	var renderer:Dynamic;
	var scene:Dynamic;
	var container:Dynamic;
	var composer:Dynamic;
	public function new() {
		renderer = untyped __js__('new THREE.WebGLRenderer()');
		renderer.setSize(Lib.stage.stageWidth, Lib.stage.stageHeight);
		var color = untyped __js__('new THREE.Color(0, 1)');
		renderer.setClearColor(color);
		renderer.autoClear = false;
		renderer.shadowMapEnabled = true;
		renderer.shadowMapSoft = true;
		scene = untyped __js__('new THREE.Scene()');
		//scene.fog = untyped __js__('new THREE.Fog(0, 75, 100)');
		camera = new Camera();
		composer = untyped __js__('new THREE.EffectComposer(this.renderer)');
		var renderPass = untyped __js__('new THREE.RenderPass(this.scene, this.camera.camera)');
		composer.addPass(renderPass);
		var bloomPass = untyped __js__('new THREE.BloomPass(5)');
		composer.addPass(bloomPass);
		var shaderPass = untyped __js__('new THREE.ShaderPass(THREE.ShaderExtras[\"screen\"])');
		shaderPass.renderToScreen = true;
		composer.addPass(shaderPass);
		var dlightr = untyped __js__('new THREE.DirectionalLight(0x444444)');
		dlightr.position.set(0.25, 0.5, -1);
		scene.add(dlightr);
		var dlight = untyped __js__('new THREE.DirectionalLight(0xdddddd)');
		dlight.position.set(-0.25, -0.5, 1);
		dlight.castShadow = true;
		dlight.shadowDarkness = 0.2;
		scene.add(dlight);
		container = untyped __js__('window.document.getElementById(\"screen\")');
		container.appendChild(renderer.domElement);
	}
	public function render():Void {
		renderer.clear();
		composer.render();
	}
	public function addChild(mesh:Dynamic):Void {
		scene.add(mesh);
	}
	public function removeChild(mesh:Dynamic):Void {
		scene.remove(mesh);
	}
	public function reset():Void {
		while (scene.__objects.length > 0) {
			var o = scene.__objects[0];
			//renderer.deallocateObject(o);
			scene.remove(o);
		}
	}
}
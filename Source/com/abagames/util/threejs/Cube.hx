package com.abagames.util.threejs;
import com.abagames.util.Vector;
class Cube {
	public static var geometries:Hash<Dynamic> = new Hash<Dynamic>();
	public static var materials:Hash<Dynamic> = new Hash<Dynamic>();
	var view:View;
	var mesh:Dynamic;
	public function new(view:View, width:Float = 1, height:Float = 1, depth:Float = 1,
	color:Int = 0xffffff, alpha:Float = 1, hasLighting:Bool = true) {
		this.view = view;
		var gkey = width + "/" + height + "/" + depth;
		var geom;
		if (geometries.exists(gkey)) {
			geom = geometries.get(gkey);
		} else {
			geom = untyped __js__('new THREE.CubeGeometry(width, height, depth)');
			geom.computeBoundingSphere();
			geometries.set(gkey, geom);
		}
		var mkey = color + "/" + alpha;
		var mat;
		if (materials.exists(mkey)) {
			mat = materials.get(mkey);
		} else {
			if (hasLighting) mat = untyped __js__('new THREE.MeshLambertMaterial()');
			else mat = untyped __js__('new THREE.MeshBasicMaterial()');
			mat.color = untyped __js__('new THREE.Color(color)');
			mat.opacity = alpha;
			if (alpha < 1) mat.transparent = true;
			materials.set(mkey, mat);
		}
		mesh = untyped __js__('new THREE.Mesh(geom, mat)');
		mesh.boundRadius = geom.boundingSphere.radius;
		if (hasLighting) {
			mesh.castShadow = true;
			mesh.receiveShadow = true;
		}
		view.addChild(mesh);
	}
	public function remove():Void {
		view.removeChild(mesh);
	}
	public var x(getX, setX):Float;
	public var y(getY, setY):Float;
	public var z(getZ, setZ):Float;
	public var xyz(null, setXyz):Vector;
	public var scaleX(null, setScaleX):Float;
	public var scaleY(null, setScaleY):Float;
	public var scaleZ(null, setScaleZ):Float;
	public var visible(null, setVisible):Bool;
	function getX():Float { return mesh.position.x; }
	function getY():Float { return mesh.position.y; }
	function getZ():Float { return mesh.position.z; }
	function setX(v:Float):Float {
		mesh.position.x = v;
		return v;
	}
	function setY(v:Float):Float {
		mesh.position.y = v;
		return v;
	}
	function setZ(v:Float):Float {
		mesh.position.z = v;
		return v;
	}
	function setXyz(v:Vector):Vector {
		mesh.position.x = v.x;
		mesh.position.y = v.y;
		mesh.position.z = v.z;
		return v;
	}
	function setScaleX(v:Float):Float {
		mesh.scale.x = v;
		return v;
	}
	function setScaleY(v:Float):Float {
		mesh.scale.y = v;
		return v;
	}
	function setScaleZ(v:Float):Float {
		mesh.scale.z = v;
		return v;
	}
	function setVisible(v:Bool):Bool {
		mesh.visible = v;
		return v;
	}
}
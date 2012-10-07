package com.abagames.util.away3d;
import away3d.entities.Mesh;
import away3d.materials.ColorMaterial;
import away3d.materials.methods.SoftShadowMapMethod;
import away3d.materials.methods.FogMethod;
import away3d.primitives.CubeGeometry;
import com.abagames.util.Vector;
class Cube {
	public static var geometries:Hash<CubeGeometry> = new Hash<CubeGeometry>();
	public static var materials:Hash<ColorMaterial> = new Hash<ColorMaterial>();
	var view:View;
	var mesh:Mesh;
	public function new(view:View, width:Float = 1, height:Float = 1, depth:Float = 1,
	color:Int = 0xffffff, alpha:Float = 1, hasLighting:Bool = true) {
		this.view = view;
		var gkey = width + "/" + height + "/" + depth;
		var geom;
		if (geometries.exists(gkey)) {
			geom = geometries.get(gkey);
		} else {
			geom = new CubeGeometry(width, height, depth);
			geometries.set(gkey, geom);
		}
		var mkey = color + "/" + alpha + "/" + hasLighting;
		var mat;
		if (materials.exists(mkey)) {
			mat = materials.get(mkey);
		} else {
			mat = new ColorMaterial(color, alpha);
			if (hasLighting) {
				mat.addMethod(new FogMethod(75, 100, 0));
				mat.lightPicker = view.lightPicker;
				mat.shadowMethod = new SoftShadowMapMethod(view.light);
			}
			materials.set(mkey, mat);
		}
		mesh = new Mesh(geom, mat);
		if (hasLighting) mesh.castsShadows = true;
		view.addChild(mesh);
	}
	public function remove():Void {
		view.removeChild(mesh);
		mesh.dispose();
	}
	public var x(getX, setX):Float;
	public var y(getY, setY):Float;
	public var z(getZ, setZ):Float;
	public var xyz(null, setXyz):Vector;
	public var scaleX(null, setScaleX):Float;
	public var scaleY(null, setScaleY):Float;
	public var scaleZ(null, setScaleZ):Float;
	public var visible(null, setVisible):Bool;
	function getX():Float { return mesh.x; }
	function getY():Float { return mesh.y; }
	function getZ():Float { return mesh.z; }
	function setX(v:Float):Float {
		mesh.x = v;
		return v;
	}
	function setY(v:Float):Float {
		mesh.y = v;
		return v;
	}
	function setZ(v:Float):Float {
		mesh.z = v;
		return v;
	}
	function setXyz(v:Vector):Vector {
		mesh.x = v.x;
		mesh.y = v.y;
		mesh.z = v.z;
		return v;
	}
	function setScaleX(v:Float):Float {
		mesh.scaleX = v;
		return v;
	}
	function setScaleY(v:Float):Float {
		mesh.scaleY = v;
		return v;
	}
	function setScaleZ(v:Float):Float {
		mesh.scaleZ = v;
		return v;
	}
	function setVisible(v:Bool):Bool {
		mesh.visible = v;
		return v;
	}
}
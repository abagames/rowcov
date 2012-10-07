package com.abagames.util.threejs;
import com.abagames.util.Vector;
import nme.Lib;
class Camera {
	public var camera:Dynamic;
	public function new() {
		camera = untyped __js__('new THREE.PerspectiveCamera(45, 1, 0.1, 1000)');
		camera.aspect = Lib.stage.stageWidth / Lib.stage.stageHeight;
	}
	public var x(getX, setX):Float;
	public var y(getY, setY):Float;
	public var z(getZ, setZ):Float;
	public function lookAt(p:Vector):Void {
		camera.lookAt(p);
	}
	function getX():Float { return camera.position.x;  }
	function getY():Float { return camera.position.y;  }
	function getZ():Float { return camera.position.z;  }
	function setX(v:Float):Float {
		camera.position.x = v;
		return v;
	}
	function setY(v:Float):Float {
		camera.position.y = v;
		return v;
	}
	function setZ(v:Float):Float {
		camera.position.z = v;
		return v;
	}
}
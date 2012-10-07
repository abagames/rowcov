package com.abagames.util.away3d;
import flash.geom.Vector3D;
import away3d.cameras.Camera3D;
import com.abagames.util.Vector;
class Camera {
	var camera:Camera3D;
	var lookPos:Vector3D;
	public function new(camera:Camera3D):Void {
		this.camera = camera;
		camera.lens.near = 0.1;
		camera.lens.far = 1000;
		lookPos = new Vector3D();
	}
	public var x(getX, setX):Float;
	public var y(getY, setY):Float;
	public var z(getZ, setZ):Float;
	public function lookAt(p:Vector):Void {
		lookPos.x = p.x;
		lookPos.y = p.y;
		lookPos.z = p.z;
		camera.lookAt(lookPos);
	}
	function getX():Float { return camera.x;  }
	function getY():Float { return camera.y;  }
	function getZ():Float { return camera.z;  }
	function setX(v:Float):Float {
		camera.x = v;
		return v;
	}
	function setY(v:Float):Float {
		camera.y = v;
		return v;
	}
	function setZ(v:Float):Float {
		camera.z = v;
		return v;
	}
}
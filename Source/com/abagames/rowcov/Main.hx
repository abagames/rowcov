package com.abagames.rowcov;
import com.abagames.util.Dots;
import com.abagames.util.Frame;
import com.abagames.util.Actor;
import com.abagames.util.Color;
import com.abagames.util.Particle;
import com.abagames.util.Message;
import com.abagames.util.Screen;
import com.abagames.util.Key;
import com.abagames.util.Mouse;
import com.abagames.util.Vector;
import com.abagames.util.Random;
#if flash
import com.abagames.util.away3d.View;
import com.abagames.util.away3d.Camera;
import com.abagames.util.away3d.Cube;
#elseif js
import com.abagames.util.threejs.View;
import com.abagames.util.threejs.Camera;
import com.abagames.util.threejs.Cube;
#end
using Math;
using com.abagames.util.FloatUtil;
// To build for HTML5, you should modify the built rowcov.js code as below.
// l.619 jeash.Lib.jeashSetSurfaceOpacity(gfx.jeashSurface,fullAlpha);
//  v
//       jeash.Lib.jeashSetSurfaceOpacity(gfx.jeashSurface,0);
class Main extends Frame {
	public static var i:Main;
	var nextCoveDist:Float;
	var covePos:Vector;
	var coveVel:Vector;
	var coveSize:Float;
	var coveSizeVel:Float;
	var cameraVel:Vector;
	var damageVel:Vector;
	var lookAt:Vector;
	override public function initialize() {
		Main.i = this;
		title = "rowcov";
		isDebugging = false;
		view.reset();
		camera.x = camera.y = camera.z = 0;
		lookAt = new Vector(0, 0, 1);
		camera.lookAt(lookAt);
		camera.y = -Cove.BASE_SIZE / 4;
		cameraVel = new Vector();
		Cove.s = new Array<Cove>();
		Star.s = new Array<Star>();
		nextCoveDist = 0.0;
		covePos = new Vector(0, 0, 100);
		coveVel = new Vector();
		coveSize = Cove.BASE_SIZE;
		coveSizeVel = 0;
		damageVel = new Vector();
		Shield.i = new Shield();
		scroll(100);
		if (isInGame) Message.addOnce("USE MOUSE TO CONTROL", new Vector(70, 20));
	}
	override public function update() {
		Actor.updateAll(Cove.s);
		Actor.updateAll(Star.s);
		if (isInGame) {
			rank = ticks * 0.001;
			score += Std.int(rank * 10);
		} else {
			rank = 0.1;
		}
		scroll(rank);
		if (isInGame) {
#if flash
			cameraVel.x += (mouse.pos.x - screen.center.x) * 0.001;
#elseif js
			cameraVel.x -= (mouse.pos.x - screen.center.x) * 0.001;
#end
			cameraVel.y -= (mouse.pos.y - screen.center.y) * 0.001;
			cameraVel.scaleBy(0.9);
			camera.x += cameraVel.x;
			camera.y += cameraVel.y;
		}
		lookAt.x = camera.x + random.n(damageVel.x * 5);
		lookAt.y = camera.y + random.n(damageVel.y * 5);
		lookAt.z = camera.z + 1;
		camera.lookAt(lookAt);
		damageVel.scaleBy(0.75);
		if (isInGame) Shield.i.update();
		screen.drawText("FPS " + Std.int(fps), screen.size.x, 10, true);
	}
	public function checkHit(p:Vector, size:Float) {
		if (!isInGame) {
			camera.x += (p.x - camera.x) * 0.01;
			camera.y += (p.y - camera.y) * 0.01;
			return;
		}
		var dx = 0.0;
		var dy = 0.0;
		if (camera.x < p.x - size / 2) {
			camera.x = p.x - size / 2;
			if (cameraVel.x < 0) {
				cameraVel.x *= -1;
				dx = cameraVel.x;
			}
		} else if (camera.x > p.x + size / 2) {
			camera.x = p.x + size / 2;
			if (cameraVel.x > 0) {
				cameraVel.x *= -1;
				dx = cameraVel.x;
			}
		}
		if (camera.y < p.y - size / 2) {
			camera.y = p.y - size / 2;
			if (cameraVel.y < 0) {
				cameraVel.y *= -1;
				dy = cameraVel.x;
			}
		} else if (camera.y > p.y + size / 2) {
			camera.y = p.y + size / 2;
			if (cameraVel.y > 0) {
				cameraVel.y *= -1;
				dy = cameraVel.x;
			}
		}
		damageVel.x += dx;
		damageVel.y += dy;
		if (Shield.i.damage((Math.abs(dx) + Math.abs(dy)) * 50)) endGame();
		if (camera.y > 0) {
			camera.y = 0;
			if (cameraVel.y > 0) cameraVel.y *= -1;
		}
	}
	function scroll(v:Float) {
		nextCoveDist -= v;
		while (nextCoveDist <= 0) {
			coveVel.x += random.n(0.1) * random.pm();
			coveVel.y += random.n(0.1) * random.pm();
			coveVel.scaleBy(0.99);
			covePos.incrementBy(coveVel);
			if ((covePos.y > 0 && coveVel.y > 0) ||
				(covePos.y < -Cove.BASE_SIZE * 2 && coveVel.y < 0)) coveVel.y *= -0.5;
			coveSizeVel += random.n(0.1) * random.pm();
			coveSizeVel *= 0.99;
			coveSize += coveSizeVel;
			if ((coveSize < Cove.BASE_SIZE * 0.5 && coveSizeVel < 0) ||
				(coveSize > Cove.BASE_SIZE * 2 && coveSizeVel > 0)) coveSizeVel *= -0.5;
			Cove.s.push(new Cove(covePos, coveSize));
			Star.s.push(new Star());
			nextCoveDist += coveSize;
			covePos.z += coveSize;
		}
		camera.z += v;
	}
	public static function main() {
		new Main();
	}
}
class Cove extends Actor {
	public static inline var BASE_SIZE = 7.0;
	public static var s:Array<Cove>;
	public var size:Float;
	var cubes:Array<Cube>;
	public function new(p:Vector, size:Float) {
		super();
		this.size = size;
		cubes = new Array<Cube>();
		pos.xyz = p;
		var cp = new Vector();
		for (x in -1...2) {
			for (y in -1...2) {
				if (x == 0 && y == 0) continue;
				cp.x = p.x + x * size;
				cp.y = p.y + y * size;
				if (cp.y - size / 2 >= 0) continue;
				var height = size;
				var oh = 0.0;
				if (cp.y + size / 2 >= 0) height = -(cp.y - size / 2);
				var c = new Cube(Frame.i.view, BASE_SIZE, BASE_SIZE, BASE_SIZE, 0x5577dd);
				c.x = p.x + x * size;
				if (height < size) c.y = -height / 2;
				else c.y = p.y + y * size;
				c.z = p.z;
				c.scaleX = size * 0.9 / BASE_SIZE;
				c.scaleY = height * 0.9 / BASE_SIZE;
				c.scaleZ = size * 0.9 / BASE_SIZE;
				cubes.push(c);
			}
		}
	}
	override public function update():Bool {
		var cz = Frame.i.camera.z;
		if ((pos.z - cz).abs() < size / 2) Main.i.checkHit(pos, size);
		return pos.z > cz - 25;
	}
	override public function remove():Void {
		for (c in cubes) c.remove();
	}
}
class Star extends Actor {
	public static var s:Array<Star>;
	var cube:Cube;
	public function new() {
		super();
		cube = new Cube(Frame.i.view, 1, 1, 1, 0xccccff, 0.8, false);
		var camera = Frame.i.camera;
		cube.x = camera.x + random.n(300) * random.pm();
		cube.y = 100 + random.n(50);
		cube.z = camera.z + 500;
	}
	override public function update():Bool {
		return cube.z > Frame.i.camera.z + 200;
	}
	override public function remove():Void {
		cube.remove();
	}
}
class Shield {
	public static var i:Shield;
	public var dots:Dots;
	public var value = 50.0;
	var dp:Vector;
	public function new() {
		dots = new Dots([
			[Color.red, Color.yellow, Color.green],
			["1", "1", "1", "1", "1"], 0,
			["2", "2", "2", "2", "2"], 0,
			["3", "3", "3", "3", "3"], 0]);
		dp = new Vector();
	}
	public function update() {
		value += 0.1;
		if (value > 50) value = 50;
		dp.x = 1;
		dp.y = 2;
		for (i in 0...Std.int(value)) {
			var ci = 2;
			if (i < 10) ci = 0;
			else if (i < 30) ci = 1; 
			dots.draw(dp, ci);
			dp.x++;
		}
	}
	public function damage(v:Float) {
		value -= v;
		if (value <= 0) {
			value = 0;
			return true;
		}
		return false;
	}
}
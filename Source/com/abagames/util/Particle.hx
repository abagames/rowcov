package com.abagames.util;
#if flash
import com.abagames.util.away3d.Cube;
#elseif js
import com.abagames.util.threejs.Cube;
#end
class Particle extends Actor {
	public static var s:Array<Particle> = new Array<Particle>();
	public static var random:Random = new Random();
	public var ticks:Int = 0;
	var cube:Cube;
	public function new(color:Color) {
		super();
		cube = new Cube(Frame.i.view, 1, 1, 1, color.i, 0.5);
	}
	override public function update():Bool {
		pos.incrementBy(vel);
		vel.scaleBy(0.98);
		cube.xyz = pos;
		return --ticks > 0;
	}
	override public function remove():Void {
		cube.remove();
	}
	public static function add(p:Vector, color:Color, count:Int, speed:Float,
	ticks:Float = 30, angle:Float = 0, angleWidth:Float = 6.28):Void {
		for (i in 0...count) {
			var pt = new Particle(color);
			pt.pos.xy = p;
			pt.vel.addAngle(
				angle + random.n(angleWidth / 2) * random.pm(),
				speed * random.n(1, 0.5));
			pt.ticks = Std.int(ticks * random.n(1, 0.5));
			s.push(pt);
		}
	}
}
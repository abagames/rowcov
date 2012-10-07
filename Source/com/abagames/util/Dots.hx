package com.abagames.util;
import flash.display.BitmapData;
import nme.geom.Point;
class Dots {
	public static inline var XINV = -1;
	public static inline var YINV = -2;
	static var dotss:Array<Dots> = new Array<Dots>();
	public var shps:Array<DotsShape>;
	public var currentAnim = 0;
	public var hash = 0;
	public var isStatic = false;
	var bd:BitmapData;
	var pos:Vector;
	var point:Point;
	var isFirst = true;
	public function new(patterns:Array<Dynamic>) {
		bd = Frame.i.bd;
		pos = new Vector();
		point = new Point();
		var h = getHash(patterns);
		for (s in dotss) {
			if (s.hash == h) {
				shps = s.shps;
				return;
			}
		}
		hash = h;
		shps = new Array<DotsShape>();
		var colors:Array<Color> = patterns[0];
		var i:Int = 1;
		while (i < patterns.length) {
			var pattern:DotsPattern;
			if (Std.is(patterns[i], DotsPattern)) pattern = patterns[i];
			else pattern = new DotsPattern(patterns[i]);
			var rev:Int = patterns[i + 1];
			shps.push(new DotsShape(pattern, colors));
			if (rev == XINV) {
				shps.push(new DotsShape(pattern.clone().invertX(), colors));
			} else if (rev == YINV) {
				shps.push(new DotsShape(pattern.clone().invertY(), colors));
			} else if (rev > 1) {
				for (j in 1...rev) {
					shps.push(new DotsShape(
						pattern.clone().rotate(Math.PI * 2 * j / rev), colors));
				}
			}
			i += 2;
		}
		dotss.push(this);
	}
	function getHash(patterns:Array<Dynamic>):Int {
		var t:Int = 0;
		var cs:Array<Color> = patterns[0];
		for (c in cs) t += c.i;
		var pattern:DotsPattern;
		if (Std.is(patterns[1], DotsPattern)) pattern = patterns[1];
		else pattern = new DotsPattern(patterns[1]);
		t += pattern.getHash() * 3;
		t += cast(patterns[2], Int) * 7;
		t += patterns.length * 17;
		return t;
	}
	public function draw(p:Vector, animationIndex:Int = 0):Void {
		currentAnim = animationIndex;
		pos.x = Std.int(p.x - size.x / 2) * DotsShape.DOT_SIZE;
		pos.y = Std.int(p.y - size.y / 2) * DotsShape.DOT_SIZE;
		point.x = pos.x;
		point.y = pos.y;
		var s:DotsShape = shps[currentAnim];
		bd.copyPixels(s.bd, s.rect, point, null, null, true);
	}
	public var size(getSize, null):Vector;
	function getSize():Vector {
		return shps[currentAnim].size;
	}
}
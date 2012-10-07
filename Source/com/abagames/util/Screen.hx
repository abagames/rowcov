package com.abagames.util;
import nme.Lib;
class Screen {
	public var pixelSize:Vector;
	public var size:Vector;
	public var center:Vector;
	public var letterDots:Array<Dots>;
	static inline var LETTER_COUNT = 36;
	var tPos:Vector;
	public function new() {
		pixelSize = new Vector(Lib.stage.stageWidth, Lib.stage.stageHeight);
		size = new Vector(
			Std.int(pixelSize.x / DotsShape.DOT_SIZE),
			Std.int(pixelSize.y / DotsShape.DOT_SIZE));
		center = new Vector(size.x / 2, size.y / 2);
		tPos = new Vector();
		var letterPatterns = [
		0x4644aaa4, 0x6f2496e4, 0xf5646949, 0x167871f4, 0x2489f697, 0xe9669696, 0x79f99668, 
		0x91967979, 0x1f799976, 0x1171ff17, 0xf99ed196, 0xee444e99, 0x53592544, 0xf9f11119,
		0x9ddb9999, 0x79769996, 0x7ed99611, 0x861e9979, 0x994444e7, 0x46699699, 0x6996fd99,
		0xf4469999, 0xf248];
		letterDots = new Array<Dots>();
		var lp:Int = 0, d:Int = 32;
		var lpIndex:Int = 0;
		var ptn:DotsPattern;
		for (i in 0...LETTER_COUNT) {
			ptn = new DotsPattern();
			ptn.setSize(4, 5);
			for (j in 0...5) {
				for (k in 0...4) {
					if (++d >= 32) {
						lp = letterPatterns[lpIndex++];
						d = 0;
					}
					if (lp & 1 > 0) ptn.setDot(1, k, j);
					lp >>= 1;
				}
			}
			letterDots[i] = new Dots([[Color.white], ptn, 0]);
			letterDots[i].isStatic = true;
		}
	}
	public function drawText(text:String, x:Float, y:Float, isFromRight:Bool = false):Void {
		tPos.x = x;
		if (isFromRight) tPos.x -= text.length * 5;
		else tPos.x -= text.length * 5 / 2;
		tPos.y = y;
		for (i in 0...text.length) {
			var c = text.charCodeAt(i);
			var li:Int = -1;
			if (c >= 48 && c < 58) {
				li = c - 48;
			} else if (c >= 65 && c <= 90) {
				li = c - 65 + 10;
			} else if (c >= 97 && c <= 122) {
				li = c - 97 + 10;
			}
			if (li >= 0) letterDots[li].draw(tPos);
			tPos.x += 5;
		}
	}
	public function isIn(p:Vector, spacing:Float = 0):Bool {
		return p.x >= -spacing && p.x <= size.x + spacing && 
			p.y >= -spacing && p.y <= size.y + spacing;
	}
}
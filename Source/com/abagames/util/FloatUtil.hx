package com.abagames.util;
class FloatUtil {
	public static inline var PI = Math.PI;
	public static inline var PI2 = Math.PI * 2;
	public static function clamp(v:Float, min:Float, max:Float):Float {
		if (v > max) return max;
		else if (v < min) return min;
		return v;
	}
	public static function normalizeAngle(v:Float):Float {
		var r = v % PI2;
		if (r < -PI) r += PI2;
		else if (r > PI) r -= PI2;
		return r;
	}
}
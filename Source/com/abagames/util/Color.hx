package com.abagames.util;
class Color {
	private static inline var BASE_BRIGHTNESS = 24;
	private static inline var WHITENESS = 0;
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var brightness = 1.0;
	public function new(r:Int = 0, g:Int = 0, b:Int = 0) {
		this.r = r * BASE_BRIGHTNESS;
		this.g = g * BASE_BRIGHTNESS;
		this.b = b * BASE_BRIGHTNESS;
	}
	public var i(getI, null):Int;
	public var rgb(null, setRgb):Color;
	function getI():Int {
		return Std.int(
			Std.int(r * brightness) * 0x10000 + 
			Std.int(g * brightness) * 0x100 + 
			b * brightness);
	}
	function setRgb(c:Color):Color {
		r = c.r;
		g = c.g;
		b = c.b;
		return this;
	}
	public static var black:Color = new Color(0, 0, 0);
	public static var red:Color = new Color(10, WHITENESS, WHITENESS);
	public static var green:Color = new Color(WHITENESS, 10, WHITENESS);
	public static var blue:Color = new Color(WHITENESS, WHITENESS, 10);
	public static var yellow:Color = new Color(10, 10, WHITENESS);
	public static var magenta:Color = new Color(10, WHITENESS, 10);
	public static var cyan:Color = new Color(WHITENESS, 10, 10);
	public static var white:Color = new Color(10, 10, 10);
}
/**
 * Asciify
 * Actionscript 3 Class for creating Ascii Art from DisplayObjects
 *
 * @author		Pierluigi Pesenti
 * @version		1.0
 */

/*
Licensed under the MIT License

Copyright (c) 2008 Pierluigi Pesenti

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

http://blog.oaxoa.com/
*/

package com.oaxoa.fx{

	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.system.System;

	public class Asciify extends Sprite {

		private var _font:Font;
		private var _bd:BitmapData;
		private var _tfield:TextField;
		private var _tformatSample:TextFormat;

		private var _picW:uint;
		private var _picH:uint;
		private var _pixels:Array;
		private var _charsX:uint;
		private var _pixelSize:Number;
		private var _colors:Array;
		private var _chars:Array;
		private var _matrix:Matrix;
		private var _targetClip:DisplayObject;
		private var _negative:Boolean;

		public function Asciify(targetClip:DisplayObject, $tField, pixelSize:Number=8, negative:Boolean=false) {
			
			_tfield = $tField;
			_negative=negative;
			
			initFormats();
			sampleChars();

			_targetClip=targetClip;
			_pixelSize=pixelSize;

			var initw:Number=targetClip.width;
			var inith:Number=targetClip.height;
			
			targetClip.visible=false;

			_picW=initw/_pixelSize;
			_picH=inith/_pixelSize;

			
			_matrix=new Matrix();
			_matrix.scale(1/_pixelSize, 1/_pixelSize);

			render();
		}
		
		private function initFormats():void {

			_tformatSample=new TextFormat();
			_tformatSample.font="Arial";
			_tformatSample.size=16;
			_tformatSample.color=0;
		}
		
		public function render():void {
			
			_tfield.text="";
			var output:String="";
			
			var i:uint;
			var j:uint;
			
			_bd=new BitmapData(_picW, _picH);
			_bd.draw(_targetClip, _matrix);

			_pixels=new Array();

			for (i=0; i<_picH; i++) {
				var row:Array=new Array();
				for (j=0; j<_picW; j++) {
					var sampledColor:Number=_bd.getPixel(j, i);
					if(_negative) sampledColor=0xffffff-sampledColor;
					row.push(sampledColor);
				}
				_pixels.push(row);
			}

			for (i=0; i<_picH; i++) {
				for (j=0; j<_picW; j++) {
					var color:Number=_pixels[i][j];
					var rgb:Object=hex2rgb(color);
					var avg:Number=rgb.r+rgb.g+rgb.b;
					output+=getCharFromColor(avg);
					
				}
				output+="\r\n";

			}
			
			_tfield.appendText(output);
			_tfield.autoSize="left";
			
		}

		private function sampleChars():void {
			_colors=[];
			_chars=[];

			var i:uint;
			var c:uint=0;

			var mini:uint=32;
			var maxi:uint=256;
			
			for (i=mini; i<maxi; i++) {
				_colors.push(c);
				c+=3;
			}
			for (i=mini; i<maxi; i++) {
				
				var cc:String=String.fromCharCode(i);
				_chars.push({char:cc, darkness:getDarkness(cc)});
				_chars.sortOn("darkness", Array.NUMERIC | Array.DESCENDING);

			}
		}
		
		private function getDarkness(char):uint {
			var i:uint;
			var j:uint;

			var tf:TextField=new TextField();
			tf.defaultTextFormat=_tformatSample;
			tf.text=char;
			tf.embedFonts=true;
			tf.autoSize="left";

			var w:uint=tf.width;
			var h:uint=tf.height;

			var bd:BitmapData=new BitmapData(w, h);
			bd.draw(tf);

			var darkness:uint=0;

			for (i=0; i<h; i++) {
				for (j=0; j<w; j++) {
					var col=bd.getPixel(j, i);
					if (col<0x333333) {
						darkness++;
					}
				}
			}
			return darkness;
		}

		private function hex2rgb(hex:Number):Object {
			var r:Number;
			var g:Number;
			var b:Number;
			r = (0xFF0000 & hex) >> 16;
			g = (0x00FF00 & hex) >> 8;
			b = (0x0000FF & hex);
			return {r:r,g:g,b:b};
		}
		
		private function getCharFromColor(arg:uint):String {
			var i:uint=0;
			for each (var col in _colors) {
				if (arg<=col) {
					return _chars[i].char;
				}
				i++;
			}
			return " ";
		}
		
	}
}
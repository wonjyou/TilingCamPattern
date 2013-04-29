// 
// Maven Interactive
// 
// Copyright (c) 2008 Won You, All rights reserved.
// 
// THIS FILE AND THE SOFTWARE OF WHICH IT IS A CONSTITUENT ("THE SOFTWARE") IS
// PROPRIETARY AND CONFIDENTIAL.  YOU MAY ONLY USE THE SOFTWARE IN ACCORDANCE
// WITH ITS LICENSE AND ANY APPLICABLE AGREEMENTS.
// 
// Unless required by applicable law or agreed to in writing, The Software
// is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied.
// 
// Development by Won J. You
// maven-interactive.com
// 

package com.maven
{
    import flash.display.*;
    import flash.events.*;
	import flash.ui.*;
	import flash.text.*;
	import flash.net.*;	
	import flash.utils.*;
	import flash.media.Camera;
	import flash.media.Video;
	
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;


    public class PatternMain extends MovieClip
    {        
		public var timeline : MovieClip;			
		
		public var patternArray:Array = new Array();
		
		private var checkTimer:Timer; 
		
		private var cam		:Camera;
		private var video	:Video;
		private var now		:BitmapData;
		private var out		:BitmapData;
		private var output 	:Bitmap;
		
		//Webcam settings
		private var camFPS	:Number 	= 30;
		private var camW	:Number 	= 80;
		private var camH	:Number 	= 60;

		public var isLoading:Boolean = true;
		
		public var patternSize:Number = 17;	//the size of the pattern being tiled (assumes a square in dimensions)
	
		
		public function PatternMain()
        {
			trace("\nPatternMain constructed");

			try{
				
				timeline = this;
				
				addEventListener(Event.ADDED_TO_STAGE, init);
				
				//	init();
			}
			catch ( e:Error ){
				trace("Error: problem encountered within Main with " + e);
			}
			
		}
		
		public function init(evt:Event = null) : void
		{
			trace("init called");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
				
			//  Stage settings
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;				
				
			repositionStage();

			
			stage.addEventListener(Event.RESIZE, repositionStage);
			
			initShell();
		}
	
	
		//___________________________________________________________Initialize the main elements
		
		private function initShell() : void
		{
			trace("initShell called");
			
			setTiles();
			
			//Set up the webcam
			video = new Video(camW, camH);
		
			cam = Camera.getCamera();
			
			cam.setMode(160, 120, camFPS);

			if (cam == null) {
				
			} else {
				
				video.attachCamera(cam);
				video.deblocking = 2; 
				
				camMC.addChild(video);
			
				now = new BitmapData(video.width, video.height);
				output = new Bitmap(now);
				
				camMC.addChild(output);
				output.x = 0; 
				output.y = 0;

				checkTimer = new Timer(100);
				checkTimer.addEventListener(TimerEvent.TIMER, render);
				checkTimer.start();
				
			}		
			
		}
		
		private function render ( evt:Event = null ) : void 
		{
		
			if (!cam.currentFPS) return;
			
			now.draw(video);
			
			setColors();

		}
		
		//___________________________________________________________Generate the tiles
		
		private function resetTiles() : void
		{
			trace("resetTiles called");
			
			var max:Number = patternArray.length;
			
			try{
				for (var i:Number = 0; i<max; i++){
					
					if (patternMC.getChildAt(0) != null){
						patternMC.removeChild(patternMC.getChildAt(0));
					}
					patternArray.pop();
				}
			}
			catch (e:Error){
				
			}
		}
		
		private function setTiles() : void
		{
			trace("setTiles called");
			
			var tileWidth:Number = Math.ceil(stage.stageWidth/patternSize);
			var tileHeight:Number = Math.ceil(stage.stageHeight/patternSize);
			
			var xPos:Number = 0;
			var yPos:Number = 0;
			var rowCounter:Number = 0;
			var i:Number = 0;
			
			resetTiles();
			
			patternArray = new Array();

			for (i=0; i<tileWidth; i++){
				var tempArray:Array=new Array();

				for (var j:Number = 0; j<tileHeight; j++){
					var mc:circleMC = new circleMC();
				
					mc.x = i*patternSize;
					mc.y = j*patternSize;
					
					patternMC.addChild(mc);
					
					tempArray.push(mc);
				}
				
				patternArray[i] = tempArray;
				//patternArray.push(tempArray);
			}
			
		}

		private function setColors( evt:Event = null ) : void 
		{
			//trace("setColors called");
			
			var tileWidth:Number = Math.ceil(stage.stageWidth/patternSize);
			var tileHeight:Number = Math.ceil(stage.stageHeight/patternSize);
			
			var ratioX:Number = video.width/stage.stageWidth;
			var ratioY:Number = video.height/stage.stageHeight;
			var col;
			var counter:Number = 0;
			var clr:ColorTransform= new ColorTransform();
			
			try{
				for (var i:int = 0; i < tileWidth; i++) {
					
					for (var j:int = 0; j < tileHeight; j++) {
						
						var pt1:Point = new Point( Math.floor(i*patternSize*ratioX) , Math.floor(j*patternSize*ratioY) );
						col= now.getPixel(pt1.x, pt1.y);
						if (col != null){
							clr.color =col; //normal
							//clr.color =col>>8; // modify to blue
							
							patternArray[i][j].transform.colorTransform = clr;	
						}
					}
					
				}
			}
			catch (e:Error){}
		}
	
		//___________________________________________________________Reposition handler
	
		 private function repositionStage(evt:Event = null) : void 
		 {
			trace("repositionStage called");

			camMC.x = Math.round((stage.stageWidth-camMC.width)/2);
			camMC.y = Math.round(stage.stageHeight-camMC.height);
			
			setTiles();
		}
	
	}

}
// 
// Maven Interactive
// 
// Copyright (c) 2008 Won You, All rights reserved.
// 
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
	
	import com.gskinner.geom.ColorMatrix;
	import flash.filters.ColorMatrixFilter;
	
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import com.maven.effects.*;

    public class HalfToneMain extends MovieClip
    {        
		public var timeline : MovieClip;			
		
		private var checkTimer:Timer; 
		
		private var cam		:Camera;
		private var video	:Video;
		private var now		:BitmapData;
		
		//Webcam settings
		private var camFPS	:Number 	= 30;
		private var camW	:Number 	= 1000;
		private var camH	:Number 	= 600;

		public var isLoading:Boolean = true;
		
		public function HalfToneMain()
        {
			trace("\nHalfToneMain constructed");

			try{
				
				timeline = this;
				
				//  Stage settings
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;				
		
				init();
				
				repositionStage();
			}
			catch ( e:Error ){
				trace("Error: problem encountered within Main with " + e);
			}
			
		}
		
		public function init() : void
		{
			trace("init called");

			stage.addEventListener(Event.RESIZE, repositionStage);
			
			initShell();
		}
	
	
		//___________________________________________________________Initialize the main elements
		
		private function initShell() : void
		{
			trace("initShell called");
	
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

				//Turn to greyscale
				var cm:ColorMatrix = new ColorMatrix();
				cm.adjustColor(0, 0, -100, 0);
				camMC.filters = [new ColorMatrixFilter(cm)];
				
				checkTimer = new Timer(5000);
				checkTimer.addEventListener(TimerEvent.TIMER, render);
				checkTimer.start();

			}
			
		}
		
		private function render ( evt:Event = null ) : void 
		{
		
			if (!cam.currentFPS) return;
			
			now.draw(video);
			
			Halftone.draw( holderMC, now, 5, 16777215, false, 5, true);
		}
		

		//___________________________________________________________Reposition handler
	
		 private function repositionStage(evt:Event = null) : void 
		 {
			trace("repositionStage called");

			camMC.x = Math.round((stage.stageWidth-camMC.width)/2);
			camMC.y = Math.round(stage.stageHeight-camMC.height);

		}
	
	}

}
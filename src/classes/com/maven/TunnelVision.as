// 
// Maven Interactive
// 
// Copyright (c) 2009 Won You, All rights reserved.
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
    import flash.media.*;
	import flash.utils.*;

    public class TunnelVision extends MovieClip
    {
        public var alter:Number;
        public var vid:Video;
		
		private var bitmapArray:Array = new Array();
		private var dataArray:Array = new Array();
		
		private var checkTimer:Timer; 
		
        public var i:Number;
		
        public var cam:Camera;
		
		public var counter:Number; 
		
		public var total:Number;
		public var scaleIncrement:Number = 0.10;
		
        public function TunnelVision()
        {
			stage.quality = StageQuality.LOW;
            stage.align = "TL";
            stage.scaleMode = "noScale";
			
            init();
        }

        function init()
        {
			trace("init called");

            cam = Camera.getCamera();
            cam.setMode(320, 240, 50, false);

	   
			if (cam == null) {
				
			} else {
				vid = new Video(cam.width * 0.2, cam.height * 0.2);
				vid.attachCamera(cam);
				vid.smoothing = true;
				
				genTunnel();
				
				stage.addEventListener(Event.RESIZE, resizeHandler);
				
				checkTimer = new Timer(100);
				checkTimer.addEventListener(TimerEvent.TIMER, loop);
				checkTimer.start();
			}
        }

        public function genTunnel()
        {
			trace("genTunnel called");
			
            var totalCount:Number = 1/ scaleIncrement;
			var counter:Number = 0;
			var scaleFactor:Number;
			
            i = 0;
            
            alter = 1;
			
            while (i < totalCount)
            {
				
                if (!bitmapArray[i]){
                    bitmapArray[i] = new BitmapData(vid.width, vid.height, false, 0);
                    dataArray[i]= new Bitmap(bitmapArray[i]);
                    addChild(dataArray[i]);
                }
				
				scaleFactor = 1-i*scaleIncrement;
				
				dataArray[i].width = stage.stageWidth*scaleFactor;
				dataArray[i].height = stage.stageHeight*scaleFactor;
				
                dataArray[i].x = Math.round((stage.stageWidth- dataArray[i].width)/2);
                dataArray[i].y = Math.round((stage.stageHeight- dataArray[i].height)/2);
				
                i++;
            }

			total = bitmapArray.length;
			
			bitmapArray.reverse();
        }

        public function loop(evt:Event) : void
        {
		
			i= total;
            bitmapArray[0].draw(vid);
			
            while (i-->0 )
            {  
				if (bitmapArray[i-1] != null){
					bitmapArray[i].draw(bitmapArray[i - 1]);
				}
            }

        }

        public function resizeHandler(evt:Event)
        {
            genTunnel();

        }

    }
}

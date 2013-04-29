
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

package com.maven.frameworks
{
	
	/*
	*  Maintains a list of constants that are needed universally by the slideshow
	* 
	*/
    public class Constants extends Object
    {
		static public const CSS_PATH:String = "../css/flash.css";
		
		//---------------------------------------------------------------------------------------------------
		// Default Values
		//---------------------------------------------------------------------------------------------------

		static public const SLIDESHOW_TIMER:Number = 6000; //The number of milliseconds for the switching between articles
		static public const ANIMATION_SPEED:Number = 0.6;
		static public const EASE_TYPE:String = "Quad.easeOut";
		static public const BGCOLOR = "0x333333";
		
		static public const FLICKR_API:String = "572d1db8aa5bf01574d61a30b24e75c4";

        public function Constants()
        {
            return;
        }

    }
}

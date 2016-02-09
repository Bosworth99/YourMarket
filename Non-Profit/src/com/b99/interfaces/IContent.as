///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>interfaces>IContent.as
//
//	extends : sprite
//
//	interface to define content type 
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.interfaces 
{
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public interface IContent 
	{
		function assignLibrary(index:uint)			:void;
		function instantiateLibraryItem(index:uint)	:void;
		function assembleDisplayObjects()			:void;
		function animateContentIn()					:void;
		function animateInComplete()				:void;
		function addEventHandlers()					:void;
		function animateContentOut()				:void;
		function animateOutComplete()				:void;
		function removeEventHandlers()				:void;
		function reset()							:void;
		
		function get camDirection()					:String;
	}
}
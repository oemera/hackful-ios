/*-----------------------------------------------------------------------------------*/
/*	Start Custom jQuery
/*-----------------------------------------------------------------------------------*/

$(document).ready(function(){
	
/*-----------------------------------------------------------------------------------*/
/*	Configure Slides and Feature List
/*-----------------------------------------------------------------------------------*/

	$('ul.features li.top-row').equalize('height');
	
	$('#slides').cycle({timeout:5000,pause:1});
	
/*-----------------------------------------------------------------------------------*/
/*	Tab & Panel Switches
/*-----------------------------------------------------------------------------------*/
	
	$('#tabs li').click(function(){
	
			// Get current and clicked panels
			var current = '#' + $('#tabs li.current').attr('data-panel');
			var clicked = '#' + $(this).attr('data-panel');
			
			// Toggle tabs
			$('#tabs li').removeClass('current');
			$(this).addClass('current');
			
			
			$(current).hide();
			$(clicked).show();
			

			/*$(current).fadeTo(400, 0, function(){
				
				//$(current).slideUp(400, function(){
					
					$(clicked).fadeTo(100, 100);
				//	$(clicked).slideDown(400);
					
				//});
				
			});*/
			
	});
	
/*-----------------------------------------------------------------------------------*/
/*	Thats all folks!
/*-----------------------------------------------------------------------------------*/

});
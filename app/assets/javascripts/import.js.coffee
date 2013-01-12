# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
window.importModel = (url, model_name) ->
	$('#'+model_name+'_msg').text('正在处理...').css('color', 'red')
	$.post url, (data) ->
		$('#'+model_name+'_msg').text('处理完成...').css('color', 'blue')

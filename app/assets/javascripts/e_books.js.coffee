# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
adfly_shorten = (url) ->
  $.get '/webstorage_links/adfly_shorten.json?url='+url, (data) -> $('#webstorage_link_ad_link').val data.ad_link 

$(document).ready ->
  $('#webstorage_link_url').blur ->
    adfly_shorten this.value

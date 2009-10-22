$(function(){
  $('input').bind('click',function(event){$(this).val('')});
  $('#about').bind('click',function(event){$('#more-info').toggle('blind')});
  //$('#discogs dl').load('discogs')
  $.get('/discogs/' + $('#artist')[0].innerHTML + '/' + $('#track')[0].innerHTML, function(data) { $('#discogs dl').html(data); $('#loading').fadeOut(); });
});

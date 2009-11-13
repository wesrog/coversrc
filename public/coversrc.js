$(function(){
  $('input').bind('click',function(event){$(this).val('')});
  $('#about').bind('click',function(event){$('#more-info').toggle('blind'); $('#about').blur();});

  $.get('/discogs/wesr', function(data) { $('#discogs-releases').html(data); });
});

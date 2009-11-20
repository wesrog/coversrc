$(function(){
  $('input').bind('click',function(event){$(this).val('')});
  $('#about').bind('click',function(event){$('#more-info').toggle('blind'); $('#about').blur();});

  $.get('/lastfm', function(data) { $('#lastfm-data').html(data); });
  $.get('/discogs', function(data) { $('#discogs-releases').html(data); });
});

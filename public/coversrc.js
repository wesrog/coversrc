$(function(){
  $('input').bind('click',function(event){$(this).val('')});
  $('#about').bind('click',function(event){$('#more-info').toggle('blind'); $('#about').blur();});

  if($('#artist')[0]) {
    url = '/discogs/' + $('#artist')[0].innerHTML + '/' + $('#track')[0].innerHTML;
    $.get(url, function(data) { $('#discogs dl').html(data); });
  }
});

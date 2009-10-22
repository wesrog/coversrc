$(function(){
  $('input').bind('click',function(event){$(this).val('')});
  $('#more-info').bind('click',function(e){$(this.toggle('blind'))});
});

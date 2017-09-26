# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require flowplayer
#= require rails-ujs
#= require_tree .

window.pollTV = ($) ->
  $.ajax
    url: '/tv/index.json'
    method: 'GET'
    success: (data, status, xhr) ->
#      console.log(data.online)
#      console.log(data.content)
      player = $(data.content)

      console.log(player.has('.player')[0] != undefined )
      console.log($('#player .player').length == 0)


      if(player.has('.player') and $('#player .player').length == 0)
        $('#player').empty()
        $('#player').append(player)

      $('#player .player').flowplayer()

  window.setTimeout(pollTV, 3000, $)


jQuery ->

  $('#player_modal .modal-close').on 'click', (e) ->
    e.preventDefault()
    $(this).parent().removeClass('is-active').hide()
    $(this).parent().find('video')[0].pause()
    $(this).parent().find('.player').remove()
#
#
  $('.gallery-text').on 'click', (e) ->
    e.preventDefault()

    player = $('<div class="player"><video width="720" height="404"><source type="video/mp4"/></video></div>')

    player.find('source').attr(src: $(this).attr('href'))

    $('#player_modal .modal-content').append(player)
    $('#player_modal .player').flowplayer()
    $('#player_modal').addClass('is-active').show()

  if($(document).has('#player'))
    window.pollTV(jQuery)


  #        alert(data.status)
#        if data.status == 200
#          player = $('<div class="player" data-debug="true" data-engine="flash"><video width="720" height="404"><source type="video/flash"/></video></div>')
#          player.find('source').attr(src: data.src)
#          $('#player').append(player)
#          $('#player .player').flowplayer()
#        else if data.status == 404
#          player = $("<img src='#{data.src}' width='720' height='404' />")
#          $('#player').append(player)

  $('#tabTV').on 'click', (e) ->
    e.preventDefault()
    $('#program').hide()
    $('#player').show()
    $('#tabProgram').parent().removeClass('is-active')
    $('#tabTV').parent().addClass('is-active')

  $('#tabProgram').on 'click', (e) ->
    e.preventDefault()
    $('#program').show()
    $('#player').hide()
    $('#tabTV').parent().removeClass('is-active')
    $('#tabProgram').parent().addClass('is-active')



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
    $('.player').flowplayer()
    $('#player_modal').addClass('is-active').show()

  if($(document).has('#tv-player'))
    jQuery.ajax
      url: '/tv/index.json'
      method: 'GET'
      success: (data, status, xhr) ->

        player = $('<div class="player" data-debug="true" data-engine="flash"><video width="720" height="404"><source type="video/flash"/></video></div>')
        player.find('source').attr(src: data.)


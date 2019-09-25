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
#= require jquery/dist/jquery
#= require jquery.initialize
#= require hls.js/dist/hls.light
#= require flowplayer
#= require rails-ujs
#= require detectMobile
#= require_self



window.pollTV = ($) ->
  $.ajax
    url: '/tv/index.json'
    method: 'GET'
    success: (data, status, xhr) ->
#      console.log(data.online)
#      console.log(data.content)
      player = $(data.content)

      console.log({remote_player:player.has('.player')[0] != undefined})
      console.log({html_player:$('#player').has('.player')[0] != undefined})
      console.log({isTVActive: window.isTVActive})
      
      if player.has('.player') and !window.isTVActive
        console.log('Adding player')
        $('#player').empty()
        $('#player').append(player)

  if !window.isTVActive
    window.setTimeout(pollTV, 3000, $)


jQuery ->
  $('.navbar-burger').on 'click', (e) ->
    e.preventDefault()

    $('.navbar-burger').toggleClass('is-active')
    target = $('.navbar-burger').data('target')
    $target = $('#' + target)
    $target.toggleClass('is-active')

  $('#player_modal .modal-close').on 'click', (e) ->
    e.preventDefault()
    $(this).parent().removeClass('is-active').hide()
    $(this).parent().find('video')[0].pause()
    $(this).parent().find('.player').remove()


  $('#legal_modal button.delete, #legal_modal button.is-success').on 'click', (e) ->
    e.preventDefault()
    $('#legal_modal').removeClass('is-active').hide()

  $('.legalcode').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('#legal_modal .modal-card-body').load('/szabalyzat.html main')
    $('#legal_modal .modal-card-body > footer').remove()
    $('#legal_modal').addClass('is-active').show()

    #jQuery.ajax
    #  url: '/szabalyzat.html'
    #  method: 'GET'
    #  success: (data,status,jqXHR) ->
    #    rules = $(data).find('main')
    #    $('#legal_modal .modal-card-body').empty()
    #    $('#legal_modal .modal-card-body').append(rules)
    #    $('#legal_modal').addClass('is-active').show()
#
#
  $('.gallery-text').on 'click', (e) ->
    e.preventDefault()

    player = $('<div class="player"><video width="720" height="404"><source type="video/mp4"/></video></div>')

    player.find('source').attr(src: $(this).attr('href'))

    $('#player_modal .modal-content').append(player)
    $('#player_modal .player').flowplayer()
    $('#player_modal').addClass('is-active').show()

  jQuery.initialize '#player .player', ->
    $(this).flowplayer()
    window.isTVActive = true

  if($(document).has('#player'))
    window.isTVActive = false
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
    $('#player').find('video').each () ->
      this.play()
    $('#tabProgram').parent().removeClass('is-active')
    $('#tabTV').parent().addClass('is-active')

  $('#tabProgram').on 'click', (e) ->
    e.preventDefault()

    program_id = $('#program_book').data('playlist')

    if detectMobile()
      window.open("#{window.location.origin}/playlists/#{program_id}/tracks", '_blank').focus()
      return false
    

    $('#player').find('video').each () ->
      if 'stop' of this
        this.stop()
    $('#player').hide()
    $('#program').show()
    $('#tabTV').parent().removeClass('is-active')

    ## Initialize program book

    jQuery.ajax
      url: "/playlists/#{program_id}"
      method: 'GET'
      type: 'JSON'
      success: (data, status, jqXHR) ->
        prev = data.previous
        next = data.next
        $('#program .pagination-previous').data 'playlist', prev
        $('#program .pagination-previous').attr 'aria-disabled', (if prev <= 0 then 'true' else 'false')
        $('#program .pagination-previous').attr 'disabled', (prev <= 0)

        $('#program .pagination-next').data 'playlist', next
        $('#program .pagination-next').attr 'aria-disabled', (if next <= 0 then 'true' else 'false')
        $('#program .pagination-next').attr 'disabled', (next <= 0)


    $('#tabProgram').parent().addClass('is-active')

  ## Program navigation. Only AJAX if non-zero value set
  $('#program .pagination-previous, #program .pagination-next').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()

    program_id = $(this).data 'playlist'
    if !$(this).attr('disabled') and program_id > 0
      jQuery.ajax
        url: "/playlists/#{program_id}"
        method: 'GET'
        type: 'JSON'
        success: (data, status, jqXHR) ->
          prev = data.previous
          next = data.next
          window.frames[0].location.href = "#{window.location.origin}/playlists/#{program_id}/tracks"

          $('#program .pagination-previous').data 'playlist', prev
          $('#program .pagination-previous').attr 'aria-disabled', (if prev <= 0 then 'true' else 'false')
          $('#program .pagination-previous').attr 'disabled', (prev <= 0)

          $('#program .pagination-next').data 'playlist', next
          $('#program .pagination-next').attr 'aria-disabled', (if next <= 0 then 'true' else 'false')
          $('#program .pagination-next').attr 'disabled', (next <= 0)

# vim: ts=2 sw=2 et

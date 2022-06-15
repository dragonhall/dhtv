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
#= require video.js/dist/video
#= require video.js/dist/lang/hu
#= require video-js-hu
#= require rails-ujs
#= require detectMobile
#= require_self

window.pollTV = ($) ->
  
  $.ajax
    url: '/tv/current.json'
    method: 'GET'
    success: (data, status, xhr) ->
      if window.location.pathname == '/' and not $('#tv_player').length
        window.location.reload();

      if window.ga?
        window.oldTrack = window.activeTrack
        window.activeTrack = data

        if (not window.oldTrack?) or (window.oldTrack.id != window.activeTrack.id)
          console.log("Sending data to Google Analytics")
          gaTitle = window.activeTrack.title.toLowerCase().replace(/[\s:-]+/g, '-')
          category = window.activeTrack.category

          ga('set', 'title', window.activeTrack.title)
          ga('send', 'pageview', "/tv?active#{category}=#{gaTitle}")
  
  window.setTimeout(pollTV, 3000, $)

jQuery ->
  videojs.options.language = 'hu'

  playerDiv = $('#tv_player')

  if playerDiv.length

    playerDiv.on 'contextmenu', (e) ->
      e.preventDefault()

    tv_params =
      liveui: true
      fluid: true
      controls: true
      autoplay: true
      controlBar:
        progressControl: false
        playToggle: false

    tvPlayer = videojs 'tv_player', tv_params

  if $('.monoscope').length or $('#tv_player').length
    window.setTimeout(pollTV, 3000, $)

  $('.navbar-burger').on 'click', (e) ->
    e.preventDefault()

    $('.navbar-burger').toggleClass('is-active')
    target = $('.navbar-burger').data('target')
    $target = $('#' + target)
    $target.toggleClass('is-active')

  $('.gallery-text').on 'click', (e) ->
      e.preventDefault()

      src = window.location.origin + $(this).find('.icon').data('path')
      poster = window.location.origin + $(this).parent().find('img').attr('src')
      title = $(this).parent().parent().parent().find('.card-header-title').text().trim()
      gaTitle = title.toLowerCase().replace(/[\s:.-]+/g, '-')

      playerSrc = "
      <video class=\"video-js vjs-default-skin vjs-big-play-centered\" id=\"gallery_player\" width=\"720\" height=\"404\" preload=\"auto\">
        <source src=\"\" type=\"video/mp4\" />
      </video>
      "

      player = $(playerSrc)
      $('#player_modal .modal-content').append(player)

      player.find('source').attr('src', src)
      player.attr('poster', poster)

      gallery_params =
        aspectRatio: '16:9'
        controls: true

      console.log("Creating gallery player with params: ")
      console.log(gallery_params)

      videojs(player[0], gallery_params)

      $('#player_modal').addClass('is-active').show()

      console.log("Sending data to Google Analytics: " + "/recordings?video=#{gaTitle}")
      if window.ga?
        ga('set', 'title', title)
        ga('send', 'pageview', "/recordings?video=#{gaTitle}")


  $('#player_modal .modal-close').on 'click', (e) ->
    e.preventDefault()
    $(this).parent().removeClass('is-active').hide()

    galleryPlayer = videojs('gallery_player')
    galleryPlayer.pause()
    galleryPlayer.dispose()

  jQuery.initialize '#gallery_player', ->
    $(this).on 'contextmenu', (e) ->
      e.preventDefault()

  $('#legal_modal button.delete, #legal_modal button.is-success').on 'click', (e) ->
    e.preventDefault()
    $('#legal_modal').removeClass('is-active').hide()

  $('.legalcode').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('#legal_modal .modal-card-title').text('DragonHall+ TV Szabályzat')
    $('#legal_modal .modal-card-body').load('/szabalyzat.html main')
    $('#legal_modal .modal-card-body > footer').remove()
    $('#legal_modal').addClass('is-active').show()

  $('.faq').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('#legal_modal .modal-card-title').text('DragonHall+ TV - Gyakran Ismételt Kérdések')
    $('#legal_modal .modal-card-body').load('/gyik.html main')
    $('#legal_modal .modal-card-body > footer').remove()
    $('#legal_modal').addClass('is-active').show()

  $('.tip-support').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('#legal_modal .modal-card-title').text('DragonHall+ TV - Mindent a támogatásról')
#    $('#legal_modal .modal-card-body').load('/tip.html main')
#    $('#legal_modal .modal-card-body > footer').remove()
    $('#legal_modal .modal-card-body').html('<iframe width="100%" style="min-height: 750px;" border="0"></iframe>')
    $('#legal_modal .modal-card-body > iframe').attr('src', 'https://tamogatas.dragonhall.hu/fika.php')
    $('#legal_modal .modal-card-body > iframe').on 'load', (e) ->
      $('#legal_modal').addClass('is-active').show()

  $('#tabTV').on 'click', (e) ->
    e.preventDefault()
    $('#program').hide()
    $('#player').show()
    $('#player').find('video').each () ->
      this.play()
    $('#tabProgram').parent().removeClass('is-active')
    $('#tabTV').parent().addClass('is-active')

  $('#tabProgram[disabled]').on 'click', (e) ->
    e.preventDefault()

  $('#tabProgram:not([disabled])').on 'click', (e) ->
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


  $('img.adsense').on 'load', (e) ->
    if window.ga?
      ga('send', 'pageview', '/assets/adsense.png')
# vim: ts=2 sw=2 et

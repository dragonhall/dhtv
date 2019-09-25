#= require jquery/dist/jquery
#= require jquery-migrate/dist/jquery-migrate
#= require jquery-mobile/dist/jquery.mobile
#= require_self

jQuery.mobile.ajaxEnabled = false
jQuery.mobile.loadingMessage = false

jQuery ->
  $('.ui-loader').hide()
  $('#wrapper').on 'swipeleft', (e) ->
    splitted = window.location.href.split('/')
    program_id = parseInt(splitted[splitted.length - 2], 10)

    jQuery.ajax
      url: "/playlists/#{program_id}"
      method: 'GET'
      type: 'JSON'
      success: (data, status, jqXHR) ->
        prev = data.previous
        next = data.next

        if next > 0
          window.location.href = "#{window.location.origin}/playlists/#{next}/tracks"

  $('#wrapper').on 'swiperight', (e) ->
    splitted = window.location.href.split('/')
    program_id = parseInt(splitted[splitted.length - 2], 10)

    jQuery.ajax
      url: "/playlists/#{program_id}"
      method: 'GET'
      type: 'JSON'
      success: (data, status, jqXHR) ->
        prev = data.previous
        next = data.next
        
        if prev > 0
          window.location.href = "#{window.location.origin}/playlists/#{prev}/tracks"

# vim: ts=2 sw=2 et

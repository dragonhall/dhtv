class PlaylistsController < ApplicationController #  InheritedResources::Base
  respond_to :json

  layout false

  def show
    channel = Channel.where(domain: request.host).any? ? Channel.where(domain: request.host).first : nil
    playlist = channel.playlists.finalized.find(params[:id])
    
    prev_day = channel.playlists.finalized.where('CAST(start_time AS date) <= ?', playlist.start_time.to_date - 1.day).where('start_time >= ?', Time.zone.now - 1.week).any? ?
               channel.playlists.finalized.where('CAST(start_time AS date) <= ?', playlist.start_time.to_date - 1.day).where('start_time >= ?', Time.zone.now - 1.week).order('start_time ASC').last.id : -1
    next_day = channel.playlists.finalized.where('CAST(start_time AS date) >= ?', playlist.start_time.to_date + 1.day).where('start_time <= ?', Time.zone.now + 1.week).any? ? 
               channel.playlists.finalized.where('CAST(start_time AS date) >= ?', playlist.start_time.to_date + 1.day).where('start_time <= ?', Time.zone.now + 1.week).order('start_time ASC').first.id : -1
    respond_with({previous: prev_day, next: next_day})
  end
end

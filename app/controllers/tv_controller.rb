class TvController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        if Channel.where(domain: request.host).any? and Channel.where(domain: request.host).first.playlists.active.any?
          @channel = Channel.where(domain: request.host).first
          render :json, {src: "rtmp://tv.dragonhall.hu:1935/live/#{@channel.stream_path}"}
        else
          render :json, {status: '404', error: 'No active playlist found'}, status: :not_found
        end
      end
    end
  end
end

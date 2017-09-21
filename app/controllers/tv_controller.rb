class TvController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        if Channel.where(domain: request.host).any? and Channel.where(domain: request.host).first.playlists.active.any?
          @channel = Channel.where(domain: request.host).first
          render json: {status: 200, src: "rtmp://tv.dragonhall.hu:1935/live/#{@channel.stream_path}"}
        else
          render json: {status: 404, src: ActionController::Base.helpers.asset_path('monoscope.png')}
        end
      end
    end
  end
end

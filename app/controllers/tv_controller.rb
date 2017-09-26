class TvController < ApplicationController
  respond_to :html, :json

  def index
    @channel = Channel.where(domain: request.host).first
    @playlist = @channel.playlists.active.any? ? @channel.playlists.active.first : nil
    respond_to do |format|
      format.html
      format.json do
        if @playlist
          render json: { online: true, content: render_to_string(partial: 'player.html') }
        else
          render json: { online: false, content: render_to_string(partial: 'monoscope.html') }
        end
      end
    end
  end
end


###
# - if @playlist
#          .
#     - else

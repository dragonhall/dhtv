class TvController < ApplicationController
  respond_to :html, :json

  def index
    @playlist = (!channel.blank? && channel.playlists.active.any?) ? channel.playlists.active.first : nil
    @today_playlist = channel.playlists.finalized.where('CAST(start_time AS date) = ?', Time.zone.now.to_date).first || nil

    @active_track = if Track.where(playing: true).joins(:playlist).where('playlists.channel_id' => (channel ? channel.id : -1)).any? then
                      Track.where(playing: true).joins(:playlist).where('playlists.channel_id' => (channel ? channel.id : -1)).first
                    else
                      nil
                    end
    respond_to do |format|
      format.html
      # format.json do
      #   if @playlist
      #     render json: { online: true, content: render_to_string(partial: 'player.html') }
      #   else
      #     render json: { online: false, content: render_to_string(partial: 'monoscope.html') }
      #   end
      # end
    end
  end

  def banner
    respond_to do |format|
      banner_base = '/szeroka/dh0/www/index_elemei/tv_panel'
      banner = channel.playlists.active.any? ? "#{banner_base}/DHTV_panel_elo.png" : "#{banner_base}/DHTV_panel.png"
      format.html do
        response.headers['Expires'] = 1.day.ago
        response.headers['Cache-Control'] = 'no-cache'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Last-Modified'] = Time.zone.now.strftime("%a, %d %b %Y %T %Z")
        send_data File.read(banner), type: 'image/png', disposition: :inline
      end
    end
  end

  private

  def channel
    @channel ||= Channel.where(domain: request.host).any? ? Channel.where(domain: request.host).first : nil
  end
end


###
# - if @playlist
#          .
#     - else

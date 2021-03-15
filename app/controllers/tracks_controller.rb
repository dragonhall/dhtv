# frozen_string_literal: true

class TracksController < InheritedResources::Base
  belongs_to :playlist

  respond_to :json, :html

  layout 'playlist', only: :index

  before_action :set_title

  # skip_before_action :authenticate_admin!, only: :index

  # rubocop:disable Metrics/AbcSize
  def current
    active_track = Rails.cache.fetch('active_track', expires_in: 30.seconds) do
      if Track.where(playing: true).joins(:playlist)
              .where('playlists.channel_id' => (channel ? channel.id : -1)).any?
        Track.where(playing: true).joins(:playlist)
             .where('playlists.channel_id' => (channel ? channel.id : -1)).first
      end
    end

    if active_track.nil?
      render json: { error: 'No active track' }, status: 404
    else
      track_json = {
        id: active_track.id,
        title: active_track.title,
        start_time: active_track.start_time,
        end_time: active_track.end_time,
        pegi_rating: active_track.video.pegi_rating_s,
        category: active_track.video.video_type.to_s.titleize,
        length: Time.at(active_track.length).utc.strftime('%H:%M:%S')
      }
      response.headers['Access-Control-Allow-Origin'] = '*'
      render json: track_json, status: :ok
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def playlist
    @playlist ||= params[:playlist_id] ? Playlist.find(params[:playlist_id]) : nil
  end

  def set_title
    # playlist = Playlist.find(params[:playlist_id])
    @title = playlist&.human_title
  end

  def channel
    @channel ||= Channel.where(domain: request.host).any? ? Channel.where(domain: request.host).first : nil
  end

  # def track_params
  #  params.require(:track).permit(:playlist_id, :video_id)
  # end
end

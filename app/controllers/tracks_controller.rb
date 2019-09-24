# frozen_string_literal: true

class TracksController < InheritedResources::Base
  belongs_to :playlist

  respond_to :json, :html

  layout 'playlist', only: :index

  before_action :set_title

  #skip_before_action :authenticate_admin!, only: :index

  private

  def set_title
    playlist = Playlist.find(params[:playlist_id])

    @title = playlist.human_title
  end

  #def track_params
  #  params.require(:track).permit(:playlist_id, :video_id)
  #end
end

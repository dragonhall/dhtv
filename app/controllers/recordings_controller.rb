class RecordingsController < InheritedResources::Base

  respond_to :json, :html

  protected

  def begin_of_association_chain
    Recording.available.joins(:video).where('videos.recordable' => true).where('videos.series' => params[:series])
  end

  private


    def recording_params
      params.require(:recording).permit()
    end
end


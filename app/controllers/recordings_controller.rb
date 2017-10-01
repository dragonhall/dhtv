class RecordingsController < InheritedResources::Base

  respond_to :json, :html

  protected

  def begin_of_association_chain
    if params[:series].present? then
      Recording.available.joins(:video).where('videos.recordable' => true).where('videos.series' => params[:series])
    else
      super
    end
  end

  private


    def recording_params
      params.require(:recording).permit()
    end
end


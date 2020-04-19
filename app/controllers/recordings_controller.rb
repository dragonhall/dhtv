class RecordingsController < InheritedResources::Base

  respond_to :json, :html

  protected

  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.available)
  end

  private


    def recording_params
      params.require(:recording).permit()
    end
end


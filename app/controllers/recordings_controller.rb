class RecordingsController < InheritedResources::Base

  private

    def recording_params
      params.require(:recording).permit()
    end
end


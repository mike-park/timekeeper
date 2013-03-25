class TorgsController < InheritedResources::Base

  def show
    if params[:compare_id]
      other = Torg.find(params[:compare_id])
      @diff = TorgDiff.new(resource, other)
    end

    respond_with(resource) do |format|
      format.csv do
        filename = "torg_#{@torg.start_date.to_s(:de)}_bis_#{@torg.end_date.to_s(:de)}.csv"
        send_data @torg.to_csv, {
            filename: filename,
            type: :csv
        }
      end
    end
  end

  private
  
  def collection
    @torgs ||= Torg.by_start_date
  end

  def resource_params
    params.require(:torg).permit(:start_date, :end_date)
  end
end

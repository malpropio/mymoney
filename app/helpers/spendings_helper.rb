module SpendingsHelper
  def sort_column
    Spending.column_names.include?(params[:sort]) ? params[:sort] : 'spending_date'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end
end

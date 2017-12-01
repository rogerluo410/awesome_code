module PaginationHelper
  def pagination_info(records)
    {
      next_page: records.next_page,
      prev_page: records.prev_page,
      current_page: records.current_page,
      total_pages: records.total_pages,
      total_count: records.total_count
    } if records.respond_to?(:current_page)
  end
end
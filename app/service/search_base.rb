class SearchBase
  attr_reader :params, :result
  PER_PAGE_LIMIT = 10

  def self.call(*params)
    self.new(*params)
  end

  def name
    model_name.name
  end

  def initialize(params)
    @params = params
  end

  def per_page_limit
    SearchBase::PER_PAGE_LIMIT
  end

  def model_name
    # model class Name
    raise NotImplementedError
  end

  def match_fields
    # for query multiple search fields
    # Array of string
    raise NotImplementedError
  end

  def filters
    # Array
    raise NotImplementedError
  end

  def sorts
    # Hash
    raise NotImplementedError
  end

  def per_page
    params[:per_page] || 10
  end

  def page
    params[:page] || 0
  end

  def search
    query = {
      size: per_page,
      query: {
        filtered: {
          query: search_query,
          filter: {
            and: {
              filters: filters
            }
          }
        }
      }
    }
    .merge(sorts)
    Rails.logger.debug(query.to_json)

    if params[:unlimit]
      model_name.__elasticsearch__.search(query, size: 1000)
    else
      model_name.__elasticsearch__.search(query).page(params[:page])
    end

  end

  def term options={}
    {
      term: options
    }
  end

  def terms options={}
    {
      terms: options
    }
  end

  def range options={}
    {
      range: options
    }
  end

  def or_term options=[]
    {
      or: options
    }
  end

  def sort_term options=[]
    {
      sort: options
    }
  end

  def and_term options=[]
    {
      and: options
    }
  end

  def not_term options = []
    {
      not: {
        term: options
      }
    }
  end

  def none_term
    term(id: 0)
  end

  def search_query
    text = params[:q]
    if text.presence
      { multi_match: { query: text, type: "phrase_prefix", fields: match_fields } }
    else
      { match_all: {} }
    end
  end

  def source
    result._source
  end

  def find_match(list)
    find_source_match(list)
  end

  def find_source_match(list)
    list.each do |l|
      result = source
      l.split('.').each do |r|
        result = result.try(r)
        if result.is_a?(String) && !result.blank?
          return result
        end
      end
    end
    nil
  end
end


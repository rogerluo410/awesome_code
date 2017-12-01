module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include ReferenceUpdatable
    index_name [Rails.application.engine_name, Rails.env, self.name.downcase].join('_')

    after_commit on: [:create] do
      __elasticsearch__.index_document
    end

    after_commit on: [:destroy] do
      __elasticsearch__.delete_document
    end

    after_commit on: [:update] do
      __elasticsearch__.update_document

      self.update_document
    end

    def update_document(options={})
      if self.instance_variable_get(:@__changed_attributes)
        client.update(
            { index: index_name,
              type:  document_type,
              id:    self.id,
              body:  { doc: self.as_indexed_json } }.merge(options)
        )
      else
        self.__elasticsearch__.index_document(options)
      end
    end
  end

  def searchable_fields reference, extras={}
    return {} unless reference
    reference = if reference.class == String; reference.constantize else reference.class end
    {
      only: reference.columns.select {|c| [:string, :text].include? c.type}.map(&:name)
    }.merge(extras) do |key, oldV, newV|
      oldV + newV
    end
  end
end

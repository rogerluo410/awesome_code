# match_api_schema(:category, layout: :paginated_list)
RSpec::Matchers.define :match_api_schema do |schema, options = {}|
  match do |response|
    if options[:layout].present?
      definition_path = "spec/api_schemas/v1/definitions"
      item_schema = "#{definition_path}/#{schema}.json"

      schema = case options[:layout]
                 when :item
                   {
                       type: "object",
                       properties: {
                           data: {"$ref" => item_schema},
                       }
                   }
                 when :list
                   {
                       type: "object",
                       properties: {
                           data: {
                               type: "array",
                               items: {"$ref" => item_schema},
                           }
                       }
                   }
                 when :paginated_list
                   {
                       type: "object",
                       properties: {
                           meta: {"$ref" => "#{definition_path}/meta.json"},
                           data: {
                               type: "array",
                               items: {"$ref" => item_schema},
                           }
                       }
                   }
                when :notification_paginated_list
                  {
                    type: "object",
                    properties: {
                      meta: {"$ref" => "#{definition_path}/meta_notificaion.json"},
                      data: {
                        type: "array",
                        items: {"$ref" => item_schema},
                      }
                    }
                  }
               end
      JSON::Validator.validate!(schema, response.body, strict: true)
    else
      # Old bahavior
      schema_path = "#{Rails.root}/spec/api_schemas/v1/#{schema}.json"
      JSON::Validator.validate!(schema_path, response.body, strict: true)
    end
  end
end

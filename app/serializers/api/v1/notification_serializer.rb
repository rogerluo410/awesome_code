class Api::V1::NotificationSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :n_type,
    :title,
    :body,
    :is_read,
    :resource_type,
    :resource_id,
    :created_at,
  )
end

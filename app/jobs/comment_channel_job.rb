class CommentChannelJob < ApplicationJob
  queue_as :default

  def perform(comment)
  end
end

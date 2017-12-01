module Api
  module V1
    class ApiBaseController < ActionController::Base
      rescue_from NotAuthorizedError do |exception|
        render_api_error status: 401, message: exception.message
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        render_api_error status: 404, message: 'Resource not found'
      end

      alias_method :devise_current_user, :current_user

      private

      def current_user
        if session_auth?
          @current_user ||= devise_current_user
        else
          auth_token = request.headers['Authorization']
          token = AuthToken.find_by_id(auth_token)
          return unless token.present?
          if token.expired_at  < Time.zone.now
            token.destroy!
            return
          end
          @current_user ||= token.try(:user)
        end
      end

      def authenticate!
        raise NotAuthorizedError, 'User unauthorized.' unless current_user.present?
      end

      def authenticate_doctor!
        raise NotAuthorizedError, 'Doctor unauthorized.' unless current_user.present? && current_user.class.name == 'Doctor'
      end

      def render_api_error(status:, message:, code: nil)
        error = {message: message}
        error[:code] = code if code
        render status: status, json: {error: error}
      end

      def session_auth?
        return true if !!request.headers['X-Session-Auth']
        false
      end

      def render_one(resource, opts = {})
        if resource
          render opts.merge(json: resource, root: 'data')
        else
          render json: {data: nil}
        end
      end

      def render_paginated_list(resources, each_serializer:)
        meta = {
          next_page: resources.next_page,
          prev_page: resources.prev_page,
          current_page: resources.current_page,
          total_pages: resources.total_pages,
          total_count: resources.total_count
        }

        render json: resources,
               each_serializer: each_serializer,
               root: 'data',
               meta: meta
      end

      def render_list(resources, opts = {})
        render opts.merge(json: resources, root: 'data')
      end

      def render_one_jsonapi(resource, opts = {})
        if resource
          render opts.merge(jsonapi_opts).merge(json: resource)
        else
          render json: { data: nil }
        end
      end

      def render_list_jsonapi(resources, opts = {})
        render_list(resources, opts.merge(jsonapi_opts))
      end

      def jsonapi_opts
        { adapter: :json_api, key_transform: :camel_lower }
      end
    end
  end
end

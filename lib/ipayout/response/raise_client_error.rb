require 'faraday'
require 'ipayout/error/bad_request'
require 'ipayout/error/too_many_requests'
require 'ipayout/error/forbidden'
require 'ipayout/error/not_acceptable'
require 'ipayout/error/not_found'
require 'ipayout/error/unauthorized'
require 'ipayout/error/ewallet_not_found'
require 'pry'

module Ipayout
  module Response
    class RaiseClientError < Faraday::Middleware
      def call(request_env)
        request_body = request_env.body

        @app.call(request_env).on_complete do |env|
          env[:request_body] = request_body
          on_complete(env)
        end
      end

      def on_complete(env)
        case env[:status].to_i
        when 200
          process_success_response(env)
        when 400
          error!(Ipayout::Error::BadRequest, env)
        when 401
          error!(Ipayout::Error::Unauthorized, env)
        when 403
          if env[:body]['error'] == 'over_limit'
            error!(Ipayout::Error::TooManyRequests, env)
          else
            error!(Ipayout::Error::Forbidden, env)
          end
        when 404
          error!(Ipayout::Error::NotFound, env)
        when 406
          error!(Ipayout::Error::NotAcceptable, env)
        end
      end

      private

      def error!(error_class, env, message = nil)
        message ||= error_message(env)
        fail error_class.new(message,
                             env[:response_headers],
                             env[:request_body])
      end

      def error_message(env)
        "#{env[:method].to_s.upcase} #{env[:url]}: \
          #{env[:status]}#{error_body(env[:body])}"
      end

      # rubocop:disable MethodLength
      def error_body(body)
        if body.nil?
          nil
        elsif body['error']
          ": #{body['error']}"
        elsif body['errors']
          first = Array(body['errors']).first
          if first.is_a? Hash
            ": #{first['message'].chomp}"
          else
            ": #{first.chomp}"
          end
        end
      end

      def process_success_response(env)
        body_response = env[:body][:response]
        return unless body_response
        case body_response[:m_Code]
        when -2
          error!(Ipayout::Error::EwalletNotFound,
                 env,
                 body_response[:m_Text])
        end
      end
    end
  end
end

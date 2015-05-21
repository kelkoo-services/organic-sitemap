module OrganicSitemap
  module Middleware
    class UrlCapture
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, response = @app.call(env)
        processor = OrganicSitemap::UrlProcessor.new(status, headers, env)
        if processor.sitemap_url?
          OrganicSitemap::RedisManager.add(processor.sanitize_path_info)
        end
        [status, headers, response]
      end
    end
  end
end

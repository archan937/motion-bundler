module Motion
  module Project
    class App
      def self.setup
        yield new
      end
      def self.fail(msg)
        raise msg
      end
      def files
        @files ||= []
      end
      def files=(files)
        @files = files
      end
      def files_dependencies(deps)
      end
    end
  end
end
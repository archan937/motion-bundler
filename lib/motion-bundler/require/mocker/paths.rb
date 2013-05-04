module MotionBundler
  module Require
    module Mocker
      module Paths

        APP_MOCKS = File.expand_path("./mocks")
        GEM_MOCKS = File.expand_path("../../../mocks", __FILE__)

        def dirs
          @dirs ||= [APP_MOCKS, GEM_MOCKS]
        end

        def add_dir(dir)
          dirs.insert 1, dir
        end

        def resolve(path)
          base_path = path.gsub(/\.rb$/, "")

          dirs.each do |dir|
            if file = (Dir["#{dir}/#{base_path}.rb"].first || Dir["#{dir}/*/#{base_path}.rb"].first)
              return file
            end
          end

          path
        end

      end
    end
  end
end
module MotionBundler
  module Require
    module Mocker
      module Dirs

        APP_MOCKS = File.expand_path("./mocks")
        GEM_MOCKS = File.expand_path("../../../mocks", __FILE__)

        def dirs
          @dirs ||= [APP_MOCKS, GEM_MOCKS]
        end

        def add_dir(dir)
          dirs.insert 1, File.expand_path(dir)
        end

      end
    end
  end
end
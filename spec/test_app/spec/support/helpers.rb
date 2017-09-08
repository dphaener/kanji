module Test
  module DatabaseHelpers
    module_function

    def rom
      TestApp::Container["persistence.rom"]
    end

    def db
      TestApp::Container["persistence.db"]
    end
  end
end

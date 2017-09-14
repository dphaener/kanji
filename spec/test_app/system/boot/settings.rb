require "test_app/settings"

TestApp::Container.finalize :settings do |container|
  start do
    settings = TestApp::Settings.load(container.config.root, container.config.env)
    container.register "settings", settings
  end
end

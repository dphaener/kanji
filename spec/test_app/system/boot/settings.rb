TestApp::Container.finalize :settings do |container|
  init do
    require "test_app/settings"
  end

  start do
    settings = TestApp::Settings.load(container.config.root, container.config.env)
    container.register "settings", settings
  end
end

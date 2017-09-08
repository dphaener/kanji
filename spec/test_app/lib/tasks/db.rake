require "rom/sql/rake_task"

namespace :db do
  task :setup do
    require_relative "#{Dir.pwd}/system/container"

    TestApp::Container.boot!(:persistence)
    TestApp::Container["persistence.db"]
  end
end

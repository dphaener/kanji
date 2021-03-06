require "dry/core/inflector"

TestApp::Container.namespace :repos do |container|
  container.finalize :repos do
    init do
      Dir[container.root.join("app/repositories/*.rb")].each do |repo|
        require repo
      end
    end

    start do
      db = container.resolve("persistence.rom")

      Dir[container.root.join("app/repositories/*.rb")].each do |repo|
        repo_name = File.basename(repo, ".rb")
        klass_name = Dry::Core::Inflector.camelize(repo_name)
        klass = Dry::Core::Inflector.constantize("Repositories::#{klass_name}")

        container.register(repo_name.to_sym, klass.new(db))
      end
    end
  end
end

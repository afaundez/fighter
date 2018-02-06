require 'erb'

module Fighter
  class Style
    attr_accessor :framework
    attr_accessor :version

    def initialize(framework, version)
      @framework = framework
      @version = version
    end

    def self.collect(&block)
      self.each.collect(&block)
    end

    def self.each(&block)
      return to_enum(:each) unless block
      self.all.each(&block)
    end

    def fighterfile_content
      ERB.new(fighterfile_template, nil, '-').result binding
    end

    def self.all
      frameworks = File.join File.dirname(File.expand_path(__FILE__)), 'frameworks/**/*.yml'
      Dir.glob(frameworks).collect do |framework_file|
        framework = File.basename File.dirname(framework_file)
        version = File.basename(framework_file, '.yml')
        self.new framework, version
      end
    end

    def self.default
      self.all.first
    end

    private

      def fighterfile_template
        File.read Fighter.root.join('templates/fighter.yml.erb')
      end
  end
end

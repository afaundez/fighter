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

    def self.all
      [['basic', '1.0']].collect do |framework, version|
        self.new framework, version
      end
    end

    def self.default
      self.all.first
    end

  end
end

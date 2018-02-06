require 'fighter/version'
require 'fighter/cli'

module Fighter
  def self.root
    Pathname.new File.expand_path '..', File.dirname(File.expand_path(__FILE__))
  end
end

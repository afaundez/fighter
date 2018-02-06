require 'fighter/thor'
require 'fighter/style'
require 'fighter/phase/prep'
require 'fighter/phase/ready'

module Fighter
  class CLI < Thor

    method_option :force, aliases: '-f', type: :boolean, lazy_default: false,
      desc: 'Overwrites `.fighter.yml` if it already exists'
    desc 'prep [FRAMEWORK] [VERSION]', 'Prepare your fighter for a framework'
    long_desc <<-LONGDESC
      `fighter prep [FRAMEWORK] [VERSION]` will create a `.fighter.yml` file and add it to your `.gitignore`. It won't execute if the file already exists, unless you use the `--force` option.

      FRAMEWORK parameter is optional and defaults to `basic`. The available options are: `#{Fighter::Style.collect(&:framework)}`.

      VERSION parameter is option when using FRAMEWORK parameter.
    LONGDESC
    def prep(framework=Fighter::Style.default.framework,
      version=Fighter::Style.default.version)
      Phase::Prep.run Dir.pwd, framework, version, options
    end

    desc 'go', 'Create environment from .fighter.yml and run it'
    def go
      Phase::Ready.run Dir.pwd, options
    end

  end
end

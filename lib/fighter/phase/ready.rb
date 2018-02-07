require 'yaml'
require 'json'
require 'mixlib/shellout'
require 'logger'

module Fighter
  module Phase
    class Ready

      def self.run(cwd, options={})
        fighterfile = File.join cwd, '.fighter.yml'
        if File.exist?(fighterfile)
          skills = YAML.load_file fighterfile
          style = Fighter::Style.new skills['style']['framework'], skills['style']['version']
          stage = File.join cwd, '.fighter'
          FileUtils.mkdir_p  stage

          ['Vagrantfile.erb', 'Berksfile.erb'].each do |template|
            content = File.read Fighter.root.join('templates', template)
            rendered =ERB.new(content, nil, '-').result binding
            destination = File.join stage, File.basename(template, '.erb')
            File.write destination, rendered
          end

          logger = Logger.new STDOUT
          vagrant_up = Mixlib::ShellOut.new 'vagrant up', cwd: stage, live_stdout: logger
          vagrant_up.run_command
          vagrant_up.error!
        end
      end

    end
  end
end

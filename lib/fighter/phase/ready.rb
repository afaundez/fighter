require 'yaml'
require 'json'

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
        end
      end

    end
  end
end

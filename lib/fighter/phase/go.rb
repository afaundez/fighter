require 'mixlib/shellout'

module Fighter
  module Phase
    class Go

      def self.run(cwd, options={})
        fighterfile = File.join cwd, '.fighter.yml'
        if File.exist?(fighterfile)
          stage = File.join cwd, '.fighter'
          Kernel.exec "cd #{stage} && vagrant ssh"
        end
      end

    end
  end
end

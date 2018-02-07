require 'mixlib/shellout'

module Fighter
  module Phase
    class KO

      def self.run(cwd, options={})
        fighterfile = File.join cwd, '.fighter.yml'
        if File.exist?(fighterfile)
          stage = File.join cwd, '.fighter'
          Kernel.exec "cd #{stage} && vagrant halt"
        end
      end

    end
  end
end

require 'mixlib/shellout'

module Fighter
  module Phase
    class Retire

      def self.run(cwd, options={})
        fighterfile = File.join cwd, '.fighter.yml'
        if File.exist?(fighterfile)
          stage = File.join cwd, '.fighter'

          logger = Logger.new STDOUT
          vagrant_up = Mixlib::ShellOut.new 'vagrant destroy', cwd: stage, live_stdout: logger
          vagrant_up.run_command

          FileUtils.rm_f File.join(stage, 'Berksfile'), verbose: true
          FileUtils.rm_f File.join(stage, 'Berksfile.lock'), verbose: true
          FileUtils.rm_f File.join(stage, 'Vagrantfile'), verbose: true
          FileUtils.rmtree File.join(stage, '.vagrant'), verbose: true, secure: true
          FileUtils.rmtree stage, verbose: true, secure: true
        end
      end

    end
  end
end

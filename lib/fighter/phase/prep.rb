module Fighter
  module Phase
    class Prep

      def self.run(cwd, options={})
        fighterfile = File.join cwd, '.fighter.yml'
        if options['force'] || !File.exist?(fighterfile)
          File.write fighterfile, '# .fighter.yml'
          gitignorefile = File.join cwd, '.gitignore'
          if !File.exist?(gitignorefile)
            File.write gitignorefile, ".fighter.yml\n"
          elsif !File.read(gitignorefile).include?('.fighter.yml')
            File.write gitignorefile, "\n.fighter.yml\n", File.size(gitignorefile)
          end
        end
      end

    end
  end
end

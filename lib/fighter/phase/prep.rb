module Fighter
  module Phase
    class Prep

      def self.run(cwd, options={})
        fighterfile = File.join cwd, '.fighter.yml'
        if options['force'] || !File.exist?(fighterfile)
          File.write fighterfile, "# .fighter.yml\n"
          gitignorefile = File.join cwd, '.gitignore'
          if !File.exist?(gitignorefile)
            File.write gitignorefile, ".fighter\n"
          elsif !File.read(gitignorefile).include?('.fighter')
            File.write gitignorefile, "\n.fighter\n", File.size(gitignorefile)
          end
        end
      end

    end
  end
end

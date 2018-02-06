require 'test_helper'

describe Fighter::CLI do
  before :all do
    @dir = Dir.mktmpdir
    @fighterfile = File.join @dir, '.fighter.yml'
    @gitignorefile = File.join @dir, '.gitignore'
  end

  after :all do
    FileUtils.remove_entry @dir
  end

  it 'shows help if command is not provided' do
    proc { Fighter::CLI.start }.must_output(/Commands:/)
  end

  describe 'prep command' do
    let(:args) { ['prep'] }

    describe 'and fighterfile does not exists' do

      describe 'and gitignore is not present' do
        it 'should create a new fighterfile and a new gitignore' do
          Dir.chdir(@dir) {Fighter::CLI.start args}
          File.read(@fighterfile).must_match /# .fighter.yml/
          File.read(@gitignorefile).must_match /^.fighter$/
        end
      end

      describe 'and gitignore is present' do
        it 'should create a new fighterfile and add lines to gitignore' do
          File.write @gitignorefile, '.tmp'
          Dir.chdir(@dir) {Fighter::CLI.start args}
          File.read(@fighterfile).must_match /# .fighter.yml/
          File.read(@gitignorefile).must_match /.tmp$/
          File.read(@gitignorefile).must_match /^.fighter$/
        end
      end
    end

    describe 'and fighterfile exists' do
      before :all do
        File.write @fighterfile, 'Already existing fighterfile'
        @fighterfile_mtime = File.mtime(@fighterfile).to_f
        @fighterfile_content = File.read(@fighterfile)
      end

      describe 'and gitignore is not present' do

        it 'should not modify fighterfile nor create gitignorefile' do
          Dir.chdir(@dir) {Fighter::CLI.start args}
          @fighterfile_mtime.must_equal File.mtime(@fighterfile).to_f
          @fighterfile_content.must_equal File.read(@fighterfile)
          File.exists?(@gitignorefile).must_equal false
        end

        it 'should overwrite fighterfile and create gitignore if forcing' do
          Dir.chdir(@dir) {Fighter::CLI.start args.push('--force')}
          @fighterfile_mtime.wont_equal File.mtime(@fighterfile).to_f
          File.read(@fighterfile).must_match /# .fighter.yml/
          File.read(@gitignorefile).must_match /^.fighter$/
        end
      end

      describe 'and gitignore is present' do
        before :all do
          File.write @gitignorefile, '.tmp'
          @gitignorefile_mtime = File.mtime(@gitignorefile).to_f
          @gitignorefile_content = File.read(@gitignorefile)
        end

        it 'should not modify fighterfile nor gitignorefile' do
          Dir.chdir(@dir) {Fighter::CLI.start args}
          @fighterfile_mtime.must_equal File.mtime(@fighterfile).to_f
          @fighterfile_content.must_equal File.read(@fighterfile)
          @gitignorefile_mtime.must_equal File.mtime(@gitignorefile).to_f
          @gitignorefile_content.must_equal File.read(@gitignorefile)
        end

        it 'should overwrite fighterfile and modify gitignore if forcing' do
          Dir.chdir(@dir) {Fighter::CLI.start args.push('--force')}
          @fighterfile_mtime.wont_equal File.mtime(@fighterfile).to_f
          File.read(@fighterfile).must_match /# .fighter.yml/
          File.read(@gitignorefile).must_match /.tmp$/
          File.read(@gitignorefile).must_match /^.fighter$/
        end
      end
    end
  end
end

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
          File.read(@fighterfile).must_match "style:\n  framework: base\n  version: 1.0\n"
          File.read(@gitignorefile).must_match /^.fighter$/
        end
      end

      describe 'and gitignore is present' do
        it 'should create a new fighterfile and add lines to gitignore' do
          File.write @gitignorefile, '.tmp'
          Dir.chdir(@dir) {Fighter::CLI.start args}
          File.read(@fighterfile).must_match "style:\n  framework: base\n  version: 1.0\n"
          File.read(@gitignorefile).must_match /.tmp$/
          File.read(@gitignorefile).must_match /^.fighter$/
        end
      end
    end

    describe 'and fighterfile exists' do
      before :all do
        File.write @fighterfile, 'Already existing fighterfile'
        FileUtils.touch @fighterfile, mtime: Time.now - 60*60*24
        @fighterfile_mtime = File.mtime @fighterfile
        @fighterfile_content = File.read @fighterfile
      end

      describe 'and gitignore is not present' do

        it 'should not modify fighterfile nor create gitignorefile' do
          Dir.chdir(@dir) {Fighter::CLI.start args}
          @fighterfile_mtime.must_equal File.mtime(@fighterfile)
          @fighterfile_content.must_equal File.read(@fighterfile)
          File.exists?(@gitignorefile).must_equal false
        end

        it 'should overwrite fighterfile and create gitignore if forcing' do
          Dir.chdir(@dir) {Fighter::CLI.start args.push('--force')}
          @fighterfile_mtime.wont_equal File.mtime(@fighterfile)
          File.read(@fighterfile).must_match "style:\n  framework: base\n  version: 1.0\n"
          File.read(@gitignorefile).must_match /^.fighter$/
        end
      end

      describe 'and gitignore is present' do
        before :all do
          File.write @gitignorefile, '.tmp'
          FileUtils.touch @gitignorefile, mtime: Time.now - 60*60*24
          @gitignorefile_mtime = File.mtime @gitignorefile
          @gitignorefile_content = File.read @gitignorefile
        end

        it 'should not modify fighterfile nor gitignorefile' do
          Dir.chdir(@dir) {Fighter::CLI.start args}
          @fighterfile_mtime.must_equal File.mtime(@fighterfile)
          @fighterfile_content.must_equal File.read(@fighterfile)
          @gitignorefile_mtime.must_equal File.mtime(@gitignorefile)
          @gitignorefile_content.must_equal File.read(@gitignorefile)
        end

        it 'should overwrite fighterfile and modify gitignore if forcing' do
          Dir.chdir(@dir) {Fighter::CLI.start args.push('--force')}
          @fighterfile_mtime.wont_equal File.mtime(@fighterfile)
          File.read(@fighterfile).must_match "style:\n  framework: base\n  version: 1.0\n"
          File.read(@gitignorefile).must_match /.tmp$/
          File.read(@gitignorefile).must_match /^.fighter$/
        end
      end
    end
  end
end

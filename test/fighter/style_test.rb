require 'test_helper'

describe Fighter::Style do
  it 'has at least one style' do
    Fighter::Style.all.wont_be_empty
  end

  it 'has a default style' do
    Fighter::Style.default.must_be_instance_of Fighter::Style
  end
end

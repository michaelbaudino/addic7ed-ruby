require 'spec_helper'
require './lib/addic7ed'

describe Addic7ed do
  it 'should define SHOWS_URL' do
    Addic7ed::SHOWS_URL.should_not be_nil
  end
  it 'should define EPISODES_URL' do
    Addic7ed::EPISODES_URL.should_not be_nil
  end
  it 'should define EPISODE_REDIRECT_URL' do
    Addic7ed::EPISODE_REDIRECT_URL.should_not be_nil
  end
  it 'should define LANGUAGES' do
    Addic7ed::LANGUAGES.should_not be_nil
    Addic7ed::LANGUAGES['fr'].should == {name: 'French', id: 8}
  end
end

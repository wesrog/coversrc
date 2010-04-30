require File.dirname(__FILE__) + '/spec_helper'

describe "coversrc" do
  it "will return a 200 on the homepage" do
    get '/'
    last_response.status.should == 200
    assert last_response.body.include?('music')
  end

  it "will return a 200 on valid user" do
    get '/wesr'
    last_response.status.should == 200
  end

  it "will return a 404 on invalid user" do
    get '/wesra'
    get '/lastfm'
    last_response.status.should == 404
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe "A search on Discogs" do
  before(:each) do
    @search = Discogs::Search.new('Harold Budd Afar')
  end

  it "should return success when using a proper API key" do
    @search.response.status.first.should == '200'
  end

end

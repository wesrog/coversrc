require File.dirname(__FILE__) + '/../spec_helper'

describe "A search on Discogs" do
  before(:each) do
    @search = Discogs::Search.new('Harold Budd Afar')
    @nonvalid_search = Discogs::Search.new('junbiejrn')
  end

  it "should return success when using a proper API key" do
    @search.response.status.first.should == '200'
  end

  it "should return results for a valid search" do
    @search.results.should_not be_empty
  end

  it "should raise an exception if no results are returned" do
    lambda { @nonvalid_search.results }.should raise_error
  end

end

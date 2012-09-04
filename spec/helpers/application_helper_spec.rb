require 'spec_helper'
describe ApplicationHelper do
	describe "full title" do
		it "Should include page title" do
			full_title('foo').should =~ /foo/
		end
		it "Should include base title" do
			full_title('foo').should =~ /Greatest twitter clone ever build/
		end
		it "Should include base title" do
			full_title('').should_not =~ /\|/
		end
	end	
end
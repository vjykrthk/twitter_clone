require 'spec_helper'

describe "StaticPages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(title) ) }
  end
  describe "Home page" do
    let(:heading) { 'Twitter Clone'}
    let(:title) { '' }
    before { visit root_path }
    it_should_behave_like "all static pages"
    it { should_not have_selector('title', text:'| Home')}
  end
  describe "About page" do
    before { visit about_path }
    it { should have_selector('h1', text:'About Us') }
    it { should have_selector('title', text:full_title("About") ) }
  end
  describe "Help page" do
    before { visit help_path() }
    it { should have_selector('h1', text:'Help') }
    it { should have_selector('title', text:full_title("Help") ) }
  end
  describe "Contact" do
    before { visit contact_path }
    it { should have_selector('h1', text:'Contact Us') }
    it { should have_selector('title', text:full_title("Contact Us") ) } 
  end

  it "Should have right links on the page" do
      visit root_path
      click_link "About"
      should have_selector('h1', text:'About Us')
      click_link "Help"
      should have_selector('h1', text:'Help')
      click_link "Contact"
      should have_selector('h1', text:'Contact Us')
      click_link "twitter clone"
      should have_selector('h1', text:'Twitter Clone')
      click_link "Sign up now!"
      should have_selector('h1', text:'Sign Up')
  end

end

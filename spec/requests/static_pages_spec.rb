require 'spec_helper'

describe "StaticPages" do
  let(:base_title) { 'Greatest twitter clone ever build' }
  describe "About page" do
    it "Shoud have about page" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About Us')
    end
    it "Shoud have right title" do
      visit '/static_pages/about'
      page.should have_selector('title', 
                        :text => "#{base_title} | About")
    end
  end
  describe "Help page" do
    it "Shoud have help page" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end
    it "Shoud have right title" do
      visit '/static_pages/help'
      page.should have_selector('title', 
                        :text => "#{base_title} | Help")
    end
  end
  describe "Contact" do
    it "Shoud have contact page" do
      visit '/static_pages/contact'
      page.should have_selector('h1', :text => 'Contact Us')
    end
    it "Shoud have right title" do
      visit '/static_pages/contact'
      page.should have_selector('title', 
                        :text => "#{base_title} | Contact Us")
    end
  end
end

require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "RoR Sample App (Filling Layout)" }
  subject {page}

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before {visit root_path}
    let(:heading)    { base_title }
    let(:page_title) { '' }

    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path}
    let(:heading)    { base_title }
    let(:page_title) { '' }

  end

  describe "About page" do
    before { visit about_path}
    let(:heading)    { base_title }
    let(:page_title) { '' }
  end

  describe "Contact Page" do
    before {visit contact_path}
    let(:heading)    { base_title }
    let(:page_title) { '' }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "Sign Up Now !"
    expect(page).to have_title(full_title('Sign Up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end
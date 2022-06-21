require "rails_helper"

RSpec.feature "Show an Article" do
  before do
    @john = User.create!(email: "John@example.com", password: "password")
    @fred = User.create!(email: "Fred@example.com", password: "password")
    @article = Article.create(title: "First", body: "Lorem Ipsum", user: @john)
  end

  scenario "To non-signed in user hide edit and delete buttons" do
    visit "/"
    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

  scenario "To non-owner in user hide edit and delete buttons" do
    login_as(@fred)
    visit "/"
    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

  scenario "Signed in owner sees both edit and delete buttons" do
    login_as(@john)
    visit "/"
    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).to have_link("Edit Article")
    expect(page).to have_link("Delete Article")
  end
end

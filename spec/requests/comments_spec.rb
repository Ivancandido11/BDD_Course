require "rails_helper"

RSpec.feature "Comments", type: :request do
  before do
    @john = User.create!(email: "John@example.com", password: "password")
    @fred = User.create!(email: "Fred@example.com", password: "password")
    @article = Article.create(title: "First", body: "Lorem Ipsum", user: @john)
  end

  describe "POST /articles/:id/comments" do
    context "with a non signed in user" do
      before do
        post "/articles/#{@article.id}/comments", params: { comment: { body: "Awesome post" } }
      end

      it "redirects user to sign in page" do
        flash_message = "Please sign in or sign up first"
        expect(response).to redirect_to(new_user_session_path)
        expect(response.status).to eq 302
        expect(flash[:alert]).to eq flash_message
      end
    end

    context "with a logged in user" do
      before do
        login_as(@fred)
        post "/articles/#{@article.id}/comments", params: { comment: { body: "Awesome post" } }
      end

      it "creates the comment succesfully" do
        flash_message = "Comment has been created"
        expect(response).to redirect_to(article_path(@article))
        expect(response.status).to eq 302
        expect(flash[:notice]).to eq flash_message
      end
    end
  end
end

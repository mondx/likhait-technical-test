require 'rails_helper'

RSpec.describe "Api::Categories", type: :request do
  describe "GET /api/categories" do
    before do
      Category.create!(name: "Food")
      Category.create!(name: "Transport")
      Category.create!(name: "Supplies")
    end

    it "returns all categories" do
      get "/api/categories"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
      expect(json.map { |c| c["name"] }).to include("Food", "Transport", "Supplies")
    end

    it "returns categories in alphabetical order" do
      get "/api/categories"

      json = JSON.parse(response.body)
      expect(json.map { |c| c["name"] }).to eq([ "Food", "Supplies", "Transport" ])
    end
  end

  describe "POST /api/categories" do
    context "with a valid name" do
      it "creates the category and returns 201" do
        post "/api/categories", params: { category: { name: "Utilities" } }, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Utilities")
        expect(json["id"]).to be_present
      end

      it "persists the category to the database" do
        expect {
          post "/api/categories", params: { category: { name: "Utilities" } }, as: :json
        }.to change(Category, :count).by(1)
      end
    end

    context "with a blank name" do
      it "returns 422 with an error message" do
        post "/api/categories", params: { category: { name: "" } }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Name can't be blank")
      end

      it "does not create a category" do
        expect {
          post "/api/categories", params: { category: { name: "" } }, as: :json
        }.not_to change(Category, :count)
      end
    end

    context "with a duplicate name" do
      before { Category.create!(name: "Food") }

      it "returns 422 with an error message" do
        post "/api/categories", params: { category: { name: "Food" } }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Name has already been taken")
      end

      it "does not create a duplicate category" do
        expect {
          post "/api/categories", params: { category: { name: "Food" } }, as: :json
        }.not_to change(Category, :count)
      end
    end
  end
end

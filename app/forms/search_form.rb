class SearchForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  attr_accessor :search_term
end

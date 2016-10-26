class Question < ApplicationRecord
  belongs_to :user_auth

  has_many :choices, inverse_of: :question, dependent: :destroy
  has_many :voices, dependent: :destroy

  accepts_nested_attributes_for :choices, reject_if: proc { |attribs| attribs[:text].blank? }
  # since the UI for choice create/edit dictates
  # to specify a blank, there is no need to accept
  # direct destroy requests

  def author
    user_auth.name
  end

  def self.get_unseen_for(some_user_auth, limit=100)
    return nil unless some_user_auth
    Question.includes(Choice.find_by(user_auth: some_user.id))
      .where(choice: null)
      .order(cents: desc)
      .limit(limit)
  end

end
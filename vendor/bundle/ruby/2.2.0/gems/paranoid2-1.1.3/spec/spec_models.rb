class ParentModel < ActiveRecord::Base
  has_many :paranoid_models, dependent: :destroy
end

class PlainModel < ActiveRecord::Base
end

class ParanoidModel < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :parent_model
end

class FeaturefulModel < ActiveRecord::Base
  paranoid

  validates :name, presence: true, uniqueness: true
end

class CallbackModel < ActiveRecord::Base
  paranoid

  attr_accessor :callback_called

  before_destroy {|model| model.callback_called = true }
end

class ParentModel < ActiveRecord::Base
  paranoid
  has_many :related_models
end

class RelatedModel < ActiveRecord::Base
  paranoid

  belongs_to :parent_model
end

class Employer < ActiveRecord::Base
  paranoid

  has_many :jobs
  has_many :employees, through: :jobs
end

class Employee < ActiveRecord::Base
  paranoid

  has_many :jobs
  has_many :employers, through: :jobs
end

class Job < ActiveRecord::Base
  paranoid

  belongs_to :employer
  belongs_to :employee
end
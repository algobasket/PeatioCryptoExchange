require_relative 'spec_helper'

describe Paranoid2 do
  it 'has a version number' do
    Paranoid2::VERSION.wont_be_nil
  end

  let(:object) { model.new }

  describe PlainModel do
    let(:model) { PlainModel }

    before { model.unscoped.delete_all }

    it 'is not paranoid' do
      model.wont_be :paranoid?
    end

    it 'has not paranoid object' do
      object.wont_be :paranoid?
    end

    it 'has default destroy behavior' do
      model.count.must_equal 0
      object.save!
      model.count.must_equal 1

      object.destroy

      object.deleted_at.must_be_nil
      object.must_be :frozen?

      model.count.must_equal 0
      model.unscoped.count.must_equal 0
    end
  end

  describe ParanoidModel do
    let(:model) { ParanoidModel }

    before { model.unscoped.destroy_all! }

    it 'is paranoid' do
      model.must_be :paranoid?
    end

    it 'has paranoid object' do
      object.must_be :paranoid?
    end

    it 'returns valid value with to_param' do
      object.save
      param = object.to_param

      object.destroy

      object.to_param.wont_be_nil
      object.to_param.must_equal param
    end

    it "it doesn't actually destroy object" do
      model.count.must_equal 0
      object.save!
      model.count.must_equal 1

      object.destroy

      object.deleted_at.wont_be_nil
      object.must_be :frozen?

      model.count.must_equal 0
      model.unscoped.count.must_equal 1
    end

    it 'has working only_deleted scope' do
      a = model.create
      a.destroy
      b = model.create

      model.only_deleted.last.must_equal a
      model.only_deleted.wont_include b
    end

    it 'restores' do
      a = model.create
      a.destroy
      a.must_be :destroyed?

      b = model.only_deleted.find(a.id)
      b.restore
      b.reload
      b.wont_be :destroyed?
    end

    it 'can be force destroyed' do
      object.save
      object.destroy(force: true)

      object.must_be :destroyed?

      model.unscoped.count.must_equal 0
    end

    it 'can be force deleted' do
      object.save
      object.delete(force: true)

      model.unscoped.count.must_equal 0
    end

    it 'works with relation scopes' do
      parent1 = ParentModel.create
      parent2 = ParentModel.create
      a = model.create(parent_model: parent1)
      b = model.create(parent_model: parent2)
      a.destroy
      b.destroy
      parent1.paranoid_models.count.must_equal 0
      parent1.paranoid_models.only_deleted.count.must_equal 1
    
      c = model.create(parent_model: parent1)
      parent1.paranoid_models.with_deleted.count.must_equal 2
      parent1.paranoid_models.with_deleted.must_equal [a, c]
    end

    it 'works with has_many_through relationships' do
      employer = Employer.create
      employee = Employee.create

      employer.jobs.count.must_equal 0
      employer.employees.count.must_equal 0
      employee.jobs.count.must_equal 0
      employee.employers.count.must_equal 0

      job = Job.create employer: employer, employee: employee

      employer.jobs.count.must_equal 1
      employer.employees.count.must_equal 1
      employee.jobs.count.must_equal 1
      employee.employers.count.must_equal 1

      employee2 = Employee.create
      job2 = Job.create employer: employer, employee: employee2
      employee2.destroy

      employer.jobs.count.must_equal 2
      employer.employees.count.must_equal 1

      job.destroy

      employer.jobs.count.must_equal 1
      employer.employees.count.must_equal 0
      employee.jobs.count.must_equal 0
      employee.employers.count.must_equal 0
    end

    it 'restores has_many associations' do
      parent = ParentModel.create
      a = model.create(parent_model: parent)
      parent.destroy

      a.reload

      parent.must_be :destroyed?
      a.must_be :destroyed?

      parent = ParentModel.unscoped.find(parent.id)
      parent.restore

      a.reload

      parent.wont_be :destroyed?
      a.wont_be :destroyed?            
    end

    it 'restores belongs_to associations' do
      parent = ParentModel.create
      a = model.create(parent_model: parent)

      parent.destroy

      a.reload

      parent.must_be :destroyed?
      a.must_be :destroyed?

      a.restore

      a.wont_be :destroyed?
      a.parent_model.wont_be :destroyed?
    end
  end

  describe CallbackModel do
    let(:model) { CallbackModel }

    it 'delete without callback' do
      object.save
      object.delete
      
      object.callback_called.must_be_nil
    end

    it 'destroy with callback' do
      object.save
      object.destroy

      object.callback_called.must_equal true
    end
  end

  describe FeaturefulModel do
    let(:model) { FeaturefulModel }

    before { model.unscoped.destroy_all! }

    it 'chains paranoid models' do
      scope = model.where(name: 'foo').only_deleted
      scope.where_values_hash['name'].must_equal 'foo'
    end
  end
end

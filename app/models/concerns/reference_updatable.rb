module ReferenceUpdatable
  extend ActiveSupport::Concern

  included do
    after_commit on: [:create, :destroy,:update] do
      # if any reference of this model should be notified changes, then trigger elasticsearch update documents
      notify_change = [Doctor, Address, AppointmentSetting, DoctorProfile]
      self.class.reflections.each do |name, reflection|
        reference = self.send(name)
        if reflection.collection?
          if notify_change.include? reference.klass
            reference.each {|r| r.__elasticsearch__.update_document} if reference.klass.respond_to? :__elasticsearch__
          end
        else
          if notify_change.include? reference.class
            reference.__elasticsearch__.update_document if reference.class.respond_to? :__elasticsearch__
          end
        end
      end
    end
  end
end

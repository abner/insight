require 'state_machine/core'

# Generic class for building machines
class Machine
  def self.new(object, attribute, *args, &block)
    machine_class = Class.new
    machine = machine_class.state_machine(*args, &block)
    machine_attribute = machine.attribute
    action = machine.action

    # Delegate attributes
    machine_class.class_eval do
      define_method(:definition) { machine }
      define_method(machine_attribute) { object.send(:read_attribute, attribute) }
      define_method("#{machine_attribute}=") {|value| object.send(:write_attribute, attribute, value ) }
      define_method(action) { object.send(action) } if action
    end

    machine_class.new
  end
end

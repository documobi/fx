require "fx/command_recorder/arguments"
require "fx/command_recorder/function"

module Fx
  module CommandRecorder
    include Function

    private

    def perform_inversion(method, args)
      arguments = Arguments.new(args)

      if arguments.revert_to_version.nil?
        message = "`#{method}` is reversible only if given a `revert_to_version`"
        raise ActiveRecord::IrreversibleMigration, message
      end

      [method, arguments.invert_version.to_a]
    end
  end
end

ActiveRecord::Migration::CommandRecorder.send(
  :include,
  Fx::CommandRecorder,
)
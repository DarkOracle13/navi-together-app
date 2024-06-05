# frozen_string_literal: true

require_relative 'form_base'

module Cryal
  module Form
    class NewRoom < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_room.yml')

      params do
        required(:room_name).filled(max_size?: 256, format?: ROOMNAME_REGEX)
        required(:room_password).filled
        required(:room_description).maybe(:string)
      end
    end
  end
end

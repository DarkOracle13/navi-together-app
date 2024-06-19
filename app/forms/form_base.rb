# frozen_string_literal: true

require 'dry-validation'

module Cryal
  # Form helpers
  module Form
    USERNAME_REGEX = /^[a-zA-Z0-9_]+$/
    EMAIL_REGEX = /@/
    ROOMNAME_REGEX = /^[a-zA-Z0-9 ]+$/

    def self.validation_errors(validation)
      validation.errors.to_h.map { |k, v| [k, v].join(' ') }.join('; ')
    end

    def self.message_values(validation)
      validation.errors.to_h.values.join('; ')
    end
  end
end

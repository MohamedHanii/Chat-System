class Chat < ApplicationRecord
    belongs_to :application, class_name: "application", foreign_key: "application_id"
end

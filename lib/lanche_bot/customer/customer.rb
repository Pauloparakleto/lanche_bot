# frozen_string_literal: true

require "csv"

module Customer
  # classe customer
  class Customer
    DATA_PATH = "data/customers.csv"
    attr_accessor :id, :name, :phone

    def initialize(name, phone, id: rand(2000))
      @id = id
      @name = name
      @phone = phone
    end

    def create
      errors = validate_fields
      if errors.empty?
        CSV.open(DATA_PATH, "ab") do |csv|
          csv << [id, name, phone]
        end
        self
      else
        errors
      end
    end

    def validate_fields
      errors = []
      errors << "O Nome não pode ser vazio" if name.empty?
      errors << "O Phone não pode ser vazio" if phone.empty?
      errors
    end

    def self.find(id)
      data = CSV.read(DATA_PATH, { col_sep: ",", headers: true })
      data.each do |line|
        return line if line["id"] == id
      end
    end
  end
end

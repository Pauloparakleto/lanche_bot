# frozen_string_literal: true

module Order
  # class to order
  class Order
    DATA_PATH = "data/orders.csv"
    attr_reader :id, :customer, :restaurant, :items, :confirmed, :canceled, :canceled_by

    def initialize(args)
      @id = rand(2000)
      @customer = args.fetch(:customer)
      @restaurant = args.fetch(:restaurant)
      @items = args.fetch(:items, [])
      @confirmed = args.fetch(:confirmed, false)
      @canceled = args.fetch(:canceled, false)
      @canceled_by = args.fetch(:canceled_by, "")
    end

    def create
      errors = validate_fields
      if errors.empty?
        attributes = [id, customer.name, customer.phone, restaurant.name, items, confirmed.to_s, canceled, canceled_by]
        Helpers.csv_include(DATA_PATH, attributes)
        { order: self, message: new_customer? }
      else
        { order: nil, message: errors }
      end
    end

    def validate_fields
      errors = []
      errors << "O pedido deve ter ao menos 1 item" unless items.any?
      errors
    end

    def self.count_orders_by_costumer(phone)
      arr = Helpers.csv_parse(DATA_PATH).select { |row| row["customer_phone"] == phone }
      arr.length
    end

    def new_customer?
      "Olá, aqui é da Lanchonete #{restaurant.name}" if Order.count_orders_by_costumer(customer.phone) == 1
    end

    def order_confirmed?
      "Seu Pedido Foi Confirmado!" if confirmed
    end

    def order_canceled?
      "Seu Pedido Foi Cancelado por #{canceled_by}!" if canceled
    end

    def confirm_order
      @confirmed = true
    end

    def cancel_order(canceled_by)
      @canceled = true
      case canceled_by
      when "Customer"
        @canceled_by = customer.name
      when "Restaurant"
        @canceled_by = restaurant.name
      end
    end
  end
end

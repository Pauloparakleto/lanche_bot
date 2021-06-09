# frozen_string_literal: true

module Order
  # class to order
  class Order
    DATA_PATH = "data/orders.csv"
    attr_accessor :id, :customer, :restaurant, :items

    def initialize(customer, restaurant, items = [])
      @id = rand(2000)
      @customer = customer
      @customer_name = customer.name
      @restaurant = restaurant
      @restaurant_name = restaurant.name
      @items = items
    end

    def create
      erro = validar_dados
      if erro.empty?
        attributes = [id, @customer_name, @restaurant_name, items]
        Helpers.csv_include(DATA_PATH, attributes)
        { order: self, message: new_customer? }
      else
        { order: nil, message: erro }
      end
    end

    def validar_dados
      erros = []
      erros << "O pedido deve ter ao menos 1 item" unless items.any?
      erros
    end

    def self.count_orders_by_costumer(name)
      arr = Helpers.csv_parse(DATA_PATH).select { |row| row["customer_name"] == name }
      arr.length
    end

    def new_customer?
      "Olá, aqui é da Lanchonete #{restaurant.name}" if Order.count_orders_by_costumer(customer.name) == 1
    end
  end
end

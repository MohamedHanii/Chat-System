class RabbitmqWorker
    include Sidekiq::Worker
  
    def perform(message)
      # Handle the RabbitMQ message here
      puts "Received RabbitMQ message: #{message}"
    end
  end
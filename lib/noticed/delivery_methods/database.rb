module Noticed
  module DeliveryMethods
    class Database < Base
      # Must return the database record
      def deliver
        recipient.send(association_name).create!(attributes)
      end

      def self.validate!(options)
        super

        # Must be executed right away so the other deliveries can access the db record
        raise ArgumentError, "database delivery cannot be delayed" if options.key?(:delay)
        raise ArgumentError, "database delivery cannot be executed in bulk" if options.key?(:bulk)
      end

      private

      def association_name
        options[:association] || :notifications
      end

      def attributes
        if (method = options[:format])
          notification.send(method)
        else
          {
            type: notification.class.name,
            params: notification.params
          }
        end
      end
    end
  end
end

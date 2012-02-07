module Assistly
  class Client
    # Defines methods related to customers
    module Customer
      # Returns extended information of customers
      #
      #   @option options [Boolean, String, Integer]
      #   @example Return extended information for customers
      #     Assistly.customers
      #     Assistly.customers(:since_id => 12345, :count => 5)
      # @format :json
      # @authenticated true
      # @see http://dev.assistly.com/docs/api/customers
      def customers(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        response = get("customers",options)
        response
      end
      
      # Returns extended information on a single customer
      #
      #   @option options [String]
      #   @example Return extended information for customer 12345
      #     Assistly.customer(12345)
      # @format :json
      # @authenticated true
      # @see http://dev.assistly.com/docs/api/customers/show
      def customer(id)
        response = get("customers/#{id}")
        response.customer
      end

      # Create a new customer
      #
      #   @option options [String]
      #   @example Return extended information for 12345
      #     Assistly.create_customer(:name => "Chris Warren", :twitter => "cdwarren")
      # @format :json
      # @authenticated true
      # @see http://dev.assistly.com/docs/api/customers/create
      def create_customer(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        response = post("customers",options)
        if response['success']
          return response['results']['customer']
        else
          return response
        end
      end
      
      # Update a customer
      #
      #   @option options [String]
      #   @example Return extended information for 12345
      #     Assistly.update_customer(12345, :name => "Christopher Warren")
      # @format :json
      # @authenticated true
      # @see http://dev.assistly.com/docs/api/customers/update
      def update_customer(id, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        response = put("customers/#{id}",options)
        if response['success']
          return response['results']['customer']
        else
          return response
        end
      end
      
      ['email', 'phone', 'address'].each do |customer_detail|
      
        # Create a new customer user detail (email, phone, twitter)
        #
        #   @option options [String]
        #   @example Return extended information for 12345
        #     Assistly.create_customer_email(12345, "foo@example.com")
        #     Assistly.create_customer_phone(12345, "1234567890")
        #     Assistly.create_customer_twitter(12345, "mytwittername")                    
        # @format :json
        # @authenticated true  
        define_method "create_customer_#{customer_detail}" do |id, detail, *args|
          options = args.last.is_a?(Hash) ? args.pop : {}
          options.merge!({customer_detail => detail})

          response = post("customers/#{id}/#{customer_detail}s", options)
          if response['success']
            return response['results'][customer_detail]
          else
            return response
          end       
        end

        # Update a customer user detail (email, phone, twitter)
        #
        #   @option options [String]
        #   @example Return extended information for 12345
        #     Assistly.update_customer_email(12345, 67890, :email => "foo@example.com", :customer_contact_type => "work")
        #     Assistly.update_customer_phone(12345, 67891, :phone => "1234567890")    
        #     Assistly.update_customer_twitter(12345, 67892, :twitter => "mytwittername")            
        # @format :json
        # @authenticated true
        define_method "update_customer_#{customer_detail}" do |id, detail_id, *args|   
          options = args.last.is_a?(Hash) ? args.pop : {}
          response = put("customers/#{id}/#{customer_detail}s/#{detail_id}",options)
          if response['success']
            return response['results'][customer_detail]
          else
            return response
          end          
        end     
      end
      
    end
  end
end

module Intermodal
  module Controllers
    module Resource
      extend ActiveSupport::Concern

      included do
        include Intermodal::Controllers::Accountability
        include Intermodal::Controllers::Anonymous

        respond_to :xml, :json
        self.responder = Intermodal::ResourceResponder

        class_inheritable_accessor :model, :collection_name, :api

        let(:collection) { raise 'You must define collection' }
        let(:resource) { raise 'You must define resource' }

        let(:model) { self.class.model || self.class.collection_name.to_s.classify.constantize }
        let(:collection_name) { self.class.collection_name.to_s } # TODO: This might already be defined in Rails 3.x
        let(:resource_name) {collection_name.singularize }
        let(:model_name) { model.name.underscore.to_sym }

        let(:api) { self.class.api }
        let(:acceptor) { api.acceptors[model_name] }
        let(:accepted_params) { acceptor.call(params[resource_name] || {}) }
      end

      # Actions
      def index
        respond_with(collection)
      end

      def show
        respond_with(resource)
      end

      def create
        respond_with(model.create(create_params))
      end

      def update
        resource.update_attributes(update_params)
        respond_with(resource)
      end

      def destroy
        resource.destroy
        respond_with(resource)
      end
    end
  end
end
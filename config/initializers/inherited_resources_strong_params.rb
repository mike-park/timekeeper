# https://github.com/josevalim/inherited_resources/issues/236#issuecomment-11652170

# this is done by restful_json
# Add Strong Attributes support to all models (Remove in Rails4)
#ActiveRecord::Base.send(:include, ActiveModel::ForbiddenAttributesProtection)

# MonkeyPatch Inherited Resources to support strong parameters
module InheritedResources
  module BaseHelpers
    protected

    def build_resource
      get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_build, request.get? ? {} : resource_params))
    end

    def update_resource(object, attributes)
      object.update_attributes(attributes)
    end

  end
end

# in controllers have a resource_params method
# def resource_params
#   params.require(:group).permit(:name, :description)
# end
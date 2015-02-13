# MONGOID 4
module BSON
  class ObjectId
    alias :to_json :to_s
    alias :as_json :to_s
  end
end

module Mongoid
  module Document
    def serializable_hash(options = nil)
      h = super(options)
      h['id'] = h.delete('_id') if(h.has_key?('_id'))
      h
    end
  end
end

# module Mongoid
#   module Document
#     def to_json(options={})
#       attrs = super(options)
#       attrs["_id"] = attrs["_id"].to_s
#       attrs
#     end
#   end
# end
# MONGOID 3
# module Moped
#   module BSON
#     class ObjectId
#       alias :to_json :to_s
#       alias :as_json :to_s
#     end
#   end
# end

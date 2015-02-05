# module Mongoid
#   module Document
#     def to_json(options={})
#       attrs = super(options)
#       attrs["_id"] = attrs["_id"].to_s
#       attrs
#     end
#   end
# end
# module Moped
#   module BSON
#     class ObjectId
#       alias :to_json :to_s
#       alias :as_json :to_s
#     end
#   end
# end

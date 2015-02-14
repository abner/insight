module ZeroOidFix
  extend ActiveSupport::Concern

  # module ClassMethods
  #   def serialize_from_session(key, salt)
  #     record = to_adapter.get((key[0]["$oid"] rescue nil))
  #     record if record && record.authenticatable_salt == salt
  #   end
  # end
  # class << self
  #   def serialize_into_session(record)
  #     [record.id.to_s, record.authenticatable_salt]
  #   end
  # end

#FIX the problem with json cookie serialization on devise + mongoid
  def to_key
    id.to_s
  end
end

# frozen_string_literal: true

# Creates a HashWithIndifferentAcces hash from json content
class JsonWithIndifferentAccessSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(json)
    obj = HashWithIndifferentAccess.new(JSON.load(json))
    # obj.freeze
    obj
  end
end

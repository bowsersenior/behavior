class BehaviorConfig
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :key
  field :value
  index :key
  
  class << self
    def retrieve_by_key(some_key)
      where(:key => some_key).first
    end

    def retrieve_or_create_by_key(some_key)
      retrieve_by_key(some_key) or self.create(:key => some_key)
    end
  end  
end
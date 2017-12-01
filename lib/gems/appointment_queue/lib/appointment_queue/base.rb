module AppointmentQueue
  class Base
    def initialize(key, options = {})
      raise ArgumentError, 'First argument must be a non empty string' if !key.is_a?(String) || key.empty?

      @key = key
      @redis = options[:redis] || Redis.current
    end

    def push(member)
      @redis.zadd(@key, 1, member)
    end

    def will_pop_element
      @redis.watch(@key) do
        members(end_index: 0).first.tap do |member|
          if !member.nil?
            member
          else
            nil
          end
        end
      end
    end

    def in_queue?(member)
      return true if members.index(member.to_s)
      false
    end

    def queue_before_me(member)
      members.index(member.to_s) || 0
    end

    def top_element
      members.last
    end

    def pop
      @redis.watch(@key) do
        members(end_index: 0).first.tap do |member|
          if !member.nil?
            remove(member)
          else
            nil
          end
        end
      end
    end

    def remove(member)
      @redis.zrem(@key, member)
    end

    def size
      @redis.zcard(@key)
    end

    def clear!
      @redis.del(@key)
    end

    def members(start_index: 0, end_index: -1)
      @redis.zrange(@key, start_index, end_index) || []
    end
  end
end
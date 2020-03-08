module Retry
  def self.http(enumerable=nil, &block)
    procedure = lambda { |_| block.call }
    last_exception = nil

    # retry backoff timings
    backoff = 0.1
    backoff_max = 2.0

    if enumerable.nil?
      enumerable = 1.times
    end

    enumerable.each do |val|
      begin
        return procedure.call(val)

      rescue => e
        puts "Failed (#{e}). Retrying in #{backoff} seconds"
        last_exception = e
        # Exp backoff
        sleep(backoff)
        backoff = [backoff * 2, backoff_max].min unless backoff == backoff_max
      end
    end

    last_exception.set_backtrace(StandardError.new.backtrace)

    raise last_exception

  end #end do
end

require 'forwardable'

module DiskStats

  class ParseError < RuntimeError; end

  class Device
    LINE = Regexp.new('(\d+)\ +(\d+)\ ([\w-]+)\ (\d+)\ (\d+)\ (\d+)\ (\d+)\ (\d+)\ (\d+)\ (\d+)\ (\d+)\ (\d+)\ (\d+)\ (\d+)')

    def initialize line
      unless @line = LINE.match(line)
        raise DiskStats::ParseError.new("Error parsing line: #{line}")
      end
    end

    def major; @line[1].to_i; end
    def minor; @line[2].to_i; end
    def name; @line[3]; end
    def reads_completed; @line[4].to_i; end
    def reads_merged; @line[5].to_i; end
    def sectors_read; @line[6].to_i; end
    def read_time; @line[7].to_i; end
    def writes_completed; @line[8].to_i; end
    def writes_merged; @line[9].to_i; end
    def sectors_written; @line[10].to_i; end
    def write_time; @line[11].to_i; end
    def inflight; @line[12].to_i; end
    def total_time; @line[13].to_i; end
    def weighted_time; @line[14].to_i; end
  end

  class Parser
    extend Forwardable
    include Enumerable

    def_delegators :@devices, :each, :count

    def initialize output
      update output
    end

    def [] id
      case id
      when Symbol, String
        id = id.to_s
        @devices.find { |d| d.name == id }
      when Fixnum
        @devices[id]
      else
        nil
      end
    end

    def devices
      @devices.map { |d| d.name.to_sym }
    end

    def update new_output
      parse! new_output.split("\n")
    end

    private
    def parse! lines
      @devices = lines.map { |line| ::DiskStats::Device.new line }
    end
  end
end

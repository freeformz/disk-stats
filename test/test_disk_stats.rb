require 'helper'

$output =
%q{   1       0 ram0 0 0 0 0 0 0 0 0 0 0 0
   7       0 loop0 0 0 0 0 0 0 0 0 0 0 0
   7       1 loop1 0 0 0 0 0 0 0 0 0 0 0
   8       1 sda1 19855 6 508474 118980 959732 197454 9317336 45178260 136 546160 45302960
   8      16 sdb 143 6 1186 90 309 523 6656 2620 0 380 2710
   8      88 sdf8 8159 13 399360 57330 44722 40106 2189984 4677860 0 76940 4735190
   8      81 sdf1 8250 16 401466 110900 47127 40591 2213244 4678750 96 58847720 1350355434
   8      65 sde1 101 1 810 310 989858 1589839 20637576 18587270 0 536750 18587210
   9       0 md0 65272 0 3236125 0 680840 0 17512761 0 0 0 0
 254       0 dm-0 65226 0 3235829 728940 685988 0 17603486 84449350 130 58938560 3428434364
}

$output2 = 
%q{   1       0 ram0 0 0 0 0 0 0 0 0 0 0 0
   7       0 loop0 0 0 0 0 0 0 0 0 0 0 0
   7       1 loop1 0 0 0 0 0 0 0 0 0 0 0
   8       1 sda1 9855 6 58474 11980 95932 19454 917336 4178260 16 54160 4532960
}

describe DiskStats::Parser do

  describe 'with good data' do
    before do
      @parser = DiskStats::Parser.new($output)
    end

    it 'should properly count the number of devices' do
      @parser.count.must_equal 10
    end

    it 'should know the devices it has' do
      @parser.devices.must_equal [:ram0, :loop0, :loop1, :sda1, :sdb, :sdf8, :sdf1, :sde1, :md0, :'dm-0']
    end

    it 'should be enumerable' do
      @parser.is_a? Enumerable
    end

    it 'should support each, returning the right types' do
      @parser.each do |device|
        device.must_be_instance_of DiskStats::Device
      end
    end

    it 'should return nil for a disk that does not exist' do
      @parser[:foozle].must_be_nil
    end

    it 'should return a device when indexed by the device name' do
      @parser[:ram0].must_be_instance_of DiskStats::Device
      @parser[:ram0].name.must_equal 'ram0'
    end

    it 'should return the correct device when indexed by number' do
      @parser[4].must_be_instance_of DiskStats::Device
      @parser[4].name.must_equal 'sdb'
    end

    it 'should support updating' do
      @parser.update($output2)
      @parser[:sdf1].must_be_nil
      @parser[:sda1].name.must_equal 'sda1'
      @parser[:sda1].reads_completed.must_equal 9855
    end

  end

  describe 'with bad data' do

    it 'should raise a ParseError' do
      Proc.new { DiskStats::Parser.new('sdfsdfsdfsdfsdf') }.must_raise DiskStats::ParseError
    end
  end
end

describe DiskStats::Device do
  before do
    @parser = DiskStats::Parser.new($output)
  end

  it 'should have the right data for a specific parsed row' do
    @sdf1 = @parser[:sdf1]
    @sdf1.name.must_equal 'sdf1'
    @sdf1.major.must_equal 8
    @sdf1.minor.must_equal 81
    @sdf1.reads_completed.must_equal 8250 
    @sdf1.reads_merged.must_equal 16
    @sdf1.sectors_read.must_equal 401466
    @sdf1.read_time.must_equal 110900
    @sdf1.writes_completed.must_equal 47127
    @sdf1.writes_merged.must_equal 40591
    @sdf1.sectors_written.must_equal 2213244
    @sdf1.write_time.must_equal 4678750
    @sdf1.inflight.must_equal 96
    @sdf1.total_time.must_equal 58847720
    @sdf1.weighted_time.must_equal 1350355434
  end

  it 'should have the right data for a different specific parsed row' do
    @loop0 = @parser[:loop0]
    @loop0.name.must_equal 'loop0'
    @loop0.major.must_equal 7
    @loop0.minor.must_equal 0
    @loop0.reads_completed.must_equal 0
    @loop0.reads_merged.must_equal 0
    @loop0.sectors_read.must_equal 0
    @loop0.read_time.must_equal 0
    @loop0.writes_completed.must_equal 0
    @loop0.writes_merged.must_equal 0
    @loop0.sectors_written.must_equal 0
    @loop0.write_time.must_equal 0
    @loop0.inflight.must_equal 0
    @loop0.total_time.must_equal 0
    @loop0.weighted_time.must_equal 0
  end
end

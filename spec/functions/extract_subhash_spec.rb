require 'spec_helper'

describe 'extract_subhash' do

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('extract_subhash')).to eq('function_extract_subhash')
  end

  describe 'check bad argument conditions' do
    it 'raise a ParseError if there is less than 2 arguments' do
      expect { subject.call([]) }.to raise_error(Puppet::ParseError, /Wrong number of arg/)
    end

    it 'raise a ParseError if there is more than 2 arguments' do
      expect { subject.call([{'foo1' => 'bar1'}, {'foo2' => 'bar2'},{'foo3' => 'bar3'}]) }.to raise_error(Puppet::ParseError, /Wrong number of arg/)
    end

    it 'raise a ParseError if first argument is not a hash' do
      expect { subject.call(['foo1', 'bar1']) }.to raise_error(Puppet::ParseError, /to be a hash/)
    end

    it 'raise a ParseError if second argument is not a string' do
      expect { subject.call([{'foo1' => 'bar1'}, {'foo2' => 'bar2'}]) }.to raise_error(Puppet::ParseError, /to be a string/)
    end
  end

  describe 'check good argument conditions:' do
    describe 'hash and string arguments' do
      it 'will not raise an ParseError condition' do
        expect { subject.call([{'foo' => 'bar'}, 'baz']) }.to_not raise_error()
      end
    end
  end

  describe 'check return values' do
    it 'should be empty array' do
      expect(subject.call([{"yaml"=> {"datadir"=>"/root/dev/test"}, "file"=>{"datadir"=>"/root/dev/foo"}}, 'foo'])).to(eq({}))
    end
    it 'should be array with one hash' do
      expect(subject.call([{"yaml"=> {"datadir"=>"/root/dev/test"}, "file"=>{"datadir"=>"/root/dev/foo"}}, 'yaml'])).to(eq({"yaml"=>{"datadir"=>"/root/dev/test"}}))
    end
  end

end

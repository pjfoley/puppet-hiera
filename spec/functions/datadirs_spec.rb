require 'spec_helper'

describe 'datadirs' do

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('datadirs')).to eq('function_datadirs')
  end

  describe 'checking bad argument conditions' do
    it 'raise a ParseError if there is less than 1 argument' do
      expect { subject.call([]) }.to raise_error(Puppet::ParseError, /Wrong number of arg/)
    end

    it 'raise a ParseError if there is more than 1 argument' do
      expect { subject.call([{'foo1' => 'bar1'}, {'foo2' => 'bar2'}]) }.to raise_error(Puppet::ParseError, /Wrong number of arg/)
    end

    it 'raise a ParseError if argument is a string' do
      expect { subject.call(['foo1']) }.to raise_error(Puppet::ParseError, /Requires a hash/)
    end

    it 'raise a ParseError if argument is an array' do
      expect { subject.call([['foo1']]) }.to raise_error(Puppet::ParseError, /Requires a hash/)
    end
  end

  describe 'check good argument condition' do
    it 'when passed a single argument which is a hash do not raise a ParseError' do
      expect { subject.call([{'foo' => 'bar'}]) }.to_not raise_error()
    end
  end

  describe 'checking return values' do
    it 'should be empty array' do
      expect(subject.call([{ 'foo' => '/foo/bar'}])).to(eq([]))
    end
    it 'should find a single value' do
      expect(subject.call([{ 'foo' => {'datadir' => '/foo/bar'}}])).to(eq(['/foo/bar']))
    end
    it 'should return a single unique value' do
      expect(subject.call([{ 'foo' => {'datadir' => '/foo/bar'},  'bar' => {'datadir' => '/foo/bar'}}])).to(eq(['/foo/bar']))
    end
    it 'should return two values' do
      expect(subject.call([{ 'foo' => {'datadir' => '/foo/bar'},  'bar' => {'datadir' => '/foo/oof'}}])).to(eq(['/foo/bar', '/foo/oof']))
    end
    it 'should return one value and remove variable placeholder' do
      expect(subject.call([{ 'foo' => {'datadir' => '/foo/bar/%%{}{environment}/'}}])).to(eq(['/foo/bar']))
    end
  end
end

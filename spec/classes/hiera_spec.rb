require 'spec_helper'

describe 'hiera' do

  context 'with puppet enterprise and default parameters on debian' do
    let :facts do
      {
        :operatingsystem => 'debian',
        :puppetversion => 'Puppet Enterprise'
      }
    end
    let (:params) {{ }}

    it 'properly sets default parameters when called without parameters' do
      should create_file('/etc/puppetlabs/puppet/hieradata').with({
        'ensure' => 'directory',
        'owner' => 'pe-puppet',
        'group' => 'pe-puppet',
        'mode' => '0644',
      })

      should create_file('/etc/puppetlabs/puppet/hiera.yaml').with({
        'ensure' => 'present',
      })

      should create_file('/etc/hiera.yaml').with({
        'ensure' => 'symlink',
        'target' => '/etc/puppetlabs/puppet/hiera.yaml',
      })
    end
  end

  context 'with puppet community edition and default parameters on debian' do
    let :facts do
      {
        :operatingsystem => 'debian',
        :puppetversion => '2.7.23'
      }
    end
    let (:params) {{ }}

    it 'properly sets default parameters when called without parameters' do
      should create_file('/etc/puppet/hieradata').with({
        'ensure' => 'directory',
        'owner' => 'puppet',
        'group' => 'puppet',
        'mode' => '0644',
      })

      should create_file('/etc/puppet/hiera.yaml').with({
        'ensure' => 'present',
      })

      should create_file('/etc/hiera.yaml').with({
        'ensure' => 'symlink',
        'target' => '/etc/puppet/hiera.yaml',
      })
    end

    it 'uses the yaml backend by default' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{---\n:backends:\n  - yaml})
    end

    it 'uses an empty hierarchy by default' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{hierarchy:\n\n:yaml:})
    end
  end

  context 'with custom backend configuration' do
    let (:facts) {{ :puppetversion => '2.7.23' }}
    let (:params) {{
      :backends => {'foo' => {'fooy'  => '/foo/a', 'foo_truthy'   => 'true', 'foo_falsey' =>'false'}, 'bar' => { 'bary' => '/bar/b', 'bar_truthy' => 'false', 'bar_falsey' => 'false'}},
    }}

    it 'properly configures the given backends' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{backends:\n  - foo\n  - bar\n:logger:})
    end

    it 'properly configures the given backends custom configuration' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{:foo:\n  :foo_falsey: false\n  :foo_truthy: true\n  :fooy: /foo/a\n:bar:\n})
    end
  end
end

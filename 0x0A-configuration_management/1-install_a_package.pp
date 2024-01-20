# Ensure the necessary provider is available
package { 'puppetlabs-python':
  ensure => present,
}

# Install Flask 2.1.0 using pip3
package { 'flask':
  ensure   => '2.1.0',
  provider => pip3,
}


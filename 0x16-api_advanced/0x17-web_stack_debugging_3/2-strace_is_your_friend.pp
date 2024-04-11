# Debug web_server
  # Ensure Apache is installed
  package { 'apache2':
    ensure => installed,
  }

  # Ensure the headers module is enabled
  exec { 'enable_headers_module':
    command => '/usr/sbin/a2enmod headers',
    require => Package['apache2'],
  }

  # Add the headers to the Apache configuration file
  file_line { 'add_headers':
    path    => '/etc/apache2/sites-available/000-default.conf',
    line    => '<Directory "/var/www/html">
                Header set Link "<http://127.0.0.1/?rest_route=/>; rel=\"https://api.w.org/\""
                Header set X-Powered-By "PHP/5.5.9-1ubuntu4.21"
                Header unset Last-Modified
                Header unset ETag
                Header unset Accept-Ranges
                Header set Content-Type "text/html; charset=UTF-8"
              </Directory>',
    after   => '</VirtualHost>',
    require => Exec['enable_headers_module'],
  }

  # Create the index.html file
  file { '/var/www/html/index.html':
    ensure  => file,
    content => '<title>Holberton – Just another WordPress site</title>
                <link rel="alternate" type="application/rss+xml" title="Holberton » Feed" href="http://127.0.0.1/?feed=rss2" />
                <link rel="alternate" type="application/rss+xml" title="Holberton » Comments Feed" href="http://127.0.0.1/?feed=comments-rss2" />
                <div id="wp-custom-header" class="wp-custom-header"><img src="http://127.0.0.1/wp-content/themes/twentyseventeen/assets/images/header.jpg" width="2000" height="1200" alt="Holberton" /></div>
                <h1 class="site-title"><a href="http://127.0.0.1/" rel="home">Holberton</a></h1>
                <p>Yet another bug by a Holberton student</p>',
    require => File_line['add_headers'],
  }

  # Ensure Apache service is running and restarts when config changes
  service { 'apache2':
    ensure    => running,
    enable    => true,
    subscribe => [File_line['add_headers'], File['/var/www/html/index.html']],
  }

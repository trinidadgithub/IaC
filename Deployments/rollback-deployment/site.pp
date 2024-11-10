node default {
    # Step 1: Simulate a failure by creating the failure file
    exec { 'simulate_failure':
        command => '/usr/bin/touch /tmp/simulate_failure',
        creates => '/tmp/simulate_failure',  # Only creates if it doesn't already exist
    }

    # Step 2: Attempt to install or update to version 2
    exec { 'install-c-app-v2':
        command => '/usr/bin/dpkg -i ./c_app1/c-app-v2.deb',
        unless  => '/usr/bin/dpkg -s c-app | grep -q \'Version: 2.0\'',
    }

    # Step 3: Roll back to version 1 if failure is detected (via the failure file)
    exec { 'rollback-to-v1':
        command => '/usr/bin/dpkg -i ./c_app/c-app-v1.deb',
        onlyif  => '/bin/test -f /tmp/simulate_failure',
    }

    # Step 4: Clean up for future testing
    exec { 'cleanup_failure_file':
        command => '/usr/bin/rm -f /tmp/simulate_failure',
        onlyif  => '/bin/test -f /tmp/simulate_failure',
        require => Exec['rollback-to-v1'],
    }

}

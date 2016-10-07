# -*- coding: utf-8 -*-

'''
Another slsutils module

Extending https://github.com/saltstack/salt/tree/develop/salt/modules

See also:
 - https://github.com/saltstack/salt/issues/12761
 - https://groups.google.com/forum/#!topic/salt-users/BQpzBO5RopQ

Other useful links to revisit:
  - http://stackoverflow.com/questions/20897796/using-the-output-of-salt-to-be-used-as-input-for-an-sls-state-or-pillar
  - http://stackoverflow.com/questions/21857533/defining-states-depending-on-existance-of-a-file-directory/21884669#21884669
  - https://docs.saltstack.com/en/latest/topics/grains/index.html
  - https://github.com/saltstack/salt/tree/develop/salt/grains
  - https://docs.saltstack.com/en/latest/topics/grains/index.html
  - https://docs.saltstack.com/en/latest/topics/states/index.html

'''

from string import digits
from datetime import datetime


def remove_digits(string):
    return string.translate(None, digits)


def nodename_to_role(string):
    return remove_digits(string.split('-')[0])


def filter_list(list, key, value):
    '''Filter a list based on one one member property from a list

    Imagine we have a list like this

    ```jinja
    {%- set all_internal_nodes = [
              {'name': 'web222', 'private_ip': '10.0.0.33', 'role': 'web'},
              {'name': 'noc', 'private_ip': '10.0.0.2', 'role': 'noc'}
    ] %}
    ```

    And we want only the entries who has role with a given value (e.g. role is noc)

    ```jinja
    {%- set noc_node = salt['slsutils.filter_list'](all_internal_nodes, 'role', 'noc') %}
    ```

    We {{ noc_node|json }} would then be

    ```json
    [{"name": "noc", "private_ip": "10.0.0.2", "role": "noc"}]
    ```

    ## Where it is used
      - gdnsd/master.sls

    ## Credits
      - http://stackoverflow.com/questions/20529234/how-to-select-reduce-a-list-of-dictionaries-in-flask-jinja
    '''
    return filter(lambda t: t[key] == value, list)


def strftime(format=None):
    """
    Return a string representing the date and time, controlled by an explicit
    format string. Time is always UTC.

    For formatting syntax, see Pytnon [datetime-docs]

    [datetime-docs]: https://docs.python.org/2/library/datetime.html#strftime-strptime-behavior

    From the CLI::
      salt-call slsutils.strftime '%H:%M:%S'

    In a SLS::
      ```jinja
      {%- set date = salt['slsutils.strftime']('%Y-%m-%d') %}
      {# Elsewhere in a state #}
      Today we are {{ date }}:
        test:
          - succeed_with_changes
      ```

      Should output "Today we are 2016-09-22" if we were on Sept 22th 2016.

      Default if no argument is given, it will return a ISO 8601 formatted timestamp string:

        2016-09-22T16:24:01.306579

      Which would be equivalent of using:

        '%Y-%m-%dT%H:%M:%S.%f'

    """
    if format is not None:
      return datetime.utcnow().strftime(format)
    else:
      return datetime.utcnow().isoformat()

#!/usr/bin/env python

# Incomplete.

import salt.config
import salt.loader
__opts__ = salt.config.minion_config('/etc/salt/minion')
__grains__ = salt.loader.grains(__opts__)
role = __grains__['role']
print role

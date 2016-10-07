#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Grains to help enforce conventions

See also:
 - http://stackoverflow.com/questions/27376313/salt-custom-grains
 - https://github.com/webplatform/salt-states/blob/201506-refactor/_grains/purpose.py

And other bookmarks in _modules/slsutils.py

'''

import socket
from string import digits


## COPYPASTA from _modules/slsutils.py
## Please keep in sync (!)
## ... We'll copy-paste that way until we find how to import from a _module
##     and/or once we need more than this to be copied around.
##
## If you make change to _modules/slsutils.py and want to copy it here, make sure
## you add an underscore before function name. Otherwise Salt will complain.
## Grain functions requires no arguments.
def _nodename_to_role(string):
    return _remove_digits(string.split('-')[0])

def _remove_digits(string):
    return string.translate(None, digits)
## /COPYPASTA from _modules/slsutils.py


def role():
    '''
    Take the hostname, create a list of dash separated strings,
    strip digits, return one word.

        salt1         -> "salt"
        redis1-jobs   -> "redis"
        web1-foo-3-23 -> "web"

    '''
    name = _nodename_to_role(socket.gethostname())
    return {'role': name}

#!/bin/bash

# Copyright (c) 2014-2018 Dominique Leuenberger, Muhen, Switzerland
# Copyright (c) 2016 Raymond Wooninck, Vienna, Austria

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# Cleanup existing appdata found on the system
for list in $(find /var/cache/app-info/xmls/*.xml.gz 2> /dev/null); do
	appdata=$(basename ${list} .xml.gz)
	appstream-util uninstall "${appdata}" 2>&1 > /dev/null
done

# Install new appdata files - libzypp calls us with 6 parameters per repo:
# -R REPO_ALIAS -t REPO_TYPE -p REPO_METADATA_PATH [-R NEXT_REPO....]
# We can just blindly pass the parameters through to to helper
while ([ "$1" = "-R" ]); do
  /usr/lib/AsHelper install $1 $2 $3 $4 $5 $6
  shift 6
done

# Fixup icon that might have uncompressed with odd permissions
chmod 755 /var/cache/app-info/icons/*

# (Re)create the Xapian database required by the KDE tools
appstreamcli refresh-cache

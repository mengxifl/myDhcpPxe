#! /usr/bin/python

###############################################################################
# Copyright (c) 2008-2019 VMware, Inc.
#
# This file is part of Weasel.
#
# Weasel is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# version 2 for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51
# Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#

'''
Execute an VUM upgrade through esximage.Transaction class.
'''

import os
import sys
import logging
import optparse
try:
    import upgrade_precheck
except ImportError:
    try:
        import precheck as upgrade_precheck
    except ImportError:
        import PRECHECK as upgrade_precheck

# Directory where this file is running. Script expects data files, helper
# utilities to exist here.
SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))

logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.INFO)

systemProbe = None
pathToISO = None

#------------------------------------------------------------------------------
def calcExpectedPaths():
    global pathToISO
    pathToISO = upgrade_precheck.RAMDISK_NAME
    if os.path.exists(upgrade_precheck.RAMDISK_NAME):
        # upgrade_precheck has already allocated the correct-sized ramdisk
        log.info('RAM disk already exists')
        return
    if systemProbe.imageMetadata:
        size = systemProbe.imageMetadata.sizeOfUpgradeImage
    else:
        log.warn('Could not get ISO size from the precheck metadata.'
                 ' Guessing 400MiB')
        size = 400*1024*1024 # 400 MiB
    upgrade_precheck.allocateRamDisk(upgrade_precheck.RAMDISK_NAME,
                                     sizeInBytes=size)
#------------------------------------------------------------------------------
def showExpectedPaths():
    print('image=%s' % pathToISO)

#------------------------------------------------------------------------------
def main():
    parser = optparse.OptionParser()
    parser.add_option('-s', '--showexpectedpaths',
                      dest='showExpectedPaths', default=False,
                      action='store_true',
                      help=('Show expected paths for ISO, isoinfo, and user'
                            ' agent.'))
    parser.add_option('-v', '--verbose',
                      dest='verbose', default=False,
                      action='store_true',
                      help=('Verbosity. Turns the logging level up to DEBUG'))
    parser.add_option('--ip',
                      dest='ip', default='',
                      help=('The IP address that the host should bring up'
                            ' after rebooting.'))
    parser.add_option('--netmask',
                      dest='netmask', default='',
                      help=('The subnet mask that the host should bring up'
                            ' after rebooting.'))
    parser.add_option('--gateway',
                      dest='gateway', default='',
                      help=('The gateway that the host should use'
                            ' after rebooting.'))
    parser.add_option('--ignoreprereqwarnings',
                      dest='ignoreprereqwarnings', default='False',
                      help=('Ignore the precheck warnings during upgrade/install.'))

    parser.add_option('--ignoreprereqerrors',
                      dest='ignoreprereqerrors', default='False',
                      help=('Ignore the precheck errors during upgrade/install.'))

    options, _ = parser.parse_args()

    if options.verbose:
        log.setLevel(logging.DEBUG)

    global systemProbe
    _, version = upgrade_precheck._getProductInfo()
    upgrade_precheck.init(upgrade_precheck.SystemProbeESXi.VUM_ENV, False)
    systemProbe = upgrade_precheck.systemProbe
    assert systemProbe.bootDeviceName
    log.info('found boot device %s' % systemProbe.bootDeviceName)

    calcExpectedPaths()

    if options.showExpectedPaths:
        showExpectedPaths()
        return 0

    # vmware package is designed to be able to spread across muliple
    # places. For subpackage of the same name (esximage), compiled copy
    # is preferred by the runtime. We want to always use the package in
    # esximage.zip, we can accomplish this by importing esximage package
    # from esximage.zip/vmware directly, which will not be confused with
    # the library in the host /lib64 folder.
    esximageZip = os.path.join(SCRIPT_DIR, 'esximage.zip')
    sys.path.insert(0, os.path.join(esximageZip, 'vmware'))

    import esximage
    if esximage.SYSTEM_STORAGE_ENABLED:
        # Add systenStorage lib path.
        log.info('New system storage feature is enabled')
        sys.path.insert(0, os.path.join(esximageZip, 'systemStorage'))

    from esximage.Transaction import Transaction

    log.info('Performing image profile update from ESXi %s' % version)
    try:
        t = Transaction()
        res = t.InstallVibsFromDeployDir(pathToISO)
    except Exception as e:
        log.error('Failed to perform image profile update: %s' % e)
        raise
    log.info('VIB installed: %s' % str(res.installed))
    log.info('VIB removed: %s' % str(res.removed))
    log.info('VIB skipped: %s' % str(res.skipped))
    return 0

if __name__ == "__main__":
    sys.exit(main())

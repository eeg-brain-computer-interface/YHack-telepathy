import sys
import subprocess
import signal
import time
import pexpect

def main():
    call = '/Applications/Muse/muse-player -l udp:5000 -M test.mat'
    proc = pexpect.spawn(call)

    time.sleep(1.2)
    proc.sendcontrol('c')
    proc.close()


if __name__ == '__main__':
    main()

#main()

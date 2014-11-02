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

def main2():
#    sys.stdout.write("Hello World!")
    proc = subprocess.Popen(["/Applications/Muse/muse-player", "-l", "udp:5000", "-M", "test.mat"], creationflags=0)
    
    child_pid = proc.pid

    time.sleep(5)
    proc.terminate()

if __name__ == '__main__':
    main()

#main()

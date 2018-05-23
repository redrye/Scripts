sed -i 's/getuid/getpid/g' /usr/bin/kwrite
sed -i 's/getuid/getpid/g' /usr/bin/kate
sed -i 's/getuid/getpid/g' /usr/lib/libkdeinit5_dolphin.so
sed -i 's/geteuid/getppid/g' /usr/bin/vlc

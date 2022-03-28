How to add kali repo to your distro when public key gives an error:

Ghidra depends on Java 11:
    $ sudo apt install default-jre default-jdk

Add repository to /etc/apt/sources.list : deb http://http.kali.org/kali kali-rolling main non-free contrib

    $ gpg --keyserver pgpkeys.mit.edu --recv-key  ED444FF07D8D0BF6
    $ gpg -a --export ED444FF07D8D0BF6 | sudo apt-key add -
    $ sudo apt-get update
    $ sudo apt-get install ghidra

Run:
    
    $ ghidra

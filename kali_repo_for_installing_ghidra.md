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
    
Program to investegate :

    https://github.com/grotius-cnc/dump/releases/download/1.2/draftSight.deb

Log :

    To understand the Gidhra program we test a standard qt application.

    - Create a qt application "untitled" and compile.
    - Start project in Ghidra
    - Import file : ~/build-untitled-Desktop-Debug/untitled
        1. Load as raw binary
        2. Language : X86 gcc
        3. Analize : yes
    - Save project
    - Export project as "untitled1"
    - Change file properties "untitled1" to executable and read-write for all.
    - Run 
        `./untitled1.bin`
    - Conclusion
        New executable run's ok.
        
        
        
        

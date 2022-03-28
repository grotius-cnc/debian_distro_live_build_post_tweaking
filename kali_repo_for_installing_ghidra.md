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

Step 0, to understand the Gidhra program we test a standard qt application.

    - Create a qt application "untitled" and compile.
    - Start project in Ghidra
    - Import file : ~/build-untitled-Desktop-Debug/untitled
        1. Load as raw binary
        2. Language : X86 gcc
        3. Analize : yes
    - Save project
    - Export project as "untitled1"
    - Change file properties "untitled1.bin" to executable and read-write for all.
    - Run 
    - Conclusion
        New executable run's ok.
        
        
Step 1, try to change some text.
    
    - Create a qt application that display's a text : "Hacked by : Nothing at all."
    
![screen01](https://user-images.githubusercontent.com/44880102/160398969-2b45c115-732a-42a1-8f1f-c843b5b966c4.jpg)

Open new Ghidra project as by above "Step 0", Find text "hacked" and get the hex format of the full string :
        ![screen](https://user-images.githubusercontent.com/44880102/160398739-3f79871a-3fa5-473a-a32a-a998f95377cd.jpg)
        
        Then use for example https://codebeautify.org/string-hex-converter to get a new string to hex.
      
Edited bytes by hand:

![screen02](https://user-images.githubusercontent.com/44880102/160404023-4cc2fd67-ee03-4bcf-ac91-29de56740411.jpg)

Save project, save program, set file permissions, and run :

![screen03](https://user-images.githubusercontent.com/44880102/160404609-a9429656-0890-4cbc-b057-9e5e4039eb3b.jpg)

Conclustion Step.2, this looks okey to me. 


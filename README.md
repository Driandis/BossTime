# BOSSRUSH

 ## Preconditions to work on BossRush
  
  1. PowerShell
  2. SSH
    2.1 Generate key   
  3. Git
    3.1 Clone Project 
  4. Godot

### 1. Install PowerShell (Version 5.1 or later)
   > Open search and enter "cmd" hit enter 
   > winget install --id Microsoft.PowerShell --source winget

####  2. Install SSH
   >  Open PowerShell in admin mode
   >  enter "Set-Service -Name sshd -StartupType 'Automatic'"

> 2.1  Generate SSh-key for git
    >  Open search and enter "cmd" hit enter
    >  enter "ssh-keygen -t rsa"
    >  Under  C:\Users\Username\.ssh should be two new files. Your key for github is in id_rsa.pub
    
###3. Register on Git and add key
   After registering on Git
   Got to your Settings (click on Icon at top right)
   Under "Access" click on "SSH and GPG keys"
   Click on "New SSH key"
   Copy the whole key starting with "ssh-rsa" don't copy your user and machine name at the end
 
> 3.1 Copy Project
     Ask for Permission to work on the Prject "maximilian.gross@gmx.de"
     At the start screen of the project you should see a green button "<> Code "
     Click on it and select "SSH" tab and copy link to clipboard
     Open a folder where you want to save the project
       Node: Git will create a folder with name "BossRush" while cloning (So better create a folder like Project and open the command line on this folder)
       C:\User\Username\Project will produce -> C:\User\Username\Project\BossRush
     Open command line by entering "cmd" on the filepath line or use "cd C:\User\Username\Project\BossRush" in command line to switch folders
     Type "git clone https://github.com/Driandis/BossRush.git" and hit enter
     Project should now be copied on your local file system

###4. Install Godot
   Go to https://godotengine.org/download/windows/
   Download NET.SDK and install (simple wizard)
   Download Windows - x86_64 (https://github.com/godotengine/godot/releases/download/4.4.1-stable/Godot_v4.4.1-stable_win64.exe.zip)
   Now you should be able to run Godot
   Click on "Import" and select the folder where you saved the cloned project

Happy Coding :)
   


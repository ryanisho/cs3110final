# `got` - A Command-Line Interface Tool (CS 3110 - FA23)

```
          ______                  _______               _____         
         /\    \                 /::\    \             /\    \         
        /::\    \               /::::\    \           /::\    \        
       /::::\    \             /::::::\    \          \:::\    \       
      /::::::\    \           /::::::::\    \          \:::\    \      
     /:::/\:::\    \         /:::/~~\:::\    \          \:::\    \     
    /:::/  \:::\    \       /:::/    \:::\    \          \:::\    \    
   /:::/    \:::\    \     /:::/    / \:::\    \         /::::\    \   
  /:::/    / \:::\    \   /:::/____/   \:::\____\       /::::::\    \  
 /:::/    /   \:::\ ___\ |:::|    |     |:::|    |     /:::/\:::\    \ 
/:::/____/  ___\:::|    ||:::|____|     |:::|    |    /:::/  \:::\____\
\:::\    \ /\  /:::|____| \:::\    \   /:::/    /    /:::/    \::/    /
 \:::\    /::\ \::/    /   \:::\    \ /:::/    /    /:::/    / \/____/ 
  \:::\   \:::\ \/____/     \:::\    /:::/    /    /:::/    /          
   \:::\   \:::\____\        \:::\__/:::/    /    /:::/    /           
    \:::\  /:::/    /         \::::::::/    /     \::/    /            
     \:::\/:::/    /           \::::::/    /       \/____/             
      \::::::/    /             \::::/    /                            
       \::::/    /               \::/____/                             
        \::/____/                 ~~                                   
```

## Features of 'got'

`got` is a command-line interface tool designed for version control. It offers a variety of functions similar to Git but with its unique syntax and features. Here's a brief overview of its capabilities:

1. **Initialization (`init`)**: Initialize a new version-controlled project. Usage: `./got init <path>`

2. **Addition (`add`)**: Add files to the staging area in preparation for committing. Usage: `./got add <file>`

3. **Removal (`rm`)**: Remove files from the current working directory and the staging area. Usage: `./got rm <file>`

4. **Committing Changes (`commit`)**: Save the staged changes to the project history. Usage: `./got commit <message>`

5. **Viewing Log (`log`)**: Display a log of all commits made to the repository. Usage: `./got log`

6. **Checking Status (`status`)**: View the status of files in the current working directory and staging area. Usage: `./got status`

7. **Branching (`branch`)**: Manage branches in the repository. Usage: `./got branch` to list branches or `./got branch -D <branch>` to delete a branch

8. **Checkout (`checkout`)**: Switch between different branches. Usage: `./got checkout <branch>` to switch to an existing branch or `./got checkout -b <branch>` to switch to a new branch

9. **Reset (`reset`)**: Reset commit and / or repository history. Usage: `./got reset <timestamp>` to reset commit history or `./got reset --hard <timestamp>` to reset commit and repository history.

10. **Merging (`merge`)**: [Feature in Development] Merge changes from different branches.

11. **Stashing (`stash`)**: [Feature in Development] Temporarily store modified, tracked files.

12. **Diffing (`diff`)**: [Feature in Development] Compare changes across commits, branches, etc.

13. **General Help**: Get a general usage guide by running `got` without arguments.

---

## A Basic Workflow Using Got: 

```bash
./got init
echo "bar" > repo/foo.txt
./got add foo.txt
./got commit -m "Create foo"
echo "buzz" > repo/fizz.txt
./got add fizz.txt
./got commit -m "Create fizz"
./got rm fizz.txt
./got commit -m "Remove fizz" 

## Authors of 'got'

1. **Bryant Park (blp73)**

2. **Chris Xu (cx72)**

3. **Junkai Zheng (jz765)**

4. **Ryan Ho (rh564)**

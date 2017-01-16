# youtubeveri
A script to verify authenticity of a youtube channel

#tutorial
*clone the repository
*cd into the directory containing the cloned files
*execute :
chmod +x ./verify_youtube.sh     ==> to make the file executable

#N.B The files: file1.txt, file2.txt are files containing the youtube links and the script is executed like so:

./verify_youtube.sh file1.txt final1

Please replace file1.txt with the appropriate file containing the links and final one with the file that you would like to store the output of the script




#extra note: Using tutorials point coding ground.
After cloning the files, access tuturials point. Upload the files : verify_youtube.sh and file1.txt(replace with the file containing the youtube links). Then save the project. Note that coding group has tendency to timeout and its adviced to repeat saving the project at short intervals. I saved to google drive myself. Github has a limit of 2MB files.

After uploading the files and saving the project, execute the script from the shell below the page like so:

bash -f verify_youtube.sh file1.txt final1

#KEEP SAVING THE OUTPUT FREQUENTLY

You can check for the file being write like so:

watch -n 0.1 'cat final1'

To see the current line on the file being written:

watch -n 0.1 'cat final1 | wc -l'


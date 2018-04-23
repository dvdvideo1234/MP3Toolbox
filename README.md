# MP3Toolbox

# This is and mp3 player for the Matlab Environment.

### What is this ?
This repository is actually an old lecture of mine when I was at the university.
It is basically a discrete real-time FFT mp3 toolbox. Capable to plot the DFT
as the file is playing. It contains three different DTF algorithms.
You can see it in action [here](https://www.youtube.com/watch?v=UAKX-qg8xbY).
   
### How can I install it ?
Clone this repository first inside Malab/toolbox.
Then click `File` -> `Set Path` -> `Add with sub-folders`.
Click the mp3 toolbox and `OK`. You are done.
Type `help openmp3` and if an output is present, you have done it right.
   
### How can I use the mp3 player ?
Type `help openmp3` and it will show you how to use it.
Open an `*.mp3` file by setting the argument to its path.
*It will start running. Type `help` to explore additional options
The function uses the fastest iterative divider DFT algorithm `fft` of the all three.*

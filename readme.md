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

### Thanks and dependencies
This program uses `mp3read` and `mp3write`. I did not make these finctons. They were
made by [Alfredo Fernandez][ref-af] or [Dan Ellis][ref-de] from the [Mathworks community file exchange program][ref-file].
The repository contains this dependency. [The player is entirely my thing][ref-play].
Currently [Dan's implementation][ref-html] is chosen due to the multi-platform support.

[ref-file]: https://www.mathworks.com/matlabcentral/fileexchange/
[ref-af]: https://www.mathworks.com/matlabcentral/fileexchange/6152-mp3write-and-mp3read
[ref-play]: https://www.mathworks.com/matlabcentral/fileexchange/63764-console-mp3-player-and-dft-plotter?s_tid=prof_contriblnk
[ref-de]:https://www.mathworks.com/matlabcentral/fileexchange/13852-mp3read-and-mp3write
[ref-html]: http://htmlpreview.github.io/?https://raw.githubusercontent.com/dvdvideo1234/MP3Toolbox/master/functions/mp3readwrite/html/demo_mp3readwrite.html
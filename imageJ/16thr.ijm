
dir1 = getDirectory("Choose Source Directory ");
dir2 = getDirectory("Choose Destination Directory ");
list = getFileList(dir1);     //gets list of files in dir1
setBatchMode(true);
for (i=0; i<list.length; i++) {
    showProgress(i+1, list.length);
    filename = dir1 + list[i];
    string=replace(list[i],"(.dv)",""); 
    
    
    if (endsWith(filename, "SIR_EAL.dv")) {
    
    
    open(filename);
    
        run("Threshold and 16-bit Conversion", "auto-scale");
        
    
    saveAs("TIFF",dir2+string+"_THR");     //saves as a new tiff in dir2
  close();
  }
}




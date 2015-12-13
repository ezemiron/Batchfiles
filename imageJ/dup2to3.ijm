
dir1 = getDirectory("Choose Source Directory ");
dir2 = getDirectory("Choose Destination Directory ");
list = getFileList(dir1);     //gets list of files in dir1
setBatchMode(true);
for (i=0; i<list.length; i++) {
    showProgress(i+1, list.length);
    filename = dir1 + list[i];
    string=replace(list[i],"(.tif)","-1"); 
    
    
    if (endsWith(filename, "SIR_EAL_THR-mod.tif")) {
    
    
    open(filename);
        filetitle=getTitle();
        run("Split Channels");
          
          selectWindow("C1-"+filetitle);
          titleC1=getTitle();
          
          run("Duplicate...", "duplicate");
          
          selectWindow("C1-"+string+".tif");
          titleC2=getTitle();
          
          selectWindow("C2-"+filetitle);
          titleC3=getTitle();
          run("Merge Channels...", 
          "c1=&titleC1 c2=&titleC2 c3=&titleC3 create");
    
    saveAs("TIFF",dir2+string);     //saves as a new tiff in dir2
    close();
  }
}



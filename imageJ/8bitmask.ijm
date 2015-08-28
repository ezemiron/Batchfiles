
dir1 = getDirectory("Choose Source Directory ");
dir2 = getDirectory("Choose Destination Directory ");
list = getFileList(dir1);     //gets list of files in dir1
setBatchMode(true);
for (i=0; i<list.length; i++) {
    showProgress(i+1, list.length);
    filename = dir1 + list[i];
    string=replace(list[i],"(.tif)","-mask"); 
    
    
    if (endsWith(filename, "_THR-1-log.tif")) {
    
    
    open(filename);
        filetitle=getTitle();
        run("Split Channels");
//        Stack.setChannel(6); 
//        run("Reduce Dimensionality..."); 
        
          
          selectWindow("C6-"+filetitle);
//          titleC1=getTitle();
//          
//          run("Duplicate...", "duplicate");
//          
//          selectWindow("C1-"+string+".tif");
//          titleC2=getTitle();
//          
//          selectWindow("C2-"+filetitle);
//          titleC3=getTitle();
//          run("Merge Channels...", 
//          "c1=&titleC1 c2=&titleC2 c3=&titleC3 create");
    run("16-bit")
    run("8-bit")
    saveAs("TIFF",dir2+string);     //saves as a new tiff in dir2
    close();
  }
}



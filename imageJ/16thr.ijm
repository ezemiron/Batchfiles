
dir1 = getDirectory("Choose Source Directory ");
dir2 = getDirectory("Choose Destination Directory ");
list = getFileList(dir1);     //gets list of files in dir1
//setBatchMode(true);
for (i=0; i<list.length; i++) {
    showProgress(i+1, list.length);
    filename = dir1 + list[i];
    string=replace(list[i],"(.dv)",""); 
    
    
    if (endsWith(filename, "02.dv")) {
    
    //Open raw .dv
    open(filename);

        //make the modulation contrast (32bit)
        run("Modulation Contrast", "angles=3 phases=5 z=1");
        //make the same size
        run("Scale...", 
        "x=2 y=2 z=1.0 width=512 height=512 depth=33 interpolation=Bicubic average create title=scaled");
        //run("Threshold...");
        setThreshold(6.0000, 50.0000);
        run("NaN Background", "stack");
        //make it a binary mask (8bit)
        run("Convert to Mask", "method=Default background=Default");
        //Turn it to 16bit to make it compatible with next step (16bit)
        run("16-bit");

//but multiply the range to make it scale to 16bit
        run("Multiply...", "value=257 stack");
//        
//        
//        
//        
////Open unaligned SIR.dv 
//        open(filename);
////and do 16bit thr (16bit)

////apply the 16bit modulation mask
//        imageCalculator("AND create stack", "EM15-08-D_S2_1514_H3K4me2-594_Sytox_02_SIR-1_THR-1","EM15-08-D_S2_1514_H3K4me2-594_Sytox_02_MCN-3");


    saveAs("TIFF",dir2+string+"_modmask");     //saves as a new tiff in dir2
//  close();
  }
  
  if (endsWith(filename, "02_SIR.dv")) {
  
  
  
}
}







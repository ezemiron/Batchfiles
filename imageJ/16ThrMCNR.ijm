

dir1 = getDirectory("Choose Source Directory ");
dir2 = getDirectory("Choose Destination Directory ");
list = getFileList(dir1);     //gets list of files in dir1
setBatchMode(true);
for (i=0; i<list.length; i++) 
{
    showProgress(i+1, list.length);
    filename = dir1 + list[i];
    string=replace(list[i],"(.dv)",""); 


    if (endsWith(filename, "SIR.dv")) 
    {

      open(filename);

          SIR=getTitle();
          RAW=replace(SIR,"(_SIR.dv)",".dv");
          //runs the SIMcheck 16bit mode threshold (16bit):
          run("Threshold and 16-bit Conversion", "auto-scale");
          THR=replace(SIR, "(.dv)","_THR-1");
          saveAs("TIFF",dir2+THR);     //saves as a new tiff in dir2
          THR=getTitle();

      //Open raw .dv
      open(RAW);

          //make the SIMcheck modulation contrast (32bit)
          run("Modulation Contrast", "angles=3 phases=5 z=1");
          //make the same size
          run("Scale...","x=2 y=2 z=1.0 width=512 height=512 interpolation=Bicubic average create title=scaled");
          //run("Threshold...");
          setThreshold(5.0000, 50.0000);
          run("NaN Background", "stack");
          //make it a binary mask (8bit)
          run("Convert to Mask", "method=Default background=Default");
          //Turn it to 16bit to make it compatible with next step (16bit)
          run("16-bit");

          //but multiply the range to make it scale to 16bit
          run("Multiply...", "value=257 stack");

      //apply the 16bit modulation mask
      imageCalculator("AND create stack",THR,"scaled");

      saveAs("TIFF",dir2+string+"_THR-mod");     //saves as a new tiff in dir2

      while (nImages>0) 
          { 
          selectImage(nImages); 
          close(); 
          }
    }
  

}






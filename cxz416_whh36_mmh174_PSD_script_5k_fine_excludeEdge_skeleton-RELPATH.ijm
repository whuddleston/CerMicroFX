requires("1.33s"); 
setBatchMode(true);
 dir = "/"+replace(getDirectory("current"),"\\","/")+"WHX_05k_HC/";

start = lengthOf(dir)

count = 0;
countFiles(dir);
n = 0;
processFiles(dir);
   //print(count+" files processed");


function countFiles(dir) {   // creates directory
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }
  
   function processFiles(dir) {        //sets processing directory
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             finish = lengthOf(path);
             doJacks(path);
          }
      }
  }

function doJacks(path){          //executes directory
open(path);
rename(substring(path,start,start+5)+path);


makeLine(10, 1040, 315, 1040);

run("Set Scale...", "distance=190 known=10 pixel=1 unit=µm global");
makeRectangle(0, 0, 1024, 1024);
run("Crop");
run("Smooth");
setAutoThreshold("Default dark"); 
setOption("BlackBackground", false); 
run("Convert to Mask"); 


//skeleton analysis


run("Analyze Particles...", "size=0.001-Infinity show=Masks exclude include in_situ"); //removes particles smaller than 0.001 and edge particles

run("Fill Holes");
run("Rotate 90 Degrees Left");
run("Flip Vertically");
run("Skeletonize");
run("Analyze Skeleton (2D/3D)", "prune=none show");

selectWindow("Results");

saveAs("Results", "/"+replace(getDirectory("current"),"\\","/")+"data-files/"+"skeletons5k/"+substring(path,start+6,finish)+".csv");

selectWindow("Branch information");

saveAs("Results", "/"+replace(getDirectory("current"),"\\","/")+"data-files/"+"skeleton.branch.info5k/"+substring(path,start+6,finish)+".csv");

//comment out below code for headless

selectWindow(substring(path,start+6,finish)+".csv");
run("Close");

selectWindow("Results");
run("Close");
}

run("Quit");


 


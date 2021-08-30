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

run("Set Measurements...", "area centroid center perimeter shape feret's area_fraction display redirect=None decimal=3");
run("Analyze Particles...", "size=0.001-Infinity display summarize in_situ");

//selectWindow("Results");
}

//if (nResults==0) exit("Results table is empty"); //saves to directory as cvs file
   path = "/"+replace(getDirectory("current"),"\\","/")+"data-files/"+"PSD.Data.Verbose.5k+edge.csv";
   saveAs("Measurements", path);




 


requires("1.33s"); 
setBatchMode(true);
 dir = "/"+replace(getDirectory("current"),"\\","/")+"WHX_10k_HC/";

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

run("Set Scale...", "distance=305 known=8 pixel=1 unit=µm global");
makeRectangle(0, 0, 1024, 1024);
run("Crop");
run("Smooth");
setAutoThreshold("Default dark"); 
setOption("BlackBackground", false); 
run("Convert to Mask"); 

run("Set Measurements...", "area centroid center perimeter shape feret's area_fraction display redirect=None decimal=3");
run("Analyze Particles...", "size=0.001-Infinity display summarize in_situ");

run("Voronoi");
saveAs("Text Image", "/"+replace(getDirectory("current"),"\\","/")+"data-files/"+"voronoi-txt-files-10k/"+substring(path,start+6,finish)+".txt");

}




 


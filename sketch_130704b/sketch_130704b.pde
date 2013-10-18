/*This sketch is design to change one VGA depth csv file to one colorful image.
  When the depth value more close to depthToAnalysisMax,the color is more red. 
  When the depth value more close to depthToAnalysisMin,the color is more green.
  
  How to use this tool:
  Copy the 640x480 depth csv file to the data folder and rename it to input.csv.
  You should set the three parameters depthToSeeMin/depthToAnalysisMin/depthToAnalysisMax first to fit the depth csv file.
  Move the mouse to show the x y and depth info of this pixel.
  Click the button of the mouse to save the image capture in the app's folder
  
  Created by bijl1@lenovo.com 2013.7.4
*/
int rectHigh = 2;
int rectWidth = 2;   //Design to draw one 2x2 pixel rect to show one depth value pixel
int colorIndex = 0;
String[] pointsLineFromCsv;  //String Array to story the depth value
String xyDepth;

void setup()
{
  size(640*rectWidth,480*rectHigh);
  noStroke();
  background(255,255,255);
  pointsLineFromCsv = loadStrings("input.csv"); 
  frameRate(1);
}

//Render engine for each depth value
color renderDepthWithColor(int depth)
{
  int colorIndex = 0;                  
  int depthToSeeMin = 500;            //Make the pixel which > depthToSeeMin and < depthToAnalysisMin with white color
  int depthToAnalysisMin = 1060;      //depthToAnalysisMin and depthToAnalysisMax is the depth change area you want to analysis the depth value.
  int depthToAnalysisMax = 1120;      //When the depth value more close to depthToAnalysisMax,the color is more red. 
  int colorIndexChangeValue = int(256/(depthToAnalysisMax - depthToAnalysisMin));    //0 < depthToSeeMin < depthToAnalysisMin < depthToAnalysisMax
  
  color rectColor = color(100,100,100);  //defaut color is gray
  
  if(depth > depthToSeeMin && depth < depthToAnalysisMin)
  {
    rectColor = color(255, 255, 255);    //If the depth is between depthToSeeMin and depthToAnalysisMin color the rect with white
  }
  else if(depth >= depthToAnalysisMin && depth <= depthToAnalysisMax)
  {
    colorIndex = depth - depthToAnalysisMin;
    rectColor = color(colorIndexChangeValue*colorIndex - 1, 255-colorIndexChangeValue*colorIndex, 0);    //Color change from RGB(0,255,0) to RGB(255,0,0) 
  }                                                                                                      // => When the depth value more close to depthToAnalysisMax,the color is more red. 
  else
  {
    rectColor = color(255, 0, 0);  //depthToAnalysisMax < Depth <= depthToSeeMin -> Invalid depth. Color theses invalid pixel with red color
  }
  return rectColor;
}

//Draw one rect with x y and depth value
void drawRect(int x, int y, int depth)
{
   fill(renderDepthWithColor(depth));
   rect(rectWidth*x, rectHigh*y, rectWidth, rectHigh);
}

//The main draw function
void draw()
{
  int x = 0;
  int y = 0;  
  int depthValueInCSVCell = 0;
  
  for (String line : pointsLineFromCsv) 
  {
    String[] pieces = split(line, ',');
    for(x = 0; x < pieces.length; x++)
    {
      depthValueInCSVCell = int(pieces[x]);
      drawRect(x, y, depthValueInCSVCell);
    }
    y++;  
  }
  
  if(xyDepth != null)
  {
    textSize(24);
    fill(0, 102, 153, 204);
    text(xyDepth, 600, 900);
  }
}
//Get the xy's depth
void mouseMoved()
{
  int x = mouseX/rectWidth;
  int y = mouseY/rectHigh;
  String line = pointsLineFromCsv[y];
  String[] pieces = split(line, ',');
  String depth = pieces[x];
    
  String str = "Position:(" + x + "," + y + ").Depth:" + depth + ".";
  
  updateXYDepthStr(str);
}

void updateXYDepthStr(String str)
{
  xyDepth = new String(str);
}
//Save the image capture
void mousePressed() 
{
    saveFrame();
}

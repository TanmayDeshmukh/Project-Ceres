import processing.serial.*;

Serial port;
float curr_temp, curr_humi, curr_soilMoisture;
float t=0,h=0;
Graph temp=new Graph();
Graph humi=new Graph();

Button Temp_inc=new Button(200,500,10,20,"Inc");
Button Temp_dec=new Button(300,500,10,20,"Dec");
Button Humi_inc=new Button(200,600,10,20,"Inc");
Button Humi_dec=new Button(300,600,10,20,"Dec");
void setup()
{
  size(1300,700);
  temp.Height=400;
  temp.Width=600;
  temp.max_val=100;
  temp.min_val=0;
  temp.x=0;
  temp.y=100;
  temp.val_ind_inc=5;
  temp.set_val=35;
  temp.title="Temperature";
  
  humi.Height=400;
  humi.Width=600;
  humi.max_val=100;
  humi.min_val=0;
  humi.x=600;
  humi.y=100;
  humi.val_ind_inc=5;
  humi.set_val=55;
  humi.title="Humidity";
  
  try{
    port = new Serial(this, "COM8", 115200);
    port.bufferUntil('\n');
  }
  catch(Exception e){
  };
 
}

void draw()
{
  temp.refresh(t++);
    delay(100);
  if(t>=20)
  t=0;
  
  humi.refresh(h++);
    delay(100);
  if(h>=50)
  h=0;
  //Temp_inc.draw();
  //Temp_dec.draw();
  //Humi_inc.draw();
  //Humi_dec.draw();
  
}
void serialEvent (Serial port)
{
  try {
    String input = port.readStringUntil('\n');
    String valS=input.substring(2);
    float val=Float.parseFloat(valS);
    if (input.charAt(0)=='T' && input.charAt(1)=='0')
      temp.refresh(val);
    else if (input.charAt(0)=='H')
      humi.refresh(val);
  }
  catch(Exception e){};
}
void Refresh()
{
  port.write('T');
  port.write((byte)((int)temp.set_val*10.0));
  port.write('\n');
  
  port.write('H');
  port.write((byte)((int)humi.set_val*10.0));
  port.write('\n');
  
}
class Button
{
  int x,y;
  int Width=20,Height=10;
  String label="button";
  Button(int x,int y,int Height,int Width,String label)
  {
    this.x=x;
    this.y=y;
    this.Width=Width;
    this.Height=Height;
    this.label=label;
  }
  boolean check_rollover()
  {
    if(mouseX>x && mouseX<x+Width && mouseY>y && mouseY<y+Height)
      return true;
    else 
      return false;
  }
  void draw()
  {
    fill(150,150,150);
    noStroke();
    rect(x,y,x+Width,y+Height);
    fill(200);
    text(label,x+4,y+4);
  }
}
class Graph
{
  float Height,Width;
  float x,y;
  float max_val,min_val;
  
  float set_val;
  
  int val_ind_inc=5;
  String title="";
  float prev_vals[]=new float[51];
  
  void refresh(float new_val)
  {
    fill(0);
    stroke(50, 50,100);
    rect(x,y,x+Width,y+Height);
    
    
    fill(255);
    text(title,x+Width/2,y+20);
    
    fill(10,200,50);
    for(int i=0;i<=max_val;i+=val_ind_inc)
    {
      float y_pos=Height*i/max_val+y;
      text((int)max_val-i,x+Width-28,y_pos);
      line(x+Width-8,y_pos,x+Width,y_pos);
    }
      stroke(100, 102, 0);
    float setLine_y=map(set_val,min_val,max_val,Height+y,y);
    text(set_val,x+10,setLine_y);
    line(x,setLine_y,x+Width,setLine_y);
    
    stroke(25, 50, 100);
    setLine_y=map(new_val,min_val,max_val,Height+y,y);
    text(new_val,x+Width/2,setLine_y);
    line(x,setLine_y,x+Width,setLine_y);
    
    //println("r");
    stroke(204, 102, 0);
    noFill();
    beginShape();
    for(int i=0;i<=50;i++)
    {
     vertex((float)Width*i/50.0+x, map(prev_vals[i],min_val,max_val,Height+y,y));
     //print(i);print(":x: "+Width*i/50.0);
     //println("\ty: "+map(prev_vals[i],min_val,max_val,Height+y,y));
    }
    println();
     endShape();
     redraw();
     for(int i=0;i<50;i++)
    prev_vals[i]=prev_vals[i+1];
    prev_vals[50]=new_val;
  }
}
     
     
  
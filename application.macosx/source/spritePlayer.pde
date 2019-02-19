import drop.*;

SDrop drop;
MyDropListener m;


PImage sprite;
String filePath, info, input;
int  frames, menu, inNumber; 
float rows, cols, w, h;
boolean resize = false;
boolean spriteLoaded = false;
boolean frameCalc = true;
float posX = 0.0;
float posY = 0.0;
int framesDone = 0;
int txtclr = 255;
int clrS = 10; 
PVector clr;



void setup()
{
  size(300, 200);
  smooth();
  frameRate(25);
  drop = new SDrop(this);
  m = new MyDropListener();
  drop.addDropListener(m);
  rows = 5;
  cols = 10;
  info = ("drop sprite");
  input = ("");
  menu = 0;
  colorMode(HSB);
  clr = new PVector (0, 0, 100);
}


void draw()
{
  if (mousePressed == true) {
    clr = new PVector(mouseX, clrS, mouseY);
  }

  fill(clr.x, clr.y, clr.z);
  noStroke();
  rect(0, 0, width, height);
  if (!spriteLoaded) {

    fill(255);
    textAlign(CENTER);
    textSize(14);
    text(info, 150, 100);
    fill(txtclr);
    text(input, 150, 130);
  }

  if (resize) {
    w = sprite.width/cols;
    h = sprite.height/rows;
       
    surface.setSize(int(w), int(h));
    m.setTargetRect(0, 0, width, height);
    resize = false;
  }


  if (spriteLoaded &! resize) {
    image(sprite, int(posX), int(posY), sprite.width, sprite.height);
    posX -= w;
    framesDone++;
    if (posX <= -sprite.width) {
      posX = 0.0;
      posY -= h;
    }
    if (posY <= -sprite.height) {
      posY = 0.0;
    }
    if (framesDone == frames) {
      framesDone = 0;
      posX = 0;
      posY = 0;
    }
     println("return  "+posX+"  rs "+posY);
  }

  m.draw();
}


class MyDropListener extends DropListener {
  int myC = 0;

  MyDropListener() {
    setTargetRect(0, 0, width, height);
  }

  void draw() {
    noStroke();
    fill(0, 255, 0, myC);
    rect(0, 0, width, height);
    stroke(0);
  }
  void dropEnter() {
    myC = 100;
  }
  void dropLeave() {
    myC = 0;
  }
  void dropEvent(DropEvent theEvent) {   
    menu = 0;
    filePath = theEvent.toString();
    surface.setSize(300, 200);
    spriteLoaded = false;  
    fill(255);
    info = ("sprite loaded, how many rows?");
  }
}

void keyPressed() {
  if (key == BACKSPACE) {
    if (input.length() > 0) {
      input = input.substring(0, input.length()-1);
    }
  }

  if (key != RETURN && key != ENTER && key != BACKSPACE) {
    input += key;
  }

  if ((key != RETURN && key != ENTER && key != BACKSPACE) && frameCalc) {
    txtclr = 255;
    input =("");
    input += key;
    frameCalc = false;
  }

  inNumber = int(input);

  if ((key == RETURN || key == ENTER) && menu == 0 && inNumber > 0) {
    rows = inNumber;
    info = ("and how many columns?");
  } else if ((key == RETURN || key == ENTER) && menu == 1 && inNumber > 0) {
    cols = inNumber;
    info = ("and how many frames?");
    txtclr = 180;
  } else if ((key == RETURN || key == ENTER) && menu == 2 && inNumber > 0) {
    frames = inNumber;
    sprite = loadImage(filePath);
    spriteLoaded = true;
    resize = true;
    menu = 0;
    input = ("");
    txtclr = 255;
  } else if ((key == RETURN || key == ENTER) &&inNumber < 1) {
    menu--;
    input = ("");
  }
}

void keyReleased() {
  if (key == RETURN || key == ENTER) {
    input = ("");
    menu++;
    if (menu == 2) {
      input = str(int(rows * cols));
    }
    frameCalc = true;
  }
}

void mouseWheel(MouseEvent event) {
  clrS += event.getCount();
  if (clrS < 0) {
    clrS = 0;
  }
  if (clrS > 255) {
    clrS = 255;
  }
}

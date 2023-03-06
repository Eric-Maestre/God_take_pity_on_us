// VARIABLES

int enemies = 10;
int obstaculos = 15;

float [] xPNJ = new float[enemies];
float [] yPNJ = new float[enemies];
float [] alfa = new float[enemies];

float alfaFriend;
float radio;

//para distancia entre jugador y friend
float vxf, vyf, modulof;

//distancia entre friend y enemies
float [] vxef = new float[enemies];
float [] vyef = new float[enemies];
float [] moduloef = new float[enemies];
float [] vxep = new float[enemies];
float [] vyep = new float[enemies];
float [] moduloep = new float[enemies];

float [] playerPos = new float[2];
float [] friendPos = new float[2];

//obstaculos
PVector [] cajas;
int ancho_caja;
int alto_caja;
color [] color_caja = new color[obstaculos];



//SETUP
void setup() {
  size(1200, 800);
  radio = 17.5;
  cajas = new PVector[obstaculos];
  //inicializar jugador
  playerPos[0] = 50;
  playerPos[1] = height/2.0;
  //inicializar friend
  friendPos[0] = 780;
  friendPos[1] = height/2.0;
  alfaFriend = 0.13;

  //pedir valor enemies al jugador

  //inicializar enemies
  for (int i = 0; i<enemies; i++)
  {
    xPNJ[i] = random(0, width);
    yPNJ[i] = random(0, height);
    alfa[i] = random (0.15, 0.9);
  }
  //inicializar obstaculos
  ancho_caja = 50;
  alto_caja = 50;
  for (int i = 0; i < obstaculos; i++)
  {
    float x = random(ancho_caja, width-ancho_caja);
    float y = random(alto_caja, height-alto_caja);
    cajas[i] = new PVector(x,y);
    color_caja[i] = color(random(0, 255), random(0, 255), 255);
  }
}




//DRAW
void draw() {
  background (0); //fondo negro

  //1.calcular


  vxf = playerPos[0] - friendPos[0];
  vyf = playerPos[1] - friendPos[1];
  modulof = sqrt(vxf*vxf+vyf*vyf);
  for (int i = 0; i < enemies; i++)
  {
    //calcular la distancia friend enemy para saber si colisionan
    vxef[i] = friendPos[0] - xPNJ[i];
    vyef[i] = friendPos[1] - yPNJ[i];
    moduloef[i] = sqrt(vxef[i]*vxef[i]+vyef[i]*vyef[i]);
    //calcular la distancia player enemy para saber si colisionan
    vxep[i] = playerPos[0] - xPNJ[i];
    vyep[i] = playerPos[1] - yPNJ[i];
    moduloep[i] = sqrt(vxep[i]*vxep[i]+vyep[i]*vyep[i]);
  }
  // pintar

  rectMode(CENTER);
  for (int i = 0; i<obstaculos; i++) {
    fill(color_caja[i]);
    rect(cajas[i].x, cajas[i].y, ancho_caja, alto_caja);
  }

  //calcular proximidad friend y player
  if (modulof <= radio*10.0) {
    friendPos[0] = friendPos[0] + alfaFriend*(playerPos[0] - friendPos[0]);
    friendPos[1] = friendPos[1] + alfaFriend*(playerPos[1] - friendPos[1]);
  } else if (modulof <= radio*5.0) {
    friendPos[0] = friendPos[0] - alfaFriend*(playerPos[0] - friendPos[0]);
    friendPos[1] = friendPos[1] - alfaFriend*(playerPos[1] - friendPos[1]);
  }

  for (int i = 0; i < enemies/2; i++)
  {
    //los que siguen al friend
    xPNJ[i] = xPNJ[i] + alfa[i]* (friendPos[0] - xPNJ[i]);
    yPNJ[i] = yPNJ[i] + alfa[i]* (friendPos[0] - yPNJ[i]);
    if (moduloep[i] <= radio*6.0)
    {
      xPNJ[i] = xPNJ[i] - alfa[i]* (playerPos[0] - xPNJ[i]);
      yPNJ[i] = yPNJ[i] - alfa[i]* (playerPos[1] - yPNJ[i]);
    }
  }
  for (int i = enemies/2; i < enemies; i++)
  {
    //los que son aleatorios
    xPNJ[i] = xPNJ[i] + alfa[i]* (random(0, width) - xPNJ[i]);
    yPNJ[i] = yPNJ[i] + alfa[i]* (random(0, height) - yPNJ[i]);
    if (moduloep[i] <= radio*6.0)
    {
      xPNJ[i] = xPNJ[i] - alfa[i]* (playerPos[0] - xPNJ[i]);
      yPNJ[i] = yPNJ[i] - alfa[i]* (playerPos[1] - yPNJ[i]);
    }
  }
}


//Movimiento PJ1 función void
void keyPressed() {
  if (key == CODED) {
    switch(keyCode)
    {
    case UP:
      playerPos[1] -= 10;
      break;
    case LEFT:
      playerPos[0] -= 10;
      break;
    case DOWN:
      playerPos[1] += 10;
      break;
    case RIGHT:
      playerPos[0] += 10;
      break;
    default :
      break;
    }
  }
}

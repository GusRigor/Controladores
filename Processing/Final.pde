// Carrega as bibliotecas Serial e Arduino

import processing.serial.*;

import cc.arduino.*;

Arduino arduino;

 

// Definicao das variaveis

int sensorIn = A0;

int mVperAmp = 100; // use 100 for 20A Module and 66 for 30A Module

double Voltage = 0;

double VRMS = 0;

double AmpsRMS = 0;

 

 

int pinoTensao = A2; //PINO ANALÓGICO EM QUE O SENSOR ESTÁ CONECTADO

float tensaoEntrada = 0.0; //VARIÁVEL PARA ARMAZENAR O VALOR DE TENSÃO DE ENTRADA DO SENSOR

float tensaoMedida = 0.0; //VARIÁVEL PARA ARMAZENAR O VALOR DA TENSÃO MEDIDA PELO SENSOR

float valorR1 = 30000.0; //VALOR DO RESISTOR 1 DO DIVISOR DE TENSÃO

float valorR2 = 7500.0; // VALOR DO RESISTOR 2 DO DIVISOR DE TENSÃO

int leituraSensor = 0; //VARIÁVEL PARA ARMAZENAR A LEITURA DO PINO ANALÓGICO

 

float getVPP() //FUNÇÃO QUE DEFINE O VALOR DE PICO DA ONDA SENOIDAL DA CORRENTE AC PARA CALCULAR TENSÃO EFICAZ E CORRENTE EFICAZ (RMS)

{

  float result;

 

  int readValue;             //LEITURA DO SENSOR

  int maxValue = 0;          // VARIÁVEL DE MAX

  int minValue = 1024;          // VARIÁVEL DE MIN

 

   uint32_t start_time = millis();

   while((millis()-start_time) < 1000) //COLETA AMOSTRAS DURANTE UM SEGUNDO

   {

       readValue = analogRead(sensorIn);// SE TEM NOVO MAX

      

       if (readValue > maxValue)

       {

           maxValue = readValue; //MAX

       }

       if (readValue < minValue)

       {

           minValue = readValue; //,MIN

       }

   }

  

  

   result = ((maxValue - minValue) * 5.0)/1024.0;

     

   return result;

}

void setup()

{

// Abre uma janela no tamanho 500x300

size(1000,500);

// Habilita o anti-aliasing

smooth();

// Define fundo na cor preta

background(0);

println(Arduino.list());

 // Comunicacao com Arduino

arduino = new Arduino(this, Arduino.list()[0], 57600);

// Define o pino do led como saida

arduino.pinMode(sensorIN, Arduino.INPUT);

// Define o pino do botao como entrada

arduino.pinMode(pinoTensao, Arduino.INPUT);

 ellipseMode(RADIUS);

 

//Carrega a fonte de texto a ser utilizada

textFont(createFont("Arial Bold",18));

textAlign(CENTER);

 

 // Inicio do cabecalho

// Desenha o retangulo laranja

fill(0,250,154);   // Cor preenchimento

rect(0,0,1000,40);

// Define o tamanho da fonte

textSize(31);

// Define a cor e imprime o texto

fill(0);  // Cor preta

text("Pi 3 - Bike EGBM", width/2,30);

// Final do cabecalho

 fill(0,250,154);   // Cor preenchimento

rect(0,460,1000,40);

// Define o tamanho da fonte

textSize(31);

// Define a cor e imprime o texto

fill(0);  // Cor preta

text("Pi 3 - Projeto Bike", width/2,30);

// Final do cabecalho

  

 // Valores medidos

textSize(20);

fill(255);

text("Tensão: "+tensaoMedida + "V", 65,405); //Colocar a variável da tensão

textSize(20);

fill(255);

text("Corrente: "+ AmpsRMS +"A", 72,425); //Colocar a variável da tensão

textSize(20);

fill(255);

text("Potência: "+(tensaoMedida*AmpsRMS)+"W", 72,445); //Colocar a variável da tensão

 

}

void draw()

{

   Voltage = getVPP();

VRMS = (Voltage/2.0) *0.707;

 AmpsRMS = (((VRMS * 1000)/mVperAmp)-0.12);

 

 

  leituraSensor = arduino.analogRead(pinoTensao); //FAZ A LEITURA DO PINO ANALÓGICO E ARMAZENA NA VARIÁVEL O VALOR LIDO

  tensaoEntrada = (leituraSensor * 5.0) / 1024.0; //VARIÁVEL RECEBE O RESULTADO DO CÁLCULO

  tensaoMedida = tensaoEntrada / (valorR2/(valorR1+valorR2)); //VARIÁVEL RECEBE O VALOR DE TENSÃO DC MEDIDA PELO SENSOR

  tensaoMedida = tensaoMedida + 0.2; //OFFSET

 

  stroke(255);

//Colocar os pinos em uma variável e usar um map(pino, 0, 1023, 40, 405)

 int y1=map(tensaoMedida,0,25,40,222);

int y2=map(AmpsRMS,-20,20,40,405);

//Lembrar que a corrente é alternada então usar todos, tensão usar a metade

  // Atualiza o grafico

  stroke(255);

  line(x+1,y1, x+1, y1-3);//Para Y usar a variável e a diferença ser a largura

  stroke(128);

  line(1000-x,AmpsRMS, 1000-x, AmpsRMS-5);

  

  // Atualiza o valor de X para desenhar a

  // proxima linha do grafico

  x = x +1;

  // Se o valor de X for igual ao tamanho da tela

  // reinicia a contagem

  if (x == 1000)

  {

    x = 0;

    stroke(0);

    line(x,291, x, 199);

  }

 

  // Aguarda 10 milisegundos e reinicia o processo

  delay(100);

}
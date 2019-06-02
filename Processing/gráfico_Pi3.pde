// Carrega as bibliotecas Serial e Arduino
import processing.serial.*;
import cc.arduino.*;
 
Arduino arduino;

// Definicao das variaveis
int ledPin = 3;
int pinobotao = 7;
int valor = 0;
int x = 0;
int y = 290;
int contador = 0;
 
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
 arduino.pinMode(ledPin, Arduino.OUTPUT);
 // Define o pino do botao como entrada
 arduino.pinMode(pinobotao, Arduino.INPUT);
 
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
 text("Pi 3 - Projeto Bike", width/2,30);
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
 text("Tensão: 5.0V", 65,405); //Colocar a variável da tensão
 textSize(20);
 fill(255);
 text("Corrente: 0.5A", 72,425); //Colocar a variável da tensão
 textSize(20);
 fill(255);
 text("Potência: 2.5W", 72,445); //Colocar a variável da tensão 

}
 
void draw()
{
  valor = arduino.digitalRead(pinobotao);
  stroke(255);
 //Colocar os pinos em uma variável e usar um map(pino, 0, 1023, 40, 405)
 //Lembrar que a corrente é alternada então usar todos, tensão usar a metade
  // Atualiza o grafico 
  stroke(255);
  line(x+1,228, x+1, 223);//Para Y usar a variável e a diferença ser a largura
  stroke(128);
  line(1000-x,300, 1000-x, 295);
   
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
  delay(10);
}

import 'dart:math';
import 'dart:io';

class HangmanGame{
  String word = '', tip = '', state = '', option='hard', lastReport = '';
  int size = 0, vidas = 0, emptySpaces = 0;
  bool victory = false;
  List lettersTried = [], expectionLetters = [' ', '-'];

  final possibleWordsEasy = ['Banana', 'Acerola', 'Graviola', 'Panquecas', 'Brinquedo', 'Saturno', 'Teclado', 'Cadeado', 'Vento', 'Primavera', 'Professor', 'Travesseiro', 'Italiano', 'Restaurante', 'Shopping', 'Grecia', 'Montanha', 'Tiradentes'];
  final tipWordEasy = ['Fruta originária das Américas',
                   'Fruta comum no Brasil',
                   'Fruta com interior Branco',
                   'Café da manhã comum nos EUA',
                   'Crianças gostam',
                   'Possui aneis',
                   'Usado para Escrever',
                   'Usado para proteger',
                   'Presente em todo lugar',
                   'Flores',
                   'Profissao',
                   'Dormir',
                   'Idioma',
                   'Comida',
                   'Compras',
                   'Pais europeu',
                   'Natureza',
                   'Figura histórica',
                  ];

    final possibleWordsMedium = ['Candelabro', 'Apolo', 'Artropode', 'Condado', 'Dermatologista', 'Pancreas', 'Paleontologia', 'Madrasta', 'Gaivota', 'Cosseno', 'Termologia'];
    final tipWordMedium = ['Ilumina', 
                           'Deus grego', 
                           'Um dos maiores grupos dos animais',
                           'Subdivisão de uma nação',
                           'Profissão na área da Saúde', 
                           'Parte do corpo humano',
                           'Área das Ciências da natureza',
                           'Membro da família',
                           'Pássaro',
                           'Operação matemática',
                           'Área da Física'];

    final possibleWordsHard = ['Pé-de-moleque'];
    final tipWordHard = ['Doce'];

    final possibleWordsTest = ['Jogó-graáãndé'];
    final tipWordTest = ['teste'];

  HangmanGame({int vidas = 5}){
    List aux = this.selectWord();
    this.word = aux[0];
    this.tip = aux[1];
    this.size = aux[0].length;
    this.vidas = vidas;
    this.state = this.emptyState();
    this.emptySpaces = this.countEmptyState();
  }

  @override
  String toString(){
    return (this.word + '\n' + this.tip + '\n' + this.state);
  }

  List selectWord(){
    Random rand = Random();
    int number = 0;
    if (this.option == "test"){
      number = rand.nextInt(this.possibleWordsTest.length);
      return [this.possibleWordsTest[number], this.tipWordTest[number]];
    }
    if (this.option == "easy"){
      number = rand.nextInt(this.possibleWordsEasy.length);
      return [this.possibleWordsEasy[number], this.tipWordEasy[number]];
    }
    if (this.option == "medium"){
      number = rand.nextInt(this.possibleWordsMedium.length);
      return [this.possibleWordsMedium[number], this.tipWordMedium[number]];
    }
    if (this.option == "hard"){
      number = rand.nextInt(this.possibleWordsHard.length);
      return [this.possibleWordsHard[number], this.tipWordHard[number]];
    }
    return ['Erro ao escolher palavra', 'Erro ao selecionar dica'];
  }

  String emptyState(){
    String result = '';

    for (int i = 0; i < this.size; i++){

      // Se for uma das letras excessão, então coloco a letra diretamente
      if (this.expectionLetters.contains(this.word[i])){
        result = result + this.word[i] + ' ';
      } else{
      // Senão, coloco um "_"
        result = result + '_' + ' ';
      }

    }
    return result;
  }

  int countEmptyState(){
    int count = 0;
    for (int i = 0; i < this.state.length; i++){
      if (this.state[i] == '_') count++;
    }
    return count;
  }

  bool checkTry(String letter){
    for (String each in this.lettersTried){
      if (each == letter){
        return true;
      }
    }
    return false;
  }

  bool matchTest(String letter1, String letter2){
    List specialMatchLetters = [
      ['á', 'à', 'ã', 'â', 'a'], 
      ['é', 'ê', 'e'], 
      ['í', 'î', 'i'], 
      ['ó', 'ô', 'o'], 
      ['ú', 'û', 'u'], 
      ['ç', 'c']
      ];

    letter1 = letter1.toLowerCase();
    letter2 = letter2.toLowerCase();

    if (letter1 == letter2){
      return true;
    }else{
      for (List match in specialMatchLetters){
        if (match.contains(letter1) && match.contains(letter2)) return true;
      }
    }
    return false;
  }

  void guess(String letter){
    String result = '';
    int count = 0;

    if (letter.length != 1) this.lastReport = "Apenas uma letra por Palpite";
    else{
      //Adiciona a letra nova na lista de letras já tentadas
      if (this.checkTry(letter)) this.lastReport = "Letra já tentada";
      this.lettersTried.add(letter);

      //Verifica se a letra tentada está na palavra e produz o novo State
      for(int i = 0; i < this.size; i++){
        if (this.matchTest(this.word[i], letter)){
          count += 1;
          result = result + this.word[i] + ' '; 
        }else{
          result = result + this.state[2*i] + ' ';
        }
      }

    // Se a letra não estava na palavra, count == 0, então diminui uma vida.
    // Caso haja 0 vidas restantes, o jogo acaba. A palavra é apresentada no
    // State e victory é falso (perdeu)
    // Se a letra estava na palavra (count > 0), então diminui o contador de
    // espaços vazios ( _ ) e atualiza o estado. Se não há mais nenhum espaço
    // vazio, então o jogo acabou e o jogador venceu

    if (count == 0){
      vidas -= 1;
      if (vidas == 0){
        this.state = this.createFinalState();
        this.victory = false;
        this.lastReport = "Infelizmente você perdeu :(";
      }
      this.lastReport = "Ops, essa letra não faz parte da palavra";
    }else{
      this.emptySpaces -= count;
      this.state = result;
      if (this.emptySpaces == 0) this.victory = true;
      this.lastReport = "Letra colocada";
      }
    }
  }

  String createFinalState(){
    String result = '';
    for (int i = 0; i < this.size; i++){
      result = result + this.word[i] + ' ';
    }
    return result;
  }

  void guessWord(String word){
    this.state = this.createFinalState();
    if (this.word.toUpperCase() == word.toUpperCase()){
      this.victory = true;
    } else{
      this.victory = false;
    }
  }

  bool isGameOver(){
    bool isGameOver = true;
    if (this.vidas == 0) return true;
    for (int i = 0; i < this.state.length; i++){
      if (this.state[i] == '_'){
        isGameOver = false;
        break;
      }
    }

    return isGameOver;
  }

  String turnString(List elements){
    String result = '';
    for(String each in elements){
      result = result + each + ' ';
    }
    return result;
  }

  void presentState(){
    print(this.lastReport);
    print("Vidas : " + this.vidas.toString());
    print(this.tip);
    print(this.state + '\n');
    print("Letras tentadas : " + turnString(this.lettersTried));
  }

  void endgame(){
    if (this.victory){
      print("A palavra é : " + this.word);
      print("Sobraram " + this.vidas.toString() + " vidas");
    } else{
      print("A palavra era : " + this.word);
    }
  }
}

class ManagerHagmanGame{
  HangmanGame? jogo = null;

  ManagerHagmanGame(){
    this.jogo = HangmanGame();
  }

  void play(){
    String? entry = '', choose = '';

    print("===============================================");
    print("Bem vindo ao jogo de forca feito por Breno Gabriel!!");
    print("Pronto para começar?? digite y/N");
    choose = stdin.readLineSync();
    if (choose == 'y'){
      
      while(this.jogo!.isGameOver() == false){
        print("-------------------------------------------");
        this.jogo!.presentState();

        print("Dê o palpite de uma palavra ou letra: ");
        entry = stdin.readLineSync();
        if (entry!.length == 1){
          this.jogo!.guess(entry); // Inimigo da coesão
        } else{
          print("Tem certeza que quer tentar a palavra $entry ? Se ela estiver errada, o jogo vai acabar! y/N");
          choose = stdin.readLineSync();
          if (choose == 'y'){
            this.jogo!.guessWord(entry);
          }
        }
      }

      if (this.jogo!.victory){
        print("\n\nMeus parabéns, você ganhou!!");
        this.jogo!.endgame();
      } else{
        print("\n\nInfelizmente você perdeu :(");
      }

    } else{
      print("\n\nUma pena! Até a próxima!");
    }

  }
}

void main(){
  var jogo = ManagerHagmanGame();
  jogo.play();
}

void testHangman(){
  var gameH = HangmanGame();
  print(gameH);
  gameH.guess('a');
  print(gameH);
  print(gameH.vidas);
  print(gameH.isGameOver());
  gameH.guess('c');
  print(gameH);
  print(gameH.vidas);
  print(gameH.isGameOver());
  gameH.guessWord('Acerola');
  print(gameH.state);
  print(gameH.isGameOver());
}
[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/4nHL7_6-)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=18911051&assignment_repo_type=AssignmentRepo)
# CS 164: Programming Assignment 1

[PA1 Specification]: https://drive.google.com/open?id=1oYcJ5iv7Wt8oZNS1bEfswAklbMxDtwqB
[ChocoPy Specification]: https://drive.google.com/file/d/1mrgrUFHMdcqhBYzXHG24VcIiSrymR6wt

Note: Users running Windows should replace the colon (`:`) with a semicolon (`;`) in the classpath argument for all command listed below.

## Getting started

Run the following command to generate and compile your parser, and then run all the provided tests:

    mvn clean package

    java -cp "chocopy-ref.jar:target/assignment.jar" chocopy.ChocoPy --pass=s --test --dir src/test/data/pa1/sample/

In the starter code, only one test should pass. Your objective is to build a parser that passes all the provided tests and meets the assignment specifications.

To manually observe the output of your parser when run on a given input ChocoPy program, run the following command (replace the last argument to change the input file):

    java -cp "chocopy-ref.jar:target/assignment.jar" chocopy.ChocoPy --pass=s src/test/data/pa1/sample/expr_plus.py

You can check the output produced by the staff-provided reference implementation on the same input file, as follows:

    java -cp "chocopy-ref.jar:target/assignment.jar" chocopy.ChocoPy --pass=r src/test/data/pa1/sample/expr_plus.py

Try this with another input file as well, such as `src/test/data/pa1/sample/coverage.py`, to see what happens when the results disagree.

## Assignment specifications

See the [PA1 specification][] on the course
website for a detailed specification of the assignment.

Refer to the [ChocoPy Specification][] on the CS164 web site
for the specification of the ChocoPy language. 

## Receiving updates to this repository

Add the `upstream` repository remotes (you only need to do this once in your local clone):

    git remote add upstream https://github.com/cs164berkeley/pa1-chocopy-parser.git

To sync with updates upstream:

    git pull upstream master


## Submission writeup

Team member 1: Isadora Crescencio Verbicário Botelho

Team member 2: João Guilherme Coutinho Beltrão

Team member 3: João Pedro Mateus Souza

Agradecimentos: Dario Chen Chen Ye, Lucca Sabbatini

Horas necessárias: 40h

Perguntas:
    1 - A estratégia adotada para emissão dos tokens INDENT e DEDENT baseou-se no gerenciamento de estados e no uso de uma estrutura de pilha para controle dos níveis de indentação. O arquivo jflex implementa essa lógica através de dois estados principais: um dedicado à análise da indentação no início das linhas e outro para o processamento do resto do conteudo.

    Inicialmente, uma pilha é utilizada para armazenar os níveis de indentação, começando com o valor 0. Durante a análise, sempre que é identificado um novo nível de indentação no começo de uma linha, ele é comparado com o valor armazenado no topo da pilha. Caso o nível atual seja superior, o novo valor é empilhado e um token INDENT é gerado (linhas 180-184). Quando o nível é inferior, os valores são desempilhados e tokens DEDENT são emitidos até que seja alcançada a correspondência com o nível atual (linhas 185-189).

    Caso a linha não comece com eespaço em branco, o scanne verifica se ouve um dedent e faz um yypushback para voltar o buffer e processar corretamente o resto da linha.

    O programa também inclui tratamento especial para o final do arquivo, garantindo que todos os níveis de indentação abertos sejam devidamente fechados através da emissão dos tokens DEDENT correspondentes antes da geração do token EOF (linhas 215-223).

    2 - A implementação da indentação no analisador léxico do ChocoPy segue as regras da Seção 3.1.5 do manual, utilizando uma pilha para controlar os níveis de indentação e emitir os tokens INDENT e DEDENT corretamente. O manual especifica que os espaços iniciais de uma linha definem seu nível de indentação, que deve ser comparado com o topo da pilha. Se for maior, um novo nível é empilhado e um token INDENT é gerado; se for menor, a pilha é desempilhada até encontrar um nível igual, emitindo DEDENT para cada remoção. Ao final do arquivo, todos os níveis restantes são fechados com DEDENT.

    No código, essa lógica é aplicada no estado IDENTATION, onde a indentação é verificada no início de cada linha. A pilha começa com zero, e variáveis auxiliares controlam o estado do lexer, garantindo que os blocos sejam abertos e fechados conforme a especificação.

    3 - A parte mais complicada foi pensar na implementação de Strings, já que teríamos que pensar em formas de considerar o tratamento correto de todos os casos especiais que podem aparecer em literais string (aspas internas, por exemplo).
    Criamos uma Macro (StringChar) e um estado novo chamado <STRING> (l:181 ChocoPy.jflex) onde resolvem os problemas.

(Students should edit this section with their write-up)

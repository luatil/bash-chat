# README

# Entrega: 8 da matina de 4 de novembro de 2020

# TODO 

1.1. O servidor de chat

- ./chatbacana.sh servidor deve inicializar o servidor
- [X] Uma vez inicializado, o servidor deve exibir na tela um propt aguardando os comandos do usuario

        servidor>

- [x] list  - lista os nomes de todos os usuarios logados, um por linha. 
- [x] list  - nenhum usuario nao lista nada

- [X] time  - informa o intervalo de tempo desde que o servidor foi iniciado 
- [X] time  - informa o intervalo de tempo em segundos


- [  ] reset - remove todos os usuarios que foram criados nessa instancia de execucao

- [  ] quit  - finaliza o servidor
- [  ] quit  - remove todos os arquivos temporarios

Reset e quit soh serao executados se nao houverem clientes conectados

1.2 O cliet de chat

Os clientes serao iniciados apos o servidor ser iniciado. 

- ./chatbacana.sh cliente deve inicializar o cliente
- [X] Uma vez iniciado os usuarios serao recebidos por 

        cliente>

- [X] create <usuario> <senha> - cria um novo usuario e senha
- [  ] create <usuario> <senha> - So podem ser perdidas enquanto o servidor executar um reset ou quit
- [X] create <usuario> <senha> - Se o usuario <user> ja existir, a string ERRO deve ser impressa

- [  ] passwd <usuario> <antiga> <nova>: altera a senha de antiga para nova. 
- [  ] passwd <usuario> <antiga> <nova>: se o usuario nao existir a string ERRO devo ser impressa
- [  ] passwd <usuario> <antiga> <nova>: se a senha estiver errada a string ERRO deve ser impressa

- [X] login <usuario> <senha>: loga como o <usuario> com a senha <senha>. 
- [X] login <usuario> <senha>: se o usuario nao existir, a string ERRO deve ser impressa
- [X] login <usuario> <senha>: se a senha estiver errada, a string ERRO deve ser impressa
- [X] login <usuario> <senha>: se o usuario ja estiver logao, a string ERRO deve ser impressa

- [X] list: lista o nome de todos os usuarios logados, inclusive do proprio usuario
- [X] list: se o usuario nao estiver logado, imprimir erro

EX:
    cliente> list
    bilbo
    frodo

- [X] logout: desloga do sistema mas nao encerra a execucao do cliente
- [X] logout: se o usuario nao estiver logado, imprimir erro

- [  ] msg <usuario> <mensagem>: escreve na tela do <usario> a <mensagem>
- [  ] msg <usuario> <mensagem>: se o usuario nao estiver logao, imprimir ERRO
- [  ] msg <usuario> <mensagem>: na tela do <usuario> a mensagem deve ser exibida da seguinte forma:
    [Mensagem do <remetente>]:
- [  ] msg <usuario> <mensagem>: se o usuario nao estiver logado, imprimir erro
- [  ] msg <usuario> <mensagem>: <mensagem> pode conter espacos 

EX:
    <terminal do bilbo>
    cliente> msg frodo olah, vamos para valfenda? 
    cliente>

    <terminal do frodo>
    cliente> [Mensagem do bilbo]: msg frodo olah, vamos para valfenda?
    cliente>

- [X] quit: o usuario pode dar quit e voltar para o terminal
- [X] quit: da logout 

EX:
    <terminal do servidor>
    servidor> list
    bilbo
    frodo
    servidor>

    <terminal do bilbo>
    cliete> quit
    /tmp$ 

    <terminal do servidor>
    servidor> list
    frodo
    servidor>


OBS: o unico parametro que pode conter espacos eh mensagem.
Nenhum parametro pode conter tabulacoes ou quebras de linha.

2. Requisitos

- [  ] Arquivos temporarios devem ser criados em /tmp
- [  ] Certifique-se que os usuarios tem permissao
- [  ] Todos os arquivos criados devem ser removidos quando os clientes e o servidor forem encerrados







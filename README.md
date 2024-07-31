# Assembly Calculator

## Descrição

Este projeto implementa uma calculadora simples em Assembly, capaz de solicitar dois números e uma operação ao usuário. Ele realiza a operação escolhida e exibe o resultado na tela. A calculadora é escrita para sistemas que utilizam a arquitetura x86_64 e utiliza chamadas de sistema do Linux.

![demonstração](img.png)

## Compilação e Execução

Para compilar e executar o código, você pode usar as seguintes ferramentas:

No Linux: Use o nasm para compilar e ld para linkar.

```
nasm -f elf64 -o main.o main.asm
ld -o main main.o
./main
```

No Windows: Use o nasm para compilar e o link da Microsoft para linkar, ou configure seu projeto no Visual Studio para incluir as funções necessárias.
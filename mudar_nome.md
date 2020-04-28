## mudar_nome.sh

Considere o seguinte diretório que contém os vídeos e as legendas de um seriado americano:

`$ ls -1`

###### 30.Rock.S03E01.HDTV.XviD-LOL.mkv
###### 30.Rock.S03E01.srt
###### 30.Rock.S03E02.HDTV.XviD-LOL.mkv
###### 30.Rock.S03E02.srt
###### 30.Rock.S03E03.HDTV.XviD-LOL.mkv
###### 30.Rock.S03E03.srt
###### 30.Rock.S03E04.HDTV.XviD-LOL.mkv
###### 30.Rock.S03E04.srt
###### 30.Rock.S03E05.christmas-especial.mkv
###### 30.Rock.S03E05.srt
###### ...

Os aficcionados em séries sabem que para assistir esses episódios (com legenda) é preciso que o nome do arquivo de vídeo (.mkv)
esteja igual ao da legenda (.srt), o que não acontece no nosso caso.

Um simples `mv` resolveria o problema, mas imagine que esse diretório contém mais de 300 arquivos.
Nessas horas é possível automatizar o processo com bash.

### Construindo o script mudar_nome.sh

Para criar o script, e começar a edição, execute a seguinte linha de comando:
`$ echo '#!/bin/bash' > mudar_nome.sh; chmod u+x mudar_nome.sh; vim mudar_nome.sh`

Retornando ao comando `ls -1` podemos notar que os arquivos .srt seguem um padrão, enquanto os arquivos .mkv
possuem variações como é o caso do arquivo **30.Rock.S03E05.christmas-especial.mkv**.
Vamos então utilizar os arquivos da legenda para renomear os arquivos de vídeo.

Primeiramente devemos percorrer todos os arquivos .srt. Para isso podemos utilizar a estrutura do laço `for`.

```
#!/bin/bash

for i in $(ls *.srt); do
	echo "$i"
done
```
###### 30.Rock.S03E01.srt
###### 30.Rock.S03E02.srt
###### 30.Rock.S03E03.srt
###### 30.Rock.S03E04.srt
###### 30.Rock.S03E05.srt
###### ...

Em seguida vamos usar o comando `sed` para remover a extensão dos arquivos. Afinal, na hora de renomear os arquivos de vídeo
vamos manter a extensão original.

```
#!/bin/bash

for i in $(ls *.srt | sed 's/.srt//g'); do
	echo "$i" 
done
```
###### 30.Rock.S03E01
###### 30.Rock.S03E02
###### 30.Rock.S03E03
###### 30.Rock.S03E04
###### 30.Rock.S03E05
###### ...

Agora precisamos achar a correspondência entre esses nomes tratados e os arquivos de vídeo que desejamos renomear.
Para isso, podemos substituir o comando `echo` por um filtro.

```
#!/bin/bash

for i in $(ls *.srt | sed 's/.srt//g'); do
	ls *.mkv | grep "$i" 
done
```
###### **30.Rock.S03E01**.HDTV.XviD-LOL.mkv
###### 30.Rock.S03E02.HDTV.XviD-LOL.mkv
###### 30.Rock.S03E03.HDTV.XviD-LOL.mkv
###### 30.Rock.S03E04.HDTV.XviD-LOL.mkv
###### 30.Rock.S03E05.christmas-especial.mkv
###### ...

Na alteração acima, estamos filtrando os arquivos .mkv que correspondem ao padrão definido anteriormente.
Por exemplo, o arquivo **30.Rock.S03E01.HDTV.XviD-LOL.mkv** casa exatamente com o padrão **30.Rock.S03E01**.

Por fim, basta utilizar o comando `xargs` para renomear cada um dos arquivos, lembrando de manter a extensão .mkv.

```
#!/bin/bash

for i in $(ls *.srt | sed 's/.srt//g'); do
	ls *.mkv | grep "$i" | xargs -n1 -I {} mv {} "$i".mkv 
done
```
`$ ls -1`
###### 30.Rock.S03E01.mkv
###### 30.Rock.S03E01.srt
###### 30.Rock.S03E02.mkv
###### 30.Rock.S03E02.srt
###### 30.Rock.S03E03.mkv
###### 30.Rock.S03E03.srt
###### 30.Rock.S03E04.mkv
###### 30.Rock.S03E04.srt
###### 30.Rock.S03E05.mkv
###### 30.Rock.S03E05.srt
###### ...

### Ajustes

Do jeito que escrevemos, o script só vai conseguir renomear arquivos .mkv. Para tornar nosso trabalho mais abrangente podemos
passar a extensão desejada na hora de executar o script. A extensão será o primeiro (e o único) parâmetro que deverá
ser passado ao script. Essa informação vai ficar armazenada na variável padrão `$1`.
Fazendo as modificações, temos:

```
#!/bin/bash

for i in $(ls *.srt | sed 's/.srt//g'); do
	ls *."$1" | grep "$i" | xargs -n1 -I {} mv {} "$i"."$1" 
done
```

Na hora de executar o script basta digitar:
`$ ./mudar_nome.sh [EXTENSÃO]`

#!/bin/bash

# O QUE É:
# Script para renomear arquivos de vídeo de acordo com a nomenclatura da legenda.
# Útil quando o nome do arquivo tem algum "lixo" que precia ser removido.
# Por exemplo, o nome do vídeo é "30.Rock.S03E04.HDTV.XviD-LOL.mkv"
# e o da legenda é 30.Rock.S03E04.srt.

# COMO USAR:
# É preciso passar um parâmetro na hora da execução do script.
# Esse parâmetro deve indicar a extensão dos arquivos de vídeo que serão renomeados.
# Exemplo de uso: ./mudar_nome.sh avi


for i in `ls *.srt | sed 's/.srt//g'`; do
	ls *."$1" | grep "$i" | xargs -n1 -I {} mv {} $i.$1
done



#Script para criar o ambiente de teste
##!/bin/bash

#EXT="mkv"
#rm *.mkv
#for i in `seq -w 1 10`; do > 30.Rock.S03E"$i".HDTV.XviD-LOL."$EXT"; done
#mv 30.Rock.S03E06.HDTV.XviD-LOL."$EXT" 30.Rock.S03E06-christmas-especial."$EXT"

#!/usr/bin/env bash

echo 'CREATE DATABASE datascience;' > /docker-entrypoint-initdb.d/dump.sql
echo '' > /docker-entrypoint-initdb.d/dumptable.sql

for file in /rawdata/*; do
    f=$(echo "${file##*/}");
    filename=$(echo $f| cut  -d'.' -f 1);
    echo "CREATE SEQUENCE ${filename}_id_seq; CREATE TABLE IF NOT EXISTS ${filename}( id integer NULL DEFAULT nextval('${filename}_id_seq'), unidade_gestora VARCHAR(255),gestao VARCHAR(50),acao VARCHAR(200),esfera VARCHAR(50),tipo_de_despesa VARCHAR(50),programa_de_trabalho VARCHAR(255),funcao VARCHAR(255),subfuncao VARCHAR(255),programa VARCHAR(255),subtitulo VARCHAR(255),categoria_economica VARCHAR(255),grupo_de_natureza_da_despesa VARCHAR(255),modalidade_de_aplicacao VARCHAR(255),elemento_de_despesa VARCHAR(255),fonte_de_recursos VARCHAR(255),no_do_processo VARCHAR(30),credor VARCHAR(120),cnpj_cpf_credor VARCHAR(20),empenhado VARCHAR(200),liquidado VARCHAR(200),pago_ex VARCHAR(200),pago_rpp VARCHAR(200),pago_rpnp VARCHAR(200),pago_ret VARCHAR(200),total_pago VARCHAR(200) );" >> /docker-entrypoint-initdb.d/dumptable.sql
done

psql -h localhost -U postgres postgres -f docker-entrypoint-initdb.d/dump.sql
psql -h localhost -U postgres datascience -f docker-entrypoint-initdb.d/dumptable.sql

for ffile in /rawdata/*; do
    ff=$(echo "${ffile##*/}");
    ffilename=$(echo $ff| cut  -d'.' -f 1);
    psql -h localhost -U postgres datascience -c "\copy ${ffilename}( unidade_gestora,gestao,acao,esfera,tipo_de_despesa,programa_de_trabalho,funcao,subfuncao,programa,subtitulo,categoria_economica,grupo_de_natureza_da_despesa,modalidade_de_aplicacao,elemento_de_despesa,fonte_de_recursos,no_do_processo,credor,cnpj_cpf_credor,empenhado,liquidado,pago_ex,pago_rpp,pago_rpnp,pago_ret,total_pago) FROM '/rawdata/${ffilename}.csv' DELIMITER ';' CSV   HEADER;"
done
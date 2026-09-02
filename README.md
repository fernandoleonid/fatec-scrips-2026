# Scripts de Linux - FATEC 2026

Exercícios introdutórios de administração de sistemas Linux, elaborados pelo
professor Fernando Leonid.

## Scripts

- `01.sh`: exibe um relatório básico do Debian 13, com data, host, kernel e
	espaço em disco.
- `02.sh`: mostra as interfaces de rede, o gateway padrão e os servidores DNS.
- `03.sh`: configura uma interface `eth0` com IP estático e grava as definições
	em `/etc/network/interfaces`.

## Como executar

Em um sistema Debian ou Linux compatível:

```bash
chmod +x *.sh
./01.sh
./02.sh
sudo ./03.sh
```

O script `03.sh` sobrescreve o arquivo `/etc/network/interfaces` com os
seguintes parâmetros: IP `192.168.1.100`, gateway `192.168.1.1` e DNS
`8.8.8.8` e `8.8.4.4`. Confira a configuração da rede antes de executá-lo.

## Redes sociais

- [LinkedIn](https://www.linkedin.com/in/fernandoleonid)
- [YouTube](https://www.youtube.com/@fernandoleonid)
- [Instagram](https://www.instagram.com/fernandoleonid)
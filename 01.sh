#!/bin/bash
# Meu primeiro script de relatório no Debian 13
# Autor: [Seu Nome] - Data: 03/09/2026

echo "========================================="
echo "  RELATÓRIO DO SISTEMA DEBIAN 13"
echo "========================================="
echo "Olá, $USER! Bem-vindo ao seu primeiro script."
echo ""
echo "Data e Hora atuais: $(date)"
echo "Nome da Máquina (Host): $(hostname)"
echo "Versão do Kernel: $(uname -r)"
echo ""
echo "Como está o espaço em disco?"
df -h /
echo ""
echo "Fim do relatório. Tenha um ótimo dia!"
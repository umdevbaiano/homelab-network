# HOME LAB

Este repositório contém a configuração integral de um **Protótipo de Rede Resiliente** para Home Lab, implementado em **MikroTik RouterOS v7**. O projeto foca em alta disponibilidade via Multi-WAN e segmentação lógica rigorosa através de VLANs.


## 🛠️ Especificações Técnicas

### Engenharia de Tráfego (PCC)
Implementação de balanceamento de carga **4-Way** utilizando o algoritmo **Per Connection Classifier (PCC)** para otimização de largura de banda e redundância.
- **Método:** `both-addresses-and-ports` para distribuição granular de sessões.
- **Interfaces WAN:** Redundância distribuída entre 4 provedores independentes (JT, He-Net, Oi e Starlink).
- **Failover:** Monitoramento de gateway via ICMP (ping) para comutação automática em caso de falha de link.



### Segmentação de Camada 2 e 3
Arquitetura baseada no modelo **Router-on-a-Stick** com isolamento de domínios de broadcast para maior segurança e desempenho:
- **VLAN 10 (IA):** Cluster de processamento e treinamento de modelos.
- **VLAN 20 (MGMT):** Gerenciamento de dispositivos e infraestrutura.
- **VLAN 30 (IOT):** Dispositivos inteligentes e sensores.
- **VLAN 40 (FAM):** Rede administrativa e de uso pessoal.

### Segurança e Firewall
- **Isolamento L3:** Políticas de Firewall (Drop) bloqueando o tráfego lateral entre redes de produção (IA) e redes de usuário (Família).
- **NAT Dinâmico:** Masquerade configurado para todas as saídas WAN de forma independente, garantindo persistência de rota.

## 🚀 Como Usar

1. Baixe o arquivo `main_config.rsc` disponível neste repositório.
2. Acesse o seu MikroTik via Winbox e transfira o arquivo para o menu `Files`.
3. No terminal do RouterOS, execute o comando de importação:
   ```routeros
   /import file-name=main_config.rsc


**Samuel de Jesus Miranda** | *Full-Stack Developer & Infrastructure Specialist*

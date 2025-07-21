# ZCAPNet - Sistema de apoio à Proteção Civil
Projeto realizado por: 
  - Gonçalo Dimas([github.com/Dimas48263](https://github.com/Dimas48263))
  - Luís Alves([github.com/zitosxj](https://github.com/zitosxj))

Curso:
  - Licenciatura em Engenharia Informática e de Computadores no semestre de verão 2024/2025

# Resumo
O alojamento temporário de emergência é uma valência do apoio psicossocial em emergência, essencial para proporcionar ao cidadão individual e às famílias um local seguro para permanecerem, antes, durante e após um acidente grave ou catástrofe, onde são igualmente asseguradas as suas necessidades básicas, bem como apoio psicossocial de emergência.
Assim, o alojamento de emergência providenciado em caso de acidente grave, catástrofe ou outro tipo de ocorrência de caráter excecional é uma resposta temporária à existência de cidadãos que, no âmbito de uma evacuação, são deslocados das suas residências por não estarem numa zona segura, enquanto não é restabelecida a normalidade ou necessitam de apoio psicossocial em emergência.
No âmbito do Sistema Integrado de Operações de Proteção e Socorro (SIOPS), do Sistema de Gestão de Operações (SGO) e dos Planos de Emergência Nacionais, Regionais, Distritais, Municipais e Especiais, a designação utilizada para o alojamento de emergência de pessoas deslocadas na sequência de acidente grave ou catástrofe é Zona de Concentração e Apoio à
População (ZCAP).
Embora existam vários tipos de alojamento de emergência, um dos objetivos principais de uma ZCAP é o de constituir um local seguro para os indivíduos e famílias, afetados por uma emergência ou acidente grave, poderem pernoitar ou descansar e oferecer, entre outras, cuidados básicos de saúde, alimentação, bebidas, agasalhos, instalações sanitárias, apoio psicossocial e informações sobre o desenvolvimento das operações de socorro.
O objetivo deste projeto é criar um sistema computacional centralizado para assistir na gestão das ZCAP garantindo a existência de centralização de informação com uma estrutura de dados uniforme.
A arquitetura desenhada baseia-se na implementação de uma aplicação desktop autónoma sob o princípio de funcionamento \textit{offline-first} com uma base de dados local e sincronização posterior com a base de dados remota a partir de uma Web API também desenvolvida. 
O sistema desenvolvido tem capacidade de resiliência na eventualidade de falha das infraestruturas de comunicação e permite ser evoluído para casos de uso futuro.

# Abstract
Emergency temporary shelter is a component of psychosocial emergency support, essential for providing individuals and families with a safe place to stay before, during, and after a serious accident or disaster. It ensures that their basic needs are met, while also delivering psychosocial emergency support.
Thus, emergency shelter provided in the event of a serious accident, disaster, or other exceptional occurrence is a temporary response to support citizens who, following an evacuation, have been displaced from their homes due to unsafe conditions, until normality is restored or psychosocial support is no longer required.
Within the framework of the Integrated System for Protection and Relief Operations (SIOPS), the Operations Management System (SGO), and National, Regional, District, Municipal, and Special Emergency Plans, the designation used for emergency shelter for displaced persons is Population Support and Assembly Zone (ZCAP).
Although there are various types of emergency accommodation, one of the main objectives of a ZCAP is to provide a safe location where individuals and families affected by an emergency or serious accident can sleep or rest. ZCAPs also offer, among other services, basic healthcare, food, beverages, warm clothing, sanitary facilities, psychosocial support, and updates of rescue operations.
The objective of this project is to develop a centralized computational system to support the management of ZCAPs, ensuring uniform data structuring and centralized information.
The proposed architecture is based on the implementation of a standalone desktop application under an \textit{offline-first} paradigm, using a local database with subsequent synchronization to a remote database through a custom-built Web API.
The developed system is resilient in the event of communication infrastructure failures and is designed to evolve for future use cases.

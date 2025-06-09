# Evex - Gerenciador de Eventos Acadêmicos
### Visão Geral
O Evex é um aplicativo mobile e web para gerenciar eventos acadêmicos (palestras, workshops, congressos) da PUC-GO, desenvolvido como Projeto Integrador do 5º período do curso de Análise e Desenvolvimento de Sistemas. Facilita organização, inscrição e divulgação de eventos para estudantes e professores.

### Funcionalidades

- Autenticação: Login com e-mail institucional (PUC-GO), categorizando usuários (Aluno/Professor).
- Gestão de Eventos: Criar, editar e categorizar eventos com detalhes (data, horário, local via Google Maps).
- Inscrições: Inscrição com validação de conflitos de horário e capacidade; cancelamento até 1 hora antes.
- Notificações: Lembretes via notificações push.
- Relatórios: Relatórios de inscrições e presenças para organizadores.
- Interface: Design intuitivo para Android e web (Chrome).

### Tecnologias

- Flutter/Dart: Interface para Android e web.
- Firebase:
    - Firestore: Banco de dados NoSQL.
    - Authentication: Autenticação segura.
    - Storage: Armazenamento de imagens.

- Cloud Functions: Lógica de negócio.
- Node.js/Render: API RESTful hospedada no Render.
- Figma: Prototipagem.

### Como Executar

1. Pré-requisitos:
- Flutter SDK
- Conta Firebase
- VS Code ou Android Studio com extensões Flutter/Dart


2. Configuração:
- Clone o repositório: `git clone` <https://github.com/Villainitt/evex>
- Configuração do Firebase:
    - Acesse o Firebase Console e obtenha o projeto Firebase.
    - Baixe o arquivo `google-services.json` (para Android) ou configure o Firebase para web (arquivo `firebase_config.js`).
    - Coloque o `google-services.json` na pasta `/android/app` (para Android) ou configure o `firebase_config.js` conforme instruções do Firebase para web.


- Configuração da API:
    - A API está hospedada no Render em <https://email-api-v80f.onrender.com>.


- Instale dependências: `flutter pub get`


3. Execução:
- Para Android: `flutter run`
- Para web (Chrome): `flutter run -d chrome`



### Estrutura do Projeto

- `/lib`: Código-fonte (Flutter/Dart).
- `/assets`: Imagens e recursos.
- `/documentacao`: Documentação.

### Limitações

- Exclusivo para eventos da PUC-GO.
- Autenticação simulada (sem integração com banco institucional).
- Suporte para Android e web (Chrome).
- Capacidade inicial de 1000 usuários simultâneos.

### Metodologia
Desenvolvido com **Scrum**, com sprints semanais de 20/03/2025 a 09/06/2025.

### Equipe

- Camila Martins Sousa
- Giovanna Castro Freitas
- Pablo Leandro de Oliveira Glória


### Licença
Uso exclusivo para fins acadêmicos na PUC-GO.
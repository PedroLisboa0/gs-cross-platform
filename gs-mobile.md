Global Solution 2026.2 - Cross-Platform Application
Development
Tema global: CitizenTech
Tecnologia que transforma a vida das pessoas. Esse é o espírito da Global Solution do 2º
semestre de 2026.
O desafio CitizenTech convida você a olhar para problemas reais das cidades, do campo e das
comunidades e a desenvolver soluções tecnológicas capazes de melhorar concretamente a
vida das pessoas: mobilidade, acessibilidade, sustentabilidade, segurança, infraestrutura,
conectividade, inclusão e tantas outras necessidades do cotidiano.
Mais do que desenvolver uma aplicação, queremos que você compreenda para quem está
criando, qual problema está resolvendo e qual impacto pode gerar. Cada disciplina
contribui com uma peça desse desafio, conectando seus conhecimentos técnicos à construção
de soluções reais. A Global Solution não é apenas uma avaliação: é a oportunidade de mostrar
como diferentes conhecimentos se conectam para transformar ideias em soluções.
Desafio da turma: Territory Predictive Insights
Você deverá criar uma plataforma de análise de dados voltada à antecipação de problemas
que afetam a qualidade de vida em um território (cidade, bairro ou comunidade rural), como
desperdício de recursos, variações climáticas locais ou demanda por serviços.
A solução completa deve:
• Coletar e tratar conjuntos de dados públicos, sintéticos ou autorizados
• Identificar padrões e aplicar modelos estatísticos ou de machine learning para apoiar
decisões
• Apresentar painéis interpretáveis e alertas fundamentados nas evidências
• Explicitar métricas, limitações, vieses e as condições em que as previsões não são
confiáveis
• Evitar decisões automáticas de alto impacto: a decisão final é sempre humana
• Relacionar o desempenho analítico a indicadores de benefício social
• Prever mecanismos adequados de privacidade e inclusão

Entrega para Cross-Platform Application Development
Para esta disciplina, o grupo deverá criar um aplicativo mobile completo e funcional em
Flutter que funcione como um painel de inteligência territorial: a interface pela qual gestores
públicos e cidadãos acompanham indicadores, previsões e alertas do território escolhido.
O app deve consumir dados públicos, sintéticos ou autorizados sobre temas como consumo de
água e energia, clima local, resíduos ou demanda por serviços. Cada alerta preditivo deve vir
acompanhado de sua justificativa, nível de confiança e limitações.
Aplique os conhecimentos do semestre (navegação entre telas, gerenciamento de estado,
consumo de APIs, persistência de dados, formulários com validação e componentes
reutilizáveis com identidade visual própria) e vá além. A escolha de bibliotecas, serviços e
arquitetura é do grupo e deve ser justificada no README.
O resultado esperado é um app funcional, visualmente coerente e tecnicamente sólido, como
se fosse a central de decisões de um gestor público comprometido com o bem-estar da
população.
Critérios de avaliação
A Global Solution vale 6 pontos na nota do semestre. A avaliação é de 0 a 10 pontos,
convertida proporcionalmente para os 6 pontos. Por ser a avaliação final do semestre, o rigor é
máximo.
| #  Critério     | Descrição                            | Pontuação máxima  |
| --------------- | ------------------------------------ | ----------------- |
| 1  Navegação e  | Navegação entre múltiplas telas bem  | 1,0 pt            |
| fluxo de telas  | organizada, com rotas nomeadas,      |                   |
passagem de parâmetros e fluxo coerente
(ex.: visão geral → detalhe do indicador →
detalhe do alerta).
| 2  Dashboards  | Mínimo de 3 dashboards distintos com        | 1,5 pt  |
| -------------- | ------------------------------------------- | ------- |
| territoriais   | dados do território (ex.: recursos, clima,  |         |
serviços). Uso de gráficos, cards e
indicadores visuais com histórico e
tendência.
| 3  Alertas     | Alertas gerados a partir de regras ou      | 1,5 pt  |
| -------------- | ------------------------------------------ | ------- |
| preditivos e   | previsões sobre os dados. Cada alerta      |         |
| transparência  | exibe justificativa (evidência), nível de  |         |
confiança, limitações e deixa claro que a
decisão final é humana.
4  Gerenciamento  Estado local e global bem separados,  1,0 pt
| de estado  | compartilhado entre múltiplas telas, com  |     |
| ---------- | ----------------------------------------- | --- |
tratamento de carregamento, erro e lista
vazia.

| #  Critério      | Descrição                                     | Pontuação máxima  |
| ---------------- | --------------------------------------------- | ----------------- |
| 5  Integração e  | Consumo de dados de API ou serviço            | 1,0 pt            |
| persistência de  | externo (real ou simulado) e persistência     |                   |
| dados            | local de dados relevantes (ex.: ocorrências,  |                   |
limiares, preferências). O app deve
continuar útil sem conexão.
6  Formulários  Ao menos um formulário funcional (ex.:  1,0 pt
| com validação  | registro de ocorrência pelo cidadão,  |     |
| -------------- | ------------------------------------- | --- |
configuração de limiares de alerta), com
validação, mensagens de erro claras e
submissão correta.
7  Identidade  Interface coesa e temática, com tema e  1,0 pt
| visual e UX  | componentes reutilizáveis (cores, tipografia,  |     |
| ------------ | ---------------------------------------------- | --- |
espaçamentos padronizados). Boa
usabilidade e responsividade.
8  Acessibilidade,  Contraste adequado, suporte a tamanhos  0,5 pt
| privacidade e   | de fonte e leitores de tela. Dados pessoais  |     |
| --------------- | -------------------------------------------- | --- |
| impacto social  | anonimizados e consentimento explícito. Ao   |     |
menos um indicador de benefício social
exibido no app.
9  Organização do  Estrutura de pastas clara, separação de  1,0 pt
| código e  | responsabilidades, código limpo, decisões  |     |
| --------- | ------------------------------------------ | --- |
| README    | técnicas justificadas. README completo     |     |
conforme especificação.
| 10  Vídeo de  | Vídeo de até 3 minutos demonstrando       | 0,5 pt  |
| ------------- | ----------------------------------------- | ------- |
| demonstração  | todas as funcionalidades do app de forma  |         |
clara e objetiva.
|   Total  |     | 10 pts  |
| -------- | --- | ------- |

Diferenciais (bônus, sem ultrapassar 10 pts)
Itens não obrigatórios que compensam eventuais perdas nos critérios principais.
Diferencial Descrição
Dados reais Integração com bases ou APIs públicas reais (ex.: dados
abertos municipais, clima, qualidade do ar)
Mapa e geolocalização Visualização dos indicadores ou alertas por região em
mapa
Notificações Alertas críticos enviados como notificações locais ou push
IA generativa Explicação dos alertas em linguagem simples para o
cidadão, gerada por LLM
Animações Animações e transições com propósito claro de
comunicação
Temas Modo escuro e tema de alto contraste
Testes automatizados Testes de unidade ou de widget cobrindo a lógica de alertas
e validações
APK de release APK instalável disponibilizado no repositório (Releases)
Checklist de entrega para nota máxima
Use este checklist para garantir que nada fique faltando antes de enviar.
Repositório GitHub
• ☐ Repositório público no GitHub
• ☐ README.md completo conforme a especificação abaixo
• ☐ Código-fonte completo e funcional
• ☐ Arquivos de build e dependências fora do repositório (.gitignore configurado)
• ☐ Chaves de API e credenciais fora do código versionado
• ☐ Commits com mensagens descritivas ao longo do desenvolvimento

Funcionalidades do app
• ☐ Pelo menos 5 telas com navegação organizada e fluxo coerente
• ☐ Mínimo de 3 dashboards territoriais distintos, com gráficos e indicadores
• ☐ Alertas gerados a partir dos dados, cada um com justificativa, nível de confiança e
limitações
• ☐ Aviso visível de que os alertas apoiam, mas não substituem, a decisão humana
• ☐ Estado global compartilhado em pelo menos 2 telas diferentes
• ☐ Estados de carregamento, erro e lista vazia tratados
• ☐ Dados consumidos de API ou serviço externo (real ou simulado)
• ☐ Pelo menos 1 tipo de dado relevante persistido localmente
• ☐ App continua útil sem conexão (dados em cache ou locais)
• ☐ Formulário funcional com validação e feedback visual de erro
• ☐ Ao menos 1 indicador de benefício social exibido no app
• ☐ App roda sem erros em emulador ou dispositivo físico
Qualidade, acessibilidade e privacidade
• ☐ Identidade visual temática e consistente em todas as telas
• ☐ Tema e componentes reutilizáveis (sem estilos repetidos tela a tela)
• ☐ Contraste adequado e textos legíveis com fonte ampliada
• ☐ Elementos interativos com descrição para leitores de tela
• ☐ Dados pessoais anonimizados e tela ou etapa de consentimento
• ☐ Layout testado em pelo menos 2 tamanhos de tela
• ☐ Sem código morto, print excessivo ou imports não utilizados
Vídeo
• ☐ Duração máxima de 3 minutos
• ☐ Demonstra todas as telas e funcionalidades principais
• ☐ Mostra um alerta sendo gerado e sua justificativa
• ☐ Voz ou legenda explicando o que está sendo mostrado
• ☐ Qualidade de imagem e áudio adequada
Arquivo de entrega
• ☐ Arquivo .txt com nome completo e RM de todos os integrantes
• ☐ Link do repositório GitHub
• ☐ Link do vídeo de demonstração (YouTube, Drive ou similar, com acesso público)
• ☐ Arquivo zipado se o portal da FIAP exigir

Especificação do README
O README.md é parte obrigatória da entrega e é avaliado no critério 9. Ele deve conter, nesta
ordem:
1. Cabeçalho: nome do app, banner ou logo e uma frase que resuma a solução.
2. Problema e público: qual problema do território o app antecipa, para quem foi criado e
qual impacto social espera gerar.
3. Integrantes: tabela com nome completo e RM de todos.
4. Demonstração visual (obrigatório): prints de todas as telas do app, cada um com
legenda curta. Salve as imagens em assets/screenshots/ e exiba-as no README, por
exemplo em tabela lado a lado.
5. Funcionalidades: checklist das funcionalidades implementadas.
6. Dados e alertas: fonte dos dados (públicos, sintéticos ou autorizados), como os alertas
são gerados, métricas usadas, limitações, possíveis vieses e quando as previsões não
são confiáveis.
7. Privacidade e inclusão: como os dados pessoais são protegidos e quais recursos de
acessibilidade foram implementados.
8. Tecnologias e decisões técnicas: bibliotecas, serviços e arquitetura escolhidos, com
uma justificativa curta para cada escolha.
9. Como executar: passo a passo para clonar, instalar dependências, configurar variáveis
de ambiente e rodar o app.
10. Vídeo: link do vídeo de demonstração (thumbnail opcional).
11. Licença: projeto acadêmico, FIAP, Global Solution 2026.2.
README sem prints de todas as telas será penalizado.
Formação dos grupos
Modalidade Permitido?
Individual Sim
Dupla Sim
Trio Sim
Grupo de 4 ou mais Não permitido
Grupos maiores que o permitido terão a nota zerada automaticamente.

Formato de entrega
A entrega deve ser feita pelo portal da FIAP até a data limite. Envie um arquivo .txt (ou .zip
contendo o .txt, se o portal exigir) com o conteúdo abaixo:
=== GLOBAL SOLUTION 2026.2 ===
Disciplina: Cross-Platform Application Development
Desafio: Territory Predictive Insights
Integrante 1: [Nome Completo] | RM: [XXXXXX]
Integrante 2: [Nome Completo] | RM: [XXXXXX]
Integrante 3: [Nome Completo] | RM: [XXXXXX]
GitHub: https://github.com/...
Vídeo: https://...
Entregas fora do formato, com link quebrado ou vídeo inacessível não serão avaliadas.
Critérios que zeram a nota
• App não roda (erro crítico na execução)
• Repositório privado ou link inválido
• Plágio ou cópia de outro grupo
• Vídeo ausente ou que não demonstra o app
• App que toma decisões automáticas de alto impacto sem supervisão humana
• Entrega fora do prazo
Prazos
Evento Data
Divulgação do desafio 04/11/2026
Entrega final 19/11/2026, até 23h55
Dúvidas
Procure o professor nos canais oficiais da turma:
• E-mail: profhercules.ramos@fiap.com.br
• Microsoft Teams: canal da turma
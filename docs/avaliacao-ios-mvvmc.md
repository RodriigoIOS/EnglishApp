# Avaliação do app iOS + proposta **mais simples e eficiente** (MVVM-C por módulos)

Você está certo: dá para simplificar bastante.

A estrutura anterior estava completa, porém um pouco detalhada para o estágio atual do app. A melhor relação **simplicidade x eficiência** aqui é:

- **MVVM-C por feature (módulo)**
- 4 pastas por módulo: `Domain`, `Data`, `Presentation`, `Coordinator`
- Um `Core` pequeno para itens realmente compartilhados

---

## 1) Diagnóstico rápido do que já está bom

Seu projeto já tem base sólida:

- Coordinator implementado (`AppCoordinator`, `ChatCoordinator`)
- ViewModels e UseCases separados
- Repositórios com protocolo
- DI container central

Ou seja: você **já está no caminho do MVVM-C**, falta só organizar melhor a estrutura física para escalar sem fricção.

---

## 2) Estrutura recomendada (versão enxuta)

> Regra prática: se uma pasta não tiver pelo menos 2–3 arquivos no curto prazo, não crie agora.

```txt
OhMyLanguageApp/
├─ App/
│  ├─ AppDelegate.swift
│  ├─ SceneDelegate.swift
│  ├─ AppCoordinator.swift
│  └─ AppDIContainer.swift
│
├─ Core/
│  ├─ UI/
│  │  ├─ UIColor+Theme.swift
│  │  ├─ UIFont+App.swift
│  │  └─ UIView+Constraints.swift
│  ├─ Network/
│  │  ├─ APIError.swift
│  │  └─ LLMClientProtocol.swift
│  └─ Common/
│     ├─ Coordinator.swift
│     ├─ ViewCodeProtocol.swift
│     └─ AppConstants.swift
│
├─ Modules/
│  ├─ Chat/
│  │  ├─ Domain/
│  │  │  ├─ Message.swift
│  │  │  ├─ ChatRepositoryProtocol.swift
│  │  │  └─ SendMessageUseCase.swift
│  │  ├─ Data/
│  │  │  ├─ MessageDTO.swift
│  │  │  ├─ MessageResponseDTO.swift
│  │  │  ├─ ChatRepository.swift
│  │  │  └─ GeminiClient.swift
│  │  ├─ Presentation/
│  │  │  ├─ ChatViewController.swift
│  │  │  ├─ ChatViewModel.swift
│  │  │  ├─ ChatView.swift
│  │  │  ├─ ChatInputView.swift
│  │  │  ├─ MessageCell.swift
│  │  │  └─ TypingIndicatorCell.swift
│  │  └─ Coordinator/
│  │     └─ ChatCoordinator.swift
│  │
│  ├─ Goals/
│  │  ├─ Domain/
│  │  │  ├─ LearningGoal.swift
│  │  │  ├─ GoalsRepositoryProtocol.swift
│  │  │  └─ ManageGoalsUseCase.swift
│  │  ├─ Data/
│  │  │  └─ GoalsRepository.swift
│  │  ├─ Presentation/
│  │  │  ├─ GoalsViewController.swift
│  │  │  ├─ GoalsViewModel.swift
│  │  │  └─ GoalCell.swift
│  │  └─ Coordinator/
│  │     └─ GoalsCoordinator.swift (opcional agora)
│  │
│  └─ Progress/
│     ├─ Domain/
│     │  ├─ UserProgress.swift
│     │  └─ TrackProgressUseCase.swift
│     ├─ Presentation/
│     │  ├─ FeedbackViewModel.swift
│     │  ├─ StatsViewModel.swift
│     │  └─ PanelViewController.swift
│     └─ Coordinator/
│        └─ ProgressCoordinator.swift (opcional agora)
│
└─ Tests/
   ├─ Unit/
   └─ UI/
```

---

## 3) Por que essa versão é mais eficiente?

1. **Menos profundidade de pastas**
   - Você encontra arquivos rápido.

2. **Separação por feature primeiro**
   - Melhor para times e evolução incremental.

3. **Escala com pouco atrito**
   - Quando crescer, você adiciona subpastas internas sem quebrar o padrão.

4. **Evita over-engineering precoce**
   - Nada de criar `DataSources/Factories/Mappers` antes de precisar.

---

## 4) Regras simples para manter arquitetura saudável

- Toda navegação entre telas: **Coordinator**.
- VC não fala com Repository direto: sempre via **ViewModel/UseCase**.
- Tudo que é compartilhado por 2+ módulos vai para **Core**.
- Nomes de código em inglês (`lessonMode`, `sendMessage`).
- Strings de interface em `Localizable.strings`.

---

## 5) Plano de migração (3 passos)

### Passo 1 — Organizar sem alterar comportamento

- Criar `App`, `Core`, `Modules`.
- Mover arquivos atuais para os módulos correspondentes.
- Ajustar groups do Xcode.

### Passo 2 — Limpar contratos

- Renomear `AnthropicAPIClient` para `GeminiClient` (ou abstrair para `LLMClientProtocol`).
- Corrigir typo `lessionMode` -> `lessonMode`.
- Garantir que `GoalsRepository` realmente persista/recupere metas.

### Passo 3 — Garantir qualidade

- Testes unitários iniciais:
  - `ChatViewModelTests`
  - `SendMessageUseCaseTests`
  - `ManageGoalsUseCaseTests`

---

## 6) Decisão prática (recomendada agora)

Se você quer **simples e eficiente hoje**, adote exatamente este padrão:

- `Modules/Chat`, `Modules/Goals`, `Modules/Progress`
- dentro de cada módulo: `Domain`, `Data`, `Presentation`, `Coordinator`
- `Core` mínimo e objetivo

Esse é o ponto ideal para seu app neste momento: organizado para crescer, sem complexidade desnecessária.

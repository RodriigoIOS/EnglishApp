# Avaliação completa do app iOS (UIKit + MVVM-C) e proposta de modularização

## 1) Resumo executivo

Seu app já tem uma base muito boa para evoluir:

- Você **já usa Coordinator**, **ViewModel**, **UseCase** e **Repository**, o que acelera a transição para uma arquitetura limpa e escalável.
- O app está funcionalmente coeso: chat, metas e feedback/progresso estão conectados por fluxos claros.
- O principal gargalo atual não é “falta de arquitetura”, e sim **organização física**, **separação de módulos** e alguns **detalhes de robustez** (persistência, contratos e responsabilidades).

Minha recomendação: manter MVVM-C, mas evoluir para **MVVM-C + Clean Architecture por feature module**, com um módulo `Core` e módulos de feature (`Chat`, `Goals`, `Progress`).

---

## 2) Pontos fortes observados

1. **Coordenação de fluxo já implementada**
   - `AppCoordinator` e `ChatCoordinator` organizam navegação e comunicação de alto nível.

2. **Injeção de dependência centralizada**
   - `AppDIContainer` já cria serviços, repositórios, use cases e view models.

3. **Use cases com responsabilidade objetiva**
   - `SendMessageUseCase`, `ManageGoalsUseCase` e `TrackProgressUseCase` indicam boa direção de domínio.

4. **Protocol-oriented design em pontos críticos**
   - Protocolos para API client, repositórios e use cases ajudam testabilidade.

---

## 3) Riscos e oportunidades de melhoria

### 3.1 Organização e escalabilidade

- Hoje os arquivos estão quase todos no mesmo nível da pasta principal do target.
- Isso dificulta onboarding e manutenção quando o app crescer.

**Melhoria**: reorganizar por **módulo + camada**.

### 3.2 Fronteiras de responsabilidade

- `ChatViewController` está carregando responsabilidades de apresentação + parte de fluxo (ex.: linguagem, painel, modo).
- `ChatViewModel` contém estado de UI (ex.: `translatedIDs`) que poderia virar estado de apresentação por item.

**Melhoria**: mover decisões de fluxo para Coordinator e usar modelos de apresentação específicos.

### 3.3 Consistência de nomenclatura

- Existe mistura de português/inglês e typos (`lessionMode`).

**Melhoria**: padronizar naming em inglês técnico (código) e português apenas para textos UI/localização.

### 3.4 Persistência de metas

- `GoalsRepository` define `saveGoals`, mas o `loadGoals` retorna defaults fixos e não recupera dados salvos.

**Melhoria**: completar persistência e separar fonte local (UserDefaults) por datasource.

### 3.5 Networking e contratos

- `AnthropicAPIClient` usa endpoint do Gemini; o nome pode confundir e dificultar troca de provider.
- Parsing manual em dicionário é funcional, mas frágil para evolução.

**Melhoria**: `LLMClientProtocol` + clients concretos (`GeminiClient`, `AnthropicClient`) e DTOs `Codable`.

### 3.6 Testabilidade

- Estrutura já facilita testes, mas faltam testes de unidade para use cases e view models.

**Melhoria**: começar pelos fluxos críticos: envio de mensagem, mudança de idioma, toggle de metas.

---

## 4) Estrutura de pastas sugerida (MVVM-C por módulos)

> Objetivo: manter o app simples, porém preparado para crescer sem virar “pasta única”.

```txt
OhMyLanguageApp/
├─ App/
│  ├─ Application/
│  │  ├─ AppDelegate.swift
│  │  ├─ SceneDelegate.swift
│  │  └─ AppCoordinator.swift
│  ├─ DI/
│  │  └─ AppDIContainer.swift
│  └─ Resources/
│     ├─ Info.plist
│     └─ Config.xcconfig
│
├─ Core/
│  ├─ DesignSystem/
│  │  ├─ UIColor+Theme.swift
│  │  ├─ UIFont+App.swift
│  │  └─ ReusableViews/
│  ├─ Foundation/
│  │  ├─ Extensions/
│  │  │  └─ UIView+Constraints.swift
│  │  └─ Protocols/
│  │     └─ ViewCodeProtocol.swift
│  ├─ Networking/
│  │  ├─ APIError.swift
│  │  ├─ LLMClientProtocol.swift
│  │  └─ Providers/
│  │     ├─ GeminiClient.swift
│  │     └─ AnthropicClient.swift
│  └─ Domain/
│     ├─ Entities/
│     │  ├─ Language.swift
│     │  ├─ Message.swift
│     │  ├─ LearningGoal.swift
│     │  └─ UserProgress.swift
│     └─ SharedUseCases/
│
├─ Features/
│  ├─ Chat/
│  │  ├─ Domain/
│  │  │  ├─ Repositories/
│  │  │  │  └─ ChatRepositoryProtocol.swift
│  │  │  └─ UseCases/
│  │  │     └─ SendMessageUseCase.swift
│  │  ├─ Data/
│  │  │  ├─ DTOs/
│  │  │  │  ├─ MessageDTO.swift
│  │  │  │  └─ TutorResponseDTO.swift
│  │  │  └─ Repositories/
│  │  │     └─ ChatRepository.swift
│  │  ├─ Presentation/
│  │  │  ├─ Coordinator/
│  │  │  │  └─ ChatCoordinator.swift
│  │  │  ├─ ViewModel/
│  │  │  │  └─ ChatViewModel.swift
│  │  │  ├─ Views/
│  │  │  │  ├─ ChatView.swift
│  │  │  │  └─ ChatInputView.swift
│  │  │  └─ ViewController/
│  │  │     └─ ChatViewController.swift
│  │  └─ Components/
│  │     ├─ MessageCell.swift
│  │     └─ TypingIndicatorCell.swift
│  │
│  ├─ Goals/
│  │  ├─ Domain/
│  │  │  ├─ Repositories/
│  │  │  │  └─ GoalsRepositoryProtocol.swift
│  │  │  └─ UseCases/
│  │  │     └─ ManageGoalsUseCase.swift
│  │  ├─ Data/
│  │  │  ├─ Repositories/
│  │  │  │  └─ GoalsRepository.swift
│  │  │  └─ DataSources/
│  │  │     └─ GoalsLocalDataSource.swift
│  │  └─ Presentation/
│  │     ├─ ViewModel/
│  │     │  └─ GoalsViewModel.swift
│  │     ├─ ViewController/
│  │     │  └─ GoalsViewController.swift
│  │     └─ Views/
│  │        └─ GoalCell.swift
│  │
│  └─ Progress/
│     ├─ Domain/
│     │  └─ UseCases/
│     │     └─ TrackProgressUseCase.swift
│     └─ Presentation/
│        ├─ ViewModel/
│        │  ├─ FeedbackViewModel.swift
│        │  └─ StatsViewModel.swift
│        └─ ViewController/
│           └─ PanelViewController.swift
│
├─ Supporting/
│  ├─ Constants/
│  │  └─ AppConstants.swift
│  └─ Coordination/
│     └─ Coordinator.swift
│
└─ Tests/
   ├─ Unit/
   │  ├─ ChatViewModelTests.swift
   │  ├─ SendMessageUseCaseTests.swift
   │  └─ ManageGoalsUseCaseTests.swift
   └─ UI/
      └─ ChatFlowUITests.swift
```

---

## 5) Estratégia prática de modularização (sem “Big Bang”)

### Fase 1 — Reorganização física (sem mudança funcional)

- Criar a estrutura de pastas por `App`, `Core`, `Features`, `Supporting`.
- Mover arquivos preservando código atual.
- Ajustar groups no Xcode para espelhar diretórios.

### Fase 2 — Limpeza de contratos

- Renomear `AnthropicAPIClient` para `GeminiClient` (ou abstrair para `LLMClientProtocol`).
- Corrigir typos de assinatura (`lessionMode -> lessonMode`).
- Consolidar DTOs `Codable` para requests/responses.

### Fase 3 — Fortalecer domínio por feature

- Isolar entidades compartilhadas em `Core/Domain`.
- Deixar use cases e repositórios específicos dentro da feature.
- Delegar navegação 100% ao Coordinator.

### Fase 4 — Testes e qualidade

- Cobrir use cases e view models com unit tests.
- Adicionar lint/format (SwiftLint + SwiftFormat) para consistência.

---

## 6) Convenções recomendadas

1. **Naming**
   - Código em inglês (`sendMessage`, `loadGoals`, `lessonMode`).
   - Strings de UI em `Localizable.strings` (pt-BR, en).

2. **ViewModels**
   - Expor apenas estado necessário de UI.
   - Evitar lógica de navegação no VC.

3. **Coordinator**
   - Todo fluxo entre telas/feature passa pelo coordinator.

4. **Data layer**
   - Repositório orquestra datasource remoto/local.
   - DTO ≠ Entity (separar quando domínio crescer).

---

## 7) Checklist rápido para próxima sprint

- [ ] Mover pastas para `App/Core/Features/Supporting`.
- [ ] Padronizar nomes com typos e termos técnicos.
- [ ] Extrair `LLMClientProtocol` + provider explícito.
- [ ] Concluir persistência real de metas no repositório.
- [ ] Criar primeiros 3 testes de unidade (`ChatVM`, `SendMessageUseCase`, `ManageGoalsUseCase`).

---

## 8) Conclusão

Seu app já está em um ponto excelente para escalar. Você não precisa reescrever tudo: apenas consolidar organização por módulos e fortalecer contratos. Com isso, MVVM-C fica sustentável a médio/longo prazo e pronto para novas features (ex.: trilhas de estudo, gamificação, histórico offline e múltiplos providers de IA).

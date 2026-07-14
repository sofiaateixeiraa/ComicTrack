# ComicTrack

Projeto Final da unidade curricular **Projeto de Aplicações Móveis**  
CTeSP Desenvolvimento de Software - ISTEC  
Ano Letivo 2025/2026  
Docente Carlos Alves

---

## Grupo

| Nome               | Número  |
| ------------------ | ------- |
| Sofia Teixeira     | 2025013 |
| Gonçalo Pereira    | 2024001 |
| Guilherme Teixeira | 2025146 |

---

# Descrição

Aplicação Flutter para gestão pessoal de coleções de comics (pesquisa de editoras, séries e edições e acompanhamento do estado de leitura e posse de cada edição).

## Funcionalidades

- **Autenticação** — registo/login com email e password ou Google Sign-In, verificação de email, recuperação e alteração de password, edição de perfil (nome e foto).
- **Catálogo** — pesquisa de séries, listagem de editoras (publishers), séries por editora, edições (issues) por série e detalhe de cada edição, através da API [Metron](https://metron.cloud/).
- **Coleção pessoal** — para cada edição, o utilizador pode marcar:
  - **Estado de posse** (`OwnershipStatus`): não colecionado, wishlist, online, físico.
  - **Estado de leitura** (`ReadingStatus`): quero ler, a ler, lido.
  - Marcar como favorito e remover da coleção.
- **Persistência offline** — dados da coleção sincronizados com Firestore, com cache local ilimitada.

## Stack técnica

- **Flutter / Dart** (SDK `>=3.10.0 <4.0.0`)
- **Gestão de estado**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) + `riverpod_generator`
- **Navegação**: [go_router](https://pub.dev/packages/go_router)
- **Backend**: Firebase (Auth + Cloud Firestore) para autenticação e dados da coleção
- **API externa**: [Metron Comic Book Database](https://metron.cloud/) via `dio`, com autenticação Basic Auth e interceptor de rate limiting
- **Modelos imutáveis**: `freezed` + `json_serializable`
- **Programação funcional**: `fpdart` (Either/Option para tratamento de erros)
- **Testes**: `flutter_test` + `mocktail`

## Arquitetura

O projeto segue Clean Architecture organizada por _feature_ (`lib/features/`), cada uma dividida em três camadas:

```
lib/
├── app/            # router e tema globais
├── core/           # configuração (.env), erros, cliente HTTP da Metron, utilitários
└── features/
    ├── auth/         # autenticação e perfil de utilizador
    ├── catalog/      # editoras, séries e edições (dados da API Metron)
    └── collection/   # coleção pessoal do utilizador (Firestore)
        ├── data/         # datasources, models, repositories
        ├── domain/       # entities, repositories, usecases
        └── presentation/ # providers, screens, widgets
```

## Configuração do ambiente

A app requer credenciais da API Metron. Crie um ficheiro `.env` na raiz do projeto:

```
METRON_USERNAME=o_teu_username
METRON_PASSWORD=a_tua_password
```

Alternativamente, pode passar as credenciais via `--dart-define`:

```bash
flutter run --dart-define=METRON_USERNAME=... --dart-define=METRON_PASSWORD=...
```

É também necessário configurar o Firebase para o projeto (`firebase_options.dart` gerado via [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup)).

## Como correr o projeto

```bash
flutter pub get
flutter run
```

### Correr os testes

```bash
flutter test
```

<div align="center">

# Universal Project Starter

**Мульти-стековый скелет проекта, автоматика которого действительно работает —
и никогда не врёт о результате.**

[![CI](https://github.com/MuhammadaminPulatov/starter/actions/workflows/ci.yml/badge.svg)](https://github.com/MuhammadaminPulatov/starter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Template](https://img.shields.io/badge/GitHub-template-blue.svg)](https://github.com/MuhammadaminPulatov/starter/generate)
[![Languages](https://img.shields.io/badge/docs-EN%20%7C%20UZ%20%7C%20RU-orange.svg)](#документация)

[English](README.md) · [Oʻzbekcha](README.uz.md) · **Русский**

</div>

---

Большинство шаблонов выдают пустые папки и CI, который выполняет
`echo "настроите позже"`. Каждый pull request зелёный, и эта зелень ничего не
значит. Здесь всё построено наоборот: ничего не считается выполненным, если оно
не выполнялось, и вся автоматика подстраивается под те стеки, которые вы
оставили.

## Зачем этот шаблон

| | Что вы получаете |
| --- | --- |
| **Никакой ложной зелени** | `make lint` в пустом репозитории пишет *«нечего выполнять — 10 каталогов пропущено»* и возвращает 0. Он никогда не выдаёт несделанную работу за успех. |
| **Удаляйте лишнее** | Уберите `apps/mobile` или `services/api-python` — всё продолжит работать. Автоматика основана на обнаружении манифестов, без жёстко прописанных путей. |
| **Осмысленный CI с первого дня** | Задача `structure` проверяет ссылки в документации, соответствие `.env`, гигиену секретов и корректность YAML — реальная работа ещё до первой строки кода. |
| **Многоязычные инструменты** | Вывод скриптов на английском, узбекском и русском через `STARTER_LANG`. |
| **Готов к AI-агентам** | `AGENTS.md` + `CLAUDE.md` + `PROJECT_INDEX.md` дают агентам настоящий контракт и карту вместо догадок. |
| **Одна команда здоровья** | `make doctor` находит битые ссылки, расхождения в `.env`, забытые секреты в `.env.example`, некорректный YAML и неисполняемые скрипты. |

## Быстрый старт

Нажмите **[Use this template](https://github.com/MuhammadaminPulatov/starter/generate)**
(или склонируйте репозиторий), затем:

```bash
./scripts/init-project.sh   # имя, выбор стеков, .env, git init
make setup                  # установка зависимостей
make dev                    # запуск локальной инфраструктуры
make doctor                 # проверка, что всё на месте
```

`make help` покажет все команды. Дальше опишите проект в
[`docs/00-overview.md`](docs/00-overview.md).

> Сначала попробуйте `./scripts/init-project.sh --dry-run` — он покажет, что
> именно изменится, не трогая ни одного файла.

## Как это выглядит

```console
$ STARTER_LANG=ru make lint
 skip apps/bot: манифест не найден (package.json / pyproject.toml / go.mod)
==> apps/web: npm run lint
  ok apps/web
==> services/api-python: uv run --with ruff ruff check .
  ok services/api-python

  ok lint: 2 успешно, 8 пропущено (из 10 каталогов)
```

```console
$ STARTER_LANG=ru make doctor
==> Внутренние ссылки в документации
  ok проверено ссылок: 149, битых нет
==> Переменные окружения
  ok ключи .env и .env.example совпадают
==> Гигиена секретов
  ok Открытых секретов не найдено
==> Файлы YAML
  ok файлов YAML корректно: 5 (проверено через python3)
==> Обнаруженные стеки
  ok apps/web → node
  ok services/api-python → python

  ok Всё в порядке
```

## Поддерживаемые стеки

Определение целиком опирается на файл манифеста в каталоге:

| Манифест | Стек | lint | test | build |
| --- | --- | --- | --- | --- |
| `package.json` | Node / TypeScript | `<pm> run lint` | `<pm> run test` | `<pm> run build` |
| `pyproject.toml` | Python | `ruff check` | `pytest` | — |
| `go.mod` | Go | `go vet ./...` | `go test ./...` | `go build ./...` |
| `Cargo.toml` | Rust | `cargo clippy` | `cargo test` | `cargo build` |
| `pubspec.yaml` | Dart / Flutter | `flutter analyze` | `flutter test` | — |

Менеджер пакетов для Node определяется по lock-файлу — pnpm, yarn, bun или npm.
Добавить свой стек — это одна функция в [`scripts/run.sh`](scripts/run.sh).

## Структура

```
apps/          пользовательские приложения    (web, mobile, bot)
services/      API и фоновые задачи           (api-node, api-python, worker)
packages/      общий переиспользуемый код     (ui, types, sdk, config)
docs/          документация, ADR, руководства, runbook
infrastructure/ docker, nginx, terraform, мониторинг, база данных
design/        ссылки на figma, бренд, экспортированные ассеты
scripts/       setup, run, doctor, init-project + каталоги переводов
```

Каждый каталог внутри `apps/` и `services/` **необязателен** и содержит свой
`README.md`: что туда кладут, как начать и почему удаление ничего не сломает.

## Команды

| Команда | Что делает |
| --- | --- |
| `make setup` | Создаёт `.env` и ставит зависимости |
| `make dev` | Поднимает postgres |
| `make dev-queue` | Postgres и redis (для воркера) |
| `make lint` / `test` / `build` | Выполняет задачу для каждого найденного стека |
| `make doctor` | Проверяет здоровье репозитория |
| `make down` / `logs` / `ps` | Управление контейнерами |
| `make clean` | Удаляет контейнеры и тома (со спросом) |

## Язык

Вывод скриптов выбирается по `STARTER_LANG`, иначе по системной локали, с
откатом на английский:

```bash
STARTER_LANG=ru make doctor
STARTER_LANG=uz make lint
```

Каталоги лежат в [`scripts/lang/`](scripts/lang/). Чтобы добавить язык,
скопируйте `en.sh` и переведите значения — см.
[CONTRIBUTING.ru.md](CONTRIBUTING.ru.md).

## Документация

| Тема | English | Oʻzbekcha | Русский |
| --- | --- | --- | --- |
| Обзор | [README.md](README.md) | [README.uz.md](README.uz.md) | [README.ru.md](README.ru.md) |
| Начало работы | [guide](docs/guides/01-getting-started.md) | [qoʻllanma](docs/guides/01-getting-started.uz.md) | [руководство](docs/guides/01-getting-started.ru.md) |
| Как участвовать | [CONTRIBUTING.md](CONTRIBUTING.md) | [CONTRIBUTING.uz.md](CONTRIBUTING.uz.md) | [CONTRIBUTING.ru.md](CONTRIBUTING.ru.md) |

Справочная документация ведётся на английском:
[карта проекта](PROJECT_INDEX.md) ·
[архитектура](docs/02-architecture.md) ·
[правила API](docs/03-api.md) ·
[деплой](docs/05-deployment.md) ·
[runbook](docs/operations/runbook.md) ·
[правила для агентов](AGENTS.md)

## Участие

Issue и pull request приветствуются — включая исправления переводов.
См. [CONTRIBUTING.ru.md](CONTRIBUTING.ru.md); об уязвимостях —
[SECURITY.md](SECURITY.md).

## Лицензия

[MIT](LICENSE) — используйте, меняйте, выпускайте.

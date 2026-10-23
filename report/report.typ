#show link: underline

#set document(
  title: [ЛР6],
)

// #set heading(numbering: "1.")

#let img(imagePath, caption, supplement: [Рисунок], width: 100%) = {
  align(center)[
    #figure(image(imagePath, width: width), caption: caption, supplement: supplement)
  ]
}


#set page(
  paper: "a4",
  numbering: "1",
)

#set par(
  justify: true,
  first-line-indent: (
    amount: 1.25cm,
    all: true,
  ),
  spacing: 0.65em,
)

#set text(
  lang: "ru",
  font: "Times New Roman",
  size: 14pt,
)

#set page(footer: context {
  if counter(page).get().first() > 1 [
    #align(center)[
      #counter(page).display("1")
    ]
  ]
  if counter(page).get().first() == 1 [
    #align(center)[
      Санкт-Петербург \ 2026
    ]
  ]
})

#set page(header: context {
  if counter(page).get().first() == 1 [
    #align(center)[
      *Министерство науки и высшего образования Российской Федерации* \
    ]
  ]
})

#show raw: set text(font: "Consolas")
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)

// title

#align(center)[
  ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ
]

#align(center)[
  #text(size: 12pt)[
    \ *НАЦИОНАЛЬНЫЙ ИССЛЕДОВАТЕЛЬСКИЙ УНИВЕРСИТЕТ ИТМО*
  ]
]

#align(center)[
  \ *ITMO University*
]


#for _ in range(5) { linebreak() }

#align(center)[*ЛАБОРАТОРНАЯ 6*]

#table(
  stroke: white,
  columns: 1,
  inset: 10pt,

  [*По дисциплине* Контейнеризация и оркестрация приложений],
  [*Тема работы* Kubernetes на двух машинах и CI/CD: автоматическая сборка образа и выкатка в кластер],
  [*Обучающийся* Дощенников Никита Андреевич],
  [*Факультет* Прикладной информатики],
  [*Группа* К3321],
  [*Направление подготовки* 11.03.02 Инфокоммуникационные технологии и системы связи],
  [*Образовательная программа* Программирование в инфокоммуникационных системах],
  [],
)

#table(
  stroke: white,
  columns: 4,
  inset: 10pt,

  table.cell(align: top)[*Обучающийся*],

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 11pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt)[Дощенников Н.А.]],
    [#line(length: 100pt)],
  ),

  [],
  table.cell(align: center)[#text(size: 10pt)[(дата)]],
  table.cell(align: center)[#text(size: 10pt)[(подпись)]],
  table.cell(align: center)[#text(size: 10pt)[(Ф.И.О.)]],

  table.cell(align: top)[*Руководитель*],

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 11pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt)[Аминов Н.С.]],
    [#line(length: 100pt)],
  ),

  [],
  table.cell(align: center)[#text(size: 10pt)[(дата)]],
  table.cell(align: center)[#text(size: 10pt)[(подпись)]],
  table.cell(align: center)[#text(size: 10pt)[(Ф.И.О.)]],
)


#pagebreak()

#outline(title: [Содержание])

#pagebreak()
= Персональные параметры

#align(center)[
  #figure(
    table(
      columns: 2,
      inset: 10pt,
      align: horizon + center,
      fill: (x, y) => if (y == 0) { gray },
      table.header([*Параметр*], [*Значение*]),
      [Номер ИСУ], [_465797_],
      [Персональный префикс], [_doschennikov_],
      [NodePort приложения], [_#(30000 + 97)_],
      [Секретный ключ], [_secret97doschennikov_],
      [Имя базы данных], [_doschennikov97_],
      [Напарник], [_this_],
    ),
    caption: [Персональные параметры],
  )
]

#pagebreak()
= Схема сети

Вместо двух физических машин я использовал две виртуальные машины Ubuntu Server 24.04 в virt-manager. Обе ВМ подключены к виртуальной сети `default`. Внутри сети `192.168.122.0/24` ВМ видят друг друга и хост.

#align(center)[
  #figure(
    table(
      columns: 4,
      inset: 8pt,
      align: horizon + center,
      fill: (x, y) => if (y == 0) { gray },
      table.header([*Узел*], [*Имя*], [*IP-адрес*], [*Роль*]),
      [Хост], [`virbr0`], [192.168.122.1], [гипервизор, git, браузер],
      [ВМ №1], [`doschennikov-master`], [192.168.122.46], [control plane, метка `role=db`],
      [ВМ №2], [`doschennikov-worker`], [192.168.122.217], [worker, метка `role=app`],
    ),
    caption: [Узлы кластера],
  )
]

Сеть `default` в libvirt была неактивна, поэтому я её запустил и включил автозапуск:

```sh
sudo virsh net-list --all
sudo virsh net-start default
sudo virsh net-autostart default
ip -4 addr show virbr0
```

#img("assets/1.png", [Сеть `default` до запуска], width: 70%)

#img("assets/2.png", [Запуск сети `default` и автозапуск], width: 70%)

#img("assets/3.png", [Адрес моста `virbr0`: 192.168.122.1/24])

#img("assets/4.png", [`hostnamectl` на master], width: 80%)

#img("assets/5.png", [`hostnamectl` на worker], width: 80%)

#pagebreak()
= Этап 1. Кластер из двух узлов

== Установка k3s server на master

На первой машине я поставил k3s server, явно указав имя узла и его IP:

```sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-name doschennikov-master --node-ip 192.168.122.46 --tls-san 192.168.122.46" sh -
sudo k3s kubectl get nodes -o wide
sudo cat /var/lib/rancher/k3s/server/node-token
```

#img("assets/6.png", [Установка k3s server на master])

#img("assets/7.png", [Узел master в состоянии Ready])

Токен из `node-token` нужен только для присоединения worker.

== Присоединение worker

На второй машине я установил k3s agent, указав адрес API-сервера master и токен:

```sh
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.122.46:6443 K3S_TOKEN='<k3s_token>' INSTALL_K3S_EXEC="agent --node-name doschennikov-worker --node-ip 192.168.122.217" sh -
```

#img("assets/8.png", [Установка k3s agent на worker (токен скрыт)])

== Проверка кластера

#img("assets/9.png", [Два узла Ready с разными INTERNAL-IP])

Для удобства я скопировал kubeconfig и настроил обычный `kubectl`:

```sh
mkdir -p ~/.kube && sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
export KUBECONFIG=~/.kube/config
kubectl get nodes
```

#img("assets/10.png", [Настройка kubeconfig и `kubectl get nodes`])

== Метки узлов

```sh
kubectl label node doschennikov-master role=db
kubectl label node doschennikov-worker role=app
kubectl get nodes --show-labels
```

#img("assets/11.png", [Метки `role=db` и `role=app`])

#img("assets/12.png", [Итоговое состояние узлов: IP и метки])

- Почему PostgreSQL с PersistentVolumeClaim приходится привязывать к одному узлу при storage-классе local-path?

Storage-класс `local-path` создаёт том как обычный каталог на диске конкретного узла (`/var/lib/rancher/k3s/storage/...`). Этот каталог физически существует только на одной машине и не реплицируется на другие узлы. Если под PostgreSQL запустится на другом узле, он не найдёт свои данные и получит пустой том, а сам PersistentVolume по своей привязке к узлу всё равно останется на исходной машине. Поэтому под с БД нужно закрепить за узлом, где лежат данные (в моём случае через `nodeSelector: role: db` на master). Чтобы под мог свободно переезжать между узлами, нужно сетевое хранилище, например NFS, Longhorn или Ceph.

#pagebreak()
= Этап 2. CI в GitHub Actions

== Репозиторий и ветка

Работа выполнена в репозитории #link("https://github.com/fYmious/kubernetes-intro")[github.com/fYmious/kubernetes-intro], ветка `lab-6`. Приложение лежит в каталоге `solutions/assist-py/`, манифесты в `k8s/`.

== Workflow `.github/workflows/ci.yml`

```yaml
name: ci

on:
  push:
    branches: [main, lab-6]
  workflow_dispatch:

permissions:
  contents: read
  packages: write

env:
  IMAGE: ghcr.io/${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: solutions/assist-py
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - name: Install dependencies
        run: pip install --no-cache-dir -r requirements.txt
      - name: Syntax check
        run: python -m compileall app

  build-and-push:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-qemu-action@v3
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.IMAGE }}
          tags: |
            type=sha,format=short
            type=raw,value=latest
      - uses: docker/build-push-action@v6
        with:
          context: ./solutions/assist-py
          platforms: linux/amd64,linux/arm64
          push: true
          tags: ${{ steps.meta.outputs.tags }}
```

Job `test` ставит зависимости и проверяет синтаксис кода. Job `build-and-push` запускается только после успешного `test` (`needs: test`), собирает образ под `linux/amd64` и `linux/arm64` и публикует его в GHCR с тегами `latest` и коротким SHA коммита.

== Запуск пайплайна

```sh
git add .github/workflows/ci.yml
git commit -m "lab6: add CI"
git push -u origin lab-6
```

#img("assets/13.png", [Первый запуск пайплайна (`lab6: add CI`): job `test` пройден, идёт сборка образа])

Ссылка на вкладку Actions: #link("https://github.com/fYmious/kubernetes-intro/actions"). Успешный запуск после изменения приложения (`lab6: update greeting message`, коммит `a1a8834`), оба job зелёные:

#img("assets/27.png", [Успешный запуск CI: оба job зелёные])

== Публичный образ

Я сменил видимость пакета на Public и проверил, что образ скачивается без авторизации:

```sh
sudo k3s crictl pull ghcr.io/fymious/kubernetes-intro:latest
```

#img("assets/17.png", [Пакет в GHCR: Public, теги `latest` и `sha-e266b70`])

#img("assets/15.png", [Скачивание образа без авторизации на master])

#pagebreak()
= Этап 3. Развёртывание на двух узлах

== Изменения в манифестах

В `k8s/app-deployment.yaml` я переименовал Deployment и метки с префиксом `doschennikov`, указал образ из GHCR с тегом-SHA, поставил `replicas: 4` и добавил `topologySpreadConstraints`, чтобы поды разошлись по обоим узлам. `nodeSelector` для приложения не использовал:

```yaml
spec:
  replicas: 4
  selector:
    matchLabels:
      app: doschennikov-app
  template:
    metadata:
      labels:
        app: doschennikov-app
    spec:
      enableServiceLinks: false
      topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: kubernetes.io/hostname
          whenUnsatisfiable: DoNotSchedule
          labelSelector:
            matchLabels:
              app: doschennikov-app
      containers:
        - name: app
          image: ghcr.io/fymious/kubernetes-intro:sha-e266b70
          ports:
            - containerPort: 5527
```

Остальная часть шаблона осталась такой же, как в ЛР №5. Приложение слушает порт 5527.

В `k8s/app-service.yaml` я задал свой NodePort:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: doschennikov-app
spec:
  type: NodePort
  selector:
    app: doschennikov-app
  ports:
    - port: 5527
      targetPort: 5527
      nodePort: 30097
```

В `k8s/postgres-deployment.yaml` БД закреплена за master:

```yaml
    spec:
      enableServiceLinks: false
      nodeSelector:
        role: db
```

В `k8s/app-configmap.yaml` установлены `APP_OWNER: "doschennikov"` и `POSTGRES_DB: "doschennikov97"`.

== Применение манифестов

```sh
git clone -b lab-6 https://github.com/fYmious/kubernetes-intro.git
cd kubernetes-intro
kubectl apply -f k8s/
kubectl get pods -o wide
```

#img("assets/18.png", [`kubectl apply -f k8s/` и начальный запуск подов])

#img("assets/19.png", [Все поды Running: приложение на master и worker, postgres на master])

Поды приложения распределились по два на каждый узел, `postgres` стоит на master (по `nodeSelector`), `redis` попал на worker.

== Доступ с обеих машин

NodePort открыт на каждом узле кластера, поэтому приложение отвечает и по адресу master, и по адресу worker:

```sh
curl http://192.168.122.46:30097/
curl http://192.168.122.217:30097/
curl http://192.168.122.46:30097/health
```

#img("assets/20.png", [Ответы `GET /` через оба узла и `GET /health`])

== Балансировка

```sh
for i in $(seq 1 10); do curl -s http://192.168.122.217:30097/; echo; done
```

#img("assets/21.png", [Разные значения `hostname` в ответах: запросы распределяются по подам])

В ответах встречаются разные имена подов, то есть Service балансирует запросы между подами на двух узлах.

== Кэш и база данных

```sh
curl http://192.168.122.46:30097/weather/Moscow
curl http://192.168.122.217:30097/weather/Moscow
```

#img("assets/22.png", [Первый запрос `"source": "api"`, второй `"source": "cache"`])

Заметка создаётся через master и читается через worker, то есть запрос попадает на другой узел, а данные берутся из общей БД:

```sh
curl -X POST http://192.168.122.46:30097/notes -H "Content-Type: application/json" -d '{"text":"lab6 note from master doschennikov"}'
curl http://192.168.122.217:30097/notes
```

#img("assets/24.png", [`POST /notes` через master])

#img("assets/25.png", [`GET /notes` через worker: заметка на месте])

== Проверка APP_OWNER

Значение `APP_OWNER` приходит через ConfigMap и содержит мою фамилию:

```sh
kubectl get configmap app-config -o yaml | grep APP_OWNER
```

#img("assets/23.png", [`APP_OWNER` в ConfigMap и ответ `GET /`])

#pagebreak()
= Этап 4. Простой CD: обновление приложения

== Изменение приложения

Я изменил в `GET /` текст приветствия (`v2 (lab6 rolling update)`) и версию (`3.1`), сделал коммит `lab6: update greeting message` и отправил его в `lab-6`. Пайплайн отработал успешно (см. запуск CI выше), новый образ получил тег `sha-a1a8834`.

== Rolling update

```sh
kubectl get deployment doschennikov-app -o jsonpath='{.spec.template.spec.containers[*].name}'
kubectl set image deployment/doschennikov-app app=ghcr.io/fymious/kubernetes-intro:sha-a1a8834
kubectl rollout status deployment/doschennikov-app
kubectl get pods -o wide
```

Имя контейнера в манифесте `app`. Во время обновления в соседнем терминале я наблюдал за подами (`kubectl get pods -o wide -w`). Kubernetes создаёт новые поды и постепенно удаляет старые, не останавливая сервис целиком.

#img("assets/28.png", [Наблюдение за подами: новые поды создаются, старые переходят в Terminating])

#img("assets/29.png", [`kubectl set image` и ход `rollout status`])

#img("assets/30.png", [Обновление завершено: `successfully rolled out`, новые поды Running])

После обновления приложение отвечает новым текстом:

#img("assets/31.png", [`GET /` возвращает `v2 (lab6 rolling update)` и версию 3.1])

== История и откат

```sh
kubectl rollout history deployment/doschennikov-app
kubectl rollout undo deployment/doschennikov-app
kubectl rollout status deployment/doschennikov-app
curl http://192.168.122.46:30097/
```

#img("assets/32.png", [`rollout history` (ревизии 1 и 2) и `rollout undo`])

#img("assets/33.png", [Откат завершён, в ответе снова старое приветствие и версия 3.0])

Для финального состояния я снова выкатил версию `sha-a1a8834`:

#img("assets/34.png", [Повторная выкатка `sha-a1a8834`: в ответе снова `v2 (lab6 rolling update)`])

- Почему в манифесте для production лучше использовать тег с SHA (или digest), а не latest?

Тег `latest` изменяемый, он указывает на разные образы в разные моменты времени, и по манифесту невозможно понять, какая именно версия работает. Если под перезапустится на другом узле, он может скачать уже новый образ, а узлы с закэшированным образом останутся на старом, и версии в кластере разойдутся. Откат тоже теряет смысл, потому что "предыдущий `latest`" нигде не зафиксирован. Тег с SHA коммита неизменяемо привязан к конкретной сборке: деплой воспроизводим, `kubectl rollout undo` возвращает именно прошлую версию, а версию в кластере можно сопоставить с кодом в Git.

- манифест в Git соответствует кластеру

Я обновил тег в `k8s/app-deployment.yaml` отдельным коммитом, затем на master выполнил `git pull` и `kubectl apply -f k8s/`:

```sh
sed -i 's|kubernetes-intro:sha-e266b70|kubernetes-intro:sha-a1a8834|' k8s/app-deployment.yaml
git add k8s/app-deployment.yaml
git commit -m "lab6: bump image tag to sha-a1a8834"
git push
```

#img("assets/35.png", [Коммит с новым тегом образа в манифесте], width: 85%)

#img("assets/36.png", [`git pull`, `kubectl apply -f k8s/` и образ в кластере `sha-a1a8834`])

Образ в Deployment совпадает с тегом в манифесте из Git. Для `doschennikov-app` `apply` вывел `configured`, а не `unchanged`: после ручных `set image` и `rollout undo` аннотация `last-applied-configuration` отличалась от файла, и `apply` её обновил. Остальные ресурсы остались `unchanged`.

#pagebreak()
= Этап 5. Отказоустойчивость и финальный артефакт

== Отключение worker

Я отключил worker при помощи

```sh
sudo systemctl stop k3s-agent
```

и через некоторое время статус worker стал `NotReady`. Затем я вернул worker обратно:

```sh
sudo systemctl start k3s-agent
```

== Финальный артефакт

Финальная команда выполнена на master, когда оба узла были Ready, поды работали на обоих узлах, а в Deployment стоял образ с тегом-SHA:

#img("assets/38.png", [Финальный артефакт ЛР6])

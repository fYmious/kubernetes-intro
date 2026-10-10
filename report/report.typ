#show link: underline

#set document(
  title: [ЛР5],
)

#set heading(numbering: "1.")

#let img(imagePath, caption, supplement: [Рисунок]) = {
  align(center)[
    #figure(image(imagePath), caption: caption, supplement: supplement)
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

#align(center)[*ЛАБОРАТОРНАЯ 5*]

#table(
  stroke: white,
  columns: 1,
  inset: 10pt,

  [*По дисциплине* Контейнеризация и оркестрация приложений],
  [*Тема работы* Введение в Kubernetes],
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
      [Персональный порт (app)], [_#(5430 + 97)_],
      [Персональный порт (Redis)], [_#(6370 + 97)_],
      [Персональный префикс], [_doschennikov_],
      [Секретный ключ], [_secret97doschennikov_],
      [Имя базы данных], [_doschennikov97_],
    ),
    caption: [Персональные параметры],
  )
]

#pagebreak()
= Задание 1. Подготовка образа

Я загрузил образ напрямую в minikube:

```sh
minikube image load doschennikov-app:1.0
```

#img("assets/1.png", [Загрузка образа в minikube])

= Задание 2. Развертывание базы данных и кэша

Я создал манифесты Kubernetes для PostgreSQL и Redis:

- `k8s/redis-service.yaml`:

  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: redis
  spec:
    type: ClusterIP
    selector:
      app: redis
    ports:
      - port: 6379
        targetPort: 6379
  ```

- `k8s/redis-deployment.yaml`:

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: redis
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: redis
    template:
      metadata:
        labels:
          app: redis
      spec:
        enableServiceLinks: false
        containers:
          - name: redis
            image: redis:7-alpine
            ports:
              - containerPort: 6379
            readinessProbe:
              exec:
                command: ["redis-cli", "ping"]
              periodSeconds: 5
  ```

- `k8s/postgres-service.yaml`:

  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: postgres
  spec:
    type: ClusterIP
    selector:
      app: postgres
    ports:
      - port: 5432
        targetPort: 5432
  ```

- `k8s/postgres-pvc.yaml`:

  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: postgres-pvc
  spec:
    accessModes: [ReadWriteOnce]
    resources:
      requests:
        storage: 1Gi
  ```

- `k8s/postgres-deployment.yaml`:

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: postgres
  spec:
    replicas: 1
    strategy:
      type: Recreate
    selector:
      matchLabels:
        app: postgres
    template:
      metadata:
        labels:
          app: postgres
      spec:
        enableServiceLinks: false
        containers:
          - name: postgres
            image: postgres:15
            ports:
              - containerPort: 5432
            env:
              - name: POSTGRES_USER
                valueFrom:
                  configMapKeyRef:
                    name: app-config
                    key: POSTGRES_USER
              - name: POSTGRES_DB
                valueFrom:
                  configMapKeyRef:
                    name: app-config
                    key: POSTGRES_DB
              - name: POSTGRES_PASSWORD
                valueFrom:
                  secretKeyRef:
                    name: app-secret
                    key: POSTGRES_PASSWORD
              - name: PGDATA
                value: /var/lib/postgresql/data/pgdata
            readinessProbe:
              exec:
                command: ["sh", "-c", "pg_isready -U $POSTGRES_USER -d $POSTGRES_DB"]
              initialDelaySeconds: 5
              periodSeconds: 5
            volumeMounts:
              - name: data
                mountPath: /var/lib/postgresql/data
        volumes:
          - name: data
            persistentVolumeClaim:
              claimName: postgres-pvc
  ```

- `k8s/app-secret.yaml`:

  ```yaml
    apiVersion: v1
  kind: Secret
  metadata:
    name: app-secret
  type: Opaque
  stringData:
    APP_SECRET: "secret97doschennikov"
    POSTGRES_PASSWORD: "pgpass_465797"
  ```

- `k8s/app-configmap.yaml`:

  ```yaml
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: app-config
  data:
    APP_OWNER: "doschennikov"
    CACHE_TTL: "120"
    REDIS_URL: "redis://redis:6379/0"
    POSTGRES_HOST: "postgres"
    POSTGRES_PORT: "5432"
    POSTGRES_USER: "user_465797"
    POSTGRES_DB: "assistant_465797"
  ```

= Задание 3. Развертывание приложения

Я создал манифесты для FastAPI-приложения:

- `k8s/app-deployment.yaml`:

  ```yaml
    apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: app
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: app
    template:
      metadata:
        labels:
          app: app
      spec:
        enableServiceLinks: false
        initContainers:
          - name: wait-for-db
            image: postgres:15
            command: ["sh", "-c", "until pg_isready -h postgres -p 5432; do echo waiting for db; sleep 2; done"]
        containers:
          - name: app
            image: doschennikov-app:1.0
            imagePullPolicy: IfNotPresent
            ports:
              - containerPort: 5527
            envFrom:
              - configMapRef:
                  name: app-config
              - secretRef:
                  name: app-secret
            readinessProbe:
              httpGet:
                path: /health
                port: 5527
              initialDelaySeconds: 5
              periodSeconds: 5
  ```

- `k8s/app-service.yaml`:

  ```yaml
    apiVersion: v1
  kind: Service
  metadata:
    name: app
  spec:
    type: NodePort
    selector:
      app: app
    ports:
      - port: 5527
        targetPort: 5527
        nodePort: 30527
  ```

#pagebreak()
= Задание 4. Проверка

Я убедился, что приложение работает корректно. Для этого я посмотрел все ресурсы в неймспэйсе:

```sh
kubectl apply -f k8s/
kubectl get pods -w

kubectl get all
```

#img("assets/2.png", [Ресурсы])

Также я посмотрел логи пода приложения:

```sh
kubectl logs deploy/app
```

#img("assets/3.png", [Логи пода приложения])

Затем я открыл приложение:

```sh
minikube service app --url
```

#img("assets/4.png", [Адрес приложения])

Затем я проверил все эндпоинты:

#img("assets/5.png", [Проверка эндпоинтов])

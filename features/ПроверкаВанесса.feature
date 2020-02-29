# language: ru

Функционал: Проверка запуска и работы vanessa behavior
	Как Разработчик/Инженер по тестированию
	Я Хочу иметь возможность автоматической проверки запуска Ванессы
    Чтобы удостовериться в качестве подготовленной конфигурации

Контекст:
    Дано я подготовил репозиторий и рабочий каталог проекта
    И я подготовил рабочую базу проекта "./build/ib" по умолчанию
    И Я копирую каталог "feature" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога
    И Я создаю каталог "build/feature" в рабочем каталоге
    И Я копирую файл "vb-conf.json" из каталога "tests/fixtures/feature" проекта в подкаталог "build/" рабочего каталога
    И Я копирую файл "env.json" из каталога "tests/fixtures/feature" проекта в подкаталог "build/" рабочего каталога
    Допустим файл "build/env.json" существует
    И файл "build/vb-conf.json" существует
    И Я очищаю параметры команды "oscript" в контексте

Сценарий: Запуск проверки поведения с паузой
    И Я создаю файл "build/feature/пауза.feature" с текстом
    """
        # language: ru
        Функционал: Сделать паузу в указанное число секунд

        Сценарий: Пауза
            Когда Пауза 1
    """

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os vanessa" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--vanessasettings ./vb-conf.json" для команды "oscript"
    И Я добавляю параметр "--workspace ./build" для команды "oscript"
    И Я добавляю параметр "--path build/feature" для команды "oscript"
    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    Тогда Вывод команды "oscript" содержит
    | Сценарий: Пауза |
    | Все фичи/сценарии выполнены! |
    | Тестирование поведения завершено |
    И Вывод команды "oscript" не содержит
    | Фичи загружены |
    | Работаю по сценарию: |
    | Выполнение сценариев закончено. Ошибок не было |

    И Код возврата команды "oscript" равен 0

Сценарий: Запуск тестирования сценария с нереализованным шагом
    И Я создаю файл "build/feature/Сценарий с нереализованным шагом.feature" с текстом
    """
        # language: ru
        Функционал: Выполнение несуществующего шага

        Сценарий: Выполнение несуществующего шага
            Когда я выполняю несуществующий шаг
    """

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os vanessa" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--vanessasettings ./vb-conf.json" для команды "oscript"
    И Я добавляю параметр "--workspace ./build" для команды "oscript"
    И Я добавляю параметр "--path build/feature" для команды "oscript"
    Когда Я выполняю команду "oscript"
    Тогда Вывод команды "oscript" содержит
    | Сценарий: Выполнение несуществующего шага |
    | Пустой адрес снипета у шага: Когда я выполняю несуществующий шаг |
    | Все фичи/сценарии выполнены! |
    | Тестирование поведения завершено |
    И Вывод команды "oscript" не содержит
    | Фичи загружены |
    | Работаю по сценарию: |
    | Выполнение сценариев закончено. Ошибок не было |

    И Код возврата команды "oscript" равен 0
    # И Код возврата команды "oscript" равен 2

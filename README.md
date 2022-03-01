# ripper-wrapper
1. Можна запускати без параметрів (для першого запуску) - автоматом ставить `runmode=install і amount=50`
2. Додано параметр для конфігурування кількості контейнкрів - наприклад `/bin/bash os_x_ripper.sh -n 10`

## Windows
1. Поставити докер
2. Закинути скрит по папки windows_ripper.ps1
3. Відкрити консоль та зайту и папку зі скриптом
4. Запустити скрипт `powershell -ExecutionPolicy Bypass .\windows_ripper.ps1 -Action install -Number 10`
5. Запуск без параметрів покаже довідку `powershell -ExecutionPolicy Bypass .\windows_ripper.ps1`

## Актуальні команди:
1. Перший запуск:  
   `/bin/bash os_x_ripper.sh -n 10`  
   число можна не ставити якщо потужна машина
2. Апдейт існуючого:  
   `/bin/bash os_x_ripper.sh -m reinstall -n 10`  
   теж можна міняти кількість контейнерів якщо відчуваєте що машина тупить
3. Зупинка атаки:  
   `/bin/bash os_x_ripper.sh -m stop`  
   наприклад якщо треба подзвонити кудись з відео
4. Продовження атаки:
   `/bin/bash os_x_ripper.sh -m start`

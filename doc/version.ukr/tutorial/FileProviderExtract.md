# Файлові операції в віртуальній файловій системі

Як створити файлову систему в оперативній пам'яті та працювати з нею. Виконання синхронних і асинхронних файлових операцій.

Для багатьох операцій з файлами важлива швидкість їх обробки. Загальновідомо, що швидкість роботи з жорсткими дисками, в тому числі, з `SSD` дисками, набагато менша, ніж швидкість роботи з оперативною пам'яттю. Тому, модуль `Files` дозволяє створити віртуальну файлову систему в оперативній пам'яті машини та працювати з нею як з жорстким диском. За необхідності, дані з віртуальної файлової системи можна перенести на постійний накопичувач.

### Створення віртуальної файлової системи та перенесення даних на жорсткий диск

За роботу з файловою системою в оперативній пам'яті відповідає провайдер `Extract`. Провайдер виділяє деяку ділянку оперативної пам'яті необхідну для файлової системи, в котру завантажує вказану інформацію. В процесі роботи провайдера структура і об'єм зайнятої пам'яті може змінюватись.

<details>
  <summary><u>Структура модуля</u></summary>

```
files
  ├── Extract.js
  └── package.json
```

</details>

Для перевірки роботи провайдера `Extract` створіть приведену вище конфігурацію файлів.

Для роботи з провайдером потрібно встановити модуль `Files`. Тому, скопіюйте приведений нижче код в файл `package.json`.

<details>
    <summary><u>Код файла <code>package.json</code></u></summary>

```json    
{
  "dependencies": {
    "wFiles": ""
  }
}
```

</details>

Для встановлення залежностей скористуйтесь командою `npm install`. Після встановлення залежностей модуль готовий до роботи.

Провайдер `Extract` створює в оперативній пам'яті деревовидну файлову систему з одним коренем `/`, в яку додаються інші файли і директорії. При створенні файлової системи з допомогою провайдера `Extract` можна використати готовий шаблон - файлове дерево, яке буде розміщене в оперативній пам'яті. Іншим способом є створення порожньої директорії `/` та здійснення файлових операцій в середовищі провайдера за необхідності.

<details>
    <summary><u>Код файла <code>Extract.js</code></u></summary>

```js    
require( 'wFiles' );
var _ = wTools;

// files tree

var tree =
{
  'root' :
  {
    'File.js' : "console.log( 'This is content of File.js' )",
    'folder' :
    {
      'File.txt' : "This is content of File.txt",
    }
  },
  'user' :
  {
    'UserFile' : 'This is content of UserFile'
  }
};

// file provider, copy files tree to memory

var extract = _.FileProvider.Extract( { filesTree : tree } );

// asynchronous deletion of files

var filesDelete = _.timeOut( 100, function ()
{
  console.log( extract.filesTree );
  console.log( '' ); // empty string
  extract.filesDelete( '/user/' );
  console.log( extract.filesTree );
});

// asynchronous copying of files

var fileCopy = extract.fileCopy( { dstPath : '/user/File.txt', srcPath : '/root/folder/File.txt' , sync : 0  } );

// copy files to hard drive

extract.readToProvider( _.FileProvider.HardDrive(), _.path.current() );

// files tree in memory

console.log( extract.filesTree );
console.log( '' ); // empty string
```

</details>

Помістіть в файл `Extract.js` код, що приведено вище.

Для створення віртуальної файлової системи в провайдер `Extract` передано файлове дерево `tree`. Модуль дозволяє створити провайдер з порожньою кореневою директорією і потім її наповнити, або ж створити файлове дерево з існуючого в іншій файловій системі. В даному файловому дереві є дві директорії першого рівня вкладення - `root` i `user`. Директорія `root` поміщає файл `File.js` i директорію `folder`, а директорія `user` містить лише один файл `UserFile`.

Наступні процедури - асинхронне видалення файлів та асинхронне копіювання файла. Файлові операції модуля можна виконувати в асинхроному режимі, для цього використовується покращений механізм наслідку (`promise`) під назвою `consequence`. Наприклад, в операції `filesDelete` встановлено часову затримку 100 мілісекунд перед виконанням процедури, а в процедурі `fileCopy` - через стандартну затримку, яка лише додає процедуру в чергу для виконання. Встановлене значення затримки в 100 мілісекунд дозволяє модулю скопіювати файл з одніє директорії в іншу.

Окремо потрібно позначити рутину `readToProvider`, котра копіює дані з одного провайдера в інший. Рядок

```js
extract.readToProvider( _.FileProvider.HardDrive(), _.path.current() );
```

говорить, що файли з провайдеру `Extract`, будуть скопійовані в через провайдер `HardDrive`, в поточну директорію запуску модуля `_.path.current()`.


<details>
    <summary><u>Вивід команди <code>node Extract.js</code></u></summary>

```   
$ node Extract.js
{ root:
   { 'File.js': 'console.log( \'This is content of File.js\' )',
     folder: { 'File.txt': 'This is content of File.txt' } },
  user: { UserFile: 'This is content of UserFile' } }

{ root:
   { 'File.js': 'console.log( \'This is content of File.js\' )',
     folder: { 'File.txt': 'This is content of File.txt' } },
  user:
   { UserFile: 'This is content of UserFile',
     'File.txt': 'This is content of File.txt' } }

{ root:
   { 'File.js': 'console.log( \'This is content of File.js\' )',
     folder: { 'File.txt': 'This is content of File.txt' } } }
```

</details>

Введіть команду `node Extract.js`, порівняйте вивід з приведеним вище.

Згідно указаного виводу, перше файлове дерево відповідає дереву в змінній `tree`. Тобто, утиліта спочатку виконала всі синхронні дії. Другий вивід показує, що утиліта скопіювала файл `File.txt` з директорії за шляхом `/root/folder/` в директорію `/user/`. Остання секція показує стан файлів на момент завершення виконання побудови - директорія `user` видалена разом з файлами.

Перегляньте зміни в директорії модуля. Виконайте команду `ls -a` та порівняйте вивід з приведеним

<details>
    <summary><u>Вивід команди <code>node Extract.js</code></u></summary>

```   
$ ls -a
.  ..  Export.js  node_modules  package.json  package-lock.json  root  user
```

</details>

В поточну директорію модуля записано вміст віртуальної файлової системи. Якщо ви перевірите вміст скопійованих директорій то він відповідатиме такому файловому дереву

<details>
  <summary><u>Структура модуля</u></summary>

```
files
  ├── Extract.js
  ├── node_modules
  ├── package-lock.json
  ├── package.json
  ├── root
  │     ├── File.js
  │     └── folder
  │            └── File.txt
  └── user
        └── UserFile
```

</details>

Тобто, в директорію з модулем зкопійовано файли на момент створення віртуальної файлової системи. Асинхронні процедури виконані пізніше, це потрібно враховувати при використанні асинхронного режиму.

### Підсумок

- Для роботи з віртуальною файловою системою використовується провайдер `Extract`.
- Віртуальна файлова система розміщується в оперативній пам'яті.
- Провайдер дозволяє працювати з файлами в оперативній пам'яті як з файлами на жорсткому диску.
- Модуль `Files` може виконувати файлові операції в синхронному і асинхронному режимі.
- Модуль `Files` дозволяє переміщувати дані між провайдерами. Наприклад, з віртуальної файлової системи на постійний накопичувач.

[Повернутись до змісту](../README.md#Туторіали)
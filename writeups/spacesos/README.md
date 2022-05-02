# Spacesos Writeup
Есть сервис на дарте, который через `messages.dart` отправляет сообщения на сервис на php. В нём и будут все уязвимости.
## First vulnerability
Как мы получаем краши пользователя:
```dart
final resp = await http.get("${_baseUrl}/recv/?user=${user}");
```
```php 
recv.php
<?php  
  $user = $_GET['user'];  
  
  chdir("/tmp/messages");  
 echo file_get_contents(path_normalize($user)) ?? "";
```
Если в имени user будет #, то в `$_GET['user']` вернёт имя без #
Получается можно посмотреть все public crashes, нарегать юзеров с таким же именем и #xxxx на конце и мы получим краши юзеров без #xxxx
## Second vulnerability
Всё та же `recv.php`
Уязвимость в функции `path_normalize`
```php
function path_normalize($path){  
  $root = ($path[0] === '/') ? '/' : '';  
  
  $segments = preg_split('/\//', trim($path, '/'));  
  $ret = array();  
 foreach($segments as $segment){  
  if ($segment == '.') {  
  continue;  
  }  
  if ($segment == '..') {  
 array_pop($ret);  
  } else {  
 array_push($ret, $segment);  
  }  
 }  return $root . implode('/', $ret);  
}
```
Как мы видим, если username будет путь, то он вырежет все `..`, поэтому по папкам походить не получится, но можно вставить `.`, и тогда будет всё отлично.
Опять же, смотрим public crashes, регаем юзеров с именем xxxxx/./admin и смотрим краши админа.

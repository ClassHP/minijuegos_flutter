# minijuegos_flutter

Proyecto Flutter para desarrollo de juegos prácticos para aprender a programar.

## Probar en la WEB
[https://minijuegosf.web.app]

## Instalar en Android
[https://play.google.com/store/apps/details?id=com.classhp.minijuegosf]

## Lista de juegos desarrollados

- Color Box
  - Juego de agilidad en el que debes seleccionar 3 cuadros del mismo color y no dejar que se llene toda la pantalla.
- Reversi / Othello / Otelo / Yang
  - "Es un juego entre dos personas, que comparten 64 fichas iguales, de caras distintas, que se van colocando por turnos en un tablero dividido en 64 escaques. Las caras de las fichas se distinguen por su color y cada jugador tiene asignado uno de esos colores, ganando quien tenga más fichas sobre el tablero al finalizar la partida. Se clasifica como juego de tablero, abstracto y territorial; al igual que el go y las amazonas." Wikipedia
- 2048 (juego)
  - Juego numérico cuyo objetivo es deslizar baldosas en una cuadrícula para combinarlas y crear una baldosa con el número 2048
- Buscaminas / Minesweeper
  - El objetivo del juego es despejar un campo de minas sin detonar ninguna.

## Ideas de juegos por desarrollar

- Sokoban
  - "El objetivo del juego es empujar las cajas (o las bolas) hasta su lugar correcto dentro de un reducido almacén, con el número mínimo de empujes y de pasos. Las cajas se pueden empujar solamente, y no tirar de ellas, y sólo se puede empujar una caja a la vez." Wikipedia
- Sudoku
  - Juego que consiste en completar con números del 1 al 9 una cuadrícula de 81 casillas y 9 subcuadrículas , de forma que no se repita ningún número en la misma fila o columna ni en la misma subcuadrícula .

## Comandos utiles

Compilar para Android:
```
flutter build apk
flutter build appbundle
```

Compilar para Web y subir a Firebase Hosting
```
flutter build web
firebase deploy
```

Cambiar package name:
```
flutter pub run change_app_package_name:main com.dominio.nombre
```

Actualizar iconos:
```
flutter pub run flutter_launcher_icons:main
```

## Documentación Frutter

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



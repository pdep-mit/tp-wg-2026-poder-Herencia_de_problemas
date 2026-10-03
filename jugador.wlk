object jugador {
  var property position = game.center()
  method image() = "player.png"


  method subir() {
    if (position.y() < game.height() - 1) {position = position.up(1)}
  }

  method bajar() {
    if (position.y() > 0) {position = position.down(1)}
  }

  method irALaDerecha() {
    if (position.x() < game.width() -1) {position = position.right(1)}
  }
  
  method irALaIzquierda() {
    if (position.x() > 0) {position = position.left(1)}
  }
 
}

object movimiento {
    method mover(personaje,direccion){
        const posSiguiente = direccion.siguientePosicion(personaje)
        if(mapa.puedeIrA(posSiguiente,personaje)){
            personaje.position(posSiguiente)}
        else {personaje.noPudisteIrALaPosicion()}
    }
}

object derecha {
    method siguientePosicion(personaje) = personaje.position().right(1)
    method nombre() = "Derecha"
}
object izquierda {
    method siguientePosicion(personaje) = personaje.position().left(1)
    method nombre() = "Izquierda"
}
object arriba {
    method siguientePosicion(personaje) = personaje.position().up(1)
    method nombre() = "Arriba"
}
object abajo {
    method siguientePosicion(personaje) = personaje.position().down(1)
    method nombre() = "Abajo"
}
object mapa {
    method puedeIrA(pos,personaje) =
        self.estaDentroDelMapa(pos) &&
        personaje.puedeIrA(pos)

    method estaDentroDelMapa(pos) = 
        pos.y().between(0, game.height() - 1) &&
        pos.x().between(0, game.width() - 1)

}
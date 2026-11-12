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
    method opuesto() = izquierda
}
object izquierda {
    method siguientePosicion(personaje) = personaje.position().left(1)
    method nombre() = "Izquierda"
    method opuesto() = derecha
}
object arriba {
    method siguientePosicion(personaje) = personaje.position().up(1)
    method nombre() = "Arriba"
    method opuesto() = abajo
}
object abajo {
    method siguientePosicion(personaje) = personaje.position().down(1)
    method nombre() = "Abajo"
    method opuesto() = arriba 
}
object mapa {
    method puedeIrA(pos,personaje) =
        self.estaDentroDelMapa(pos) &&
        personaje.puedeIrA(pos)

    method estaDentroDelMapa(pos) = 
        pos.y().between(0, game.height() - 1) &&
        pos.x().between(0, game.width() - 1)

}
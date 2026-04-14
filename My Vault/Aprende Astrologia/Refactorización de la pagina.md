
## Objetivo
--- 
Optimizar el código para un mejor rendimiento de la la pagina, logrando que el código sea lo mas legible posible para futuros programadores


## Pasos a seguir
---
### Migración de ORM

- Migración de Sequelize a Typeorm, con el objetivo de disminuir la cantidad de servicios en la api relacionados con la base de datos, con esta migración los llamados a la base de datos se realizarían directamente desde Typeorm en los casos de uso, eliminando así la necesidad de un servicio especifico para cada tabla. Si bien este cambio va un poco en contra con lo que representa la arquitectura limpia, nos brinda una mayor agilidad en el uso de la base de datos.

### Actualización de validaciones

- Reemplazar las validaciones de formularios y casos de uso hechas en Joi por validaciones hechas a mano, el motivo principal de este cambio es debido a un bug recurrente que ocurre en la librería que impide el envió correcto de los formularios.

### Refactorización del Front End

- Refactorizar el Front End optimizando las distintas paginas aplicando el uso de componentes para disminuir el código de cada pagina, con el objetivo de mejorar el rendimiento aplicando las diferentes herramientas que provee React.

### Re - implementación de los servicios de pago

- Volver a implementar los servicios de pagos, principalmente payway, ya que sus servicios no son muy buenos y su documentación es bastante mala, no se logro una aplicación correcta en la pagina de este servicio, tiene bastantes problemas y no es para nada clara para futuros programadores. 

- Agregar una tabla de pagos rechazados y avisar por mail a felicitas con los datos del comprador

- Mensaje para mostrar en la pagina de pagos: "Si tu pago es rechazado por payway, podés hacer directamente una transferencia al alias gata.paz.palta. Y luego escribís al +5491154590832 enviando el comprobante de pago con tus datos Nombre apellido, fecha de nacimiento, hora minutos, país y ciudad para darte de alta en la plataforma.
	muchas gracias :) 
	Felicitas Cavo"

### Refactorización de casos de uso

- Mejorar el código general de todos los casos de uso del proyecto, implementando de forma correcta sus test aplicando TDD, eliminar código redundante, optimizar y mejorar la implementación de los casos de uso lo máximo posible

### Notas con sugerencias para aplicar a la refactorizacion

En los casos de uso de course content, en de vez de tener varios casos de uso del tipo toggle para cambiar un dato especifico de un course content, probar con solo tener el caso de uso del edit, en donde todos los datos van a ser opcionales menos el id, de esta forma con este caso de uso solo pasaríamos en el payload el dato que queremos actualizar, esto nos ahorra tener varios casos de usos y resumirlo todo a uno solo.

Se podria decir que esto haría que estemos actualizando todos los datos constantemente cada vez que queramos editar un dato especifico, pero es un precio a pagar muy menor comparándolo con todos los casos de uso que nos ahorraríamos al resumirlo en uno solo.



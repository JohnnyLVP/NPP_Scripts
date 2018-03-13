# Scripts de SQL 

### Estos Scripts generan la matriz de datos input para el modelo de Fuga

En la carpeta **"Scripts SQL"** existen 4 archivos .sql: 

* 1.Target:
		Obtiene el listado de las consultoras y genera el Target, en base a la campaña (Cx) que se quiere predecir.
* 2.Revision_Corte_Analisis:
		Obtiene Informacion Historica de las ultimas 18 campañas de las consultoras, extrayendo atributos de Constancia, Pase de Pedido, Actividad, Segmentos.
* 3.Venta:
		Obtiene la informacion Historica de las ultimas 18 campañas de las consultoras, extrayendo informacion de Venta total, Unidades Compradas, Unidades Faltantes, Unidades Anuladas, Oportunidad de Ahorro.
* 4.Venta MCT:
		Obtiene la Informacion Historica de las ultimas 18 campañas de las consultoras por Marca y Categoria.
* 5.Union: Se cruza la informacion generada de los scripts anteriores.
ALTER PROCEDURE KR_MATRIZ_TARG_V1 
@CodPais CHAR(2),
@AnioCampana CHAR(6)

AS
BEGIN

/*
	SP: Definicion de Target
	Creado por: Karin Rodriguez 
	Fecha Creacion: 31/07/2017

	Modificacion por: Johnny Valenzuela 
	Fecha Modificacion: 21/02/2018

	Detalles: 
		@AnioCampana --> Cx: Campaña a Predecir
		@AnioCampanamenos1 --> Cx-1
		@AnioCampanamenos2 --> Cx-2 Campaña cierre de Data

	/*
		Tiempo Inicial : 40 seg Aprox
		Tiempo Final: 6 seg Aprox
	*/

	EXEC KR_MATRIZ_TARG 'CO','201716'

*/

--declare @AnioCampana  char(6),
-- 		@CodPais CHAR(2)
--set @CodPais = 'CO'
--set @AnioCampana  = '201709'
--SET NOCOUNT ON;

declare @AnioCampanamenos1 CHAR(6),
	    @AnioCampanamenos2 CHAR(6)

set @AnioCampanamenos1 = dbo.CalculaAnioCampana(@AnioCampana, -1)
set @AnioCampanamenos2 = dbo.CalculaAnioCampana(@AnioCampana, -2)


IF OBJECT_ID('tempdb.dbo.#KR_MCC_TARGET1', 'U') IS NOT NULL
  DROP TABLE #KR_MCC_TARGET1;

SELECT
	@AnioCampana AS AnioCampanaT,
	@AnioCampanamenos1 AS AnioCampana_Desfase,
	@AnioCampanamenos2 AS AnioCampanaUC,
	@CodPais AS CodPais,
	A.PKEbelista,
	A.CodEbelista,
	A.FlagGerenteZona,
	E.DesRegion,
	E.CodRegion,
	E.CodZona,
	E.CodSeccion,
	CASE WHEN E.Desregion IN ('OFICINA','00 ADMINISTRATIVO','EMPLEADOS') THEN 1 ELSE 0 END AS FlagBelcorp,
	CASE WHEN E.Desregion IN ('99 FONO TIENDA','AREA ELIMINADA CON ESTADISTICA','<SIN DESCRIPCION>','SIN HOMOLOGAR','CASTIGADAS','JUBILADOS Y MAQUILLADORES','ATENCION PREFERENCIAL') THEN 1 ELSE 0 END AS Flaginusual
INTO #KR_MCC_TARGET1
FROM [DWH_ANALITICO].[dbo].[DWH_DEBELISTA]  A
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM] C ON A.PKEbelista = C.PKEbelista AND C.AnioCampana IS NOT NULL  AND C.CODPAIS=@CodPais 
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DSTATUS] D on C.CodStatus =D.CodStatus AND D.CODPAIS=@CodPais AND D.DesStatusCorp IN ('INGRESO','NORMALES','REINGRESO','EGRESADA')
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DGEOGRAFIACAMPANA] E on C.PkTerritorio = E.PkTerritorio AND C.CodPais = E.CodPais AND C.AnioCampana = E.AnioCampana
WHERE A.AnioCampanaIngreso <> '0' AND  A.AnioCampanaIngreso <>' ' AND A.AnioCampanaIngreso IS NOT NULL AND A.AnioCampanaPrimerPedido IS NOT NULL AND A.AnioCampanaIngreso<=@AnioCampanamenos2  
AND  A.CodPais=@CodPais AND C.AnioCampana = @AnioCampana

IF OBJECT_ID('tempdb.dbo.#Final', 'U') IS NOT NULL  DROP TABLE #Final;

;WITH TableMenos2 AS
(
	SELECT C.PKEbelista,C.FlagActiva,C.FlagPasoPedido,D.DesNivelComportamiento,E.DesStatusCorp
	from #KR_MCC_TARGET1 A
	INNER JOIN [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM] C ON A.PKEbelista = C.PKEbelista AND C.CodPais = @CodPais   
	INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DCOMPORTAMIENTOROLLING] D on C.codcomportamientorolling = D.CodComportamiento
	INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DSTATUS] E on C.CodStatus =E.CodStatus AND E.CodPais = A.CodPais   
	WHERE C.AnioCampana = @AnioCampana
	GROUP BY C.PKebelista,C.AnioCampana,C.flagactiva,C.FlagPasoPedido,D.DesNivelComportamiento,E.DesStatusCorp
), TableMenos1 AS
(
	SELECT C.PKEbelista,C.FlagActiva,C.FlagPasoPedido,D.DesNivelComportamiento,E.DesStatusCorp
	from #KR_MCC_TARGET1 A
	INNER JOIN [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM] C ON A.PKEbelista = C.PKEbelista AND C.CodPais = @CodPais   
	INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DCOMPORTAMIENTOROLLING] D on C.codcomportamientorolling = D.CodComportamiento
	INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DSTATUS] E on C.CodStatus =E.CodStatus AND E.CodPais = A.CodPais   
	WHERE C.AnioCampana = @AnioCampanamenos1 
	GROUP BY C.PKebelista,C.AnioCampana,C.flagactiva,C.FlagPasoPedido,D.DesNivelComportamiento,E.DesStatusCorp
), TableTemp AS
(
	SELECT C.PKEbelista,C.FlagActiva,C.FlagPasoPedido,D.DesNivelComportamiento,E.DesStatusCorp
	from #KR_MCC_TARGET1 A
	INNER JOIN [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM] C ON A.PKEbelista = C.PKEbelista AND C.CodPais = @CodPais   
	INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DCOMPORTAMIENTOROLLING] D on C.codcomportamientorolling = D.CodComportamiento
	INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DSTATUS] E on C.CodStatus =E.CodStatus AND E.CodPais = A.CodPais   
	WHERE C.AnioCampana = @AnioCampanamenos2 
	GROUP BY C.PKebelista,C.AnioCampana,C.flagactiva,C.FlagPasoPedido,D.DesNivelComportamiento,E.DesStatusCorp
)
SELECT A.*, B.FlagActiva as Cx2_Activa,C.FlagActiva as Cx1_Activa,D.FlagActiva as Cx_Activa,
			B.FlagPasoPedido as Cx2_PasoPedido, C.FlagPasoPedido as Cx1_PasoPedido, C.FlagPasoPedido as Cx_PasoPedido,
			B.DesNivelComportamiento as Cx2_Comp_Rolling, C.DesNivelComportamiento as Cx1_Comp_Rolling , D.DesNivelComportamiento as Cx_Comp_Rolling,
			B.DesStatusCorp as Cx2_Status, C.DesStatusCorp as Cx1_Status, D.DesStatusCorp as Cx_Status
INTO #Final
FROM #KR_MCC_TARGET1 A 
INNER JOIN TableMenos2 B ON A.PkEbelista = B.Pkebelista 
INNER JOIN TableMenos1 C ON A.Pkebelista = C.PkEbelista 
INNER JOIN TableTemp D ON A.PkEbelista = D.PkEbelista


IF OBJECT_ID('tempdb.dbo.#KR_MCC_TARGET_T1', 'U') IS NOT NULL DROP TABLE #KR_MCC_TARGET_T1;

SELECT *
INTO #KR_MCC_TARGET_T1
FROM 
(
	SELECT A.*,CASE WHEN Cx2_PasoPedido=0 THEN 1 ELSE 0 END AS [TARGET] 
	FROM #Final A
	WHERE Cx_Activa=1 AND FlagBelcorp=0 AND FlagInusual=0 
)KR


IF OBJECT_ID('tempdb.dbo.#KR_TARGET_FUGA', 'U') IS NOT NULL
  DROP TABLE #KR_TARGET_FUGA;

SELECT AnioCampanaT,AnioCampanaUC,CodPais,[Target],PKebelista,
		case when Cx_Comp_rolling = 'Nuevas' then 'Nuevas' 
				when Cx_Comp_rolling in  ('Brilla','Tops','Constantes 1','Constantes 2','Constantes 3','Inconstantes')  
				then 'Establecidas' end as Tipo,
		Cx_Status,Cx1_Status,Cx2_Status,
		Cx_Activa,Cx1_Activa,Cx2_Activa,
		Cx_Comp_Rolling,Cx1_Comp_Rolling,Cx2_Comp_Rolling,
		Cx_PasoPedido,Cx1_PasoPedido,Cx2_PasoPedido
INTO #KR_TARGET_FUGA
FROM #KR_MCC_TARGET_T1


DELETE FROM #KR_TARGET_FUGA WHERE Tipo IS NULL /*SON LAS QUE NO TIENEN SEGMENTO*/

/*En un inicio estaba el pkterritorio en el #KR_TARGET_FUGA, se quioto ya que solo se usa para cruzar*/
SELECT * FROM #KR_TARGET_FUGA

END


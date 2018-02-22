 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------ESTRUCTURA FINAL TABLA CONSULTORA-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CLOUD

---BD
use BD_ANALITICO
GO


CREATE PROCEDURE [dbo].[KR_MATRIZ_CONS]
@CodPais CHAR(2),
@AnioCampana CHAR(6)

AS

BEGIN

declare @CodPais CHAR(2),
		@AnioCampana VARCHAR(6)

set @CodPais = 'CO'
set	@AnioCampana = '201709'


declare @AnioCampanamenos1 CHAR(6),
	 @AnioCampanamenos2 CHAR(6),
	 @AnioCampanamenos3 CHAR(6),
	 @AnioCampanamenos4 CHAR(6),
	 @AnioCampanamenos5 CHAR(6),
	 @AnioCampanamenos6 CHAR(6),
	 @AnioCampanamenos7 CHAR(6),
	 @AnioCampanamenos8 CHAR(6),
	 @AnioCampanamenos9 CHAR(6),
	 @AnioCampanamenos10 CHAR(6),
	 @AnioCampanamenos11 CHAR(6),
	 @AnioCampanamenos12 CHAR(6),
	 @AnioCampanamenos13 CHAR(6),
	 @AnioCampanamenos14 CHAR(6),
	 @AnioCampanamenos15 CHAR(6),
	 @AnioCampanamenos16 CHAR(6),
	 @AnioCampanamenos17 CHAR(6),
	 @SQLString NVARCHAR(2000),
	 @SQLString2 NVARCHAR(2000)


set @AnioCampanamenos1 = dbo.CalculaAnioCampana(@AnioCampana, -1)
set @AnioCampanamenos2 = dbo.CalculaAnioCampana(@AnioCampana, -2)
set @AnioCampanamenos3 = dbo.CalculaAnioCampana(@AnioCampana, -3)
set @AnioCampanamenos4 = dbo.CalculaAnioCampana(@AnioCampana, -4)
set @AnioCampanamenos5 = dbo.CalculaAnioCampana(@AnioCampana, -5)
set @AnioCampanamenos6 = dbo.CalculaAnioCampana(@AnioCampana, -6)
set @AnioCampanamenos7 = dbo.CalculaAnioCampana(@AnioCampana, -7)
set @AnioCampanamenos8 = dbo.CalculaAnioCampana(@AnioCampana, -8)
set @AnioCampanamenos9 = dbo.CalculaAnioCampana(@AnioCampana, -9)
set @AnioCampanamenos10 = dbo.CalculaAnioCampana(@AnioCampana, -10)
set @AnioCampanamenos11 = dbo.CalculaAnioCampana(@AnioCampana, -11)
set @AnioCampanamenos12 = dbo.CalculaAnioCampana(@AnioCampana, -12)
set @AnioCampanamenos13 = dbo.CalculaAnioCampana(@AnioCampana, -13)
set @AnioCampanamenos14 = dbo.CalculaAnioCampana(@AnioCampana, -14)
set @AnioCampanamenos15 = dbo.CalculaAnioCampana(@AnioCampana, -15)
set @AnioCampanamenos16 = dbo.CalculaAnioCampana(@AnioCampana, -16)
set @AnioCampanamenos17 = dbo.CalculaAnioCampana(@AnioCampana, -17)


-------------Datos PKebelista

IF OBJECT_ID('tempdb.dbo.#KR_MCC_DATOS', 'U') IS NOT NULL
  DROP TABLE #KR_MCC_DATOS;

SELECT
	@AnioCampana AS AnioCampana,
	@CodPais AS CodPais,
	A.PKEbelista,
	C.PKTerritorio,
	Datediff(year,A.FechaNacimiento,Left(@AnioCampana,4)) as Edad,----se asumira edad por año campaña
	A.DesEstadoCivil,
	dbo.DiffAnioCampanas(@AnioCampana,A.AnioCampanaIngreso) as Ant_Camp_Ingreso,
	B.DesRegion,
	B.CodRegion,
	B.CodZona,
	B.codSeccion,
	CASE WHEN B.Desregion IN ('OFICINA','00 ADMINISTRATIVO','EMPLEADOS') THEN 1 ELSE 0 END AS FlagBelcorp,
	CASE WHEN B.Desregion IN ('99 FONO TIENDA','AREA ELIMINADA CON ESTADISTICA','<SIN DESCRIPCION>','SIN HOMOLOGAR','CASTIGADAS','JUBILADOS Y MAQUILLADORES','ATENCION PREFERENCIAL') THEN 1 ELSE 0 END AS Flaginusual
INTO #KR_MCC_DATOS
FROM [DWH_ANALITICO].[dbo].[DWH_DEBELISTA]  A
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM] C ON A.PKEbelista = C.PKEbelista AND C.AnioCampana=@AnioCampana AND C.AnioCampana IS NOT NULL  AND C.CODPAIS=@CodPais 
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DSTATUS] D on C.CodStatus =D.CodStatus AND D.CODPAIS=@CodPais AND D.DesStatusCorp IN ('INGRESO','NORMALES','REINGRESO')
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DGEOGRAFIACAMPANA] B ON C.PKTerritorio = B.PKTerritorio AND C.AnioCampana = B.AnioCampana AND C.CodPais=B.CodPais
WHERE A.AnioCampanaIngreso<>'0' AND  A.AnioCampanaIngreso<>' ' AND A.AnioCampanaIngreso IS NOT NULL AND A.AnioCampanaPrimerPedido IS NOT NULL AND A.AnioCampanaIngreso<=@AnioCampana
AND  A.CodPais=@CodPais

-------------Cruzando con Geografía para saber si es de Oficina

--IF OBJECT_ID('tempdb.dbo.##KR_MCC_DATOS1', 'U') IS NOT NULL
--  DROP TABLE ##KR_MCC_DATOS1;

--SELECT
--A.*,B.DESREGION,B.CODREGION,B.CODZONA,B.CODSECCION,
--CASE WHEN B.Desregion IN ('OFICINA','00 ADMINISTRATIVO','EMPLEADOS') THEN 1 ELSE 0 END AS FlagBelcorp,CASE WHEN B.Desregion IN ('99 FONO TIENDA','AREA ELIMINADA CON ESTADISTICA','<SIN DESCRIPCION>','SIN HOMOLOGAR','CASTIGADAS','JUBILADOS Y MAQUILLADORES','ATENCION PREFERENCIAL') THEN 1 ELSE 0 END AS Flaginusual
--INTO ##KR_MCC_DATOS1
--FROM
--##KR_MCC_DATOS A
--INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DGEOGRAFIACAMPANA] B ON A.PKTerritorio = B.PKTerritorio AND A.AnioCampana = B.AnioCampana AND A.CodPais=B.CodPais


------------Comportamiento Rolling + IP unico zona

IF OBJECT_ID('tempdb.dbo.#KR_MCC_COMP', 'U') IS NOT NULL DROP TABLE #KR_MCC_COMP;

SELECT C.PKebelista,C.AnioCampana,
		C.Constancia,
		C.FlagActiva,
		C.FlagIpUnicoZona,
		C.FlagPasoPedido,
		D.DesNivelComportamiento,
		E.DesStatusCorp
into #KR_MCC_COMP
from #KR_MCC_DATOS A
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM] C ON A.PKEBELISTA = C.PKEbelista AND C.CodPais = A.CodPais  
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DCOMPORTAMIENTOROLLING] D on C.Codcomportamientorolling = D.CodComportamiento
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_DSTATUS] E on C.CodStatus =E.CodStatus AND E.CodPais = C.CodPais   
WHERE C.AnioCampana BETWEEN @AnioCampanamenos17 AND @AnioCampana AND C.CodPais = @CodPais
group by C.PKebelista,C.AnioCampana,C.Constancia,C.FlagActiva,C.FlagIpUnicoZona,C.FlagPasoPedido,D.DesNivelComportamiento,E.DesStatusCorp


----------------------Ncampañas

--IF OBJECT_ID('tempdb.dbo.##KR_NCAMP', 'U') IS NOT NULL
--  DROP TABLE ##KR_NCAMP;

--SELECT 
--PKEbelista,count(distinct AnioCampana) as N_camp
--INTO ##KR_NCAMP
--FROM ##KR_MCC_COMP
--GROUP BY PKEbelista
--(63664 row(s) affected)


----------------------CONSTANCIA

IF OBJECT_ID('tempdb.dbo.#KR_Constancia', 'U') IS NOT NULL  DROP TABLE #KR_Constancia;

CREATE TABLE #KR_Constancia(
	Pkebelista INT,
	 C1_Constancia VARCHAR(6),
	 C2_Constancia VARCHAR(6),
	 C3_Constancia VARCHAR(6),
	 C4_Constancia VARCHAR(6),
	 C5_Constancia VARCHAR(6),
	 C6_Constancia VARCHAR(6),
	 C7_Constancia VARCHAR(6),
	 C8_Constancia VARCHAR(6),
	 C9_Constancia VARCHAR(6),
	 C10_Constancia VARCHAR(6),
	 C11_Constancia VARCHAR(6),
	 C12_Constancia VARCHAR(6),
	 C13_Constancia VARCHAR(6),
	 C14_Constancia VARCHAR(6),
	 C15_Constancia VARCHAR(6),
	 C16_Constancia VARCHAR(6),
	 C17_Constancia VARCHAR(6),
 	 C18_Constancia VARCHAR(6),
)

SET @SQLString = N' SELECT 
		PKebelista,
		['+  @AnioCampanamenos17+ '] AS C1_Constancia,
		['+  @AnioCampanamenos16+ '] AS C2_Constancia,
		['+  @AnioCampanamenos15+ '] AS C3_Constancia,
		['+  @AnioCampanamenos14+ '] AS C4_Constancia,
		['+  @AnioCampanamenos13+ '] AS C5_Constancia,
		['+  @AnioCampanamenos12+ '] AS C6_Constancia,
		['+  @AnioCampanamenos11+ '] AS C7_Constancia,
		['+  @AnioCampanamenos10+ '] AS C8_Constancia,
		['+  @AnioCampanamenos9+ '] AS C9_Constancia,
		['+  @AnioCampanamenos8+ '] AS C10_Constancia,
		['+  @AnioCampanamenos7+ '] AS C11_Constancia,
		['+  @AnioCampanamenos6+ '] AS C12_Constancia,
		['+  @AnioCampanamenos5+ '] AS C13_Constancia,
		['+  @AnioCampanamenos4+ '] AS C14_Constancia,
		['+  @AnioCampanamenos3+ '] AS C15_Constancia,
		['+  @AnioCampanamenos2+ '] AS C16_Constancia,
		['+  @AnioCampanamenos1+ '] AS C17_Constancia,
		['+  @AnioCampana+ '] AS C18_Constancia
FROM  (SELECT PKebelista,Aniocampana,Constancia from #KR_MCC_COMP ) as SourceTable 
PIVOT (MAX(Constancia) FOR Aniocampana in (['+  @AnioCampanamenos17+ '] ,
										['+  @AnioCampanamenos16+ '] ,
										['+  @AnioCampanamenos15+ '] ,
										['+  @AnioCampanamenos14+ '] ,
										['+  @AnioCampanamenos13+ '] ,
										['+  @AnioCampanamenos12+ '] ,
										['+  @AnioCampanamenos11+ '] ,
										['+  @AnioCampanamenos10+ '] ,
										['+  @AnioCampanamenos9+ '] ,
										['+  @AnioCampanamenos8+ '] ,
										['+  @AnioCampanamenos7+ '] ,
										['+  @AnioCampanamenos6+ '] ,
										['+  @AnioCampanamenos5+ '] ,
										['+  @AnioCampanamenos4+ '] ,
										['+  @AnioCampanamenos3+ '] ,
										['+  @AnioCampanamenos2+ '] ,
										['+  @AnioCampanamenos1+ '] ,
										['+  @AnioCampana+ '] )) AS PivotTable;'

INSERT INTO #KR_Constancia
EXEC sp_executesql @SQLString;

UPDATE #KR_Constancia SET C1_Constancia  = 0 WHERE C1_Constancia  is null or C1_Constancia  = ''
UPDATE #KR_Constancia SET C2_Constancia  = 0 WHERE C2_Constancia  is null or C2_Constancia  = ''
UPDATE #KR_Constancia SET C3_Constancia  = 0 WHERE C3_Constancia  is null or C3_Constancia  = ''
UPDATE #KR_Constancia SET C4_Constancia  = 0 WHERE C4_Constancia  is null or C4_Constancia  = ''
UPDATE #KR_Constancia SET C5_Constancia  = 0 WHERE C5_Constancia  is null or C5_Constancia  = ''
UPDATE #KR_Constancia SET C6_Constancia  = 0 WHERE C6_Constancia  is null or C6_Constancia  = ''
UPDATE #KR_Constancia SET C7_Constancia  = 0 WHERE C7_Constancia  is null or C7_Constancia  = ''
UPDATE #KR_Constancia SET C8_Constancia  = 0 WHERE C8_Constancia  is null or C8_Constancia  = ''
UPDATE #KR_Constancia SET C9_Constancia  = 0 WHERE C9_Constancia  is null or C9_Constancia  = ''
UPDATE #KR_Constancia SET C10_Constancia = 0 WHERE C10_Constancia is null or C10_Constancia = ''
UPDATE #KR_Constancia SET C11_Constancia = 0 WHERE C11_Constancia is null or C11_Constancia = ''
UPDATE #KR_Constancia SET C12_Constancia = 0 WHERE C12_Constancia is null or C12_Constancia = ''
UPDATE #KR_Constancia SET C13_Constancia = 0 WHERE C13_Constancia is null or C13_Constancia = ''
UPDATE #KR_Constancia SET C14_Constancia = 0 WHERE C14_Constancia is null or C14_Constancia = ''
UPDATE #KR_Constancia SET C15_Constancia = 0 WHERE C15_Constancia is null or C15_Constancia = ''
UPDATE #KR_Constancia SET C16_Constancia = 0 WHERE C16_Constancia is null or C16_Constancia = ''
UPDATE #KR_Constancia SET C17_Constancia = 0 WHERE C17_Constancia is null or C17_Constancia = ''
UPDATE #KR_Constancia SET C18_Constancia = 0 WHERE C18_Constancia is null or C18_Constancia = ''

----------------------COMPORTAMIENTO ROLLING

IF OBJECT_ID('tempdb.dbo.#KR_COMP_ROLLING', 'U') IS NOT NULL DROP TABLE #KR_COMP_ROLLING;

CREATE TABLE #KR_COMP_ROLLING 
(
	PkEbelista INT,
	C1_Comp_Rolling  VARCHAR(15),
	C2_Comp_Rolling	 VARCHAR(15),
	C3_Comp_Rolling	 VARCHAR(15),
	C4_Comp_Rolling	 VARCHAR(15),
	C5_Comp_Rolling	 VARCHAR(15),
	C6_Comp_Rolling	 VARCHAR(15),
	C7_Comp_Rolling	 VARCHAR(15),
	C8_Comp_Rolling	 VARCHAR(15),
	C9_Comp_Rolling  VARCHAR(15),
	C10_Comp_Rolling VARCHAR(15),
	C11_Comp_Rolling VARCHAR(15),
	C12_Comp_Rolling VARCHAR(15),
	C13_Comp_Rolling VARCHAR(15),
	C14_Comp_Rolling VARCHAR(15),
	C15_Comp_Rolling VARCHAR(15),
	C16_Comp_Rolling VARCHAR(15),
	C17_Comp_Rolling VARCHAR(15),
	C18_Comp_Rolling VARCHAR(15)
)


SET @SQLString2 = N' SELECT PKebelista,
					['+  @AnioCampanamenos17+ '] AS C1_Comp_Rolling,
					['+  @AnioCampanamenos16+ '] AS C2_Comp_Rolling,
					['+  @AnioCampanamenos15+ '] AS C3_Comp_Rolling,
					['+  @AnioCampanamenos14+ '] AS C4_Comp_Rolling,
					['+  @AnioCampanamenos13+ '] AS C5_Comp_Rolling,
					['+  @AnioCampanamenos12+ '] AS C6_Comp_Rolling,
					['+  @AnioCampanamenos11+ '] AS C7_Comp_Rolling,
					['+  @AnioCampanamenos10+ '] AS C8_Comp_Rolling,
					['+  @AnioCampanamenos9+ '] AS C9_Comp_Rolling,
					['+  @AnioCampanamenos8+ '] AS C10_Comp_Rolling,
					['+  @AnioCampanamenos7+ '] AS C11_Comp_Rolling,
					['+  @AnioCampanamenos6+ '] AS C12_Comp_Rolling,
					['+  @AnioCampanamenos5+ '] AS C13_Comp_Rolling,
					['+  @AnioCampanamenos4+ '] AS C14_Comp_Rolling,
					['+  @AnioCampanamenos3+ '] AS C15_Comp_Rolling,
					['+  @AnioCampanamenos2+ '] AS C16_Comp_Rolling,
					['+  @AnioCampanamenos1+ '] AS C17_Comp_Rolling,
					['+  @AnioCampana+ '] AS C18_Comp_Rolling
FROM (SELECT PKebelista,Aniocampana,DesNivelComportamiento from #KR_MCC_COMP ) as SourceTable 
PIVOT (MAX(DesNivelComportamiento) FOR Aniocampana in (['+  @AnioCampanamenos17+ '] ,
					 ['+  @AnioCampanamenos16+ '] ,
					 ['+  @AnioCampanamenos15+ '] ,
					 ['+  @AnioCampanamenos14+ '] ,
					 ['+  @AnioCampanamenos13+ '] ,
					 ['+  @AnioCampanamenos12+ '] ,
					 ['+  @AnioCampanamenos11+ '] ,
					 ['+  @AnioCampanamenos10+ '] ,
					 ['+  @AnioCampanamenos9+ '] ,
					 ['+  @AnioCampanamenos8+ '] ,
					 ['+  @AnioCampanamenos7+ '] ,
					 ['+  @AnioCampanamenos6+ '] ,
					 ['+  @AnioCampanamenos5+ '] ,
					 ['+  @AnioCampanamenos4+ '] ,
					 ['+  @AnioCampanamenos3+ '] ,
					 ['+  @AnioCampanamenos2+ '] ,
					 ['+  @AnioCampanamenos1+ '] ,
					 ['+  @AnioCampana+ '] )) AS PivotTable;'

INSERT INTO #KR_COMP_ROLLING
EXEC sp_executesql @SQLString2

UPDATE #KR_COMP_ROLLING SET C1_Comp_Rolling  = 0 WHERE C1_Comp_Rolling  is null or C1_Comp_Rolling  = ''
UPDATE #KR_COMP_ROLLING SET C2_Comp_Rolling  = 0 WHERE C2_Comp_Rolling  is null or C2_Comp_Rolling  = ''
UPDATE #KR_COMP_ROLLING SET C3_Comp_Rolling  = 0 WHERE C3_Comp_Rolling  is null or C3_Comp_Rolling  = ''
UPDATE #KR_COMP_ROLLING SET C4_Comp_Rolling  = 0 WHERE C4_Comp_Rolling  is null or C4_Comp_Rolling  = ''
UPDATE #KR_COMP_ROLLING SET C5_Comp_Rolling  = 0 WHERE C5_Comp_Rolling  is null or C5_Comp_Rolling  = ''
UPDATE #KR_COMP_ROLLING SET C6_Comp_Rolling  = 0 WHERE C6_Comp_Rolling  is null or C6_Comp_Rolling  = ''
UPDATE #KR_COMP_ROLLING SET C7_Comp_Rolling  = 0 WHERE C7_Comp_Rolling  is null or C7_Comp_Rolling  = ''
UPDATE #KR_COMP_ROLLING SET C8_Comp_Rolling  = 0 WHERE C8_Comp_Rolling  is null or C8_Comp_Rolling  = ''
UPDATE #KR_COMP_ROLLING SET C9_Comp_Rolling  = 0 WHERE C9_Comp_Rolling  is null or C9_Comp_Rolling  = ''
UPDATE #KR_COMP_ROLLING SET C10_Comp_Rolling = 0 WHERE C10_Comp_Rolling is null or C10_Comp_Rolling = ''
UPDATE #KR_COMP_ROLLING SET C11_Comp_Rolling = 0 WHERE C11_Comp_Rolling is null or C11_Comp_Rolling = ''
UPDATE #KR_COMP_ROLLING SET C12_Comp_Rolling = 0 WHERE C12_Comp_Rolling is null or C12_Comp_Rolling = ''
UPDATE #KR_COMP_ROLLING SET C13_Comp_Rolling = 0 WHERE C13_Comp_Rolling is null or C13_Comp_Rolling = ''
UPDATE #KR_COMP_ROLLING SET C14_Comp_Rolling = 0 WHERE C14_Comp_Rolling is null or C14_Comp_Rolling = ''
UPDATE #KR_COMP_ROLLING SET C15_Comp_Rolling = 0 WHERE C15_Comp_Rolling is null or C15_Comp_Rolling = ''
UPDATE #KR_COMP_ROLLING SET C16_Comp_Rolling = 0 WHERE C16_Comp_Rolling is null or C16_Comp_Rolling = ''
UPDATE #KR_COMP_ROLLING SET C17_Comp_Rolling = 0 WHERE C17_Comp_Rolling is null or C17_Comp_Rolling = ''
UPDATE #KR_COMP_ROLLING SET C18_Comp_Rolling = 0 WHERE C18_Comp_Rolling is null or C18_Comp_Rolling = ''

----------------------COD STATUS

IF OBJECT_ID('tempdb.dbo.#KR_COD_STATUS', 'U') IS NOT NULL DROP TABLE #KR_COD_STATUS

  CREATE TABLE #KR_COD_STATUS 
(
	PkEbelista INT,
	C1_Cod_Status  VARCHAR(15),
	C2_Cod_Status	 VARCHAR(15),
	C3_Cod_Status	 VARCHAR(15),
	C4_Cod_Status	 VARCHAR(15),
	C5_Cod_Status	 VARCHAR(15),
	C6_Cod_Status	 VARCHAR(15),
	C7_Cod_Status	 VARCHAR(15),
	C8_Cod_Status	 VARCHAR(15),
	C9_Cod_Status  VARCHAR(15),
	C10_Cod_Status VARCHAR(15),
	C11_Cod_Status VARCHAR(15),
	C12_Cod_Status VARCHAR(15),
	C13_Cod_Status VARCHAR(15),
	C14_Cod_Status VARCHAR(15),
	C15_Cod_Status VARCHAR(15),
	C16_Cod_Status VARCHAR(15),
	C17_Cod_Status VARCHAR(15),
	C18_Cod_Status VARCHAR(15)
)



DECLARE @SQLString3 NVARCHAR(2000);


SET @SQLString3 = N' SELECT PKebelista,
					['+  @AnioCampanamenos17+ '] AS C1_Cod_Status,
					['+  @AnioCampanamenos16+ '] AS C2_Cod_Status,
					['+  @AnioCampanamenos15+ '] AS C3_Cod_Status,
					['+  @AnioCampanamenos14+ '] AS C4_Cod_Status,
					['+  @AnioCampanamenos13+ '] AS C5_Cod_Status,
					['+  @AnioCampanamenos12+ '] AS C6_Cod_Status,
					['+  @AnioCampanamenos11+ '] AS C7_Cod_Status,
					['+  @AnioCampanamenos10+ '] AS C8_Cod_Status,
					['+  @AnioCampanamenos9+ '] AS  C9_Cod_Status,
					['+  @AnioCampanamenos8+ '] AS  C10_Cod_Status,
					['+  @AnioCampanamenos7+ '] AS  C11_Cod_Status,
					['+  @AnioCampanamenos6+ '] AS  C12_Cod_Status,
					['+  @AnioCampanamenos5+ '] AS  C13_Cod_Status,
					['+  @AnioCampanamenos4+ '] AS  C14_Cod_Status,
					['+  @AnioCampanamenos3+ '] AS  C15_Cod_Status,
					['+  @AnioCampanamenos2+ '] AS  C16_Cod_Status,
					['+  @AnioCampanamenos1+ '] AS  C17_Cod_Status,
					['+  @AnioCampana+ '] AS C18_Cod_Status
FROM (SELECT PKebelista,Aniocampana,DesStatusCorp from #KR_MCC_COMP ) as SourceTable 
PIVOT (MAX(DesStatusCorp) FOR Aniocampana in (['+  @AnioCampanamenos17+ '] ,
					 ['+  @AnioCampanamenos16+ '] ,
					 ['+  @AnioCampanamenos15+ '] ,
					 ['+  @AnioCampanamenos14+ '] ,
					 ['+  @AnioCampanamenos13+ '] ,
					 ['+  @AnioCampanamenos12+ '] ,
					 ['+  @AnioCampanamenos11+ '] ,
					 ['+  @AnioCampanamenos10+ '] ,
					 ['+  @AnioCampanamenos9+ '] ,
					 ['+  @AnioCampanamenos8+ '] ,
					 ['+  @AnioCampanamenos7+ '] ,
					 ['+  @AnioCampanamenos6+ '] ,
					 ['+  @AnioCampanamenos5+ '] ,
					 ['+  @AnioCampanamenos4+ '] ,
					 ['+  @AnioCampanamenos3+ '] ,
					 ['+  @AnioCampanamenos2+ '] ,
					 ['+  @AnioCampanamenos1+ '] ,
					 ['+  @AnioCampana+ '] )) AS PivotTable;'

INSERT INTO #KR_COD_STATUS
EXEC sp_executesql @SQLString3;


---------------------FLAG IP UNICO

IF OBJECT_ID('tempdb.dbo.##FLAGIPUNICO', 'U') IS NOT NULL
  DROP TABLE ##FLAGIPUNICO;

DECLARE @SQLString4 NVARCHAR(2000);

SET @SQLString4 = 
N'
SELECT PKebelista,['+  @AnioCampanamenos17+ '] AS C1_FlagIpUnico,['+  @AnioCampanamenos16+ '] AS C2_FlagIpUnico,['+  @AnioCampanamenos15+ '] AS C3_FlagIpUnico,['+  @AnioCampanamenos14+ '] AS C4_FlagIpUnico,['+  @AnioCampanamenos13+ '] AS C5_FlagIpUnico,['+  @AnioCampanamenos12+ '] AS C6_FlagIpUnico,['+  @AnioCampanamenos11+ '] AS C7_FlagIpUnico,['+  @AnioCampanamenos10+ '] AS C8_FlagIpUnico,['+  @AnioCampanamenos9+ '] AS C9_FlagIpUnico,['+  @AnioCampanamenos8+ '] AS C10_FlagIpUnico,['+  @AnioCampanamenos7+ '] AS C11_FlagIpUnico,['+  @AnioCampanamenos6+ '] AS C12_FlagIpUnico,['+  @AnioCampanamenos5+ '] AS C13_FlagIpUnico,['+  @AnioCampanamenos4+ '] AS C14_FlagIpUnico,['+  @AnioCampanamenos3+ '] AS C15_FlagIpUnico,['+  @AnioCampanamenos2+ '] AS C16_FlagIpUnico,['+  @AnioCampanamenos1+ '] AS C17_FlagIpUnico,['+  @AnioCampana+ '] AS C18_FlagIpUnico
INTO ##FLAGIPUNICO
FROM 
(SELECT PKebelista,Aniocampana,FlagIpUnicoZona from ##KR_MCC_COMP ) as SourceTable 
PIVOT 
(COUNT(FlagIpUnicoZona)
 FOR Aniocampana in (['+  @AnioCampanamenos17+ '] ,['+  @AnioCampanamenos16+ '] ,['+  @AnioCampanamenos15+ '] ,['+  @AnioCampanamenos14+ '] ,['+  @AnioCampanamenos13+ '] ,['+  @AnioCampanamenos12+ '] ,['+  @AnioCampanamenos11+ '] ,['+  @AnioCampanamenos10+ '] ,['+  @AnioCampanamenos9+ '] ,['+  @AnioCampanamenos8+ '] ,['+  @AnioCampanamenos7+ '] ,['+  @AnioCampanamenos6+ '] ,['+  @AnioCampanamenos5+ '] ,['+  @AnioCampanamenos4+ '] ,['+  @AnioCampanamenos3+ '] ,['+  @AnioCampanamenos2+ '] ,['+  @AnioCampanamenos1+ '] ,['+  @AnioCampana+ '] )) AS PivotTable;'

EXEC sp_executesql @SQLString4;

--SELECT * FROM ##FLAGIPUNICO
--SELECT * FROM ##FLAGIPUNICO WHERE [C0_FLAGIPUNICO]>1 or [C1_FLAGIPUNICO]>1 or [C2_FLAGIPUNICO]>1 or [C3_FLAGIPUNICO]>1 or [C4_FLAGIPUNICO]>1 or [C5_FLAGIPUNICO]>1 or [C6_FLAGIPUNICO]>1

IF OBJECT_ID('tempdb.dbo.##FLAGIPUNICO1', 'U') IS NOT NULL
  DROP TABLE ##FLAGIPUNICO1;

select pkebelista,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos17) C1_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos16) C2_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos15) C3_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos14) C4_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos13) C5_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos12) C6_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos11) C7_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos10) C8_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos9) C9_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos8) C10_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos7) C11_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos6) C12_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos5) C13_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos4) C14_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos3) C15_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos2) C16_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos1) C17_FlagIpUnico,
(select FlagIpUnicoZona from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampana) C18_FlagIpUnico
into ##FLAGIPUNICO1
from ##FLAGIPUNICO b 
group by pkebelista;
---4945 

--select * from ##KR_MCC_COMP where PKebelista=48023 order by  AnioCampana
--go

--select * from ##FLAGIPUNICO1 where PKebelista=48023 --order by  AnioCampana
----go


---------------------FLAG PASO PEDIDO

IF OBJECT_ID('tempdb.dbo.##FLAGPASOPEDIDO', 'U') IS NOT NULL
  DROP TABLE ##FLAGPASOPEDIDO;

DECLARE @SQLString5 NVARCHAR(2000);

SET @SQLString5 = 
N'
SELECT PKebelista,['+  @AnioCampanamenos17+ '] AS C1_FlagPasoPedido,['+  @AnioCampanamenos16+ '] AS C2_FlagPasoPedido,['+  @AnioCampanamenos15+ '] AS C3_FlagPasoPedido,['+  @AnioCampanamenos14+ '] AS C4_FlagPasoPedido,['+  @AnioCampanamenos13+ '] AS C5_FlagPasoPedido,['+  @AnioCampanamenos12+ '] AS C6_FlagPasoPedido,['+  @AnioCampanamenos11+ '] AS C7_FlagPasoPedido,['+  @AnioCampanamenos10+ '] AS C8_FlagPasoPedido,['+  @AnioCampanamenos9+ '] AS C9_FlagPasoPedido,['+  @AnioCampanamenos8+ '] AS C10_FlagPasoPedido,['+  @AnioCampanamenos7+ '] AS C11_FlagPasoPedido,['+  @AnioCampanamenos6+ '] AS C12_FlagPasoPedido,['+  @AnioCampanamenos5+ '] AS C13_FlagPasoPedido,['+  @AnioCampanamenos4+ '] AS C14_FlagPasoPedido,['+  @AnioCampanamenos3+ '] AS C15_FlagPasoPedido,['+  @AnioCampanamenos2+ '] AS C16_FlagPasoPedido,['+  @AnioCampanamenos1+ '] AS C17_FlagPasoPedido,['+  @AnioCampana+ '] AS C18_FlagPasoPedido

INTO ##FLAGPASOPEDIDO
FROM 
(SELECT PKebelista,Aniocampana,FlagPasoPedido from ##KR_MCC_COMP ) as SourceTable 
PIVOT 
(COUNT(FlagPasoPedido)
 FOR Aniocampana in (['+  @AnioCampanamenos17+ '] ,['+  @AnioCampanamenos16+ '] ,['+  @AnioCampanamenos15+ '] ,['+  @AnioCampanamenos14+ '] ,['+  @AnioCampanamenos13+ '] ,['+  @AnioCampanamenos12+ '] ,['+  @AnioCampanamenos11+ '] ,['+  @AnioCampanamenos10+ '] ,['+  @AnioCampanamenos9+ '] ,['+  @AnioCampanamenos8+ '] ,['+  @AnioCampanamenos7+ '] ,['+  @AnioCampanamenos6+ '] ,['+  @AnioCampanamenos5+ '] ,['+  @AnioCampanamenos4+ '] ,['+  @AnioCampanamenos3+ '] ,['+  @AnioCampanamenos2+ '] ,['+  @AnioCampanamenos1+ '] ,['+  @AnioCampana+ '] )) AS PivotTable;'

EXEC sp_executesql @SQLString5;

--SELECT * FROM ##FLAGPASOPEDIDO
--SELECT * FROM ##FLAGPASOPEDIDO WHERE [C0_FLAGPASOPEDIDO]>1 or[C1_FLAGPASOPEDIDO]>1 or [C2_FLAGPASOPEDIDO]>1 or [C3_FLAGPASOPEDIDO]>1 or [C4_FLAGPASOPEDIDO]>1 or [C5_FLAGPASOPEDIDO]>1 or [C6_FLAGPASOPEDIDO]>1

IF OBJECT_ID('tempdb.dbo.##FLAGPASOPEDIDO1', 'U') IS NOT NULL
  DROP TABLE ##FLAGPASOPEDIDO1;

select pkebelista,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos17) C1_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos16) C2_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos15) C3_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos14) C4_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos13) C5_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos12) C6_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos11) C7_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos10) C8_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos9) C9_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos8) C10_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos7) C11_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos6) C12_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos5) C13_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos4) C14_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos3) C15_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos2) C16_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos1) C17_FlagPasoPedido,
(select FlagPasoPedido from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampana) C18_FlagPasoPedido
into ##FLAGPASOPEDIDO1
from ##FLAGPASOPEDIDO b 
group by pkebelista;
---4945 


---------------------FLAG ACTIVA

IF OBJECT_ID('tempdb.dbo.##FLAGACTIVA', 'U') IS NOT NULL
  DROP TABLE ##FLAGACTIVA;

DECLARE @SQLString6 NVARCHAR(2000);

SET @SQLString6 = 
N'
SELECT PKebelista,['+  @AnioCampanamenos17+ '] AS C1_FlagActiva,['+  @AnioCampanamenos16+ '] AS C2_FlagActiva,['+  @AnioCampanamenos15+ '] AS C3_FlagActiva,['+  @AnioCampanamenos14+ '] AS C4_FlagActiva,['+  @AnioCampanamenos13+ '] AS C5_FlagActiva,['+  @AnioCampanamenos12+ '] AS C6_FlagActiva,['+  @AnioCampanamenos11+ '] AS C7_FlagActiva,['+  @AnioCampanamenos10+ '] AS C8_FlagActiva,['+  @AnioCampanamenos9+ '] AS C9_FlagActiva,['+  @AnioCampanamenos8+ '] AS C10_FlagActiva,['+  @AnioCampanamenos7+ '] AS C11_FlagActiva,['+  @AnioCampanamenos6+ '] AS C12_FlagActiva,['+  @AnioCampanamenos5+ '] AS C13_FlagActiva,['+  @AnioCampanamenos4+ '] AS C14_FlagActiva,['+  @AnioCampanamenos3+ '] AS C15_FlagActiva,['+  @AnioCampanamenos2+ '] AS C16_FlagActiva,['+  @AnioCampanamenos1+ '] AS C17_FlagActiva,['+  @AnioCampana+ '] AS C18_FlagActiva
INTO ##FLAGACTIVA
FROM 
(SELECT PKebelista,Aniocampana,FlagActiva from ##KR_MCC_COMP ) as SourceTable 
PIVOT 
(COUNT(FlagActiva)
 FOR Aniocampana in (['+  @AnioCampanamenos17+ '] ,['+  @AnioCampanamenos16+ '] ,['+  @AnioCampanamenos15+ '] ,['+  @AnioCampanamenos14+ '] ,['+  @AnioCampanamenos13+ '] ,['+  @AnioCampanamenos12+ '] ,['+  @AnioCampanamenos11+ '] ,['+  @AnioCampanamenos10+ '] ,['+  @AnioCampanamenos9+ '] ,['+  @AnioCampanamenos8+ '] ,['+  @AnioCampanamenos7+ '] ,['+  @AnioCampanamenos6+ '] ,['+  @AnioCampanamenos5+ '] ,['+  @AnioCampanamenos4+ '] ,['+  @AnioCampanamenos3+ '] ,['+  @AnioCampanamenos2+ '] ,['+  @AnioCampanamenos1+ '] ,['+  @AnioCampana+ '] )) AS PivotTable;'

EXEC sp_executesql @SQLString6;

--SELECT * FROM ##FLAGPASOPEDIDO
--SELECT * FROM ##FLAGPASOPEDIDO WHERE [C0_FLAGPASOPEDIDO]>1 or[C1_FLAGPASOPEDIDO]>1 or [C2_FLAGPASOPEDIDO]>1 or [C3_FLAGPASOPEDIDO]>1 or [C4_FLAGPASOPEDIDO]>1 or [C5_FLAGPASOPEDIDO]>1 or [C6_FLAGPASOPEDIDO]>1

IF OBJECT_ID('tempdb.dbo.##FLAGACTIVA1', 'U') IS NOT NULL
  DROP TABLE ##FLAGACTIVA1;

select pkebelista,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos17) C1_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos16) C2_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos15) C3_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos14) C4_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos13) C5_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos12) C6_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos11) C7_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos10) C8_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos9) C9_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos8) C10_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos7) C11_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos6) C12_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos5) C13_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos4) C14_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos3) C15_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos2) C16_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampanamenos1) C17_FlagActiva,
(select FlagActiva from ##KR_MCC_COMP a where a.PKEbelista=b.pkebelista and AnioCampana= @AnioCampana) C18_FlagActiva
into ##FLAGACTIVA1
from ##FLAGACTIVA b 
group by pkebelista;
---4945 


----------------Antiguedad Ultimo Pedido

IF OBJECT_ID('tempdb.dbo.##KR_MCC_ANT', 'U') IS NOT NULL
  DROP TABLE ##KR_MCC_ANT;

SELECT C.PKebelista,MAX(C.AnioCampana) AS AnioCampanaUltimoPedido
into ##KR_MCC_ANT
from 
##KR_MCC_DATOS1 A
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM] C ON ltrim(rtrim(A.PKEBELISTA)) = ltrim(rtrim(C.PKEbelista)) and ltrim(rtrim(C.AnioCampana))<=ltrim(rtrim(@AnioCampana)) AND C.CODPAIS=@CodPais AND C.FlagPasoPedido=1 
group by C.PKebelista

--SELECT * FROM FSTAEBECAMC01

----------------Antiguedad Ultimo Pedido WEB

IF OBJECT_ID('tempdb.dbo.##KR_MCC_ANTW', 'U') IS NOT NULL
  DROP TABLE ##KR_MCC_ANTW;

SELECT C.PKebelista,MAX(C.AnioCampana) AS AnioCampanaUltimoPedidoWeb
into ##KR_MCC_ANTW
from 
##KR_MCC_DATOS1 A
INNER JOIN [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM] C ON ltrim(rtrim(A.PKEBELISTA)) = ltrim(rtrim(C.PKEbelista)) and ltrim(rtrim(C.AnioCampana))<=ltrim(rtrim(@AnioCampana))  AND C.CODPAIS=@CodPais AND C.FlagPasoPedido=1 AND C.codigofacturainternet in ('WEB','WMX')
group by C.PKebelista

--SELECT * FROM FSTAEBECAMC01



--------------------------TABLA FINAL:

IF OBJECT_ID('tempdb.dbo.##KR_MCC_DATOS2', 'U') IS NOT NULL
  DROP TABLE ##KR_MCC_DATOS2;

SELECT
A.*,
dbo.DiffANIOCampanas(@AnioCampana,H.AnioCampanaUltimoPedido)    as N_Camp_UlPed,
dbo.DiffANIOCampanas(@AnioCampana,I.AnioCampanaUltimoPedidoWeb) as N_Camp_UlPedWeb,
J.N_CAMP AS N_camp,
B.C1_Constancia,
B.C2_Constancia,
B.C3_Constancia,
B.C4_Constancia,
B.C5_Constancia,
B.C6_Constancia,
B.C7_Constancia,
B.C8_Constancia,
B.C9_Constancia,
B.C10_Constancia,
B.C11_Constancia,
B.C12_Constancia,
B.C13_Constancia,
B.C14_Constancia,
B.C15_Constancia,
B.C16_Constancia,
B.C17_Constancia,
B.C18_Constancia,
C.C1_Cod_Status,
C.C2_Cod_Status,
C.C3_Cod_Status,
C.C4_Cod_Status,
C.C5_Cod_Status,
C.C6_Cod_Status,
C.C7_Cod_Status,
C.C8_Cod_Status,
C.C9_Cod_Status,
C.C10_Cod_Status,
C.C11_Cod_Status,
C.C12_Cod_Status,
C.C13_Cod_Status,
C.C14_Cod_Status,
C.C15_Cod_Status,
C.C16_Cod_Status,
C.C17_Cod_Status,
C.C18_Cod_Status,
D.C1_FlagIpUnico,
D.C2_FlagIpUnico,
D.C3_FlagIpUnico,
D.C4_FlagIpUnico,
D.C5_FlagIpUnico,
D.C6_FlagIpUnico,
D.C7_FlagIpUnico,
D.C8_FlagIpUnico,
D.C9_FlagIpUnico,
D.C10_FlagIpUnico,
D.C11_FlagIpUnico,
D.C12_FlagIpUnico,
D.C13_FlagIpUnico,
D.C14_FlagIpUnico,
D.C15_FlagIpUnico,
D.C16_FlagIpUnico,
D.C17_FlagIpUnico,
D.C18_FlagIpUnico,
E.C1_Comp_Rolling,
E.C2_Comp_Rolling,
E.C3_Comp_Rolling,
E.C4_Comp_Rolling,
E.C5_Comp_Rolling,
E.C6_Comp_Rolling,
E.C7_Comp_Rolling,
E.C8_Comp_Rolling,
E.C9_Comp_Rolling,
E.C10_Comp_Rolling,
E.C11_Comp_Rolling,
E.C12_Comp_Rolling,
E.C13_Comp_Rolling,
E.C14_Comp_Rolling,
E.C15_Comp_Rolling,
E.C16_Comp_Rolling,
E.C17_Comp_Rolling,
E.C18_Comp_Rolling,
F.C1_FlagPasoPedido,
F.C2_FlagPasoPedido,
F.C3_FlagPasoPedido,
F.C4_FlagPasoPedido,
F.C5_FlagPasoPedido,
F.C6_FlagPasoPedido,
F.C7_FlagPasoPedido,
F.C8_FlagPasoPedido,
F.C9_FlagPasoPedido,
F.C10_FlagPasoPedido,
F.C11_FlagPasoPedido,
F.C12_FlagPasoPedido,
F.C13_FlagPasoPedido,
F.C14_FlagPasoPedido,
F.C15_FlagPasoPedido,
F.C16_FlagPasoPedido,
F.C17_FlagPasoPedido,
F.C18_FlagPasoPedido,
G.C1_Flagactiva,
G.C2_Flagactiva,
G.C3_Flagactiva,
G.C4_Flagactiva,
G.C5_Flagactiva,
G.C6_Flagactiva,
G.C7_Flagactiva,
G.C8_Flagactiva,
G.C9_Flagactiva,
G.C10_Flagactiva,
G.C11_Flagactiva,
G.C12_Flagactiva,
G.C13_Flagactiva,
G.C14_Flagactiva,
G.C15_Flagactiva,
G.C16_Flagactiva,
G.C17_Flagactiva,
G.C18_Flagactiva
INTO ##KR_MCC_DATOS2
FROM 
##KR_MCC_DATOS1 A
LEFT JOIN ##KR_CONSTANCIA1 B   ON A.PKEbelista=B.PKEbelista
LEFT JOIN ##KR_COD_STATUS1 C   ON A.PKEbelista=C.PKEbelista
LEFT JOIN ##FLAGIPUNICO1 D     ON A.PKEbelista=D.PKEbelista
LEFT JOIN ##KR_COMP_ROLLING1 E ON A.PKEbelista=E.PKEbelista
LEFT JOIN ##FLAGPASOPEDIDO1  F ON A.PKEbelista=F.PKEbelista
LEFT JOIN ##FLAGACTIVA1 G      ON A.PKEbelista=G.PKEbelista
LEFT JOIN ##KR_MCC_ANT  H      ON A.PKEbelista=H.PKEbelista
LEFT JOIN ##KR_MCC_ANTW  I     ON A.PKEbelista=I.PKEbelista
LEFT JOIN ##KR_NCAMP  J        ON A.PKEbelista=J.PKEbelista;

-- SELECT * FROM ##KR_MCC_DATOS2
---SELECT * FROM ##KR_NCAMP
-- SELECT COUNT(1),COUNT(DISTINCT PKEbelista) FROM ##KR_MCC_DATOS2
-- 63,357	63,357

DECLARE @SQLString7 NVARCHAR(2000);

SET @SQLString7 = 
N'
IF OBJECT_ID(''tempdb.dbo.##KR_MCC_DATOS_'+@AnioCampana+' '', ''U'') IS NOT NULL
DROP TABLE ##KR_MCC_DATOS_'+@AnioCampana;

EXEC sp_executesql @SQLString7;


DECLARE @SQLString8 NVARCHAR(2000);

SET @SQLString8 = 
N'
SELECT * INTO ##KR_MCC_DATOS_'+@AnioCampana+' FROM ##KR_MCC_DATOS2'

EXEC sp_executesql @SQLString8;

END

GO

---INGRESANDO PARAMETROS
/*
@AnioCampana = '201711',
@AnioCampanamenos1 = '201710',
@AnioCampanamenos2 = '201709',
@AnioCampanamenos3 = '201708',
@AnioCampanamenos4 = '201707',
@AnioCampanamenos5 = '201706',
@CodPais = (select CodPais From DPais);

@AnioCampana = '201711',@AnioCampanamenos1 = '201710',@AnioCampanamenos2 = '201709',@AnioCampanamenos3 = '201708',@AnioCampanamenos4 = '201707',@AnioCampanamenos5 = '201706',@CodPais = (select CodPais From DPais);
*/

EXEC dbo.KR_MATRIZ_CONS 'CO','201714'


-------------Agregando por fuera Antiguedad Ventas:

--------------DataMartPeru

--use datamartanalitico
--go

--drop table kr_anti_14

--select 
--PKEbelista
--,max(AnioCampana) AnioCampana
--into kr_anti_14
--from BDDM02.[DATAMARTCOMPERU].[dbo].[FSTAEBECAMC01]
--where FlagActiva=0  and aniocampana<=201714
--group by PKEbelista

--select count(1) from KR_anti_14 where  pkebelista in (select pkebelista from ##KR_MCC_DATOS_201714) 
----74884
--select * from ##KR_MCC_DATOS_201714  where pkebelista not in (select pkebelista from KR_anti_14) 
----142088

-------------------------------------------------------

drop table #anti3

select A.CodPais
,A.PKEbelista
,count(*) antiguedad
into #anti3
from [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM] A
inner join kr_anti_14 B on 
A.PkEbelista=B.PKEbelista 
where A.CodPais in ('CO') and a.PKEbelista in (select pkebelista from ##KR_MCC_DATOS_201714) and a.aniocampana<=201714
and (A.AnioCampana>B.AnioCampana or B.AnioCampana is null)
group by A.CodPais,A.PKEbelista
--75733


alter table ##KR_MCC_DATOS_201714
--drop column Antig_act
add Antig_act int
go
update ##KR_MCC_DATOS_201714
set Antig_act=b.antiguedad
from ##KR_MCC_DATOS_201714 a,#anti3 b
where a.pkebelista=b.pkebelista
--75733



-------------Agregando por fuera Socia:

--------------DataMartPeru

--Drop table KR_socia

--select aniocampana,codseccion,codzona,codregion,desregion,pkebelista,codlider,RendimientoCampana  as Tipo_Exitosa,desnivel,RendimientoEtapa as Tipo_Estable 
--into KR_socia
--from DATAMARTCOMCORP.DBO.BDLideres_Base_Paises 
--where CODPAIS='CO' and codlider<>'N/C'
--and AnioCampana=201714
--5310


--------------Agregando socia

alter table ##KR_MCC_DATOS_201714
--drop column Antig_act
add codlider varchar(50),Tipo_socia_exitos varchar(30),Tipo_socia_nivel varchar(30),Tipo_socia_estable varchar(30)
go

update ##KR_MCC_DATOS_201714
set codlider=b.codlider
from ##KR_MCC_DATOS_201714 a,[DWH_ANALITICO].[dbo].[DWH_DGEOGRAFIACAMPANA] b
where a.pkterritorio=b.pkterritorio and a.codpais=b.codpais and a.aniocampana=b.aniocampana
--145236

--select * from ##KR_MCC_DATOS_201714
--select * from KR_socia

update ##KR_MCC_DATOS_201714
set 
Tipo_socia_exitos=b.Tipo_exitosa,
Tipo_socia_nivel=b.Desnivel,
Tipo_socia_estable=b.Tipo_estable
from ##KR_MCC_DATOS_201714 a,kr_socia b
where a.codlider=b.codlider and a.aniocampana=b.aniocampana
--140855

drop table ##KR_MCC_DATOST

SELECT *
INTO ##KR_MCC_DATOST
FROM 
(
SELECT * FROM ##KR_MCC_DATOS_201714
)KR
---(431865 row(s) affected)

--SELECT * FROM ##KR_MCC_DATOST
--SELECT antig_act,count(1) FROM ##KR_MCC_DATOST group by antig_act


-----------------------Agregandole Antiguedad Activa para todas

alter table ##KR_MCC_DATOST
--drop column Antig_act1
add antig_act1 int
go

update ##KR_MCC_DATOST
set antig_act1=case 
when antig_act<Ant_Camp_Ingreso then antig_act
when antig_act is null then Ant_Camp_Ingreso 
when antig_act>Ant_Camp_Ingreso then Ant_Camp_Ingreso
else antig_act 
end
--145236

--SELECT pkebelista,aniocampana,c18_comp_rolling,Ant_Camp_Ingreso,antig_act,antig_act1 FROM ##KR_MCC_DATOST
--select * from ##KR_MCC_DATOST where pkebelista=1227892
--select * from ##KR_MCC_DATOST order by antig_act1

------Generando Variables


IF OBJECT_ID('##KR_MCC_DATOST1') IS NOT NULL
  DROP TABLE ##KR_MCC_DATOST1;

select
A.AnioCampana,
A.CodPais,
A.PKEbelista,
--A.PKTerritorio,
A.Edad,
ISNULL(A.Edad,0) AS Edad,
CASE 
		WHEN A.EDAD>=18 AND A.EDAD<=36 THEN 1
		WHEN A.EDAD>36 AND A.EDAD<=56 THEN 2
		WHEN A.EDAD>56 THEN 3
		ELSE '0' END AS R_GEN,
--A.DesEstadoCivil,
A.Ant_Camp_Ingreso,
A.antig_act1,
case
when antig_act1>0 and antig_act1<=2 then 1
when antig_act1>2 and antig_act1<18 then 2
when antig_act1>=18 then 3 
else 0
end as antig_act2,
--A.DESREGION,
--A.CODREGION,
--A.CODZONA,
--A.CODSECCION,
--A.FlagBelcorp,
--A.Flaginusual,
case when ISNULL(A.N_Camp,0)= 0 then 0 else  ((1.0)*ISNULL(A.N_Camp_UlPed,0)/ISNULL(A.N_Camp,0)) end as Porc_camp,
case when ISNULL(A.N_Camp,0)= 0 then 0 else  ((1.0)*ISNULL(A.N_Camp_UlPedWeb,0)/ISNULL(A.N_Camp,0)) end as Porc_camp1,
ISNULL(A.N_Camp_UlPedWeb,0) AS N_Camp_UlPedWeb,
ISNULL(A.N_Camp_UlPed,0) AS N_Camp_UlPed,
ISNULL(A.N_Camp,0) AS N_Camp,
case 
when Tipo_socia_exitos='Exitosa' then 1
when Tipo_socia_exitos='No Exitosa' then 2
else 0
end
as Tipo_se_exit,
case 
when Tipo_socia_nivel='DIAMANTE'  then 1
when Tipo_socia_nivel='PLATINUM'  then 2
when Tipo_socia_nivel='ORO'  then 3
when Tipo_socia_nivel='PLATA'  then 4
when Tipo_socia_nivel='PRE-PLATA'  then 5
when Tipo_socia_nivel='BRONCE'  then 6
when Tipo_socia_nivel='PRE-BRONCE'  then 7
ELSE 0
end
as Tipo_se_nivel,
case 
when Tipo_socia_estable='Crítica' THEN 1
when Tipo_socia_estable='EsTABLE' THEN 2
when Tipo_socia_estable='Productiva' THEN 3
ELSE 0
end
as Tipo_se_est,
case 
when ISNULL(A.C18_Cod_Status,0)='INGRESO'   then  1 
when ISNULL(A.C18_Cod_Status,0)='NORMALES'  then  2 
when ISNULL(A.C18_Cod_Status,0)='REINGRESO' then  3
else 0
end
AS Cod_Status_UC,
case 
when ISNULL(A.C18_Constancia,0) in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6')  then  1 
when ISNULL(A.C18_Constancia,0) in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6')  then  2 
else 0
end
AS Constancia_UC,
ISNULL(A.C18_FlagIpUnico,0) AS FlagIpUnico_UC,
CASE 
WHEN ISNULL(A.C18_Comp_Rolling,0)  IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 
WHEN ISNULL(A.C18_Comp_Rolling,0) IN ('Constantes 3','Inconstantes') THEN 2 END 
AS Comp_Rolling_UC,
ISNULL(A.C18_FlagPasoPedido,0) AS FlagPasoPedido_UC,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END )/3 AS Pc_Status_Corp_Norm_3C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END )/4 AS Pc_Status_Corp_Norm_4C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END )/5 AS Pc_Status_Corp_Norm_5C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END )/6 AS Pc_Status_Corp_Norm_6C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END )/9 AS Pc_Status_Corp_Norm_9C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END )/12 AS Pc_Status_Corp_Norm_12C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END )/15 AS Pc_Status_Corp_Norm_15C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Cod_Status,0)='NORMALES' THEN 1 ELSE 0 END )/18 AS Pc_Status_Corp_Norm_18C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END )/3 AS Pc_Status_Corp_Reingreso_3C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END )/4 AS Pc_Status_Corp_Reingreso_4C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END )/5 AS Pc_Status_Corp_Reingreso_5C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END )/6 AS Pc_Status_Corp_Reingreso_6C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END )/9 AS Pc_Status_Corp_Reingreso_9C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END )/12 AS Pc_Status_Corp_Reingreso_12C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END )/15 AS Pc_Status_Corp_Reingreso_15C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Cod_Status,0)='REINGRESO' THEN 1 ELSE 0 END )/18 AS Pc_Status_Corp_Reingreso_18C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END )/3 AS Pc_Status_Corp_Retirada_3C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END )/4 AS Pc_Status_Corp_Retirada_4C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END )/5 AS Pc_Status_Corp_Retirada_5C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END )/6 AS Pc_Status_Corp_Retirada_6C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END )/9 AS Pc_Status_Corp_Retirada_9C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END )/12 AS Pc_Status_Corp_Retirada_12C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END )/15 AS Pc_Status_Corp_Retirada_15C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Cod_Status,0)='RETIRADA' THEN 1 ELSE 0 END )/18 AS Pc_Status_Corp_Retirada_18C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END )/3 AS Pc_Status_Corp_Egresada_3C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END )/4 AS Pc_Status_Corp_Egresada_4C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END )/5 AS Pc_Status_Corp_Egresada_5C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END )/6 AS Pc_Status_Corp_Egresada_6C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END )/9 AS Pc_Status_Corp_Egresada_9C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END )/12 AS Pc_Status_Corp_Egresada_12C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END )/15 AS Pc_Status_Corp_Egresada_15C,
1.0*(CASE WHEN ISNULL(C18_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Cod_Status,0)='EGRESADA' THEN 1 ELSE 0 END )/18 AS Pc_Status_Corp_Egresada_18C,

CASE WHEN C18_Comp_Rolling IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 WHEN C18_Comp_Rolling IN ('Constantes 3','Inconstantes') THEN 0 END AS FlagTipoRolling_uc,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END )/3 AS Pc_tipo_rolling_3C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END )/4 AS Pc_tipo_rolling_4C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END )/5 AS Pc_tipo_rolling_5C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END )/6 AS Pc_tipo_rolling_6C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END )/9 AS Pc_tipo_rolling_9C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END )/12 AS Pc_tipo_rolling_12C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END )/15 AS Pc_tipo_rolling_15C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Comp_Rolling,0)IN ('Brilla','Tops','Constantes 1','Constantes 2') THEN 1 ELSE 0 END )/18 AS Pc_tipo_rolling_18C,

1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END )/3 AS Pc_Rolling_CONSTANTE_2_3C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END )/4 AS Pc_Rolling_CONSTANTE_2_4C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END )/5 AS Pc_Rolling_CONSTANTE_2_5C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END )/6 AS Pc_Rolling_CONSTANTE_2_6C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END )/9 AS Pc_Rolling_CONSTANTE_2_9C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END )/12 AS Pc_Rolling_CONSTANTE_2_12C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END )/15 AS Pc_Rolling_CONSTANTE_2_15C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Comp_Rolling,0)='CONSTANTES 2' THEN 1 ELSE 0 END )/18 AS Pc_Rolling_CONSTANTE_2_18C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END )/3 AS Pc_Rolling_CONSTANTE_3_3C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END )/4 AS Pc_Rolling_CONSTANTE_3_4C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END )/5 AS Pc_Rolling_CONSTANTE_3_5C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END )/6 AS Pc_Rolling_CONSTANTE_3_6C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END )/9 AS Pc_Rolling_CONSTANTE_3_9C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END )/12 AS Pc_Rolling_CONSTANTE_3_12C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END )/15 AS Pc_Rolling_CONSTANTE_3_15C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Comp_Rolling,0)='CONSTANTES 3' THEN 1 ELSE 0 END )/18 AS Pc_Rolling_CONSTANTE_3_18C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END )/3 AS Pc_Rolling_INCONSTANTES_3C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END )/4 AS Pc_Rolling_INCONSTANTES_4C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END )/5 AS Pc_Rolling_INCONSTANTES_5C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END )/6 AS Pc_Rolling_INCONSTANTES_6C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END )/9 AS Pc_Rolling_INCONSTANTES_9C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END )/12 AS Pc_Rolling_INCONSTANTES_12C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END )/15 AS Pc_Rolling_INCONSTANTES_15C,
1.0*(CASE WHEN ISNULL(C18_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Comp_Rolling,0)='INCONSTANTES' THEN 1 ELSE 0 END )/18 AS Pc_Rolling_INCONSTANTES_18C,

1.0*(CASE WHEN ISNULL(C18_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END )/3 AS PC_Constancia_new_3C,
1.0*(CASE WHEN ISNULL(C18_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END )/4 AS PC_Constancia_new_4C,
1.0*(CASE WHEN ISNULL(C18_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END )/5 AS PC_Constancia_new_5C,
1.0*(CASE WHEN ISNULL(C18_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Constancia,0)in ('C_1d1','C_2d2','C_3d3','C_4d4','C_5d5','C_6d6') THEN 1 ELSE 0 END )/6 AS Pc_constancia_new_6C,

1.0*(CASE WHEN ISNULL(C18_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END )/3 AS Pc_Inconstancia_new_3C,
1.0*(CASE WHEN ISNULL(C18_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END )/4 AS Pc_Inconstancia_new_4C,
1.0*(CASE WHEN ISNULL(C18_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END )/5 AS Pc_Inconstancia_new_5C,
1.0*(CASE WHEN ISNULL(C18_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Constancia,0)in ('I_1d2','I_2d3','I_2d4','I_2d5','I_2d6','I_3d4','I_3d5','I_3d6','I_4d5','I_4d6','I_5d6') THEN 1 ELSE 0 END )/6 AS Pc_Inconstancia_new_6C,

CASE WHEN (CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagNoPasoPedido_3C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagNoPasoPedido_4C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagNoPasoPedido_5C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagNoPasoPedido_6C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END)>0 THEN 1 ELSE 0 END  AS FlagNoPasoPedido_9C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C9_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C8_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C7_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END)>0 THEN 1 ELSE 0 END  AS FlagNoPasoPedido_12C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C9_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C8_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C7_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C6_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C5_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C4_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END)>0 THEN 1 ELSE 0 END  AS FlagNoPasoPedido_15C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C9_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C8_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C7_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C6_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C5_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C4_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C3_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C2_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END+CASE WHEN ISNULL(C1_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END)>0 THEN 1 ELSE 0 END  AS FlagNoPasoPedido_18C,
CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END AS N_Camp_No_Paso_Pedido_3C,
CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END AS N_Camp_No_Paso_Pedido_4C,
CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END AS N_Camp_No_Paso_Pedido_5C,
CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END AS N_Camp_No_Paso_Pedido_6C,
CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END AS N_Camp_No_Paso_Pedido_9C,
CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END AS N_Camp_No_Paso_Pedido_12C,
CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END AS N_Camp_No_Paso_Pedido_15C,
CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END AS N_Camp_No_Paso_Pedido_18C,
1.0*(CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )/3 AS Pc_No_Paso_Pedido_3C,
1.0*(CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )/4 AS Pc_No_Paso_Pedido_4C,
1.0*(CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )/5 AS Pc_No_Paso_Pedido_5C,
1.0*(CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )/6 AS Pc_No_Paso_Pedido_6C,
1.0*(CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )/9 AS Pc_No_Paso_Pedido_9C,
1.0*(CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )/12 AS Pc_No_Paso_Pedido_12C,
1.0*(CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )/15 AS Pc_No_Paso_Pedido_15C,
1.0*(CASE WHEN ISNULL(C18_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_FlagPasoPedido,0)='0' THEN 1 ELSE 0 END )/18 AS Pc_No_Paso_Pedido_18C,
CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END AS N_Inactiva_3C,
CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END AS N_Inactiva_4C,
CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END AS N_Inactiva_5C,
CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END AS N_Inactiva_6C,
CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Flagactiva,0)='0' THEN 1 ELSE 0 END AS N_Inactiva_9C,
CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Flagactiva,0)='0' THEN 1 ELSE 0 END AS N_Inactiva_12C,
CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Flagactiva,0)='0' THEN 1 ELSE 0 END AS N_Inactiva_15C,
CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Flagactiva,0)='0' THEN 1 ELSE 0 END AS N_Inactiva_18C,
1.0*(CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END )/3 AS Pc_Inactiva_3C,
1.0*(CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END )/4 AS Pc_Inactiva_4C,
1.0*(CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END )/5 AS Pc_Inactiva_5C,
1.0*(CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END )/6 AS Pc_Inactiva_6C,
1.0*(CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Flagactiva,0)='0' THEN 1 ELSE 0 END )/9 AS Pc_Inactiva_9C,
1.0*(CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Flagactiva,0)='0' THEN 1 ELSE 0 END )/12 AS Pc_Inactiva_12C,
1.0*(CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Flagactiva,0)='0' THEN 1 ELSE 0 END )/15 AS Pc_Inactiva_15C,
1.0*(CASE WHEN ISNULL(C18_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_Flagactiva,0)='0' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_Flagactiva,0)='0' THEN 1 ELSE 0 END )/18 AS Pc_Inactiva_18C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagIPUnico_3C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagIPUnico_4C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagIPUnico_5C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagIPUnico_6C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagIPUnico_9C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagIPUnico_12C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagIPUnico_15C,
CASE WHEN (CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )>0 THEN 1 ELSE 0 END  AS FlagIPUnico_18C,
1.0*(CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )/3 AS Pc_Ipunico_3C,
1.0*(CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )/4 AS Pc_Ipunico_4C,
1.0*(CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )/5 AS Pc_Ipunico_5C,
1.0*(CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )/6 AS Pc_Ipunico_6C,
1.0*(CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )/9 AS Pc_Ipunico_9C,
1.0*(CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )/12 AS Pc_Ipunico_12C,
1.0*(CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )/15 AS Pc_Ipunico_15C,
1.0*(CASE WHEN ISNULL(C18_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C17_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C16_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C15_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C14_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C13_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C12_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C11_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C10_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C9_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C8_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C7_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C6_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C5_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C4_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C3_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C2_FlagIpUnico,0)='1' THEN 1 ELSE 0 END +CASE WHEN ISNULL(C1_FlagIpUnico,0)='1' THEN 1 ELSE 0 END )/18 AS Pc_Ipunico_18C
INTO ##KR_MCC_DATOST1 
from ##KR_MCC_DATOST A
---431865

----------Agregando target y Tipo:

ALTER TABLE ##KR_MCC_DATOST1
--DROP COLUMN T_NUEVA, [TARGET]
ADD T_NUEVA INT, [TARGET] INT
GO

UPDATE ##KR_MCC_DATOST1
SET 
T_NUEVA=CASE WHEN B.TIPO='nuevas' THEN 1 ELSE 0 END,
[TARGET]=B.[TARGET]
FROM ##KR_MCC_DATOST1 A,##KR_TARGET_FUGA B
WHERE A.PKEBELISTA=B.PKEBELISTA AND A.ANIOCAMPANA=B.ANIOCAMPANAUC
--401049

DELETE FROM ##KR_MCC_DATOST1 WHERE [TARGET] IS NULL
--30816

--DROP TABLE KR_MCC_DATOST1
DROP TABLE ##KR_MCC_DATOS, ##KR_MCC_DATOS1,##KR_MCC_COMP,##KR_NCAMP,##KR_CONSTANCIA,##KR_CONSTANCIA1,##KR_COMP_ROLLING,##KR_COMP_ROLLING1,##KR_COD_STATUS,##KR_COD_STATUS1,##FLAGIPUNICO,##FLAGIPUNICO1,##FLAGPASOPEDIDO,##FLAGPASOPEDIDO1,##FLAGACTIVA,##FLAGACTIVA1,##KR_MCC_ANT,##KR_MCC_ANTW,##KR_MCC_DATOS2,##KR_MCC_DATOS_201710,##KR_MCC_DATOS_201711,##KR_MCC_DATOS_201714

--select * from KR_MCC_DATOST1_E2


ALTER PROCEDURE KR_MATRIZ_VEN_MCT_V1
@CodPais CHAR(2),
@AnioCampana CHAR(6)

AS

BEGIN

SET NOCOUNT ON;

--declare @AnioCampana CHAR(6)
--declare @CodPais CHAR(2)

--set @CodPais = 'CO'
--set @AnioCampana = '201710'


declare @AnioCampanamenos1 CHAR(6),
	 @AnioCampanamenos2 CHAR(6),
	 @AnioCampanamenos3 CHAR(6),
	 @AnioCampanamenos4 CHAR(6),
	 @AnioCampanamenos5 CHAR(6),
	 @AnioCampanamenos8 CHAR(6),
	 @AnioCampanamenos11 CHAR(6),
	 @AnioCampanamenos14 CHAR(6),
	 @AnioCampanamenos17 CHAR(6)

set @AnioCampanamenos1 = dbo.CalculaAnioCampana(@AnioCampana, -1)
set @AnioCampanamenos2 = dbo.CalculaAnioCampana(@AnioCampana, -2)
set @AnioCampanamenos3 = dbo.CalculaAnioCampana(@AnioCampana, -3)
set @AnioCampanamenos4 = dbo.CalculaAnioCampana(@AnioCampana, -4)
set @AnioCampanamenos5 = dbo.CalculaAnioCampana(@AnioCampana, -5)
set @AnioCampanamenos8 = dbo.CalculaAnioCampana(@AnioCampana, -8)
set @AnioCampanamenos11 = dbo.CalculaAnioCampana(@AnioCampana, -11)
set @AnioCampanamenos14 = dbo.CalculaAnioCampana(@AnioCampana, -14)
set @AnioCampanamenos17 = dbo.CalculaAnioCampana(@AnioCampana, -17)

IF OBJECT_ID('tempdb..#TMP_MarcaCategoria') IS NOT NULL DROP TABLE #TMP_MarcaCategoria

--select A.CodPais,A.aniocampana,A.pkebelista,
--	   count(distinct CodMarca) NumMarca,
--	   count(distinct descategoria) NumCategorias, 
--	   count(distinct codmarca + descategoria) NumMarcaCategUC
--INTO #TMP_FVTAPROEBECAM
--FROM [DWH_ANALITICO].[dbo].[DWH_FVTAPROEBECAM]  A
--inner JOIN  [DWH_ANALITICO].[dbo].[DWH_DTIPOOFERTA] B  ON A.PKTipoOferta = B.PKTipoOferta AND B.CodPais = A.CodPais 
----inner JOIN  [DWH_ANALITICO].[dbo].[DWH_dmatrizcampana] C  
----		ON A.Codventa = C.Codventa and A.Aniocampana = C.Aniocampana and A.PkProducto = C.PkProducto 
----		AND C.CodPais = A.CodPais AND A.CodCanalVenta = C.CodCanalVenta AND A.PkTipoOferta = C.PkTipoOferta
--inner JOIN  [DWH_ANALITICO].[dbo].[DWH_dproducto] D  ON A.Pkproducto = D.Pkproducto AND D.CodPais= A.CodPais 
--where D.CodMarca in ('A','B','C')
--and D.descategoria in ('CUIDADO PERSONAL','FRAGANCIAS','MAQUILLAJE','TRATAMIENTO CORPORAL','TRATAMIENTO FACIAL')
--and B.CodTipoOferta not in ('030','031','040','051','061','062','065','066','068','071','072','077','078','079','082','083','085','090','093','109','050','082','091','098')
--and B.CodTipoProfit ='01'
--and A.CodVenta<> '00000'
--and RealUUVendidas>0 and RealVtaMNNeto>0
--AND A.ANIOCAMPANA BETWEEN @AnioCampanamenos17 AND @AnioCampana AND A.CodPais = @CodPais 
--AND a.aniocampana=a.aniocampanaref
--group by A.CodPais,A.aniocampana,A.pkebelista

select A.CodPais,A.aniocampana,A.pkebelista,
	   CodMarca,descategoria
INTO #TMP_MarcaCategoria
FROM [DWH_ANALITICO].[dbo].[DWH_FVTAPROEBECAM]  A
inner JOIN  [DWH_ANALITICO].[dbo].[DWH_DTIPOOFERTA] B  ON A.PKTipoOferta = B.PKTipoOferta AND B.CodPais = A.CodPais 
inner JOIN  [DWH_ANALITICO].[dbo].[DWH_dproducto] D  ON A.Pkproducto = D.Pkproducto AND D.CodPais= A.CodPais 
where D.CodMarca in ('A','B','C')
and D.descategoria in ('CUIDADO PERSONAL','FRAGANCIAS','MAQUILLAJE','TRATAMIENTO CORPORAL','TRATAMIENTO FACIAL')
and B.CodTipoOferta not in ('030','031','040','051','061','062','065','066','068','071','072','077','078','079','082','083','085','090','093','109','050','082','091','098')
and B.CodTipoProfit ='01'
and A.CodVenta<> '00000'
and RealUUVendidas>0 and RealVtaMNNeto>0
AND A.ANIOCAMPANA BETWEEN @AnioCampanamenos17 AND @AnioCampana AND A.CodPais = @CodPais 
AND a.aniocampana=a.aniocampanaref
GROUP BY A.CodPais,A.aniocampana,A.pkebelista, CodMarca,descategoria

CREATE INDEX IDX_Pais_EbeCam_MCategoria ON #TMP_MarcaCategoria (CodPais,AnioCampana,PkEbelista)


IF OBJECT_ID('tempdb..#TMP_FVTAPROEBECAM') IS NOT NULL DROP TABLE #TMP_FVTAPROEBECAM

SELECT CodPais,aniocampana,pkebelista,
	   COUNT(DISTINCT CodMarca) as NumMarca,
	   COUNT(DISTINCT DesCategoria) as NumCategorias,
	   COUNT(DISTINCT CodMarca + DesCategoria) as NumMarcaCategUC
INTO #TMP_FVTAPROEBECAM
FROM #TMP_MarcaCategoria 
GROUP BY CodPais, AnioCampana, PkEbelista

CREATE INDEX IDX_Pais_EbeCam_MC ON #TMP_FVTAPROEBECAM (CodPais,AnioCampana,PkEbelista)


IF OBJECT_ID('tempdb..#KR_VEN_CAMP_MCT_TOT') IS NOT NULL DROP TABLE #KR_VEN_CAMP_MCT_TOT

;WITH AnioCampana AS
( 
	SELECT CodPais,AnioCampana,Pkebelista,
		1.0*SUM(NumMarca)/1 AS UC_NumMarca,
		1.0*SUM(NumCategorias)/1 AS UC_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/1 AS UC_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampana
	GROUP BY CodPais, AnioCampana,Pkebelista
), AnioCampanaMenos1 AS 
(	

		SELECT CodPais,Pkebelista,
		1.0*SUM(NumMarca)/2 AS U2C_NumMarca,
		1.0*SUM(NumCategorias)/2 AS U2C_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/2 AS U2C_NumMarcaCategUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarca ELSE 0 END)/1 AS U2C_NumMarca_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumCategorias ELSE 0 END)/1 AS U2C_NumCategorias_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarcaCategUC ELSE 0 END)/1 AS U2C_NumMarcaCategUC_SUC,
		AVG(NumMarca) AS U2C_PRO_NumMarca,
		AVG(NumCategorias) AS U2C_PRO_NumCategorias,
		AVG(NumMarcaCategUC) AS U2C_PRO_NumMarcaCategUC,
		STDEV(NumMarca) AS U2C_DESV_NumMarca,
		STDEV(NumCategorias) AS U2C_DESV_NumCategorias,
		STDEV(NumMarcaCategUC) AS U2C_DESV_NumMarcaCategUC,
		MIN(NumMarca) AS U2C_MIN_NumMarca,
		MIN(NumCategorias) AS U2C_MIN_NumCategorias,
		MIN(NumMarcaCategUC) AS U2C_MIN_NumMarcaCategUC,
		MAX(NumMarca) AS U2C_MAX_NumMarca,
		MAX(NumCategorias) AS U2C_MAX_NumCategorias,
		MAX(NumMarcaCategUC) AS U2C_MAX_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampanamenos1
	GROUP BY CodPais,Pkebelista
), AnioCampanaMenos2 AS 
(	
		SELECT CodPais,Pkebelista,
		1.0*SUM(NumMarca)/3 AS U3C_NumMarca,
		1.0*SUM(NumCategorias)/3 AS U3C_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/3 AS U3C_NumMarcaCategUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarca ELSE 0 END)/2 AS U3C_NumMarca_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumCategorias ELSE 0 END)/2 AS U3C_NumCategorias_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarcaCategUC ELSE 0 END)/2 AS U3C_NumMarcaCategUC_SUC,
		AVG(NumMarca) AS U3C_PRO_NumMarca,
		AVG(NumCategorias) AS U3C_PRO_NumCategorias,
		AVG(NumMarcaCategUC) AS U3C_PRO_NumMarcaCategUC,
		STDEV(NumMarca) AS U3C_DESV_NumMarca,
		STDEV(NumCategorias) AS U3C_DESV_NumCategorias,
		STDEV(NumMarcaCategUC) AS U3C_DESV_NumMarcaCategUC,
		MIN(NumMarca) AS U3C_MIN_NumMarca,
		MIN(NumCategorias) AS U3C_MIN_NumCategorias,
		MIN(NumMarcaCategUC) AS U3C_MIN_NumMarcaCategUC,
		MAX(NumMarca) AS U3C_MAX_NumMarca,
		MAX(NumCategorias) AS U3C_MAX_NumCategorias,
		MAX(NumMarcaCategUC) AS U3C_MAX_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampanamenos2
	GROUP BY CodPais, Pkebelista
), AnioCampanaMenos3 AS 
(
		SELECT CodPais,Pkebelista,
		1.0*SUM(NumMarca)/4 AS U4C_NumMarca,
		1.0*SUM(NumCategorias)/4 AS U4C_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/4 AS U4C_NumMarcaCategUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarca ELSE 0 END)/3 AS U4C_NumMarca_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumCategorias ELSE 0 END)/3 AS U4C_NumCategorias_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarcaCategUC ELSE 0 END)/3 AS U4C_NumMarcaCategUC_SUC,
		AVG(NumMarca) AS U4C_PRO_NumMarca,
		AVG(NumCategorias) AS U4C_PRO_NumCategorias,
		AVG(NumMarcaCategUC) AS U4C_PRO_NumMarcaCategUC,
		STDEV(NumMarca) AS U4C_DESV_NumMarca,
		STDEV(NumCategorias) AS U4C_DESV_NumCategorias,
		STDEV(NumMarcaCategUC) AS U4C_DESV_NumMarcaCategUC,
		MIN(NumMarca) AS U4C_MIN_NumMarca,
		MIN(NumCategorias) AS U4C_MIN_NumCategorias,
		MIN(NumMarcaCategUC) AS U4C_MIN_NumMarcaCategUC,
		MAX(NumMarca) AS U4C_MAX_NumMarca,
		MAX(NumCategorias) AS U4C_MAX_NumCategorias,
		MAX(NumMarcaCategUC) AS U4C_MAX_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampanamenos3
	GROUP BY CodPais, Pkebelista
), AnioCampanaMenos4 AS 
(
		SELECT CodPais,Pkebelista,
		1.0*SUM(NumMarca)/5 AS U5C_NumMarca,
		1.0*SUM(NumCategorias)/5 AS U5C_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/5 AS U5C_NumMarcaCategUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarca ELSE 0 END)/4 AS U5C_NumMarca_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumCategorias ELSE 0 END)/4 AS U5C_NumCategorias_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarcaCategUC ELSE 0 END)/4 AS U5C_NumMarcaCategUC_SUC,
		AVG(NumMarca) AS U5C_PRO_NumMarca,
		AVG(NumCategorias) AS U5C_PRO_NumCategorias,
		AVG(NumMarcaCategUC) AS U5C_PRO_NumMarcaCategUC,
		STDEV(NumMarca) AS U5C_DESV_NumMarca,
		STDEV(NumCategorias) AS U5C_DESV_NumCategorias,
		STDEV(NumMarcaCategUC) AS U5C_DESV_NumMarcaCategUC,
		MIN(NumMarca) AS U5C_MIN_NumMarca,
		MIN(NumCategorias) AS U5C_MIN_NumCategorias,
		MIN(NumMarcaCategUC) AS U5C_MIN_NumMarcaCategUC,
		MAX(NumMarca) AS U5C_MAX_NumMarca,
		MAX(NumCategorias) AS U5C_MAX_NumCategorias,
		MAX(NumMarcaCategUC) AS U5C_MAX_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampanamenos4
	GROUP BY CodPais, Pkebelista
), AnioCampanaMenos5 AS 
(
		SELECT CodPais,Pkebelista,
		1.0*SUM(NumMarca)/6 AS U6C_NumMarca,
		1.0*SUM(NumCategorias)/6 AS U6C_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/6 AS U6C_NumMarcaCategUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarca ELSE 0 END)/5 AS U6C_NumMarca_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumCategorias ELSE 0 END)/5 AS U6C_NumCategorias_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarcaCategUC ELSE 0 END)/5 AS U6C_NumMarcaCategUC_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarca ELSE 0 END)/3 AS U3C_NumMarca_II,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumCategorias ELSE 0 END)/3 AS U3C_NumCategorias_II,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarcaCategUC ELSE 0 END)/3 AS U3C_NumMarcaCategUC_II,
		AVG(NumMarca) AS U6C_PRO_NumMarca,
		AVG(NumCategorias) AS U6C_PRO_NumCategorias,
		AVG(NumMarcaCategUC) AS U6C_PRO_NumMarcaCategUC,
		STDEV(NumMarca) AS U6C_DESV_NumMarca,
		STDEV(NumCategorias) AS U6C_DESV_NumCategorias,
		STDEV(NumMarcaCategUC) AS U6C_DESV_NumMarcaCategUC,
		MIN(NumMarca) AS U6C_MIN_NumMarca,
		MIN(NumCategorias) AS U6C_MIN_NumCategorias,
		MIN(NumMarcaCategUC) AS U6C_MIN_NumMarcaCategUC,
		MAX(NumMarca) AS U6C_MAX_NumMarca,
		MAX(NumCategorias) AS U6C_MAX_NumCategorias,
		MAX(NumMarcaCategUC) AS U6C_MAX_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampanamenos5
	GROUP BY CodPais, Pkebelista
), AnioCampanaMenos8 AS 
(
		SELECT CodPais,Pkebelista,
		1.0*SUM(NumMarca)/9 AS U9C_NumMarca,
		1.0*SUM(NumCategorias)/9 AS U9C_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/9 AS U9C_NumMarcaCategUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarca ELSE 0 END)/8 AS U9C_NumMarca_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumCategorias ELSE 0 END)/8 AS U9C_NumCategorias_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarcaCategUC ELSE 0 END)/8 AS U9C_NumMarcaCategUC_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarca ELSE 0 END)/6 AS U3C_NumMarca_III,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumCategorias ELSE 0 END)/6 AS U3C_NumCategorias_III,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarcaCategUC ELSE 0 END)/6 AS U3C_NumMarcaCategUC_III,
		AVG(NumMarca) AS U9C_PRO_NumMarca,
		AVG(NumCategorias) AS U9C_PRO_NumCategorias,
		AVG(NumMarcaCategUC) AS U9C_PRO_NumMarcaCategUC,
		STDEV(NumMarca) AS U9C_DESV_NumMarca,
		STDEV(NumCategorias) AS U9C_DESV_NumCategorias,
		STDEV(NumMarcaCategUC) AS U9C_DESV_NumMarcaCategUC,
		MIN(NumMarca) AS U9C_MIN_NumMarca,
		MIN(NumCategorias) AS U9C_MIN_NumCategorias,
		MIN(NumMarcaCategUC) AS U9C_MIN_NumMarcaCategUC,
		MAX(NumMarca) AS U9C_MAX_NumMarca,
		MAX(NumCategorias) AS U9C_MAX_NumCategorias,
		MAX(NumMarcaCategUC) AS U9C_MAX_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampanamenos8
	GROUP BY CodPais, Pkebelista
), AnioCampanaMenos11 AS 
(
		SELECT CodPais,Pkebelista,
		1.0*SUM(NumMarca)/12 AS U12C_NumMarca,
		1.0*SUM(NumCategorias)/12 AS U12C_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/12 AS U12C_NumMarcaCategUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarca ELSE 0 END)/11 AS U12C_NumMarca_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumCategorias ELSE 0 END)/11 AS U12C_NumCategorias_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarcaCategUC ELSE 0 END)/11 AS U12C_NumMarcaCategUC_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarca ELSE 0 END)/9 AS U6C_NumMarca_IV,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumCategorias ELSE 0 END)/9 AS U6C_NumCategorias_IV,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarcaCategUC ELSE 0 END)/9 AS U6C_NumMarcaCategUC_IV,
		AVG(NumMarca) AS U12C_PRO_NumMarca,
		AVG(NumCategorias) AS U12C_PRO_NumCategorias,
		AVG(NumMarcaCategUC) AS U12C_PRO_NumMarcaCategUC,
		STDEV(NumMarca) AS U12C_DESV_NumMarca,
		STDEV(NumCategorias) AS U12C_DESV_NumCategorias,
		STDEV(NumMarcaCategUC) AS U12C_DESV_NumMarcaCategUC,
		MIN(NumMarca) AS U12C_MIN_NumMarca,
		MIN(NumCategorias) AS U12C_MIN_NumCategorias,
		MIN(NumMarcaCategUC) AS U12C_MIN_NumMarcaCategUC,
		MAX(NumMarca) AS U12C_MAX_NumMarca,
		MAX(NumCategorias) AS U12C_MAX_NumCategorias,
		MAX(NumMarcaCategUC) AS U12C_MAX_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampanamenos11
	GROUP BY CodPais, Pkebelista
), AnioCampanaMenos14 AS 
(
		SELECT CodPais,Pkebelista,
		1.0*SUM(NumMarca)/15 AS U15C_NumMarca,
		1.0*SUM(NumCategorias)/15 AS U15C_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/15 AS U15C_NumMarcaCategUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarca ELSE 0 END)/14 AS U15C_NumMarca_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumCategorias ELSE 0 END)/14 AS U15C_NumCategorias_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarcaCategUC ELSE 0 END)/14 AS U15C_NumMarcaCategUC_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarca ELSE 0 END)/12 AS U9C_NumMarca_V,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumCategorias ELSE 0 END)/12 AS U9C_NumCategorias_V,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarcaCategUC ELSE 0 END)/12 AS U9C_NumMarcaCategUC_V,
		AVG(NumMarca) AS U15C_PRO_NumMarca,
		AVG(NumCategorias) AS U15C_PRO_NumCategorias,
		AVG(NumMarcaCategUC) AS U15C_PRO_NumMarcaCategUC,
		STDEV(NumMarca) AS U15C_DESV_NumMarca,
		STDEV(NumCategorias) AS U15C_DESV_NumCategorias,
		STDEV(NumMarcaCategUC) AS U15C_DESV_NumMarcaCategUC,
		MIN(NumMarca) AS U15C_MIN_NumMarca,
		MIN(NumCategorias) AS U15C_MIN_NumCategorias,
		MIN(NumMarcaCategUC) AS U15C_MIN_NumMarcaCategUC,
		MAX(NumMarca) AS U15C_MAX_NumMarca,
		MAX(NumCategorias) AS U15C_MAX_NumCategorias,
		MAX(NumMarcaCategUC) AS U15C_MAX_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampanamenos14
	GROUP BY CodPais, Pkebelista
), AnioCampanaMenos17 AS 
(
		SELECT CodPais,Pkebelista,
		1.0*SUM(NumMarca)/18 AS U18C_NumMarca,
		1.0*SUM(NumCategorias)/18 AS U18C_NumCategorias,
		1.0*SUM(NumMarcaCategUC)/18 AS U18C_NumMarcaCategUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarca ELSE 0 END)/17 AS U18C_NumMarca_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumCategorias ELSE 0 END)/17 AS U18C_NumCategorias_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampana THEN NumMarcaCategUC ELSE 0 END)/17 AS U18C_NumMarcaCategUC_SUC,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarca ELSE 0 END)/15 AS U12C_NumMarca_VI,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumCategorias ELSE 0 END)/15 AS U12C_NumCategorias_VI,
		1.0*SUM(CASE WHEN Aniocampana < @AnioCampanaMenos2 THEN NumMarcaCategUC ELSE 0 END)/15 AS U12C_NumMarcaCategUC_VI,
		AVG(NumMarca) AS U18C_PRO_NumMarca,
		AVG(NumCategorias) AS U18C_PRO_NumCategorias,
		AVG(NumMarcaCategUC) AS U18C_PRO_NumMarcaCategUC,
		STDEV(NumMarca) AS U18C_DESV_NumMarca,
		STDEV(NumCategorias) AS U18C_DESV_NumCategorias,
		STDEV(NumMarcaCategUC) AS U18C_DESV_NumMarcaCategUC,
		MIN(NumMarca) AS U18C_MIN_NumMarca,
		MIN(NumCategorias) AS U18C_MIN_NumCategorias,
		MIN(NumMarcaCategUC) AS U18C_MIN_NumMarcaCategUC,
		MAX(NumMarca) AS U18C_MAX_NumMarca,
		MAX(NumCategorias) AS U18C_MAX_NumCategorias,
		MAX(NumMarcaCategUC) AS U18C_MAX_NumMarcaCategUC
	FROM #TMP_FVTAPROEBECAM
	WHERE AnioCampana >= @AnioCampanamenos17
	GROUP BY CodPais, Pkebelista
)
SELECT @AnioCampana as AnioCampana,A.CodPais,A.Pkebelista,
		ISNULL(UC_NumMarca,				0) AS UC_NumMarca,					
		ISNULL(UC_NumCategorias,		0) AS UC_NumCategorias,			
		ISNULL(UC_NumMarcaCategUC,		0) AS UC_NumMarcaCategUC,			
		ISNULL(U2C_NumMarca,			0) AS U2C_NumMarca,				
		ISNULL(U2C_NumCategorias,		0) AS U2C_NumCategorias,
		ISNULL(U2C_NumMarcaCategUC,		0) AS U2C_NumMarcaCategUC,			
		ISNULL(U2C_NumMarca_SUC,		0) AS U2C_NumMarca_SUC,			
		ISNULL(U2C_NumCategorias_SUC,	0) AS U2C_NumCategorias_SUC,		
		ISNULL(U2C_PRO_NumMarca,		0) AS U2C_PRO_NumMarca,				
		ISNULL(U2C_NumMarcaCategUC_SUC,	0) AS U2C_NumMarcaCategUC_SUC,		
		ISNULL(U2C_PRO_NumCategorias,	0) AS U2C_PRO_NumCategorias,		
		ISNULL(U2C_PRO_NumMarcaCategUC,	0) AS U2C_PRO_NumMarcaCategUC,		
		ISNULL(U2C_DESV_NumMarca,		0) AS U2C_DESV_NumMarca,			
		ISNULL(U2C_DESV_NumCategorias,	0) AS U2C_DESV_NumCategorias,		
		ISNULL(U2C_DESV_NumMarcaCategUC,0) AS U2C_DESV_NumMarcaCategUC,	
		ISNULL(U2C_MIN_NumMarca,		0) AS U2C_MIN_NumMarca,			
		ISNULL(U2C_MIN_NumCategorias,	0) AS U2C_MIN_NumCategorias,		
		ISNULL(U2C_MIN_NumMarcaCategUC,	0) AS U2C_MIN_NumMarcaCategUC,		
		ISNULL(U2C_MAX_NumMarca,		0) AS U2C_MAX_NumMarca,			
		ISNULL(U2C_MAX_NumCategorias,	0) AS U2C_MAX_NumCategorias,		
		ISNULL(U2C_MAX_NumMarcaCategUC,	0) AS U2C_MAX_NumMarcaCategUC,		
		ISNULL(U3C_NumMarca,			0) AS U3C_NumMarca,				
		ISNULL(U3C_NumCategorias,		0) AS U3C_NumCategorias,			
		ISNULL(U3C_NumMarcaCategUC,		0) AS U3C_NumMarcaCategUC,			
		ISNULL(U3C_NumMarca_SUC,		0) AS U3C_NumMarca_SUC,			
		ISNULL(U3C_NumCategorias_SUC,	0) AS U3C_NumCategorias_SUC,		
		ISNULL(U3C_NumMarcaCategUC_SUC,	0) AS U3C_NumMarcaCategUC_SUC,		
		ISNULL(U3C_PRO_NumMarca,		0) AS U3C_PRO_NumMarca,			
		ISNULL(U3C_PRO_NumCategorias,	0) AS U3C_PRO_NumCategorias,		
		ISNULL(U3C_PRO_NumMarcaCategUC,	0) AS U3C_PRO_NumMarcaCategUC,		
		ISNULL(U3C_DESV_NumMarca,		0) AS U3C_DESV_NumMarca,			
		ISNULL(U3C_DESV_NumCategorias,	0) AS U3C_DESV_NumCategorias,		
		ISNULL(U3C_DESV_NumMarcaCategUC,0) AS U3C_DESV_NumMarcaCategUC,	
		ISNULL(U3C_MIN_NumMarca,		0) AS U3C_MIN_NumMarca,			
		ISNULL(U3C_MIN_NumCategorias,	0) AS U3C_MIN_NumCategorias,		
		ISNULL(U3C_MIN_NumMarcaCategUC,	0) AS U3C_MIN_NumMarcaCategUC,		
		ISNULL(U3C_MAX_NumMarca,		0) AS U3C_MAX_NumMarca,			
		ISNULL(U3C_MAX_NumCategorias,	0) AS U3C_MAX_NumCategorias,		
		ISNULL(U3C_MAX_NumMarcaCategUC,	0) AS U3C_MAX_NumMarcaCategUC,		
		ISNULL(U4C_NumMarca,			0) AS U4C_NumMarca,				
		ISNULL(U4C_NumCategorias,		0) AS U4C_NumCategorias,			
		ISNULL(U4C_NumMarcaCategUC,		0) AS U4C_NumMarcaCategUC,			
		ISNULL(U4C_NumMarca_SUC,		0) AS U4C_NumMarca_SUC,			
		ISNULL(U4C_NumCategorias_SUC,	0) AS U4C_NumCategorias_SUC,		
		ISNULL(U4C_NumMarcaCategUC_SUC,	0) AS U4C_NumMarcaCategUC_SUC,		
		ISNULL(U4C_PRO_NumMarca,		0) AS U4C_PRO_NumMarca,			
		ISNULL(U4C_PRO_NumCategorias,	0) AS U4C_PRO_NumCategorias,		
		ISNULL(U4C_PRO_NumMarcaCategUC,	0) AS U4C_PRO_NumMarcaCategUC,		
		ISNULL(U4C_DESV_NumMarca,		0) AS U4C_DESV_NumMarca,			
		ISNULL(U4C_DESV_NumCategorias,	0) AS U4C_DESV_NumCategorias,		
		ISNULL(U4C_DESV_NumMarcaCategUC,0) AS U4C_DESV_NumMarcaCategUC,	
		ISNULL(U4C_MIN_NumMarca,		0) AS U4C_MIN_NumMarca,			
		ISNULL(U4C_MIN_NumCategorias,	0) AS U4C_MIN_NumCategorias,		
		ISNULL(U4C_MIN_NumMarcaCategUC,	0) AS U4C_MIN_NumMarcaCategUC,		
		ISNULL(U4C_MAX_NumMarca,		0) AS U4C_MAX_NumMarca,			
		ISNULL(U4C_MAX_NumCategorias,	0) AS U4C_MAX_NumCategorias,		
		ISNULL(U4C_MAX_NumMarcaCategUC,	0) AS U4C_MAX_NumMarcaCategUC,		
		ISNULL(U5C_NumMarca,			0) AS U5C_NumMarca,				
		ISNULL(U5C_NumCategorias,		0) AS U5C_NumCategorias,			
		ISNULL(U5C_NumMarcaCategUC,		0) AS U5C_NumMarcaCategUC,			
		ISNULL(U5C_NumMarca_SUC,		0) AS U5C_NumMarca_SUC,			
		ISNULL(U5C_NumCategorias_SUC,	0) AS U5C_NumCategorias_SUC,		
		ISNULL(U5C_NumMarcaCategUC_SUC,	0) AS U5C_NumMarcaCategUC_SUC,		
		ISNULL(U5C_PRO_NumMarca,		0) AS U5C_PRO_NumMarca,			
		ISNULL(U5C_PRO_NumCategorias,	0) AS U5C_PRO_NumCategorias,		
		ISNULL(U5C_PRO_NumMarcaCategUC,	0) AS U5C_PRO_NumMarcaCategUC,		
		ISNULL(U5C_DESV_NumMarca,		0) AS U5C_DESV_NumMarca,			
		ISNULL(U5C_DESV_NumCategorias,	0) AS U5C_DESV_NumCategorias,		
		ISNULL(U5C_DESV_NumMarcaCategUC,0) AS U5C_DESV_NumMarcaCategUC,	
		ISNULL(U5C_MIN_NumMarca,		0) AS U5C_MIN_NumMarca,			
		ISNULL(U5C_MIN_NumCategorias,	0) AS U5C_MIN_NumCategorias,		
		ISNULL(U5C_MIN_NumMarcaCategUC,	0) AS U5C_MIN_NumMarcaCategUC,		
		ISNULL(U5C_MAX_NumMarca,		0) AS U5C_MAX_NumMarca,			
		ISNULL(U5C_MAX_NumCategorias,	0) AS U5C_MAX_NumCategorias,		
		ISNULL(U5C_MAX_NumMarcaCategUC,	0) AS U5C_MAX_NumMarcaCategUC,		
		ISNULL(U6C_NumMarca,			0) AS U6C_NumMarca,				
		ISNULL(U6C_NumCategorias,		0) AS U6C_NumCategorias,			
		ISNULL(U6C_NumMarcaCategUC,		0) AS U6C_NumMarcaCategUC,			
		ISNULL(U6C_NumMarca_SUC,		0) AS U6C_NumMarca_SUC,			
		ISNULL(U6C_NumCategorias_SUC,	0) AS U6C_NumCategorias_SUC,		
		ISNULL(U6C_NumMarcaCategUC_SUC,	0) AS U6C_NumMarcaCategUC_SUC,		
		ISNULL(U3C_NumMarca_II,			0) AS U3C_NumMarca_II,				
		ISNULL(U3C_NumCategorias_II,	0) AS U3C_NumCategorias_II,		
		ISNULL(U3C_NumMarcaCategUC_II,	0) AS U3C_NumMarcaCategUC_II,		
		ISNULL(U6C_PRO_NumMarca,		0) AS U6C_PRO_NumMarca,			
		ISNULL(U6C_PRO_NumCategorias,	0) AS U6C_PRO_NumCategorias,		
		ISNULL(U6C_PRO_NumMarcaCategUC,	0) AS U6C_PRO_NumMarcaCategUC,		
		ISNULL(U6C_DESV_NumMarca,		0) AS U6C_DESV_NumMarca,			
		ISNULL(U6C_DESV_NumCategorias,	0) AS U6C_DESV_NumCategorias,		
		ISNULL(U6C_DESV_NumMarcaCategUC,0) AS U6C_DESV_NumMarcaCategUC,	
		ISNULL(U6C_MIN_NumMarca,		0) AS U6C_MIN_NumMarca,			
		ISNULL(U6C_MIN_NumCategorias,	0) AS U6C_MIN_NumCategorias,		
		ISNULL(U6C_MIN_NumMarcaCategUC,	0) AS U6C_MIN_NumMarcaCategUC,		
		ISNULL(U6C_MAX_NumMarca,		0) AS U6C_MAX_NumMarca,			
		ISNULL(U6C_MAX_NumCategorias,	0) AS U6C_MAX_NumCategorias,		
		ISNULL(U6C_MAX_NumMarcaCategUC,	0) AS U6C_MAX_NumMarcaCategUC,		
		ISNULL(U9C_NumMarca,			0) AS U9C_NumMarca,				
		ISNULL(U9C_NumCategorias,		0) AS U9C_NumCategorias,			
		ISNULL(U9C_NumMarcaCategUC,		0) AS U9C_NumMarcaCategUC,			
		ISNULL(U9C_NumMarca_SUC,		0) AS U9C_NumMarca_SUC,			
		ISNULL(U9C_NumCategorias_SUC,	0) AS U9C_NumCategorias_SUC,		
		ISNULL(U9C_NumMarcaCategUC_SUC,	0) AS U9C_NumMarcaCategUC_SUC,		
		ISNULL(U3C_NumMarca_III,		0) AS U3C_NumMarca_III,			
		ISNULL(U3C_NumCategorias_III,	0) AS U3C_NumCategorias_III,		
		ISNULL(U3C_NumMarcaCategUC_III,	0) AS U3C_NumMarcaCategUC_III,		
		ISNULL(U9C_PRO_NumMarca,		0) AS U9C_PRO_NumMarca,			
		ISNULL(U9C_PRO_NumCategorias,	0) AS U9C_PRO_NumCategorias,		
		ISNULL(U9C_PRO_NumMarcaCategUC,	0) AS U9C_PRO_NumMarcaCategUC,		
		ISNULL(U9C_DESV_NumMarca,		0) AS U9C_DESV_NumMarca,			
		ISNULL(U9C_DESV_NumCategorias,	0) AS U9C_DESV_NumCategorias,		
		ISNULL(U9C_DESV_NumMarcaCategUC,0) AS U9C_DESV_NumMarcaCategUC,	
		ISNULL(U9C_MIN_NumMarca,		0) AS U9C_MIN_NumMarca,			
		ISNULL(U9C_MIN_NumCategorias,	0) AS U9C_MIN_NumCategorias,		
		ISNULL(U9C_MIN_NumMarcaCategUC,	0) AS U9C_MIN_NumMarcaCategUC,		
		ISNULL(U9C_MAX_NumMarca,		0) AS U9C_MAX_NumMarca,			
		ISNULL(U9C_MAX_NumCategorias,	0) AS U9C_MAX_NumCategorias,		
		ISNULL(U9C_MAX_NumMarcaCategUC,	0) AS U9C_MAX_NumMarcaCategUC,		
		ISNULL(U12C_NumMarca,			0) AS U12C_NumMarca,				
		ISNULL(U12C_NumCategorias,		0) AS U12C_NumCategorias,			
		ISNULL(U12C_NumMarcaCategUC,	0) AS U12C_NumMarcaCategUC,		
		ISNULL(U12C_NumMarca_SUC,		0) AS U12C_NumMarca_SUC,			
		ISNULL(U12C_NumCategorias_SUC,	0) AS U12C_NumCategorias_SUC,		
		ISNULL(U12C_NumMarcaCategUC_SUC,0) AS U12C_NumMarcaCategUC_SUC,	
		ISNULL(U6C_NumMarca_IV,			0) AS U6C_NumMarca_IV,				
		ISNULL(U6C_NumCategorias_IV,	0) AS U6C_NumCategorias_IV,		
		ISNULL(U6C_NumMarcaCategUC_IV,	0) AS U6C_NumMarcaCategUC_IV,		
		ISNULL(U12C_PRO_NumMarca,		0) AS U12C_PRO_NumMarca,			
		ISNULL(U12C_PRO_NumCategorias,	0) AS U12C_PRO_NumCategorias,		
		ISNULL(U12C_PRO_NumMarcaCategUC,0) AS U12C_PRO_NumMarcaCategUC,	
		ISNULL(U12C_DESV_NumMarca,		0) AS U12C_DESV_NumMarca,			
		ISNULL(U12C_DESV_NumCategorias,	0) AS U12C_DESV_NumCategorias,		
		ISNULL(U12C_DESV_NumMarcaCategUC,0) AS U12C_DESV_NumMarcaCategUC,	
		ISNULL(U12C_MIN_NumMarca,		0) AS U12C_MIN_NumMarca,			
		ISNULL(U12C_MIN_NumCategorias,	0) AS U12C_MIN_NumCategorias,		
		ISNULL(U12C_MIN_NumMarcaCategUC,0) AS U12C_MIN_NumMarcaCategUC,	
		ISNULL(U12C_MAX_NumMarca,		0) AS U12C_MAX_NumMarca,			
		ISNULL(U12C_MAX_NumCategorias,	0) AS U12C_MAX_NumCategorias,		
		ISNULL(U12C_MAX_NumMarcaCategUC,0) AS U12C_MAX_NumMarcaCategUC,	
		ISNULL(U15C_NumMarca,			0) AS U15C_NumMarca,				
		ISNULL(U15C_NumCategorias,		0) AS U15C_NumCategorias,			
		ISNULL(U15C_NumMarcaCategUC,	0) AS U15C_NumMarcaCategUC,		
		ISNULL(U15C_NumMarca_SUC,		0) AS U15C_NumMarca_SUC,			
		ISNULL(U15C_NumCategorias_SUC,	0) AS U15C_NumCategorias_SUC,		
		ISNULL(U15C_NumMarcaCategUC_SUC,0) AS U15C_NumMarcaCategUC_SUC,	
		ISNULL(U9C_NumMarca_V,			0) AS U9C_NumMarca_V,				
		ISNULL(U9C_NumCategorias_V,		0) AS U9C_NumCategorias_V,			
		ISNULL(U9C_NumMarcaCategUC_V,	0) AS U9C_NumMarcaCategUC_V,		
		ISNULL(U15C_PRO_NumMarca,		0) AS U15C_PRO_NumMarca,			
		ISNULL(U15C_PRO_NumCategorias,	0) AS U15C_PRO_NumCategorias,		
		ISNULL(U15C_PRO_NumMarcaCategUC,0) AS U15C_PRO_NumMarcaCategUC,	
		ISNULL(U15C_DESV_NumMarca,		0) AS U15C_DESV_NumMarca,			
		ISNULL(U15C_DESV_NumCategorias,	0) AS U15C_DESV_NumCategorias,		
		ISNULL(U15C_DESV_NumMarcaCategUC,0) AS U15C_DESV_NumMarcaCategUC,	
		ISNULL(U15C_MIN_NumMarca,		0) AS U15C_MIN_NumMarca,			
		ISNULL(U15C_MIN_NumCategorias,	0) AS U15C_MIN_NumCategorias,		
		ISNULL(U15C_MIN_NumMarcaCategUC,0) AS U15C_MIN_NumMarcaCategUC,	
		ISNULL(U15C_MAX_NumMarca,		0) AS U15C_MAX_NumMarca,			
		ISNULL(U15C_MAX_NumCategorias,	0) AS U15C_MAX_NumCategorias,		
		ISNULL(U15C_MAX_NumMarcaCategUC,0) AS U15C_MAX_NumMarcaCategUC,	
		ISNULL(U18C_NumMarca,			0) AS U18C_NumMarca,				
		ISNULL(U18C_NumCategorias,		0) AS U18C_NumCategorias,			
		ISNULL(U18C_NumMarcaCategUC,	0) AS U18C_NumMarcaCategUC,		
		ISNULL(U18C_NumMarca_SUC,		0) AS U18C_NumMarca_SUC,			
		ISNULL(U18C_NumCategorias_SUC,	0) AS U18C_NNumCategorias_SUC,		
		ISNULL(U18C_NumMarcaCategUC_SUC,0) AS U18C_NumMarcaCategUC_SUC,	
		ISNULL(U12C_NumMarca_VI,			0) AS U12C_NumMarca_VI,				
		ISNULL(U12C_NumCategorias_VI,	0) AS U12C_NumCategorias_VI,		
		ISNULL(U12C_NumMarcaCategUC_VI,	0) AS U12C_NumMarcaCategUC_VI,		
		ISNULL(U18C_PRO_NumMarca,		0) AS U18C_PRO_NumMarca,			
		ISNULL(U18C_PRO_NumCategorias,	0) AS U18C_PRO_NumCategorias,		
		ISNULL(U18C_PRO_NumMarcaCategUC,0) AS U18C_PRO_NumMarcaCategUC,	
		ISNULL(U18C_DESV_NumMarca,		0) AS U18C_DESV_NumMarca,			
		ISNULL(U18C_DESV_NumCategorias,	0) AS U18C_DESV_NumCategorias,		
		ISNULL(U18C_DESV_NumMarcaCategUC,0) AS U18C_DESV_NumMarcaCategUC,	
		ISNULL(U18C_MIN_NumMarca,		0) AS U18C_MIN_NumMarca,			
		ISNULL(U18C_MIN_NumCategorias,	0) AS U18C_MIN_NumCategorias,		
		ISNULL(U18C_MIN_NumMarcaCategUC,0) AS U18C_MIN_NumMarcaCategUC,	
		ISNULL(U18C_MAX_NumMarca,		0) AS U18C_MAX_NumMarca,			
		ISNULL(U18C_MAX_NumCategorias,	0) AS U18C_MAX_NumCategorias,		
		ISNULL(U18C_MAX_NumMarcaCategUC,0) AS U18C_MAX_NumMarcaCategUC		
INTO #KR_VEN_CAMP_MCT_TOT 
FROM AnioCampanaMenos17 A 
LEFT JOIN AnioCampanaMenos14 B ON A.CodPais = B.CodPais AND A.PkEbelista = B.Pkebelista
LEFT JOIN AnioCampanaMenos11 C ON A.CodPais = C.CodPais AND A.Pkebelista = C.PkEbelista
LEFT JOIN AnioCampanaMenos8 D ON A.CodPais = D.CodPais AND A.Pkebelista = D.PkEbelista
LEFT JOIN AnioCampanaMenos5 E ON A.CodPais = E.CodPais AND A.Pkebelista = E.PkEbelista
LEFT JOIN AnioCampanaMenos4 F ON A.CodPais = F.CodPais AND A.Pkebelista = F.PkEbelista
LEFT JOIN AnioCampanaMenos3 G ON A.CodPais = G.CodPais AND A.Pkebelista = G.PkEbelista
LEFT JOIN AnioCampanaMenos2 H ON A.CodPais = H.CodPais AND A.Pkebelista = H.PkEbelista
LEFT JOIN AnioCampanaMenos1 I ON A.CodPais = I.CodPais AND A.Pkebelista = I.PkEbelista
LEFT JOIN AnioCampana J ON A.CodPais = J.CodPais AND A.Pkebelista = J.PkEbelista

--IF OBJECT_ID ('tempdb..#KR_TARGET_FUGA1') IS NOT NULL DROP TABLE #KR_TARGET_FUGA1

--DECLARE @AnioCampanaCx2 CHAR(6)
--SET @AnioCampanaCx2 = dbo.CalculaAnioCampana(@AnioCampana,2)

--CREATE TABLE #KR_TARGET_FUGA1
--(
--	AnioCampanaT CHAR(6),
--	AnioCampanaUC CHAR(6),
--	CodPais CHAR(2),
--	[Target] INT,
--	PKEbelista INT,
--	Tipo VARCHAR(12),
--	Cx_Status VARCHAR(15),
--	Cx1_Status VARCHAR(15),
--	Cx2_Status VARCHAR(15),
--	Cx_Activa tinyint,
--	Cx1_Activa tinyint,
--	Cx2_Activa tinyint,
--	Cx_Comp_Rolling VARCHAR(20),
--	Cx1_Comp_Rolling VARCHAR(20),
--	Cx2_Comp_Rolling VARCHAR(20),
--	Cx_PasoPedido tinyint,
--	Cx1_PasoPedido tinyint,
--	Cx2_PasoPedido tinyint,
--)

--INSERT INTO #KR_TARGET_FUGA1
--EXEC BD_ANALITICO.dbo.KR_MATRIZ_TARG_V1 @CodPais,@AnioCampanaCx2


IF OBJECT_ID('tempdb..#KR_VEN_MCT_TF') IS NOT NULL DROP TABLE #KR_VEN_MCT_TF;


SELECT 
A.AnioCampana,
--B.[Target],
A.PkEbelista,
ISNULL(A.UC_NumMarca,0) AS UC_NumMarca,
ISNULL(A.U2C_NumMarca,0) AS U2C_NumMarca,
ISNULL(A.U3C_NumMarca,0) AS U3C_NumMarca,
ISNULL(A.U4C_NumMarca,0) AS U4C_NumMarca,
ISNULL(A.U5C_NumMarca,0) AS U5C_NumMarca,
ISNULL(A.U6C_NumMarca,0) AS U6C_NumMarca,
ISNULL(A.U9C_NumMarca,0) AS U9C_NumMarca,
ISNULL(A.U12C_NumMarca,0) AS U12C_NumMarca,
ISNULL(A.U15C_NumMarca,0) AS U15C_NumMarca,
ISNULL(A.U18C_NumMarca,0) AS U18C_NumMarca,
ISNULL(A.UC_NumCategorias,0) AS UC_NumCategorias,
ISNULL(A.U2C_NumCategorias,0) AS U2C_NumCategorias,
ISNULL(A.U3C_NumCategorias,0) AS U3C_NumCategorias,
ISNULL(A.U4C_NumCategorias,0) AS U4C_NumCategorias,
ISNULL(A.U5C_NumCategorias,0) AS U5C_NumCategorias,
ISNULL(A.U6C_NumCategorias,0) AS U6C_NumCategorias,
ISNULL(A.U9C_NumCategorias,0) AS U9C_NumCategorias,
ISNULL(A.U12C_NumCategorias,0) AS U12C_NumCategorias,
ISNULL(A.U15C_NumCategorias,0) AS U15C_NumCategorias,
ISNULL(A.U18C_NumCategorias,0) AS U18C_NumCategorias,
ISNULL(A.UC_NumMarcaCategUC,0) AS UC_NumMarcaCategUC,
ISNULL(A.U2C_NumMarcaCategUC,0) AS U2C_NumMarcaCategUC,
ISNULL(A.U3C_NumMarcaCategUC,0) AS U3C_NumMarcaCategUC,
ISNULL(A.U4C_NumMarcaCategUC,0) AS U4C_NumMarcaCategUC,
ISNULL(A.U5C_NumMarcaCategUC,0) AS U5C_NumMarcaCategUC,
ISNULL(A.U6C_NumMarcaCategUC,0) AS U6C_NumMarcaCategUC,
ISNULL(A.U9C_NumMarcaCategUC,0) AS U9C_NumMarcaCategUC,
ISNULL(A.U12C_NumMarcaCategUC,0) AS U12C_NumMarcaCategUC,
ISNULL(A.U15C_NumMarcaCategUC,0) AS U15C_NumMarcaCategUC,
ISNULL(A.U18C_NumMarcaCategUC,0) AS U18C_NumMarcaCategUC,
ISNULL(A.U2C_DESV_NumMarca,0) AS U2C_DESV_NumMarca,
ISNULL(A.U2C_DESV_NumCategorias,0) AS U2C_DESV_NumCategorias,
ISNULL(A.U2C_DESV_NumMarcaCategUC,0) AS U2C_DESV_NumMarcaCategUC,
ISNULL(A.U2C_MIN_NumMarca,0) AS U2C_MIN_NumMarca,
ISNULL(A.U2C_MIN_NumCategorias,0) AS U2C_MIN_NumCategorias,
ISNULL(A.U2C_MIN_NumMarcaCategUC,0) AS U2C_MIN_NumMarcaCategUC,
ISNULL(A.U2C_MAX_NumMarca,0) AS U2C_MAX_NumMarca,
ISNULL(A.U2C_MAX_NumCategorias,0) AS U2C_MAX_NumCategorias,
ISNULL(A.U2C_MAX_NumMarcaCategUC,0) AS U2C_MAX_NumMarcaCategUC,
ISNULL(A.U3C_DESV_NumMarca,0) AS U3C_DESV_NumMarca,
ISNULL(A.U3C_DESV_NumCategorias,0) AS U3C_DESV_NumCategorias,
ISNULL(A.U3C_DESV_NumMarcaCategUC,0) AS U3C_DESV_NumMarcaCategUC,
ISNULL(A.U3C_MIN_NumMarca,0) AS U3C_MIN_NumMarca,
ISNULL(A.U3C_MIN_NumCategorias,0) AS U3C_MIN_NumCategorias,
ISNULL(A.U3C_MIN_NumMarcaCategUC,0) AS U3C_MIN_NumMarcaCategUC,
ISNULL(A.U3C_MAX_NumMarca,0) AS U3C_MAX_NumMarca,
ISNULL(A.U3C_MAX_NumCategorias,0) AS U3C_MAX_NumCategorias,
ISNULL(A.U3C_MAX_NumMarcaCategUC,0) AS U3C_MAX_NumMarcaCategUC,
ISNULL(A.U4C_DESV_NumMarca,0) AS U4C_DESV_NumMarca,
ISNULL(A.U4C_DESV_NumCategorias,0) AS U4C_DESV_NumCategorias,
ISNULL(A.U4C_DESV_NumMarcaCategUC,0) AS U4C_DESV_NumMarcaCategUC,
ISNULL(A.U4C_MIN_NumMarca,0) AS U4C_MIN_NumMarca,
ISNULL(A.U4C_MIN_NumCategorias,0) AS U4C_MIN_NumCategorias,
ISNULL(A.U4C_MIN_NumMarcaCategUC,0) AS U4C_MIN_NumMarcaCategUC,
ISNULL(A.U4C_MAX_NumMarca,0) AS U4C_MAX_NumMarca,
ISNULL(A.U4C_MAX_NumCategorias,0) AS U4C_MAX_NumCategorias,
ISNULL(A.U4C_MAX_NumMarcaCategUC,0) AS U4C_MAX_NumMarcaCategUC,
ISNULL(A.U5C_DESV_NumMarca,0) AS U5C_DESV_NumMarca,
ISNULL(A.U5C_DESV_NumCategorias,0) AS U5C_DESV_NumCategorias,
ISNULL(A.U5C_DESV_NumMarcaCategUC,0) AS U5C_DESV_NumMarcaCategUC,
ISNULL(A.U5C_MIN_NumMarca,0) AS U5C_MIN_NumMarca,
ISNULL(A.U5C_MIN_NumCategorias,0) AS U5C_MIN_NumCategorias,
ISNULL(A.U5C_MIN_NumMarcaCategUC,0) AS U5C_MIN_NumMarcaCategUC,
ISNULL(A.U5C_MAX_NumMarca,0) AS U5C_MAX_NumMarca,
ISNULL(A.U5C_MAX_NumCategorias,0) AS U5C_MAX_NumCategorias,
ISNULL(A.U5C_MAX_NumMarcaCategUC,0) AS U5C_MAX_NumMarcaCategUC,
ISNULL(A.U6C_DESV_NumMarca,0) AS U6C_DESV_NumMarca,
ISNULL(A.U6C_DESV_NumCategorias,0) AS U6C_DESV_NumCategorias,
ISNULL(A.U6C_DESV_NumMarcaCategUC,0) AS U6C_DESV_NumMarcaCategUC,
ISNULL(A.U6C_MIN_NumMarca,0) AS U6C_MIN_NumMarca,
ISNULL(A.U6C_MIN_NumCategorias,0) AS U6C_MIN_NumCategorias,
ISNULL(A.U6C_MIN_NumMarcaCategUC,0) AS U6C_MIN_NumMarcaCategUC,
ISNULL(A.U6C_MAX_NumMarca,0) AS U6C_MAX_NumMarca,
ISNULL(A.U6C_MAX_NumCategorias,0) AS U6C_MAX_NumCategorias,
ISNULL(A.U6C_MAX_NumMarcaCategUC,0) AS U6C_MAX_NumMarcaCategUC,
ISNULL(A.U9C_DESV_NumMarca,0) AS U9C_DESV_NumMarca,
ISNULL(A.U9C_DESV_NumCategorias,0) AS U9C_DESV_NumCategorias,
ISNULL(A.U9C_DESV_NumMarcaCategUC,0) AS U9C_DESV_NumMarcaCategUC,
ISNULL(A.U9C_MIN_NumMarca,0) AS U9C_MIN_NumMarca,
ISNULL(A.U9C_MIN_NumCategorias,0) AS U9C_MIN_NumCategorias,
ISNULL(A.U9C_MIN_NumMarcaCategUC,0) AS U9C_MIN_NumMarcaCategUC,
ISNULL(A.U9C_MAX_NumMarca,0) AS U9C_MAX_NumMarca,
ISNULL(A.U9C_MAX_NumCategorias,0) AS U9C_MAX_NumCategorias,
ISNULL(A.U9C_MAX_NumMarcaCategUC,0) AS U9C_MAX_NumMarcaCategUC,
ISNULL(A.U12C_DESV_NumMarca,0) AS U12C_DESV_NumMarca,
ISNULL(A.U12C_DESV_NumCategorias,0) AS U12C_DESV_NumCategorias,
ISNULL(A.U12C_DESV_NumMarcaCategUC,0) AS U12C_DESV_NumMarcaCategUC,
ISNULL(A.U12C_MIN_NumMarca,0) AS U12C_MIN_NumMarca,
ISNULL(A.U12C_MIN_NumCategorias,0) AS U12C_MIN_NumCategorias,
ISNULL(A.U12C_MIN_NumMarcaCategUC,0) AS U12C_MIN_NumMarcaCategUC,
ISNULL(A.U12C_MAX_NumMarca,0) AS U12C_MAX_NumMarca,
ISNULL(A.U12C_MAX_NumCategorias,0) AS U12C_MAX_NumCategorias,
ISNULL(A.U12C_MAX_NumMarcaCategUC,0) AS U12C_MAX_NumMarcaCategUC,
ISNULL(A.U15C_DESV_NumMarca,0) AS U15C_DESV_NumMarca,
ISNULL(A.U15C_DESV_NumCategorias,0) AS U15C_DESV_NumCategorias,
ISNULL(A.U15C_DESV_NumMarcaCategUC,0) AS U15C_DESV_NumMarcaCategUC,
ISNULL(A.U15C_MIN_NumMarca,0) AS U15C_MIN_NumMarca,
ISNULL(A.U15C_MIN_NumCategorias,0) AS U15C_MIN_NumCategorias,
ISNULL(A.U15C_MIN_NumMarcaCategUC,0) AS U15C_MIN_NumMarcaCategUC,
ISNULL(A.U15C_MAX_NumMarca,0) AS U15C_MAX_NumMarca,
ISNULL(A.U15C_MAX_NumCategorias,0) AS U15C_MAX_NumCategorias,
ISNULL(A.U15C_MAX_NumMarcaCategUC,0) AS U15C_MAX_NumMarcaCategUC,
ISNULL(A.U18C_DESV_NumMarca,0) AS U18C_DESV_NumMarca,
ISNULL(A.U18C_DESV_NumCategorias,0) AS U18C_DESV_NumCategorias,
ISNULL(A.U18C_DESV_NumMarcaCategUC,0) AS U18C_DESV_NumMarcaCategUC,
ISNULL(A.U18C_MIN_NumMarca,0) AS U18C_MIN_NumMarca,
ISNULL(A.U18C_MIN_NumCategorias,0) AS U18C_MIN_NumCategorias,
ISNULL(A.U18C_MIN_NumMarcaCategUC,0) AS U18C_MIN_NumMarcaCategUC,
ISNULL(A.U18C_MAX_NumMarca,0) AS U18C_MAX_NumMarca,
ISNULL(A.U18C_MAX_NumCategorias,0) AS U18C_MAX_NumCategorias,
ISNULL(A.U18C_MAX_NumMarcaCategUC,0) AS U18C_MAX_NumMarcaCategUC,
ISNULL(U2C_PRO_NumMarca,0) AS U2C_PRO_NumMarca,
ISNULL(U2C_PRO_NumCategorias,0) AS U2C_PRO_NumCategorias,
ISNULL(U2C_PRO_NumMarcaCategUC,0) AS U2C_PRO_NumMarcaCategUC,
ISNULL(U3C_PRO_NumMarca,0) AS U3C_PRO_NumMarca,
ISNULL(U3C_PRO_NumCategorias,0) AS U3C_PRO_NumCategorias,
ISNULL(U3C_PRO_NumMarcaCategUC,0) AS U3C_PRO_NumMarcaCategUC,
ISNULL(U4C_PRO_NumMarca,0) AS U4C_PRO_NumMarca,
ISNULL(U4C_PRO_NumCategorias,0) AS U4C_PRO_NumCategorias,
ISNULL(U4C_PRO_NumMarcaCategUC,0) AS U4C_PRO_NumMarcaCategUC,
ISNULL(U5C_PRO_NumMarca,0) AS U5C_PRO_NumMarca,
ISNULL(U5C_PRO_NumCategorias,0) AS U5C_PRO_NumCategorias,
ISNULL(U5C_PRO_NumMarcaCategUC,0) AS U5C_PRO_NumMarcaCategUC,
ISNULL(U6C_PRO_NumMarca,0) AS U6C_PRO_NumMarca,
ISNULL(U6C_PRO_NumCategorias,0) AS U6C_PRO_NumCategorias,
ISNULL(U6C_PRO_NumMarcaCategUC,0) AS U6C_PRO_NumMarcaCategUC,
ISNULL(U9C_PRO_NumMarca,0) AS U9C_PRO_NumMarca,
ISNULL(U9C_PRO_NumCategorias,0) AS U9C_PRO_NumCategorias,
ISNULL(U9C_PRO_NumMarcaCategUC,0) AS U9C_PRO_NumMarcaCategUC,
ISNULL(U12C_PRO_NumMarca,0) AS U12C_PRO_NumMarca,
ISNULL(U12C_PRO_NumCategorias,0) AS U12C_PRO_NumCategorias,
ISNULL(U12C_PRO_NumMarcaCategUC,0) AS U12C_PRO_NumMarcaCategUC,
ISNULL(U15C_PRO_NumMarca,0) AS U15C_PRO_NumMarca,
ISNULL(U15C_PRO_NumCategorias,0) AS U15C_PRO_NumCategorias,
ISNULL(U15C_PRO_NumMarcaCategUC,0) AS U15C_PRO_NumMarcaCategUC,
ISNULL(U18C_PRO_NumMarca,0) AS U18C_PRO_NumMarca,
ISNULL(U18C_PRO_NumCategorias,0) AS U18C_PRO_NumCategorias,
ISNULL(U18C_PRO_NumMarcaCategUC,0) AS U18C_PRO_NumMarcaCategUC,
CASE WHEN ISNULL(A.U2C_NumCategorias_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumCategorias,0)/ ISNULL(A.U2C_NumCategorias_SUC,0) END  AS TEND_NumCategorias_U2C,
CASE WHEN ISNULL(A.U3C_NumCategorias_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumCategorias,0)/ ISNULL(A.U3C_NumCategorias_SUC,0) END  AS TEND_NumCategorias_U3C,
CASE WHEN ISNULL(A.U4C_NumCategorias_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumCategorias,0)/ ISNULL(A.U4C_NumCategorias_SUC,0) END  AS TEND_NumCategorias_U4C,
CASE WHEN ISNULL(A.U5C_NumCategorias_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumCategorias,0)/ ISNULL(A.U5C_NumCategorias_SUC,0) END  AS TEND_NumCategorias_U5C,
CASE WHEN ISNULL(A.U6C_NumCategorias_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumCategorias,0)/ ISNULL(A.U6C_NumCategorias_SUC,0) END  AS TEND_NumCategorias_U6C,
CASE WHEN ISNULL(A.U9C_NumCategorias_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumCategorias,0)/ ISNULL(A.U9C_NumCategorias_SUC,0) END  AS TEND_NumCategorias_U9C,
CASE WHEN ISNULL(A.U12C_NumCategorias_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumCategorias,0)/ ISNULL(A.U12C_NumCategorias_SUC,0) END  AS TEND_NumCategorias_U12C,
CASE WHEN ISNULL(A.U15C_NumCategorias_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumCategorias,0)/ ISNULL(A.U15C_NumCategorias_SUC,0) END  AS TEND_NumCategorias_U15C,
CASE WHEN ISNULL(A.U18C_NNumCategorias_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumCategorias,0)/ ISNULL(A.U18C_NNumCategorias_SUC,0) END  AS TEND_NumCategorias_U18C,
CASE WHEN ISNULL(A.U2C_NumMarca_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarca,0)/ ISNULL(A.U2C_NumMarca_SUC,0) END  AS TEND_NumMarca_U2C,
CASE WHEN ISNULL(A.U3C_NumMarca_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarca,0)/ ISNULL(A.U3C_NumMarca_SUC,0) END  AS TEND_NumMarca_U3C,
CASE WHEN ISNULL(A.U4C_NumMarca_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarca,0)/ ISNULL(A.U4C_NumMarca_SUC,0) END  AS TEND_NumMarca_U4C,
CASE WHEN ISNULL(A.U5C_NumMarca_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarca,0)/ ISNULL(A.U5C_NumMarca_SUC,0) END  AS TEND_NumMarca_U5C,
CASE WHEN ISNULL(A.U6C_NumMarca_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarca,0)/ ISNULL(A.U6C_NumMarca_SUC,0) END  AS TEND_NumMarca_U6C,
CASE WHEN ISNULL(A.U9C_NumMarca_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarca,0)/ ISNULL(A.U9C_NumMarca_SUC,0) END  AS TEND_NumMarca_U9C,
CASE WHEN ISNULL(A.U12C_NumMarca_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarca,0)/ ISNULL(A.U12C_NumMarca_SUC,0) END  AS TEND_NumMarca_U12C,
CASE WHEN ISNULL(A.U15C_NumMarca_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarca,0)/ ISNULL(A.U15C_NumMarca_SUC,0) END  AS TEND_NumMarca_U15C,
CASE WHEN ISNULL(A.U18C_NumMarca_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarca,0)/ ISNULL(A.U18C_NumMarca_SUC,0) END  AS TEND_NumMarca_U18C,
CASE WHEN ISNULL(A.U2C_NumMarcaCategUC_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U2C_NumMarcaCategUC_SUC,0) END  AS TEND_NumMarcaCategUC_U2C,
CASE WHEN ISNULL(A.U3C_NumMarcaCategUC_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U3C_NumMarcaCategUC_SUC,0) END  AS TEND_NumMarcaCategUC_U3C,
CASE WHEN ISNULL(A.U4C_NumMarcaCategUC_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U4C_NumMarcaCategUC_SUC,0) END  AS TEND_NumMarcaCategUC_U4C,
CASE WHEN ISNULL(A.U5C_NumMarcaCategUC_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U5C_NumMarcaCategUC_SUC,0) END  AS TEND_NumMarcaCategUC_U5C,
CASE WHEN ISNULL(A.U6C_NumMarcaCategUC_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U6C_NumMarcaCategUC_SUC,0) END  AS TEND_NumMarcaCategUC_U6C,
CASE WHEN ISNULL(A.U9C_NumMarcaCategUC_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U9C_NumMarcaCategUC_SUC,0) END  AS TEND_NumMarcaCategUC_U9C,
CASE WHEN ISNULL(A.U12C_NumMarcaCategUC_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U12C_NumMarcaCategUC_SUC,0) END  AS TEND_NumMarcaCategUC_U12C,
CASE WHEN ISNULL(A.U15C_NumMarcaCategUC_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U15C_NumMarcaCategUC_SUC,0) END  AS TEND_NumMarcaCategUC_U15C,
CASE WHEN ISNULL(A.U18C_NumMarcaCategUC_SUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U18C_NumMarcaCategUC_SUC,0) END  AS TEND_NumMarcaCategUC_U18C,
CASE WHEN ISNULL(A.U3C_NumCategorias_II,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumCategorias,0)/ ISNULL(A.U3C_NumCategorias_II,0) END  AS TEND_TRI_NumCategorias_U3C,
CASE WHEN ISNULL(A.U3C_NumCategorias_III,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumCategorias,0)/ ISNULL(A.U3C_NumCategorias_III,0) END  AS TEND_TRI_NumCategorias_U6C,
CASE WHEN ISNULL(A.U6C_NumCategorias_IV,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumCategorias,0)/ ISNULL(A.U6C_NumCategorias_IV,0) END  AS TEND_TRI_NumCategorias_U9C,
CASE WHEN ISNULL(A.U9C_NumCategorias_V,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumCategorias,0)/ ISNULL(A.U9C_NumCategorias_V,0) END  AS TEND_TRI_NumCategorias_U12C,
CASE WHEN ISNULL(A.U12C_NumCategorias_VI,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumCategorias,0)/ ISNULL(A.U12C_NumCategorias_VI,0) END  AS TEND_TRI_NumCategorias_U15C,
CASE WHEN ISNULL(A.U3C_NumMarca_II,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumMarca,0)/ ISNULL(A.U3C_NumMarca_II,0) END  AS TEND_TRI_NumMarca_U3C,
CASE WHEN ISNULL(A.U3C_NumMarca_III,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumMarca,0)/ ISNULL(A.U3C_NumMarca_III,0) END  AS TEND_TRI_NumMarca_U6C,
CASE WHEN ISNULL(A.U6C_NumMarca_IV,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumMarca,0)/ ISNULL(A.U6C_NumMarca_IV,0) END  AS TEND_TRI_NumMarca_U9C,
CASE WHEN ISNULL(A.U9C_NumMarca_V,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumMarca,0)/ ISNULL(A.U9C_NumMarca_V,0) END  AS TEND_TRI_NumMarca_U12C,
CASE WHEN ISNULL(A.U12C_NumMarca_VI,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_NumMarca,0)/ ISNULL(A.U12C_NumMarca_VI,0) END  AS TEND_TRI_NumMarca_U15C,
CASE WHEN ISNULL(A.U3C_NumMarcaCategUC_II,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U3C_NumMarcaCategUC_II,0) END  AS TEND_TRI_NumMarcaCategUC_U3C,
CASE WHEN ISNULL(A.U3C_NumMarcaCategUC_III,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U3C_NumMarcaCategUC_III,0) END  AS TEND_TRI_NumMarcaCategUC_U6C,
CASE WHEN ISNULL(A.U6C_NumMarcaCategUC_IV,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U6C_NumMarcaCategUC_IV,0) END  AS TEND_TRI_NumMarcaCategUC_U9C,
CASE WHEN ISNULL(A.U9C_NumMarcaCategUC_V,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U9C_NumMarcaCategUC_V,0) END  AS TEND_TRI_NumMarcaCategUC_U12C,
CASE WHEN ISNULL(A.U12C_NumMarcaCategUC_VI,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.UC_NumMarcaCategUC,0)/ ISNULL(A.U12C_NumMarcaCategUC_VI,0) END  AS TEND_TRI_NumMarcaCategUC_U15C,
CASE WHEN ISNULL(A.U2C_NumCategorias,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U2C_DESV_NumCategorias,0)/ ISNULL(A.U2C_NumCategorias,0) END  AS U2C_NumCategorias_CV,
CASE WHEN ISNULL(A.U2C_NumMarca,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U2C_DESV_NumMarca,0)/ ISNULL(A.U2C_NumMarca,0) END  AS U2C_NumMarca_CV,
CASE WHEN ISNULL(A.U2C_NumMarcaCategUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U2C_DESV_NumMarcaCategUC,0)/ ISNULL(A.U2C_NumMarcaCategUC,0) END  AS U2C_NumMarcaCategUC_CV,
CASE WHEN ISNULL(A.U3C_NumCategorias,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_DESV_NumCategorias,0)/ ISNULL(A.U3C_NumCategorias,0) END  AS U3C_NumCategorias_CV,
CASE WHEN ISNULL(A.U3C_NumMarca,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_DESV_NumMarca,0)/ ISNULL(A.U3C_NumMarca,0) END  AS U3C_NumMarca_CV,
CASE WHEN ISNULL(A.U3C_NumMarcaCategUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U3C_DESV_NumMarcaCategUC,0)/ ISNULL(A.U3C_NumMarcaCategUC,0) END  AS U3C_NumMarcaCategUC_CV,
CASE WHEN ISNULL(A.U4C_NumCategorias,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U4C_DESV_NumCategorias,0)/ ISNULL(A.U4C_NumCategorias,0) END  AS U4C_NumCategorias_CV,
CASE WHEN ISNULL(A.U4C_NumMarca,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U4C_DESV_NumMarca,0)/ ISNULL(A.U4C_NumMarca,0) END  AS U4C_NumMarca_CV,
CASE WHEN ISNULL(A.U4C_NumMarcaCategUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U4C_DESV_NumMarcaCategUC,0)/ ISNULL(A.U4C_NumMarcaCategUC,0) END  AS U4C_NumMarcaCategUC_CV,
CASE WHEN ISNULL(A.U5C_NumCategorias,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U5C_DESV_NumCategorias,0)/ ISNULL(A.U5C_NumCategorias,0) END  AS U5C_NumCategorias_CV,
CASE WHEN ISNULL(A.U5C_NumMarca,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U5C_DESV_NumMarca,0)/ ISNULL(A.U5C_NumMarca,0) END  AS U5C_NumMarca_CV,
CASE WHEN ISNULL(A.U5C_NumMarcaCategUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U5C_DESV_NumMarcaCategUC,0)/ ISNULL(A.U5C_NumMarcaCategUC,0) END  AS U5C_NumMarcaCategUC_CV,
CASE WHEN ISNULL(A.U6C_NumCategorias,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U6C_DESV_NumCategorias,0)/ ISNULL(A.U6C_NumCategorias,0) END  AS U6C_NumCategorias_CV,
CASE WHEN ISNULL(A.U6C_NumMarca,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U6C_DESV_NumMarca,0)/ ISNULL(A.U6C_NumMarca,0) END  AS U6C_NumMarca_CV,
CASE WHEN ISNULL(A.U6C_NumMarcaCategUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U6C_DESV_NumMarcaCategUC,0)/ ISNULL(A.U6C_NumMarcaCategUC,0) END  AS U6C_NumMarcaCategUC_CV,
CASE WHEN ISNULL(A.U9C_NumCategorias,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U9C_DESV_NumCategorias,0)/ ISNULL(A.U9C_NumCategorias,0) END  AS U9C_NumCategorias_CV,
CASE WHEN ISNULL(A.U9C_NumMarca,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U9C_DESV_NumMarca,0)/ ISNULL(A.U9C_NumMarca,0) END  AS U9C_NumMarca_CV,
CASE WHEN ISNULL(A.U9C_NumMarcaCategUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U9C_DESV_NumMarcaCategUC,0)/ ISNULL(A.U9C_NumMarcaCategUC,0) END  AS U9C_NumMarcaCategUC_CV,
CASE WHEN ISNULL(A.U12C_NumCategorias,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U12C_DESV_NumCategorias,0)/ ISNULL(A.U12C_NumCategorias,0) END  AS U12C_NumCategorias_CV,
CASE WHEN ISNULL(A.U12C_NumMarca,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U12C_DESV_NumMarca,0)/ ISNULL(A.U12C_NumMarca,0) END  AS U12C_NumMarca_CV,
CASE WHEN ISNULL(A.U12C_NumMarcaCategUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U12C_DESV_NumMarcaCategUC,0)/ ISNULL(A.U12C_NumMarcaCategUC,0) END  AS U12C_NumMarcaCategUC_CV,
CASE WHEN ISNULL(A.U15C_NumCategorias,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U15C_DESV_NumCategorias,0)/ ISNULL(A.U15C_NumCategorias,0) END  AS U15C_NumCategorias_CV,
CASE WHEN ISNULL(A.U15C_NumMarca,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U15C_DESV_NumMarca,0)/ ISNULL(A.U15C_NumMarca,0) END  AS U15C_NumMarca_CV,
CASE WHEN ISNULL(A.U15C_NumMarcaCategUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U15C_DESV_NumMarcaCategUC,0)/ ISNULL(A.U15C_NumMarcaCategUC,0) END  AS U15C_NumMarcaCategUC_CV,
CASE WHEN ISNULL(A.U18C_NumCategorias,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U18C_DESV_NumCategorias,0)/ ISNULL(A.U18C_NumCategorias,0) END  AS U18C_NumCategorias_CV,
CASE WHEN ISNULL(A.U18C_NumMarca,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U18C_DESV_NumMarca,0)/ ISNULL(A.U18C_NumMarca,0) END  AS U18C_NumMarca_CV,
CASE WHEN ISNULL(A.U18C_NumMarcaCategUC,0)=0 THEN 0 ELSE (1.0)* ISNULL(A.U18C_DESV_NumMarcaCategUC,0)/ ISNULL(A.U18C_NumMarcaCategUC,0) END  AS U18C_NumMarcaCategUC_CV
INTO MDL_NPP_Marca_Categoria--#KR_VEN_MCT_TF
FROM #KR_VEN_CAMP_MCT_TOT A
--INNER JOIN BD_ANALITICO.dbo.MDL_NPP_Target B ON A.PKEBELISTA=B.PKEBELISTA AND A.ANIOCAMPANA=B.ANIOCAMPANAUC

--SELECT * 
--INTO MDL_NPP_Marca_Categoria
--FROM #KR_VEN_MCT_TF

-- 6:45 min 

END
--CREATE PROCEDURE KR_MATRIZ_VEN_MCT
--@CodPais CHAR(2),
--@AnioCampana CHAR(6)

--AS

--BEGIN

declare @AnioCampana CHAR(6)
declare @CodPais CHAR(2)

set @CodPais = 'CO'
set @AnioCampana = '201716'


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

IF OBJECT_ID('tempdb..#TMP_FVTAPROEBECAM') IS NOT NULL DROP TABLE #TMP_FVTAPROEBECAM

select A.CodPais,A.aniocampana,A.pkebelista,
	   count(distinct CodMarca) NumMarca,
	   count(distinct descategoria) NumCategorias, 
	   count(distinct codmarca + descategoria) NumMarcaCategUC
INTO #TMP_FVTAPROEBECAM
FROM [DWH_ANALITICO].[dbo].[DWH_FVTAPROEBECAM]  A
inner JOIN  [DWH_ANALITICO].[dbo].[DWH_DTIPOOFERTA] B  ON A.PKTipoOferta = B.PKTipoOferta AND B.CodPais = A.CodPais 
--inner JOIN  [DWH_ANALITICO].[dbo].[DWH_dmatrizcampana] C  
--		ON A.Codventa = C.Codventa and A.Aniocampana = C.Aniocampana and A.PkProducto = C.PkProducto 
--		AND C.CodPais = A.CodPais AND A.CodCanalVenta = C.CodCanalVenta AND A.PkTipoOferta = C.PkTipoOferta
inner JOIN  [DWH_ANALITICO].[dbo].[DWH_dproducto] D  ON A.Pkproducto = D.Pkproducto AND D.CodPais= A.CodPais 
where D.CodMarca in ('A','B','C')
and D.descategoria in ('CUIDADO PERSONAL','FRAGANCIAS','MAQUILLAJE','TRATAMIENTO CORPORAL','TRATAMIENTO FACIAL')
and B.CodTipoOferta not in ('030','031','040','051','061','062','065','066','068','071','072','077','078','079','082','083','085','090','093','109','050','082','091','098')
and B.CodTipoProfit ='01'
and A.CodVenta<> '00000'
and RealUUVendidas>0 and RealVtaMNNeto>0
AND A.ANIOCAMPANA BETWEEN @AnioCampanamenos17 AND @AnioCampana AND A.CodPais = @CodPais 
AND a.aniocampana=a.aniocampanaref
group by A.CodPais,A.aniocampana,A.pkebelista

CREATE INDEX IDX_Pais_EbeCam_MC ON #TMP_FVTAPROEBECAM (CodPais,AnioCampana,PkEbelista)



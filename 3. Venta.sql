use BD_ANALITICO
GO

CREATE PROCEDURE KR_MATRIZ_VEN
	@CodPais CHAR(2),
	@AnioCampana CHAR(6)

AS

BEGIN

declare 
     @AnioCampanamenos1 CHAR(6),
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
	 @CodPais CHAR(2),
	 @AnioCampana CHAR(6)

set @CodPais = 'PE'
set @AnioCampana = '201716'
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

----------------Unidades y Facturación


--IF OBJECT_ID('tempdb.dbo.##KR_VEN_CAMP_AGR', 'U') IS NOT NULL
--  DROP TABLE ##KR_VEN_CAMP_AGR;
  

--SELECT
--PKEbelista,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampana  THEN  RealUUVendidas  else 0 end))/1 AS UC_RealUUVendidas ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos1  THEN  RealUUVendidas  else 0 end))/2 AS U2C_RealUUVendidas ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos2  THEN  RealUUVendidas  else 0 end))/3 AS U3C_RealUUVendidas ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos3  THEN  RealUUVendidas  else 0 end))/4 AS U4C_RealUUVendidas ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos4  THEN  RealUUVendidas  else 0 end))/5 AS U5C_RealUUVendidas ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  THEN  RealUUVendidas  else 0 end))/6 AS U6C_RealUUVendidas ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  THEN  RealUUVendidas  else 0 end))/9 AS U9C_RealUUVendidas ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11  THEN  RealUUVendidas  else 0 end))/12 AS U12C_RealUUVendidas ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14  THEN  RealUUVendidas  else 0 end))/15 AS U15C_RealUUVendidas ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17  THEN  RealUUVendidas  else 0 end))/18 AS U18C_RealUUVendidas ,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampana  THEN  RealUUFaltantes else 0 end))/1 AS UC_RealUUFaltantes,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos1  THEN  RealUUFaltantes else 0 end))/2 AS U2C_RealUUFaltantes,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos2  THEN  RealUUFaltantes else 0 end))/3 AS U3C_RealUUFaltantes,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos3  THEN  RealUUFaltantes else 0 end))/4 AS U4C_RealUUFaltantes,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos4  THEN  RealUUFaltantes else 0 end))/5 AS U5C_RealUUFaltantes,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  THEN  RealUUFaltantes else 0 end))/6 AS U6C_RealUUFaltantes,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  THEN  RealUUFaltantes else 0 end))/9 AS U9C_RealUUFaltantes,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11  THEN  RealUUFaltantes else 0 end))/12 AS U12C_RealUUFaltantes,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14  THEN  RealUUFaltantes else 0 end))/15 AS U15C_RealUUFaltantes,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17  THEN  RealUUFaltantes else 0 end))/18 AS U18C_RealUUFaltantes,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampana  THEN  RealUUDevueltas else 0 end))/1 AS UC_RealUUDevueltas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos1  THEN  RealUUDevueltas else 0 end))/2 AS U2C_RealUUDevueltas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos2  THEN  RealUUDevueltas else 0 end))/3 AS U3C_RealUUDevueltas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos3  THEN  RealUUDevueltas else 0 end))/4 AS U4C_RealUUDevueltas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos4  THEN  RealUUDevueltas else 0 end))/5 AS U5C_RealUUDevueltas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  THEN  RealUUDevueltas else 0 end))/6 AS U6C_RealUUDevueltas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  THEN  RealUUDevueltas else 0 end))/9 AS U9C_RealUUDevueltas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11  THEN  RealUUDevueltas else 0 end))/12 AS U12C_RealUUDevueltas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14  THEN  RealUUDevueltas else 0 end))/15 AS U15C_RealUUDevueltas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17  THEN  RealUUDevueltas else 0 end))/18 AS U18C_RealUUDevueltas,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampana  THEN  RealUUAnuladas else 0 end))/1 AS UC_RealUUAnuladas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos1  THEN  RealUUAnuladas else 0 end))/2 AS U2C_RealUUAnuladas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos2  THEN  RealUUAnuladas else 0 end))/3 AS U3C_RealUUAnuladas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos3  THEN  RealUUAnuladas else 0 end))/4 AS U4C_RealUUAnuladas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos4  THEN  RealUUAnuladas else 0 end))/5 AS U5C_RealUUAnuladas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  THEN  RealUUAnuladas else 0 end))/6 AS U6C_RealUUAnuladas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  THEN  RealUUAnuladas else 0 end))/9 AS U9C_RealUUAnuladas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11  THEN  RealUUAnuladas else 0 end))/12 AS U12C_RealUUAnuladas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14  THEN  RealUUAnuladas else 0 end))/15 AS U15C_RealUUAnuladas,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17  THEN  RealUUAnuladas else 0 end))/18 AS U18C_RealUUAnuladas,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampana  THEN  RealVtaMNNeto else 0 end))/1 AS UC_RealVtaMNNeto,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos1  THEN  RealVtaMNNeto else 0 end))/2 AS U2C_RealVtaMNNeto,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos2  THEN  RealVtaMNNeto else 0 end))/3 AS U3C_RealVtaMNNeto,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos3  THEN  RealVtaMNNeto else 0 end))/4 AS U4C_RealVtaMNNeto,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos4  THEN  RealVtaMNNeto else 0 end))/5 AS U5C_RealVtaMNNeto,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  THEN  RealVtaMNNeto else 0 end))/6 AS U6C_RealVtaMNNeto,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  THEN  RealVtaMNNeto else 0 end))/9 AS U9C_RealVtaMNNeto,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11  THEN  RealVtaMNNeto else 0 end))/12 AS U12C_RealVtaMNNeto,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14  THEN  RealVtaMNNeto else 0 end))/15 AS U15C_RealVtaMNNeto,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17  THEN  RealVtaMNNeto else 0 end))/18 AS U18C_RealVtaMNNeto,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/1 AS UC_OportunidadAhorroMN ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos1  THEN  OportunidadAhorroMN  else 0 end))/2 AS U2C_OportunidadAhorroMN ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos2  THEN  OportunidadAhorroMN  else 0 end))/3 AS U3C_OportunidadAhorroMN ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos3  THEN  OportunidadAhorroMN  else 0 end))/4 AS U4C_OportunidadAhorroMN ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos4  THEN  OportunidadAhorroMN  else 0 end))/5 AS U5C_OportunidadAhorroMN ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  THEN  OportunidadAhorroMN  else 0 end))/6 AS U6C_OportunidadAhorroMN ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  THEN  OportunidadAhorroMN  else 0 end))/9 AS U9C_OportunidadAhorroMN ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11  THEN  OportunidadAhorroMN  else 0 end))/12 AS U12C_OportunidadAhorroMN ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14  THEN  OportunidadAhorroMN  else 0 end))/15 AS U15C_OportunidadAhorroMN ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17  THEN  OportunidadAhorroMN  else 0 end))/18 AS U18C_OportunidadAhorroMN,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos1  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealUUVendidas  else 0 end))/1 AS U2C_RealUUVendidas_SUC ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos2  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealUUVendidas  else 0 end))/2 AS U3C_RealUUVendidas_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos3  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealUUVendidas  else 0 end))/3 AS U4C_RealUUVendidas_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos4  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealUUVendidas  else 0 end))/4 AS U5C_RealUUVendidas_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealUUVendidas  else 0 end))/5 AS U6C_RealUUVendidas_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealUUVendidas  else 0 end))/8 AS U9C_RealUUVendidas_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11 AND A.ANIOCAMPANA<@AnioCampana  THEN  RealUUVendidas  else 0 end))/11 AS U12C_RealUUVendidas_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14 AND A.ANIOCAMPANA<@AnioCampana  THEN  RealUUVendidas  else 0 end))/14 AS U15C_RealUUVendidas_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17 AND A.ANIOCAMPANA<@AnioCampana  THEN  RealUUVendidas  else 0 end))/17 AS U18C_RealUUVendidas_SUC  ,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  AND A.ANIOCAMPANA<@AnioCampanamenos2  THEN  RealUUVendidas  else 0 end))/3 AS U3C_RealUUVendidas_II  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  AND A.ANIOCAMPANA<@AnioCampanamenos2   THEN  RealUUVendidas  else 0 end))/6 AS U3C_RealUUVendidas_SUC_III  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11 AND A.ANIOCAMPANA<@AnioCampanamenos2   THEN  RealUUVendidas  else 0 end))/9 AS U6C_RealUUVendidas_SUCIV  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14 AND A.ANIOCAMPANA<@AnioCampanamenos2  THEN  RealUUVendidas  else 0 end))/12 AS U9C_RealUUVendidas_V  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17 AND A.ANIOCAMPANA<@AnioCampanamenos2  THEN  RealUUVendidas  else 0 end))/15 AS U12C_RealUUVendidas_VI,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos1  AND A.ANIOCAMPANA<@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/1 AS U2C_OportunidadAhorroMN_SUC ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos2  AND A.ANIOCAMPANA<@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/2 AS U3C_OportunidadAhorroMN_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos3  AND A.ANIOCAMPANA<@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/3 AS U4C_OportunidadAhorroMN_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos4  AND A.ANIOCAMPANA<@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/4 AS U5C_OportunidadAhorroMN_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  AND A.ANIOCAMPANA<@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/5 AS U6C_OportunidadAhorroMN_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  AND A.ANIOCAMPANA<@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/8 AS U9C_OportunidadAhorroMN_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11 AND A.ANIOCAMPANA<@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/11 AS U12C_OportunidadAhorroMN_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14 AND A.ANIOCAMPANA<@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/14 AS U15C_OportunidadAhorroMN_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17 AND A.ANIOCAMPANA<@AnioCampana  THEN  OportunidadAhorroMN  else 0 end))/17 AS U18C_OportunidadAhorroMN_SUC  ,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  AND A.ANIOCAMPANA<@AnioCampanamenos2  THEN  OportunidadAhorroMN  else 0 end))/3 AS U3C_OportunidadAhorroMN_II  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  AND A.ANIOCAMPANA<@AnioCampanamenos2   THEN  OportunidadAhorroMN  else 0 end))/6 AS U3C_OportunidadAhorroMN_SUC_III  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11  AND A.ANIOCAMPANA<@AnioCampanamenos2   THEN  OportunidadAhorroMN  else 0 end))/9 AS U6C_OportunidadAhorroMN_SUCIV  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14  AND A.ANIOCAMPANA<@AnioCampanamenos2  THEN  OportunidadAhorroMN  else 0 end))/12 AS U9C_OportunidadAhorroMN_V  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17 AND A.ANIOCAMPANA<@AnioCampanamenos2  THEN  OportunidadAhorroMN  else 0 end))/15 AS U12C_OportunidadAhorroMN_VI,


--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos1  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealVtaMNNeto  else 0 end))/1 AS U2C_RealVtaMNNeto_SUC ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos2  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealVtaMNNeto  else 0 end))/2 AS U3C_RealVtaMNNeto_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos3  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealVtaMNNeto  else 0 end))/3 AS U4C_RealVtaMNNeto_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos4  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealVtaMNNeto  else 0 end))/4 AS U5C_RealVtaMNNeto_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealVtaMNNeto  else 0 end))/5 AS U6C_RealVtaMNNeto_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  AND A.ANIOCAMPANA<@AnioCampana  THEN  RealVtaMNNeto  else 0 end))/8 AS U9C_RealVtaMNNeto_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11 AND A.ANIOCAMPANA<@AnioCampana  THEN  RealVtaMNNeto  else 0 end))/11 AS U12C_RealVtaMNNeto_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14 AND A.ANIOCAMPANA<@AnioCampana  THEN  RealVtaMNNeto  else 0 end))/14 AS U15C_RealVtaMNNeto_SUC  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17 AND A.ANIOCAMPANA<@AnioCampana  THEN  RealVtaMNNeto  else 0 end))/17 AS U18C_RealVtaMNNeto_SUC  ,

--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos5  AND A.ANIOCAMPANA<@AnioCampanamenos2  THEN  RealVtaMNNeto  else 0 end))/3 AS U3C_RealVtaMNNeto_II  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos8  AND A.ANIOCAMPANA<@AnioCampanamenos2   THEN  RealVtaMNNeto  else 0 end))/6 AS U3C_RealVtaMNNeto_SUC_III  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos11  AND A.ANIOCAMPANA<@AnioCampanamenos2   THEN  RealVtaMNNeto  else 0 end))/9 AS U6C_RealVtaMNNeto_SUCIV  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos14  AND A.ANIOCAMPANA<@AnioCampanamenos2  THEN  RealVtaMNNeto  else 0 end))/12 AS U9C_RealVtaMNNeto_V  ,
--1.0*(SUM(CASE WHEN A.ANIOCAMPANA>=@AnioCampanamenos17 AND A.ANIOCAMPANA<@AnioCampanamenos2  THEN  RealVtaMNNeto  else 0 end))/15 AS U12C_RealVtaMNNeto_VI

--INTO ##KR_VEN_CAMP_AGR
--FROM [DWH_ANALITICO].[dbo].[DWH_FVTAPROEBECAM]  A
--INNER JOIN  [DWH_ANALITICO].[dbo].[DWH_DTIPOOFERTA] B  ON A.PKTipoOferta=B.PKTipoOferta AND B.CODPAIS=@CodPais 
--WHERE A.ANIOCAMPANA>=@AnioCampanamenos17 AND A.ANIOCAMPANA<=@AnioCampana  AND B.codtipoprofit='01' and A.RealVtaMNNeto>0 AND A.CODPAIS=@CodPais 
--and a.aniocampana=a.aniocampanaref
--GROUP BY PKEbelista
--;

IF OBJECT_ID('tempdb..#TMP_FVTAPROEBECAM') IS NOT NULL DROP TABLE #TMP_FVTAPROEBECAM

SELECT A.CodPais, A.AnioCampana,A.PkEbelista,
		SUM(RealUUVendidas) as RealUUVendidas,
		SUM(RealUUFaltantes) as RealUUFaltantes,
		SUM(RealUUDevueltas) as RealUUDevueltas, 
		SUM(RealUUAnuladas) as RealUUAnuladas,
		SUM(RealVtaMNNeto) as RealVtaMNNeto,
		SUM(OportunidadAhorroMN) as OportunidadAhorroMN
INTO #TMP_FVTAPROEBECAM
FROM [DWH_ANALITICO].[dbo].[DWH_FVTAPROEBECAM]  A
INNER JOIN  [DWH_ANALITICO].[dbo].[DWH_DTIPOOFERTA] B  ON A.PKTipoOferta=B.PKTipoOferta AND B.CodPais = A.CodPais 
WHERE A.AnioCampana BETWEEN @AnioCampanamenos17 AND @AnioCampana AND B.codtipoprofit = '01' AND A.RealVtaMNNeto > 0 
	AND A.CodPais = @CodPais AND a.AnioCampana = a.AnioCampanaRef
GROUP BY A.CodPais, A.AnioCampana,A.PkEbelista

CREATE INDEX IDX_Pais_EbeCam ON #TMP_FVTAPROEBECAM (CodPais, AnioCampana, PkEbelista)

IF OBJECT_ID('tempdb..#TMP_EbeHistoria') IS NOT NULL DROP TABLE #TMP_EbeHistoria

;WITH EbelistaUC AS
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/1 as UC_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/1 as UC_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/1 as UC_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/1 as UC_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/1 as UC_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/1 as UC_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampana
	GROUP BY A.CodPais, A.PkEbelista
), EbelistaCampanaMenos1 AS
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/2 as U2C_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/2 as U2C_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/2 as U2C_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/2 as U2C_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/2 as U2C_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/2 as U2C_OportunidadAhorroMN,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealUUVendidas ELSE 0 END)/1 AS U2C_RealUUVendidas_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN OportunidadAhorroMN ELSE 0 END)/1 AS U2C_OportunidadAhorroMN_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealVtaMNNeto ELSE 0 END)/1 AS U2C_RealVtaMNNeto_SUC,
			AVG(RealVtaMNNeto ) AS U2C_PRO_RealVtaMNNeto ,
			AVG(OportunidadAhorroMN ) AS U2C_PRO_OportunidadAhorroMN ,
			STDEV(RealUUVendidas ) AS U2C_DESV_RealUUVendidas ,
			STDEV(RealUUDevueltas) AS U2C_DESV_RealUUDevueltas,
			STDEV(RealUUAnuladas) AS U2C_DESV_RealUUAnuladas,
			STDEV(RealVtaMNNeto) AS U2C_DESV_RealVtaMNNeto,
			STDEV(OportunidadAhorroMN) AS U2C_DESV_OportunidadAhorroMN,
			MIN(RealUUVendidas ) AS U2C_MIN_RealUUVendidas ,
			MIN(RealUUDevueltas) AS U2C_MIN_RealUUDevueltas,
			MIN(RealUUAnuladas) AS U2C_MIN_RealUUAnuladas,
			MIN(RealVtaMNNeto) AS U2C_MIN_RealVtaMNNeto,
			MIN(OportunidadAhorroMN) AS U2C_MIN_OportunidadAhorroMN,
			MAX(RealUUVendidas ) AS U2C_MAX_RealUUVendidas ,
			MAX(RealUUDevueltas) AS U2C_MAX_RealUUDevueltas,
			MAX(RealUUAnuladas) AS U2C_MAX_RealUUAnuladas,
			MAX(RealVtaMNNeto) AS U2C_MAX_RealVtaMNNeto,
			MAX(OportunidadAhorroMN) AS U2C_MAX_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos1
	GROUP BY A.CodPais, A.PkEbelista
),EbelistaCampanaMenos2 AS 
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/3 as U3C_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/3 as U3C_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/3 as U3C_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/3 as U3C_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/3 as U3C_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/3 as U3C_OportunidadAhorroMN,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealUUVendidas ELSE 0 END)/2 AS U3C_RealUUVendidas_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN OportunidadAhorroMN ELSE 0 END)/2 AS U3C_OportunidadAhorroMN_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealVtaMNNeto ELSE 0 END)/2 AS U3C_RealVtaMNNeto_SUC,
			AVG(RealVtaMNNeto ) AS U3C_PRO_RealVtaMNNeto ,
			AVG(OportunidadAhorroMN ) AS U3C_PRO_OportunidadAhorroMN ,
			STDEV(RealUUVendidas ) AS U3C_DESV_RealUUVendidas ,
			STDEV(RealUUDevueltas) AS U3C_DESV_RealUUDevueltas,
			STDEV(RealUUAnuladas) AS U3C_DESV_RealUUAnuladas,
			STDEV(RealVtaMNNeto) AS U3C_DESV_RealVtaMNNeto,
			STDEV(OportunidadAhorroMN) AS U3C_DESV_OportunidadAhorroMN,
			MIN(RealUUVendidas ) AS U3C_MIN_RealUUVendidas ,
			MIN(RealUUDevueltas) AS U3C_MIN_RealUUDevueltas,
			MIN(RealUUAnuladas) AS U3C_MIN_RealUUAnuladas,
			MIN(RealVtaMNNeto) AS U3C_MIN_RealVtaMNNeto,
			MIN(OportunidadAhorroMN) AS U3C_MIN_OportunidadAhorroMN,
			MAX(RealUUVendidas ) AS U3C_MAX_RealUUVendidas ,
			MAX(RealUUDevueltas) AS U3C_MAX_RealUUDevueltas,
			MAX(RealUUAnuladas) AS U3C_MAX_RealUUAnuladas,
			MAX(RealVtaMNNeto) AS U3C_MAX_RealVtaMNNeto,
			MAX(OportunidadAhorroMN) AS U3C_MAX_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos2
	GROUP BY A.CodPais, A.PkEbelista
),EbelistaCampanaMenos3 AS 
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/4 as U4C_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/4 as U4C_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/4 as U4C_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/4 as U4C_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/4 as U4C_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/4 as U4C_OportunidadAhorroMN,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealUUVendidas ELSE 0 END)/3 AS U5C_RealUUVendidas_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN OportunidadAhorroMN ELSE 0 END)/3 AS U4C_OportunidadAhorroMN_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealVtaMNNeto ELSE 0 END)/3 AS U4C_RealVtaMNNeto_SUC,
			AVG(RealVtaMNNeto ) AS U4C_PRO_RealVtaMNNeto ,
			AVG(OportunidadAhorroMN ) AS U4C_PRO_OportunidadAhorroMN ,
			STDEV(RealUUVendidas ) AS U4C_DESV_RealUUVendidas ,
			STDEV(RealUUDevueltas) AS U4C_DESV_RealUUDevueltas,
			STDEV(RealUUAnuladas) AS U4C_DESV_RealUUAnuladas,
			STDEV(RealVtaMNNeto) AS U4C_DESV_RealVtaMNNeto,
			STDEV(OportunidadAhorroMN) AS U4C_DESV_OportunidadAhorroMN,
			MIN(RealUUVendidas ) AS U4C_MIN_RealUUVendidas ,
			MIN(RealUUDevueltas) AS U4C_MIN_RealUUDevueltas,
			MIN(RealUUAnuladas) AS U4C_MIN_RealUUAnuladas,
			MIN(RealVtaMNNeto) AS U4C_MIN_RealVtaMNNeto,
			MIN(OportunidadAhorroMN) AS U4C_MIN_OportunidadAhorroMN,
			MAX(RealUUVendidas ) AS U4C_MAX_RealUUVendidas ,
			MAX(RealUUDevueltas) AS U4C_MAX_RealUUDevueltas,
			MAX(RealUUAnuladas) AS U4C_MAX_RealUUAnuladas,
			MAX(RealVtaMNNeto) AS U4C_MAX_RealVtaMNNeto,
			MAX(OportunidadAhorroMN) AS U4C_MAX_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos3
	GROUP BY A.CodPais, A.PkEbelista
),EbelistaCampanaMenos4 AS 
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/5 as U5C_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/5 as U5C_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/5 as U5C_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/5 as U5C_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/5 as U5C_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/5 as U5C_OportunidadAhorroMN,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealUUVendidas ELSE 0 END)/4 AS U5C_RealUUVendidas_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN OportunidadAhorroMN ELSE 0 END)/4 AS U5C_OportunidadAhorroMN_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealVtaMNNeto ELSE 0 END)/4 AS U5C_RealVtaMNNeto_SUC,
			AVG(RealVtaMNNeto ) AS U5C_PRO_RealVtaMNNeto,
			AVG(OportunidadAhorroMN ) AS U5C_PRO_OportunidadAhorroMN ,
			STDEV(RealUUVendidas ) AS U5C_DESV_RealUUVendidas ,
			STDEV(RealUUDevueltas) AS U5C_DESV_RealUUDevueltas,
			STDEV(RealUUAnuladas) AS U5C_DESV_RealUUAnuladas,
			STDEV(RealVtaMNNeto) AS U5C_DESV_RealVtaMNNeto,
			STDEV(OportunidadAhorroMN) AS U5C_DESV_OportunidadAhorroMN,
			MIN(RealUUVendidas ) AS U5C_MIN_RealUUVendidas ,
			MIN(RealUUDevueltas) AS U5C_MIN_RealUUDevueltas,
			MIN(RealUUAnuladas) AS U5C_MIN_RealUUAnuladas,
			MIN(RealVtaMNNeto) AS U5C_MIN_RealVtaMNNeto,
			MIN(OportunidadAhorroMN) AS U5C_MIN_OportunidadAhorroMN,
			MAX(RealUUVendidas ) AS U5C_MAX_RealUUVendidas ,
			MAX(RealUUDevueltas) AS U5C_MAX_RealUUDevueltas,
			MAX(RealUUAnuladas) AS U5C_MAX_RealUUAnuladas,
			MAX(RealVtaMNNeto) AS U5C_MAX_RealVtaMNNeto,
			MAX(OportunidadAhorroMN) AS U5C_MAX_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos4
	GROUP BY A.CodPais, A.PkEbelista
),EbelistaCampanaMenos5 AS 
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/6 as U6C_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/6 as U6C_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/6 as U6C_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/6 as U6C_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/6 as U6C_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/6 as U6C_OportunidadAhorroMN,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealUUVendidas ELSE 0 END)/5 AS U6C_RealUUVendidas_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN OportunidadAhorroMN ELSE 0 END)/5 AS U6C_OportunidadAhorroMN_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealVtaMNNeto ELSE 0 END)/5 AS U6C_RealVtaMNNeto_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampanamenos2 THEN RealUUVendidas ELSE 0 END)/3 AS U3C_RealUUVendidas_II,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampanamenos2 THEN OportunidadAhorroMN ELSE 0 END)/3 AS U3C_OportunidadAhorroMN_II,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampanamenos2 THEN RealVtaMNNeto ELSE 0 END)/3 AS U3C_RealVtaMNNeto_II,
			AVG(RealVtaMNNeto ) AS U6C_PRO_RealVtaMNNeto ,
			AVG(OportunidadAhorroMN ) AS U6C_PRO_OportunidadAhorroMN ,
			STDEV(RealUUVendidas ) AS U6C_DESV_RealUUVendidas ,
			STDEV(RealUUDevueltas) AS U6C_DESV_RealUUDevueltas,
			STDEV(RealUUAnuladas) AS U6C_DESV_RealUUAnuladas,
			STDEV(RealVtaMNNeto) AS U6C_DESV_RealVtaMNNeto,
			STDEV(OportunidadAhorroMN) AS U6C_DESV_OportunidadAhorroMN,
			MIN(RealUUVendidas ) AS U6C_MIN_RealUUVendidas ,
			MIN(RealUUDevueltas) AS U6C_MIN_RealUUDevueltas,
			MIN(RealUUAnuladas) AS U6C_MIN_RealUUAnuladas,
			MIN(RealVtaMNNeto) AS U6C_MIN_RealVtaMNNeto,
			MIN(OportunidadAhorroMN) AS U6C_MIN_OportunidadAhorroMN,
			MAX(RealUUVendidas ) AS U6C_MAX_RealUUVendidas ,
			MAX(RealUUDevueltas) AS U6C_MAX_RealUUDevueltas,
			MAX(RealUUAnuladas) AS U6C_MAX_RealUUAnuladas,
			MAX(RealVtaMNNeto) AS U6C_MAX_RealVtaMNNeto,
			MAX(OportunidadAhorroMN) AS U6C_MAX_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos5
	GROUP BY A.CodPais, A.PkEbelista
),EbelistaCampanaMenos8 AS
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/9 as U9C_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/9 as U9C_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/9 as U9C_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/9 as U9C_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/9 as U9C_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/9 as U9C_OportunidadAhorroMN,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealUUVendidas ELSE 0 END)/8 AS U9C_RealUUVendidas_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN OportunidadAhorroMN ELSE 0 END)/8 AS U9C_OportunidadAhorroMN_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampana THEN RealVtaMNNeto ELSE 0 END)/8 AS U9C_RealVtaMNNeto_SUC,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampanamenos2 THEN RealUUVendidas ELSE 0 END)/6 AS U3C_RealUUVendidas_SUC_III,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampanamenos2 THEN OportunidadAhorroMN ELSE 0 END)/6 AS U3C_OportunidadAhorroMN_SUC_III,
			1.0*SUM(CASE WHEN AnioCampana < @AnioCampanamenos2 THEN RealVtaMNNeto ELSE 0 END)/6 AS U3C_RealVtaMNNeto_SUC_III,
			AVG(RealVtaMNNeto ) AS U9C_PRO_RealVtaMNNeto ,
			AVG(OportunidadAhorroMN ) AS U9C_PRO_OportunidadAhorroMN ,
			STDEV(RealUUVendidas ) AS U9C_DESV_RealUUVendidas ,
			STDEV(RealUUDevueltas) AS U9C_DESV_RealUUDevueltas,
			STDEV(RealUUAnuladas) AS U9C_DESV_RealUUAnuladas,
			STDEV(RealVtaMNNeto) AS U9C_DESV_RealVtaMNNeto,
			STDEV(OportunidadAhorroMN) AS U9C_DESV_OportunidadAhorroMN,
			MIN(RealUUVendidas ) AS U9C_MIN_RealUUVendidas ,
			MIN(RealUUDevueltas) AS U9C_MIN_RealUUDevueltas,
			MIN(RealUUAnuladas) AS U9C_MIN_RealUUAnuladas,
			MIN(RealVtaMNNeto) AS U9C_MIN_RealVtaMNNeto,
			MIN(OportunidadAhorroMN) AS U9C_MIN_OportunidadAhorroMN,
			MAX(RealUUVendidas ) AS U9C_MAX_RealUUVendidas ,
			MAX(RealUUDevueltas) AS U9C_MAX_RealUUDevueltas,
			MAX(RealUUAnuladas) AS U9C_MAX_RealUUAnuladas,
			MAX(RealVtaMNNeto) AS U9C_MAX_RealVtaMNNeto,
			MAX(OportunidadAhorroMN) AS U9C_MAX_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos8
	GROUP BY A.CodPais, A.PkEbelista
),EbelistaCampanaMenos11 AS
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/12 as U12C_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/12 as U12C_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/12 as U12C_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/12 as U12C_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/12 as U12C_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/12 as U12C_OportunidadAhorroMN,
			AVG(RealVtaMNNeto ) AS U12C_PRO_RealVtaMNNeto,
			AVG(OportunidadAhorroMN ) AS U12C_PRO_OportunidadAhorroMN ,
			STDEV(RealUUVendidas ) AS U12C_DESV_RealUUVendidas ,
			STDEV(RealUUDevueltas) AS U12C_DESV_RealUUDevueltas,
			STDEV(RealUUAnuladas) AS U12C_DESV_RealUUAnuladas,
			STDEV(RealVtaMNNeto) AS U12C_DESV_RealVtaMNNeto,
			STDEV(OportunidadAhorroMN) AS U12C_DESV_OportunidadAhorroMN,
			MIN(RealUUVendidas ) AS U12C_MIN_RealUUVendidas ,
			MIN(RealUUDevueltas) AS U12C_MIN_RealUUDevueltas,
			MIN(RealUUAnuladas) AS U12C_MIN_RealUUAnuladas,
			MIN(RealVtaMNNeto) AS U12C_MIN_RealVtaMNNeto,
			MIN(OportunidadAhorroMN) AS U12C_MIN_OportunidadAhorroMN,
			MAX(RealUUVendidas ) AS U12C_MAX_RealUUVendidas ,
			MAX(RealUUDevueltas) AS U12C_MAX_RealUUDevueltas,
			MAX(RealUUAnuladas) AS U12C_MAX_RealUUAnuladas,
			MAX(RealVtaMNNeto) AS U12C_MAX_RealVtaMNNeto,
			MAX(OportunidadAhorroMN) AS U12C_MAX_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos11
	GROUP BY A.CodPais, A.PkEbelista
),EbelistaCampanaMenos14 AS
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/15 as U15C_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/15 as U15C_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/15 as U15C_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/15 as U15C_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/15 as U15C_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/15 as U15C_OportunidadAhorroMN,
			AVG(RealVtaMNNeto ) AS U15C_PRO_RealVtaMNNeto,
			AVG(OportunidadAhorroMN ) AS U15C_PRO_OportunidadAhorroMN ,
			STDEV(RealUUVendidas ) AS U15C_DESV_RealUUVendidas ,
			STDEV(RealUUDevueltas) AS U15C_DESV_RealUUDevueltas,
			STDEV(RealUUAnuladas) AS U15C_DESV_RealUUAnuladas,
			STDEV(RealVtaMNNeto) AS U15C_DESV_RealVtaMNNeto,
			STDEV(OportunidadAhorroMN) AS U15C_DESV_OportunidadAhorroMN,
			MIN(RealUUVendidas ) AS U15C_MIN_RealUUVendidas ,
			MIN(RealUUDevueltas) AS U15C_MIN_RealUUDevueltas,
			MIN(RealUUAnuladas) AS U15C_MIN_RealUUAnuladas,
			MIN(RealVtaMNNeto) AS U15C_MIN_RealVtaMNNeto,
			MIN(OportunidadAhorroMN) AS U15C_MIN_OportunidadAhorroMN,
			MAX(RealUUVendidas ) AS U15C_MAX_RealUUVendidas ,
			MAX(RealUUDevueltas) AS U15C_MAX_RealUUDevueltas,
			MAX(RealUUAnuladas) AS U15C_MAX_RealUUAnuladas,
			MAX(RealVtaMNNeto) AS U15C_MAX_RealVtaMNNeto,
			MAX(OportunidadAhorroMN) AS U15C_MAX_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos14
	GROUP BY A.CodPais, A.PkEbelista
),EbelistaCampanaMenos17 AS
(
	SELECT A.CodPais, A.PkEbelista, 
			1.0*SUM(RealUUVendidas)/17 as U18C_RealUUVendidas,
			1.0*SUM(RealUUFaltantes)/17 as U18C_RealUUFaltantes,
			1.0*SUM(RealUUDevueltas)/17 as U18C_RealUUDevueltas, 
			1.0*SUM(RealUUAnuladas)/17 as U18C_RealUUAnuladas,
			1.0*SUM(RealVtaMNNeto)/17 as U18C_RealVtaMNNeto,
			1.0*SUM(OportunidadAhorroMN)/17 as U18C_OportunidadAhorroMN,
			AVG(RealVtaMNNeto ) AS U18C_PRO_RealVtaMNNeto,
			AVG(OportunidadAhorroMN ) AS U18C_PRO_OportunidadAhorroMN ,
			STDEV(RealUUVendidas ) AS U18C_DESV_RealUUVendidas ,
			STDEV(RealUUDevueltas) AS U18C_DESV_RealUUDevueltas,
			STDEV(RealUUAnuladas) AS U18C_DESV_RealUUAnuladas,
			STDEV(RealVtaMNNeto) AS U18C_DESV_RealVtaMNNeto,
			STDEV(OportunidadAhorroMN) AS U18C_DESV_OportunidadAhorroMN,
			MIN(RealUUVendidas ) AS U18C_MIN_RealUUVendidas ,
			MIN(RealUUDevueltas) AS U18C_MIN_RealUUDevueltas,
			MIN(RealUUAnuladas) AS U18C_MIN_RealUUAnuladas,
			MIN(RealVtaMNNeto) AS U18C_MIN_RealVtaMNNeto,
			MIN(OportunidadAhorroMN) AS U18C_MIN_OportunidadAhorroMN,
			MAX(RealUUVendidas ) AS U18C_MAX_RealUUVendidas ,
			MAX(RealUUDevueltas) AS U18C_MAX_RealUUDevueltas,
			MAX(RealUUAnuladas) AS U18C_MAX_RealUUAnuladas,
			MAX(RealVtaMNNeto) AS U18C_MAX_RealVtaMNNeto,
			MAX(OportunidadAhorroMN) AS U18C_MAX_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos17
	GROUP BY A.CodPais, A.PkEbelista
)
SELECT A.CodPais,
		A.PkEbelista,
		ISNULL(J.UC_RealUUVendidas,0)					AS UC_RealUUVendidas,         
		ISNULL(I.U2C_RealUUVendidas,0)				AS U2C_RealUUVendidas,
		ISNULL(H.U3C_RealUUVendidas,0)			AS U3C_RealUUVendidas,
		ISNULL(G.U4C_RealUUVendidas,0)				AS U4C_RealUUVendidas,
		ISNULL(F.U5C_RealUUVendidas,0)			AS U5C_RealUUVendidas,
		ISNULL(E.U6C_RealUUVendidas,0)			AS U6C_RealUUVendidas,
		ISNULL(D.U9C_RealUUVendidas,0)			AS U9C_RealUUVendidas,
		ISNULL(C.U12C_RealUUVendidas,0)				AS U12C_RealUUVendidas,
		ISNULL(B.U15C_RealUUVendidas,0)			AS U15C_RealUUVendidas,
		ISNULL(A.U18C_RealUUVendidas,0)			AS U18C_RealUUVendidas,
		ISNULL(J.UC_RealUUFaltantes,0)			AS UC_RealUUFaltantes,
		ISNULL(I.U2C_RealUUFaltantes,0)				AS U2C_RealUUFaltantes,
		ISNULL(H.U3C_RealUUFaltantes,0)			AS U3C_RealUUFaltantes,
		ISNULL(G.U4C_RealUUFaltantes,0)			AS U4C_RealUUFaltantes,
		ISNULL(F.U5C_RealUUFaltantes,0)			AS U5C_RealUUFaltantes,
		ISNULL(E.U6C_RealUUFaltantes,0)			AS U6C_RealUUFaltantes,
		ISNULL(D.U9C_RealUUFaltantes,0)			AS U9C_RealUUFaltantes,
		ISNULL(C.U12C_RealUUFaltantes,0)			AS U12C_RealUUFaltantes,
		ISNULL(B.U15C_RealUUFaltantes,0)			AS U15C_RealUUFaltantes,
		ISNULL(A.U18C_RealUUFaltantes,0)			AS U18C_RealUUFaltantes,
		ISNULL(J.UC_RealUUDevueltas,0)			AS UC_RealUUDevueltas,
		ISNULL(I.U2C_RealUUDevueltas,0)				AS U2C_RealUUDevueltas,
		ISNULL(H.U3C_RealUUDevueltas,0)			AS U3C_RealUUDevueltas,
		ISNULL(G.U4C_RealUUDevueltas,0)			AS U4C_RealUUDevueltas,
		ISNULL(F.U5C_RealUUDevueltas,0)			AS U5C_RealUUDevueltas,
		ISNULL(E.U6C_RealUUDevueltas,0)			AS U6C_RealUUDevueltas,
		ISNULL(D.U9C_RealUUDevueltas,0)			AS U9C_RealUUDevueltas,
		ISNULL(C.U12C_RealUUDevueltas,0)			AS U12C_RealUUDevueltas,
		ISNULL(B.U15C_RealUUDevueltas,0)			AS U15C_RealUUDevueltas,
		ISNULL(A.U18C_RealUUDevueltas,0)			AS U18C_RealUUDevueltas,
		ISNULL(J.UC_RealUUAnuladas,0)			AS UC_RealUUAnuladas,
		ISNULL(I.U2C_RealUUAnuladas,0)				AS U2C_RealUUAnuladas,
		ISNULL(H.U3C_RealUUAnuladas,0)			AS U3C_RealUUAnuladas,
		ISNULL(G.U4C_RealUUAnuladas,0)			AS U4C_RealUUAnuladas,
		ISNULL(F.U5C_RealUUAnuladas,0)			AS U5C_RealUUAnuladas,
		ISNULL(E.U6C_RealUUAnuladas,0)			AS U6C_RealUUAnuladas,
		ISNULL(D.U9C_RealUUAnuladas,0)			AS U9C_RealUUAnuladas,
		ISNULL(C.U12C_RealUUAnuladas,0)				AS U12C_RealUUAnuladas,
		ISNULL(B.U15C_RealUUAnuladas,0)			AS U15C_RealUUAnuladas,
		ISNULL(A.U18C_RealUUAnuladas,0)			AS U18C_RealUUAnuladas,
		ISNULL(J.UC_RealVtaMNNeto,0)			AS UC_RealVtaMNNeto,
		ISNULL(I.U2C_RealVtaMNNeto,0)				AS U2C_RealVtaMNNeto,
		ISNULL(H.U3C_RealVtaMNNeto,0)				AS U3C_RealVtaMNNeto,
		ISNULL(G.U4C_RealVtaMNNeto,0)				AS U4C_RealVtaMNNeto,
		ISNULL(F.U5C_RealVtaMNNeto,0)				AS U5C_RealVtaMNNeto,
		ISNULL(E.U6C_RealVtaMNNeto,0)				AS U6C_RealVtaMNNeto,
		ISNULL(D.U9C_RealVtaMNNeto,0)				AS U9C_RealVtaMNNeto,
		ISNULL(C.U12C_RealVtaMNNeto,0)				AS U12C_RealVtaMNNeto,
		ISNULL(B.U15C_RealVtaMNNeto,0)			AS U15C_RealVtaMNNeto,
		ISNULL(A.U18C_RealVtaMNNeto,0)			AS U18C_RealVtaMNNeto,
		ISNULL(J.UC_OportunidadAhorroMN,0)			AS UC_OportunidadAhorroMN,
		ISNULL(I.U2C_OportunidadAhorroMN,0)			AS U2C_OportunidadAhorroMN,
		ISNULL(H.U3C_OportunidadAhorroMN,0)		AS U3C_OportunidadAhorroMN,
		ISNULL(G.U4C_OportunidadAhorroMN,0)		AS U4C_OportunidadAhorroMN,
		ISNULL(F.U5C_OportunidadAhorroMN,0)		AS U5C_OportunidadAhorroMN,
		ISNULL(E.U6C_OportunidadAhorroMN,0)		AS U6C_OportunidadAhorroMN,
		ISNULL(D.U9C_OportunidadAhorroMN,0)		AS U9C_OportunidadAhorroMN,
		ISNULL(C.U12C_OportunidadAhorroMN,0)		AS U12C_OportunidadAhorroMN,
		ISNULL(B.U15C_OportunidadAhorroMN,0)		AS U15C_OportunidadAhorroMN,
		ISNULL(A.U18C_OportunidadAhorroMN,0)		AS U18C_OportunidadAhorroMN,
		ISNULL(I.U2C_PRO_OportunidadAhorroMN,0)		AS U2C_PRO_OportunidadAhorroMN,
		ISNULL(I.U2C_DESV_RealUUVendidas,0)	AS U2C_DESV_RealUUVendidas,
		ISNULL(I.U2C_DESV_RealUUDevueltas,0)		AS U2C_DESV_RealUUDevueltas,
		ISNULL(I.U2C_DESV_RealUUAnuladas,0)		AS U2C_DESV_RealUUAnuladas,
		ISNULL(I.U2C_DESV_RealVtaMNNeto,0)		AS U2C_DESV_RealVtaMNNeto,
		ISNULL(I.U2C_DESV_OportunidadAhorroMN,0)		AS U2C_DESV_OportunidadAhorroMN,
		ISNULL(I.U2C_MIN_RealUUVendidas,0)	AS U2C_MIN_RealUUVendidas,
		ISNULL(I.U2C_MIN_RealUUDevueltas,0)			AS U2C_MIN_RealUUDevueltas,
		ISNULL(I.U2C_MIN_RealUUAnuladas,0)		AS U2C_MIN_RealUUAnuladas,
		ISNULL(I.U2C_MIN_RealVtaMNNeto,0)		AS U2C_MIN_RealVtaMNNeto,
		ISNULL(I.U2C_MIN_OportunidadAhorroMN,0)		AS U2C_MIN_OportunidadAhorroMN,
		ISNULL(I.U2C_MAX_RealUUVendidas,0)	AS U2C_MAX_RealUUVendidas,
		ISNULL(I.U2C_MAX_RealUUDevueltas,0)			AS U2C_MAX_RealUUDevueltas,
		ISNULL(I.U2C_MAX_RealUUAnuladas,0)		AS U2C_MAX_RealUUAnuladas,
		ISNULL(I.U2C_MAX_RealVtaMNNeto,0)		AS U2C_MAX_RealVtaMNNeto,
		ISNULL(H.U3C_PRO_OportunidadAhorroMN,0)		AS U3C_PRO_OportunidadAhorroMN,
		ISNULL(H.U3C_DESV_RealUUVendidas,0)		AS U3C_DESV_RealUUVendidas,
		ISNULL(H.U3C_DESV_RealUUDevueltas,0)		AS U3C_DESV_RealUUDevueltas,
		ISNULL(H.U3C_DESV_RealUUAnuladas,0)		AS U3C_DESV_RealUUAnuladas,
		ISNULL(H.U3C_DESV_RealVtaMNNeto,0)		AS U3C_DESV_RealVtaMNNeto,
		ISNULL(H.U3C_DESV_OportunidadAhorroMN,0)		AS U3C_DESV_OportunidadAhorroMN,
		ISNULL(H.U3C_MIN_RealUUVendidas,0)	AS U3C_MIN_RealUUVendidas,
		ISNULL(H.U3C_MIN_RealUUDevueltas,0)			AS U3C_MIN_RealUUDevueltas,
		ISNULL(H.U3C_MIN_RealUUAnuladas,0)		AS U3C_MIN_RealUUAnuladas,
		ISNULL(H.U3C_MIN_RealVtaMNNeto,	0)		AS U3C_MIN_RealVtaMNNeto,
		ISNULL(H.U3C_MIN_OportunidadAhorroMN,0)		AS U3C_MIN_OportunidadAhorroMN,
		ISNULL(H.U3C_MAX_RealUUVendidas,0)	AS U3C_MAX_RealUUVendidas,
		ISNULL(H.U3C_MAX_RealUUDevueltas,0)			AS U3C_MAX_RealUUDevueltas,
		ISNULL(H.U3C_MAX_RealUUAnuladas,0)		AS U3C_MAX_RealUUAnuladas,
		ISNULL(H.U3C_MAX_RealVtaMNNeto,	0)		AS U3C_MAX_RealVtaMNNeto,
		ISNULL(G.U4C_PRO_OportunidadAhorroMN,0)		AS U4C_PRO_OportunidadAhorroMN,
		ISNULL(G.U4C_DESV_RealUUVendidas,0)	AS U4C_DESV_RealUUVendidas,
		ISNULL(G.U4C_DESV_RealUUDevueltas,0)		AS U4C_DESV_RealUUDevueltas,
		ISNULL(G.U4C_DESV_RealUUAnuladas,0)		AS U4C_DESV_RealUUAnuladas,
		ISNULL(G.U4C_DESV_RealVtaMNNeto,0)		AS U4C_DESV_RealVtaMNNeto,
		ISNULL(G.U4C_DESV_OportunidadAhorroMN,0)		AS U4C_DESV_OportunidadAhorroMN,
		ISNULL(G.U4C_MIN_RealUUVendidas,0)	AS U4C_MIN_RealUUVendidas,
		ISNULL(G.U4C_MIN_RealUUDevueltas,0)			AS U4C_MIN_RealUUDevueltas,
		ISNULL(G.U4C_MIN_RealUUAnuladas,0)		AS U4C_MIN_RealUUAnuladas,
		ISNULL(G.U4C_MIN_RealVtaMNNeto,	0)		AS U4C_MIN_RealVtaMNNeto,
		ISNULL(G.U4C_MIN_OportunidadAhorroMN,0)		AS U4C_MIN_OportunidadAhorroMN,
		ISNULL(G.U4C_MAX_RealUUVendidas,0)	AS U4C_MAX_RealUUVendidas,
		ISNULL(G.U4C_MAX_RealUUDevueltas,0)			AS U4C_MAX_RealUUDevueltas,
		ISNULL(G.U4C_MAX_RealUUAnuladas,0)		AS U4C_MAX_RealUUAnuladas,
		ISNULL(G.U4C_MAX_RealVtaMNNeto,0)		AS U4C_MAX_RealVtaMNNeto,
		ISNULL(F.U5C_PRO_OportunidadAhorroMN,0)		AS U5C_PRO_OportunidadAhorroMN,
		ISNULL(F.U5C_DESV_RealUUVendidas,0)	AS U5C_DESV_RealUUVendidas,
		ISNULL(F.U5C_DESV_RealUUDevueltas,0)			AS U5C_DESV_RealUUDevueltas,
		ISNULL(F.U5C_DESV_RealUUAnuladas,0)		AS U5C_DESV_RealUUAnuladas,
		ISNULL(F.U5C_DESV_RealVtaMNNeto,0)		AS U5C_DESV_RealVtaMNNeto,
		ISNULL(F.U5C_DESV_OportunidadAhorroMN,0)		AS U5C_DESV_OportunidadAhorroMN,
		ISNULL(F.U5C_MIN_RealUUVendidas,0)	AS U5C_MIN_RealUUVendidas,
		ISNULL(F.U5C_MIN_RealUUDevueltas,0)			AS U5C_MIN_RealUUDevueltas,
		ISNULL(F.U5C_MIN_RealUUAnuladas,0)		AS U5C_MIN_RealUUAnuladas,
		ISNULL(F.U5C_MIN_RealVtaMNNeto,0)		AS U5C_MIN_RealVtaMNNeto,
		ISNULL(F.U5C_MIN_OportunidadAhorroMN,0)		AS U5C_MIN_OportunidadAhorroMN,
		ISNULL(F.U5C_MAX_RealUUVendidas,0)		AS U5C_MAX_RealUUVendidas,
		ISNULL(F.U5C_MAX_RealUUDevueltas,0)		AS U5C_MAX_RealUUDevueltas,
		ISNULL(F.U5C_MAX_RealUUAnuladas,0)		AS U5C_MAX_RealUUAnuladas,
		ISNULL(F.U5C_MAX_RealVtaMNNeto,0)		AS U5C_MAX_RealVtaMNNeto,
		ISNULL(E.U6C_PRO_OportunidadAhorroMN,0)		AS U6C_PRO_OportunidadAhorroMN,
		ISNULL(E.U6C_DESV_RealUUVendidas,0)	AS U6C_DESV_RealUUVendidas,
		ISNULL(E.U6C_DESV_RealUUDevueltas,0)		AS U6C_DESV_RealUUDevueltas,
		ISNULL(E.U6C_DESV_RealUUAnuladas,0)		AS U6C_DESV_RealUUAnuladas,
		ISNULL(E.U6C_DESV_RealVtaMNNeto,0)		AS U6C_DESV_RealVtaMNNeto,
		ISNULL(E.U6C_DESV_OportunidadAhorroMN,0)		AS U6C_DESV_OportunidadAhorroMN,
		ISNULL(E.U6C_MIN_RealUUVendidas,0)	AS U6C_MIN_RealUUVendidas,
		ISNULL(E.U6C_MIN_RealUUDevueltas,0)			AS U6C_MIN_RealUUDevueltas,
		ISNULL(E.U6C_MIN_RealUUAnuladas,0)		AS U6C_MIN_RealUUAnuladas,
		ISNULL(E.U6C_MIN_RealVtaMNNeto,0)		AS U6C_MIN_RealVtaMNNeto,
		ISNULL(E.U6C_MIN_OportunidadAhorroMN,0)		AS U6C_MIN_OportunidadAhorroMN,
		ISNULL(E.U6C_MAX_RealUUVendidas,0)	AS U6C_MAX_RealUUVendidas,
		ISNULL(E.U6C_MAX_RealUUDevueltas,0)			AS U6C_MAX_RealUUDevueltas,
		ISNULL(E.U6C_MAX_RealUUAnuladas,0)		AS U6C_MAX_RealUUAnuladas,
		ISNULL(E.U6C_MAX_RealVtaMNNeto,0)		AS U6C_MAX_RealVtaMNNeto,
		ISNULL(D.U9C_PRO_OportunidadAhorroMN,0)		AS U9C_PRO_OportunidadAhorroMN,
		ISNULL(D.U9C_DESV_RealUUVendidas,0)	AS U9C_DESV_RealUUVendidas,
		ISNULL(D.U9C_DESV_RealUUDevueltas,0)		AS U9C_DESV_RealUUDevueltas,
		ISNULL(D.U9C_DESV_RealUUAnuladas,0)		AS U9C_DESV_RealUUAnuladas,
		ISNULL(D.U9C_DESV_RealVtaMNNeto,0)			AS U9C_DESV_RealVtaMNNeto,
		ISNULL(D.U9C_DESV_OportunidadAhorroMN,0)		AS U9C_DESV_OportunidadAhorroMN,
		ISNULL(D.U9C_MIN_RealUUVendidas,0)	AS U9C_MIN_RealUUVendidas,
		ISNULL(D.U9C_MIN_RealUUDevueltas,0)			AS U9C_MIN_RealUUDevueltas,
		ISNULL(D.U9C_MIN_RealUUAnuladas,0)		AS U9C_MIN_RealUUAnuladas,
		ISNULL(D.U9C_MIN_RealVtaMNNeto,0)		AS U9C_MIN_RealVtaMNNeto,
		ISNULL(D.U9C_MIN_OportunidadAhorroMN,0)		AS U9C_MIN_OportunidadAhorroMN,
		ISNULL(D.U9C_MAX_RealUUVendidas,0)	AS U9C_MAX_RealUUVendidas,
		ISNULL(D.U9C_MAX_RealUUDevueltas,0)			AS U9C_MAX_RealUUDevueltas,
		ISNULL(D.U9C_MAX_RealUUAnuladas,0)		AS U9C_MAX_RealUUAnuladas,
		ISNULL(D.U9C_MAX_RealVtaMNNeto,0)		AS U9C_MAX_RealVtaMNNeto,
		ISNULL(C.U12C_PRO_OportunidadAhorroMN,0)		AS U12C_PRO_OportunidadAhorroMN,
		ISNULL(C.U12C_DESV_RealUUVendidas,0)	AS U12C_DESV_RealUUVendidas,
		ISNULL(C.U12C_DESV_RealUUDevueltas,0)		AS U12C_DESV_RealUUDevueltas,
		ISNULL(C.U12C_DESV_RealUUAnuladas,0)		AS U12C_DESV_RealUUAnuladas,
		ISNULL(C.U12C_DESV_RealVtaMNNeto,0)		AS U12C_DESV_RealVtaMNNeto,
		ISNULL(C.U12C_DESV_OportunidadAhorroMN,0)		AS U12C_DESV_OportunidadAhorroMN,
		ISNULL(C.U12C_MIN_RealUUVendidas,0)	AS U12C_MIN_RealUUVendidas,
		ISNULL(C.U12C_MIN_RealUUDevueltas,0)		AS U12C_MIN_RealUUDevueltas,
		ISNULL(C.U12C_MIN_RealUUAnuladas,0)		AS U12C_MIN_RealUUAnuladas,
		ISNULL(C.U12C_MIN_RealVtaMNNeto,0)		AS U12C_MIN_RealVtaMNNeto,
		ISNULL(C.U12C_MIN_OportunidadAhorroMN,0)		AS U12C_MIN_OportunidadAhorroMN,
		ISNULL(C.U12C_MAX_RealUUVendidas,0)	AS U12C_MAX_RealUUVendidas,
		ISNULL(C.U12C_MAX_RealUUDevueltas,0)		AS U12C_MAX_RealUUDevueltas,
		ISNULL(C.U12C_MAX_RealUUAnuladas,0)		AS U12C_MAX_RealUUAnuladas,
		ISNULL(C.U12C_MAX_RealVtaMNNeto,0)		AS U12C_MAX_RealVtaMNNeto,
		ISNULL(B.U15C_PRO_OportunidadAhorroMN,0)		AS U15C_PRO_OportunidadAhorroMN,
		ISNULL(B.U15C_DESV_RealUUVendidas,0)	AS U15C_DESV_RealUUVendidas,
		ISNULL(B.U15C_DESV_RealUUDevueltas,0)		AS U15C_DESV_RealUUDevueltas,
		ISNULL(B.U15C_DESV_RealUUAnuladas,0)		AS U15C_DESV_RealUUAnuladas,
		ISNULL(B.U15C_DESV_RealVtaMNNeto,0)		AS U15C_DESV_RealVtaMNNeto,
		ISNULL(B.U15C_DESV_OportunidadAhorroMN,0)		AS U15C_DESV_OportunidadAhorroMN,
		ISNULL(B.U15C_MIN_RealUUVendidas,0)	AS U15C_MIN_RealUUVendidas,
		ISNULL(B.U15C_MIN_RealUUDevueltas,0)		AS U15C_MIN_RealUUDevueltas,
		ISNULL(B.U15C_MIN_RealUUAnuladas,0)		AS U15C_MIN_RealUUAnuladas,
		ISNULL(B.U15C_MIN_RealVtaMNNeto,0)		AS U15C_MIN_RealVtaMNNeto,
		ISNULL(B.U15C_MIN_OportunidadAhorroMN,0)		AS U15C_MIN_OportunidadAhorroMN,
		ISNULL(B.U15C_MAX_RealUUVendidas,0)	AS U15C_MAX_RealUUVendidas,
		ISNULL(B.U15C_MAX_RealUUDevueltas,0)		AS U15C_MAX_RealUUDevueltas,
		ISNULL(B.U15C_MAX_RealUUAnuladas,0)		AS U15C_MAX_RealUUAnuladas,
		ISNULL(B.U15C_MAX_RealVtaMNNeto,0)		AS U15C_MAX_RealVtaMNNeto,
		ISNULL(A.U18C_PRO_OportunidadAhorroMN,0)		AS U18C_PRO_OportunidadAhorroMN,
		ISNULL(A.U18C_DESV_RealUUVendidas,0)	AS U18C_DESV_RealUUVendidas,
		ISNULL(A.U18C_DESV_RealUUDevueltas,0)		AS U18C_DESV_RealUUDevueltas,
		ISNULL(A.U18C_DESV_RealUUAnuladas,0)		AS U18C_DESV_RealUUAnuladas,
		ISNULL(A.U18C_DESV_RealVtaMNNeto,0)		AS U18C_DESV_RealVtaMNNeto,
		ISNULL(A.U18C_DESV_OportunidadAhorroMN,0)		AS U18C_DESV_OportunidadAhorroMN,
		ISNULL(A.U18C_MIN_RealUUVendidas,0)	AS U18C_MIN_RealUUVendidas,
		ISNULL(A.U18C_MIN_RealUUDevueltas,0)		AS U18C_MIN_RealUUDevueltas,
		ISNULL(A.U18C_MIN_RealUUAnuladas,0)		AS U18C_MIN_RealUUAnuladas,
		ISNULL(A.U18C_MIN_RealVtaMNNeto,0)		AS U18C_MIN_RealVtaMNNeto,
		ISNULL(A.U18C_MIN_OportunidadAhorroMN,0)		AS U18C_MIN_OportunidadAhorroMN,
		ISNULL(A.U18C_MAX_RealUUVendidas,0)	AS U18C_MAX_RealUUVendidas,
		ISNULL(A.U18C_MAX_RealUUDevueltas,0)		AS U18C_MAX_RealUUDevueltas,
		ISNULL(A.U18C_MAX_RealUUAnuladas,0)		AS U18C_MAX_RealUUAnuladas,
		ISNULL(A.U18C_MAX_RealVtaMNNeto,0)		AS U18C_MAX_RealVtaMNNeto
INTO #TMP_EbeHistoria
FROM EbelistaCampanaMenos17 A
LEFT JOIN EbelistaCampanaMenos14 B ON A.Pkebelista = B.Pkebelista AND A.CodPais = B.CodPais
LEFT JOIN EbelistaCampanaMenos11 C ON A.Pkebelista = C.Pkebelista AND A.CodPais = C.CodPais
LEFT JOIN EbelistaCampanaMenos8 D ON A.Pkebelista = D.Pkebelista AND A.CodPais = D.CodPais
LEFT JOIN EbelistaCampanaMenos5 E ON A.Pkebelista = E.Pkebelista AND A.CodPais = E.CodPais
LEFT JOIN EbelistaCampanaMenos4 F ON A.Pkebelista = F.Pkebelista AND A.CodPais = F.CodPais
LEFT JOIN EbelistaCampanaMenos3 G ON A.Pkebelista = G.Pkebelista AND A.CodPais = G.CodPais
LEFT JOIN EbelistaCampanaMenos2 H ON A.Pkebelista = H.Pkebelista AND A.CodPais = H.CodPais 
LEFT JOIN EbelistaCampanaMenos1 I ON A.Pkebelista = I.Pkebelista AND A.CodPais = I.CodPais
LEFT JOIN EbelistaUC J ON A.Pkebelista = J.Pkebelista AND A.CodPais = J.CodPais

/*PE: 9min aprox a las 2pm Cantidad: 272854 Consultoras*/

--select * from BD_ANALITICO.dbo.KR_MAT_FUGA_201716
--WHERE PkEbelista = 1228448

--select * from #TMP_EbeHistoria
--WHERE PkEbelista = 1228448


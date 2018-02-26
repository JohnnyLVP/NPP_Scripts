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
	 @AnioCampanamenos8 CHAR(6),
	 @AnioCampanamenos11 CHAR(6),
	 @AnioCampanamenos14 CHAR(6),
	 @AnioCampanamenos17 CHAR(6),
	 @CodPais CHAR(2),
	 @AnioCampana CHAR(6)

set @CodPais = 'CO'
set @AnioCampana = '201709'
set @AnioCampanamenos1 = dbo.CalculaAnioCampana(@AnioCampana, -1)
set @AnioCampanamenos2 = dbo.CalculaAnioCampana(@AnioCampana, -2)
set @AnioCampanamenos3 = dbo.CalculaAnioCampana(@AnioCampana, -3)
set @AnioCampanamenos4 = dbo.CalculaAnioCampana(@AnioCampana, -4)
set @AnioCampanamenos5 = dbo.CalculaAnioCampana(@AnioCampana, -5)
set @AnioCampanamenos8 = dbo.CalculaAnioCampana(@AnioCampana, -8)
set @AnioCampanamenos11 = dbo.CalculaAnioCampana(@AnioCampana, -11)
set @AnioCampanamenos14 = dbo.CalculaAnioCampana(@AnioCampana, -14)
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
INNER JOIN  [DWH_ANALITICO].[dbo].[DWH_DTIPOOFERTA] B  ON A.PKTipoOferta=B.PKTipoOferta AND B.CodPais = @CodPais 
WHERE A.ANIOCAMPANA BETWEEN @AnioCampanamenos17 AND @AnioCampana AND B.codtipoprofit = '01' AND A.RealVtaMNNeto > 0 
	AND A.CodPais = @CodPais AND a.AnioCampana = a.AnioCampanaRef
GROUP BY A.CodPais, A.AnioCampana,A.PkEbelista


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
			1.0*SUM(OportunidadAhorroMN)/2 as U2C_OportunidadAhorroMN
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
			1.0*SUM(OportunidadAhorroMN)/3 as U3C_OportunidadAhorroMN
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
			1.0*SUM(OportunidadAhorroMN)/4 as U4C_OportunidadAhorroMN
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
			1.0*SUM(OportunidadAhorroMN)/5 as U5C_OportunidadAhorroMN
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
			1.0*SUM(OportunidadAhorroMN)/6 as U6C_OportunidadAhorroMN
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
			1.0*SUM(OportunidadAhorroMN)/9 as U9C_OportunidadAhorroMN
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
			1.0*SUM(OportunidadAhorroMN)/12 as U12C_OportunidadAhorroMN
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
			1.0*SUM(OportunidadAhorroMN)/15 as U15C_OportunidadAhorroMN
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
			1.0*SUM(OportunidadAhorroMN)/17 as U18C_OportunidadAhorroMN
	FROM #TMP_FVTAPROEBECAM A
	WHERE AnioCampana >= @AnioCampanamenos17
	GROUP BY A.CodPais, A.PkEbelista
)
SELECT A.CodPais,A.PkEbelista,
		J.UC_RealUUVendidas,I.U2C_RealUUVendidas,H.U3C_RealUUVendidas,G.U4C_RealUUVendidas,F.U5C_RealUUVendidas,
		E.U6C_RealUUVendidas,D.U9C_RealUUVendidas,C.U12C_RealUUVendidas,B.U15C_RealUUVendidas,A.U18C_RealUUVendidas,
		J.UC_RealUUFaltantes,I.U2C_RealUUFaltantes,H.U3C_RealUUFaltantes,G.U4C_RealUUFaltantes,F.U5C_RealUUFaltantes,
		E.U6C_RealUUFaltantes,D.U9C_RealUUFaltantes,C.U12C_RealUUFaltantes,B.U15C_RealUUFaltantes,A.U18C_RealUUFaltantes,
		J.UC_RealUUDevueltas,I.U2C_RealUUDevueltas,H.U3C_RealUUDevueltas,G.U4C_RealUUDevueltas,F.U5C_RealUUDevueltas,
		E.U6C_RealUUDevueltas,D.U9C_RealUUDevueltas,C.U12C_RealUUDevueltas,B.U15C_RealUUDevueltas,A.U18C_RealUUDevueltas,
		J.UC_RealUUAnuladas,I.U2C_RealUUAnuladas,H.U3C_RealUUAnuladas,G.U4C_RealUUAnuladas,F.U5C_RealUUAnuladas,
		E.U6C_RealUUAnuladas,D.U9C_RealUUAnuladas,C.U12C_RealUUAnuladas,B.U15C_RealUUAnuladas,A.U18C_RealUUAnuladas,
		J.UC_RealVtaMNNeto,I.U2C_RealVtaMNNeto,H.U3C_RealVtaMNNeto,G.U4C_RealVtaMNNeto,F.U5C_RealVtaMNNeto,
		E.U6C_RealVtaMNNeto,D.U9C_RealVtaMNNeto,C.U12C_RealVtaMNNeto,B.U15C_RealVtaMNNeto,A.U18C_RealVtaMNNeto,
		J.UC_OportunidadAhorroMN,I.U2C_OportunidadAhorroMN,H.U3C_OportunidadAhorroMN,G.U4C_OportunidadAhorroMN,F.U5C_OportunidadAhorroMN,
		E.U6C_OportunidadAhorroMN,D.U9C_OportunidadAhorroMN,C.U12C_OportunidadAhorroMN,B.U15C_OportunidadAhorroMN,A.U18C_OportunidadAhorroMN
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


USE [master]
GO
/****** Object:  Database [CountryInformationDB]    Script Date: 13-Jan-16 8:40:29 PM ******/
CREATE DATABASE [CountryInformationDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CountryInformationDB', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\CountryInformationDB.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CountryInformationDB_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\CountryInformationDB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CountryInformationDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CountryInformationDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CountryInformationDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CountryInformationDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CountryInformationDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CountryInformationDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CountryInformationDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [CountryInformationDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CountryInformationDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [CountryInformationDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CountryInformationDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CountryInformationDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CountryInformationDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CountryInformationDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CountryInformationDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CountryInformationDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CountryInformationDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CountryInformationDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CountryInformationDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CountryInformationDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CountryInformationDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CountryInformationDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CountryInformationDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CountryInformationDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CountryInformationDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CountryInformationDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CountryInformationDB] SET  MULTI_USER 
GO
ALTER DATABASE [CountryInformationDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CountryInformationDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CountryInformationDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CountryInformationDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [CountryInformationDB]
GO
/****** Object:  StoredProcedure [dbo].[spGetCityInformaiton]    Script Date: 13-Jan-16 8:40:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetCityInformaiton]
	
@PageIndex int,
@PageSize int,
@TotalRecord int output
	
AS
BEGIN
	
	Declare @satrtIndex int
	Declare @endIndex int

	SET @satrtIndex=(@PageIndex* @PageSize)+1;
	SET @endIndex=(@PageIndex+1)*@PageSize;
	
	SELECT @TotalRecord=COUNT(*) FROM t_Country
	SELECT * FROM
	(
     SELECT ROW_NUMBER() OVER (Order By Id ASC ) AS RowNumber,Id,Name,About From t_Country 
	) AS Info
	 WHERE Info.RowNumber>=@satrtIndex and Info.RowNumber<=@endIndex
END
GO
/****** Object:  Table [dbo].[t_City]    Script Date: 13-Jan-16 8:40:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_City](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[About] [nvarchar](max) NOT NULL,
	[No_Of_Dwellers] [bigint] NOT NULL,
	[Location] [nvarchar](max) NOT NULL,
	[Weather] [nvarchar](max) NOT NULL,
	[CountryId] [int] NOT NULL,
 CONSTRAINT [PK_t_City] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_Country]    Script Date: 13-Jan-16 8:40:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[About] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_t_Country] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[CityInformation]    Script Date: 13-Jan-16 8:40:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CityInformation]
  AS
  SELECT CountryId,Count(Id) AS Total_City,Sum(No_Of_Dwellers) AS Total_Dwellers From t_City Group by CountryId
GO
/****** Object:  View [dbo].[CountryInformation]    Script Date: 13-Jan-16 8:40:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE VIEW [dbo].[CountryInformation]
  AS
  SELECT c.Name,c.About,CI.Total_City,CI.Total_Dwellers FROM t_Country c LEFT OUTER JOIN CityInformation CI ON c.Id=CI.CountryId
GO
/****** Object:  View [dbo].[CountryInformationWithCity]    Script Date: 13-Jan-16 8:40:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CountryInformationWithCity]
  AS
 SELECT c.Name,c.About,COAlESCE(ct.Total_City,'0') AS Total_City,COALESCE(ct.Total_Dwellers,'0') AS Total_Dwellers 
  FROM CountryInformation c
  LEFT JOIN CountryInformation ct
  ON c.Name=ct.Name
GO
/****** Object:  View [dbo].[GetCountryInformation]    Script Date: 13-Jan-16 8:40:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GetCountryInformation]
  AS
  SELECT c.Id,c.Name AS 'City_Name',c.About AS 'About_City',c.No_Of_Dwellers AS No_of_Dwellers ,c.Location,c.Weather,cn.Name AS 'Country_Name',cn.About 'About_Country' FROM t_City c INNER JOIN t_Country cn ON c.CountryId=cn.Id

GO
SET IDENTITY_INSERT [dbo].[t_City] ON 

INSERT [dbo].[t_City] ([Id], [Name], [About], [No_Of_Dwellers], [Location], [Weather], [CountryId]) VALUES (1, N'Rangpur', N'<p><span><em><strong><span class="fr-just" style="font-size: 24px;">Rangpur</span></strong></em> is a district in Northern Bangladesh. It is a part of the Rangpur Division.</span><span><span><span>&nbsp;</span></span><a data-ved="0ahUKEwiqhsXQg6bKAhUNjo4KHVzSBBoQmhMIggEwEA" href="http://en.wikipedia.org/wiki/Rangpur_District">Wikipedia</a></span></p>', 10000, N'Rangpur Division', N'26°C, Wind W at 3 km/h, 38% Humidity', 1)
INSERT [dbo].[t_City] ([Id], [Name], [About], [No_Of_Dwellers], [Location], [Weather], [CountryId]) VALUES (2, N'Nilphamari', N'<p><img class="fr-dib" src="http://i.froala.com/download/b2af03fdc81c919b25d2504abae0a8fca6432550.jpg?1452662159" style="width: 150px; height: 120px;"><span>Nilphamari is a district in Northern Bangladesh. It is a part of the Rangpur Division. It is 400 km from the capital Dhaka in north and west side. It has an area of 547 square kilometres.</span><span><span><span>&nbsp;</span></span><a data-ved="0ahUKEwjuiO2qhKbKAhUDBI4KHdmXANAQmhMIgwEwEg" href="http://en.wikipedia.org/wiki/Nilphamari_District">Wikipedia</a></span></p>', 10000, N'Rangpur Division', N'Good', 1)
INSERT [dbo].[t_City] ([Id], [Name], [About], [No_Of_Dwellers], [Location], [Weather], [CountryId]) VALUES (3, N'Mumbai', N'<p><strong>Mumbai</strong><span><span>&nbsp;</span>(</span><span><span><a href="https://en.wikipedia.org/wiki/Help:IPA_for_English" title="Help:IPA for English">/<span><span title="''m'' in ''my''">m</span><span title="/ʊ/ short ''oo'' in ''foot''">ʊ</span><span title="''m'' in ''my''">m</span><span title="/ˈ/ primary stress follows">ˈ</span><span title="''b'' in ''buy''">b</span><span title="/aɪ/ long ''i'' in ''tide''">aɪ</span></span>/</a></span></span><span>; also known as<span>&nbsp;</span></span><strong>Bombay</strong><span>,<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/List_of_renamed_Indian_cities_and_states#Maharashtra" title="List of renamed Indian cities and states">the official name until 1995</a><span>) is the<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Capital_city" title="Capital city">capital city</a><span><span>&nbsp;</span>of the<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/India" title="India">Indian</a><span><span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/States_and_Territories_of_India" title="States and Territories of India">state</a><span><span>&nbsp;</span>of<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Maharashtra" title="Maharashtra">Maharashtra</a><span>. It is the<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/List_of_most_populous_cities_in_India" title="List of most populous cities in India">most populous city in India</a><span><span>&nbsp;</span>and the<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/List_of_agglomerations_by_population" title="List of agglomerations by population">ninth most populous agglomeration in the world</a><span>, with an estimated city population of 18.4 million. Along with the neighbouring regions of the<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Mumbai_Metropolitan_Region" title="Mumbai Metropolitan Region">Mumbai Metropolitan Region</a><span>, it is one of the most populous</span><a href="https://en.wikipedia.org/wiki/List_of_urban_agglomerations_by_population" title="List of urban agglomerations by population">urban regions</a><span><span>&nbsp;</span>in the world and the seсond most populous<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/List_of_metropolitan_areas_in_India" title="List of metropolitan areas in India">metropolitan area</a><span><span>&nbsp;</span>in India, with a population of 20.7 million as of 2011.</span><sup><a href="https://en.wikipedia.org/wiki/Mumbai#cite_note-pibmumbai-12"><span>[</span>12<span>]</span></a></sup><sup><a href="https://en.wikipedia.org/wiki/Mumbai#cite_note-13"><span>[</span>13<span>]</span></a></sup><span><span>&nbsp;</span>Mumbai lies on the<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Konkan" title="Konkan">west</a><span><span>&nbsp;</span>coast of India and has a deep natural harbour. In 2009, Mumbai was named an<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Alpha_world_city" title="Alpha world city">alpha world city</a><span>.</span><sup><a href="https://en.wikipedia.org/wiki/Mumbai#cite_note-14"><span>[</span>14<span>]</span></a></sup><span><span>&nbsp;</span>It is also the wealthiest city in India,</span><sup><a href="https://en.wikipedia.org/wiki/Mumbai#cite_note-livemint.com-15"><span>[</span>15<span>]</span></a></sup><span><span>&nbsp;</span>and has the<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/List_of_cities_by_GDP#Asia.2C_Central_.26_South" title="List of cities by GDP">highest GDP</a><span><span>&nbsp;</span>of any city in<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/South_Asia" title="South Asia">South</a><span>,<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/West_Asia" title="West Asia">West</a><span>, or<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Central_Asia" title="Central Asia">Central Asia</a><span>.</span><sup><a href="https://en.wikipedia.org/wiki/Mumbai#cite_note-16"><span>[</span>16<span>]</span></a></sup><span><span>&nbsp;</span>Mumbai has the highest number of<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Billionaires" title="Billionaires">billionaires</a><span><span>&nbsp;</span>and<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Millionaires" title="Millionaires">millionaires</a><span>among all cities in India.</span><sup><a href="https://en.wikipedia.org/wiki/Mumbai#cite_note-17"><span>[</span>17<span>]</span></a></sup><sup><a href="https://en.wikipedia.org/wiki/Mumbai#cite_note-18"><span>[</span>18<span>]</span></a></sup></p>', 2025, N'Maharashtra', N'Good', 2)
INSERT [dbo].[t_City] ([Id], [Name], [About], [No_Of_Dwellers], [Location], [Weather], [CountryId]) VALUES (4, N'New Delhi', N'<p><span>The foundation stone of the city was laid by<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/George_V,_Emperor_of_India" title="George V, Emperor of India">George V, Emperor of India</a><span>during the<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Delhi_Durbar#Durbar_of_1911" title="Delhi Durbar">Delhi Durbar of 1911</a><span>.</span><sup><a href="https://en.wikipedia.org/wiki/New_Delhi#cite_note-History_New_Delhi-6"><span>[</span>6<span>]</span></a></sup><span><span>&nbsp;</span>It was designed by British architects,<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Edwin_Lutyens" title="Edwin Lutyens">Sir Edwin Lutyens</a><span><span>&nbsp;</span>and<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Herbert_Baker" title="Herbert Baker">Sir Herbert Baker</a><span>. The new capital was inaugurated on 13 February 1931,</span><sup><a href="https://en.wikipedia.org/wiki/New_Delhi#cite_note-India_freedom_capital-7"><span>[</span>7<span>]</span></a></sup><span><span>&nbsp;</span>by<span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/British_Raj" title="British Raj">India''s</a><span><span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Viceroy_and_Governor-General_of_India" title="Viceroy and Governor-General of India">Viceroy</a><span><span>&nbsp;</span></span><a href="https://en.wikipedia.org/wiki/Lord_Irwin" title="Lord Irwin">Lord Irwin</a><span>.</span></p>', 1000, N'Delhi', N'Good', 2)
INSERT [dbo].[t_City] ([Id], [Name], [About], [No_Of_Dwellers], [Location], [Weather], [CountryId]) VALUES (5, N'New York City', N'<p><img class="fr-fil fr-dib" alt="Us city" src="http://i.froala.com/download/c32a0d56a8f4a8867fadff19c9591cca1d0ae5dc.jpg?1452677706" width="222" title="Us city"></p><p><!--StartFragment-->Home to the Empire State Building, Times Square, Statue of Liberty and other iconic sites, New York City is a fast-paced, globally influential center of art, culture, fashion and finance. The city’s 5 boroughs sit where the Hudson River meets the Atlantic Ocean, with the island borough of Manhattan at the “Big Apple''s" core.<!--EndFragment--></p>', 1000, N'US', N'Good', 4)
INSERT [dbo].[t_City] ([Id], [Name], [About], [No_Of_Dwellers], [Location], [Weather], [CountryId]) VALUES (6, N'Dhaka', N'<p><img class="fr-fil fr-dib" alt="fdksadf" src="http://i.froala.com/download/200733905b9d4ab908d19f8428a679bb70c04b44.jpg?1452691827" width="228" title="fdksadf"></p><p><br></p>', 1000, N'BD', N'Good', 1)
SET IDENTITY_INSERT [dbo].[t_City] OFF
SET IDENTITY_INSERT [dbo].[t_Country] ON 

INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (1, N'Bangladesh', N'<p><span><img class="fr-dib" src="http://i.froala.com/download/ae2198f7e2b691035c7f7216c4721bc57eca7cb8.png?1452661039" style="width: 150px; height: 100px;">Bangladesh, east of India on the Bay of Bengal, is South Asian country of lush greenery and many waterways. Its Padma (Ganges), Meghna and Jamuna rivers create fertile alluvial plains, and travel by boat is common. On the southern coast, the Sundarbans, an enormous mangrove forest shared with India, are home to the Royal Bengal tiger.</span></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (2, N'India', N'<p><span><img class="fr-dib" src="http://i.froala.com/download/94b41d0cd9c72ccbb6da1d813e81dac6a2db5e9d.png?1452661123" style="width: 150px; height: 120px;">India is a vast South Asian country with diverse terrain – from Himalayan peaks to Indian Ocean coastline – and history reaching back 5 millennia. In the north, Mughal Empire landmarks include Delhi’s Red Fort complex, massive Jama Masjid mosque and Agra’s iconic Taj Mahal mausoleum. Pilgrims bathe in the Ganges in Varanasi, and Rishikesh is a yoga center and base for Himalayan trekking.</span></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (3, N'Bhutan', N'<p><img class="fr-dib" src="http://i.froala.com/download/16abc84c117cf32b156a755342e783d59c4179b0.png?1452661176" style="width: 150px; height: 120px;"><span>Bhutan, a Buddhist kingdom on the Himalayas’ eastern edge, is a land of monasteries, fortresses (or dzongs) and dramatic topography ranging from subtropical plains to steep mountains and valleys. In the High Himalayas, peaks such as 7,326m Jomolhari are a destination for serious trekkers. Taktsang Palphug (Tiger’s Nest) monastery, a sacred site, clings to cliffs above the forested Paro Valley.</span></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (4, N'United States of America', N'<p><img class="fr-dib" src="http://i.froala.com/download/58619a7c489579723f97e30e9d823ecf97955ff0.png?1452661356" style="width: 150px; height: 120px;"><span>The U.S. is a country of 50 states covering a vast swath of North America, with Alaska in the extreme Northwest and Hawaii extending the nation’s presence into the Pacific Ocean. Major cities include New York, a global finance and culture center, and Washington, DC, the capital, both on the Atlantic Coast; Los Angeles, famed for filmmaking, on the Pacific Coast; and the Midwestern metropolis Chicago.</span></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (5, N'China', N'<p><img class="fr-dib" src="http://i.froala.com/download/06dda99df95034d5ed2e4f66fa10192642d31c6f.png?1452661550" style="width: 150px; height: 120px;"><span>China, a communist nation in East Asia, is the world’s most populous country. Its vast landscape encompasses grassland, desert, mountain ranges, lakes, rivers and 14,500km of coastline. Beijing, the capital, mixes modern architecture with historic sites including sprawling Tiananmen Square. Its largest city, Shanghai, is a skyscraper-studded global financial center. The iconic Great Wall of China fortification runs east-west across the country''s north.</span></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (6, N'Malddives', N'<p><img class="fr-dib" src="http://i.froala.com/download/2eca3e3f95058d75b0ecdeb2e34dc3ffe036b7ca.png?1452661818" style="width: 150px; height: 120px;"><span>The Maldives is a tropical nation in the Indian Ocean composed of 26 coral atolls, which are made up of hundreds of islands. It’s known for its beaches, blue lagoons and extensive reefs. The capital, Malé, has a busy fish market, restaurants and shops on Majeedhee Magu and 17th-century Hukuru Miskiy (also known as Old Friday Mosque) made of coral stone.</span></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (7, N'Netherlands', N'<p><img class="fr-dib" src="http://i.froala.com/download/6795bc7e4da1e2b6b7caf3a3eb04b17f8c8710a2.png?1452661928" style="width: 150px; height: 120px;"><span>The Netherlands, a country in northwestern Europe, is known for its flat landscape, canals, tulip fields, windmills and cycling routes. Amsterdam, the capital, is home to the Rijksmuseum, Van Gogh Museum, the house where Jewish diarist Anne Frank hid during WWII and a red light district. Canalside mansions and a trove of works from artists including Rembrandt and Vermeer remain from the 17th-century "Golden Age."</span></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (8, N'Africa', N'<p><img class="fr-dib" src="http://i.froala.com/download/1e0d68f2be77f6f62c13e1998565733a609819c9.jpg?1452664237" style="width: 169px;"><span>Africa is the world''s second-largest and second-most-populous continent. At about 30.2 million km² including adjacent islands, it covers six percent of Earth''s total surface area and 20.4 percent of its total land area.</span><span><span><span>&nbsp;</span></span><a data-ved="0ahUKEwiNxt7yi6bKAhUTGI4KHY7mA8IQmhMIiwEwEw" href="http://en.wikipedia.org/wiki/Africa">Wikipedia</a></span></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (9, N'Chile', N'<p><img class="fr-fil fr-dib" alt="Chile&amp;apos;s Falg" src="http://i.froala.com/download/4585eb3ca30cc913a07d9e44b9ae6ba6ff43b6dd.png?1452673851" width="189" title="Chile&amp;apos;s Falg"><!--StartFragment--><b>Chile</b>&nbsp;(<a href="https://en.wikipedia.org/wiki/Help:IPA_for_English" title="Help:IPA for English">/<span><span title="/ˈ/ primary stress follows">ˈ</span><span title="/tʃ/ &amp;apos;ch&amp;apos; in &amp;apos;china&amp;apos;">tʃ</span><span title="/ɪ/ short &amp;apos;i&amp;apos; in &amp;apos;bid&amp;apos;">ɪ</span><span title="&amp;apos;l&amp;apos; in &amp;apos;lie&amp;apos;">l</span><span title="/i/ &amp;apos;y&amp;apos; in &amp;apos;happy&amp;apos;">i</span></span>/</a>;<sup id="cite_ref-7"><a href="https://en.wikipedia.org/wiki/Chile#cite_note-7">[7]</a></sup>&nbsp;<small>Spanish:&nbsp;</small><span title="Representation in the International Phonetic Alphabet (IPA)"><a href="https://en.wikipedia.org/wiki/Help:IPA_for_Spanish" title="Help:IPA for Spanish">[ˈtʃile]</a></span>), officially the&nbsp;<b>Republic of Chile</b>&nbsp;(<a href="https://en.wikipedia.org/wiki/Spanish_language" title="Spanish language">Spanish</a>:&nbsp;<span><a href="https://en.wikipedia.org/wiki/File:RepChile.ogg" title="About this sound"><img alt="About this sound" src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Loudspeaker.svg/11px-Loudspeaker.svg.png" width="11" height="11" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Loudspeaker.svg/17px-Loudspeaker.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Loudspeaker.svg/22px-Loudspeaker.svg.png 2x" data-file-width="20" data-file-height="20" class="fr-dii fr-fin"></a>&nbsp;</span><a href="https://upload.wikimedia.org/wikipedia/commons/5/50/RepChile.ogg" title="RepChile.ogg"><span lang="es"><i>República de Chile</i></span></a>&nbsp;<small>(<a href="https://en.wikipedia.org/wiki/Wikipedia:Media_help" title="Wikipedia:Media help">help</a>·<a href="https://en.wikipedia.org/wiki/File:RepChile.ogg" title="File:RepChile.ogg">info</a>)</small>), is a&nbsp;<a href="https://en.wikipedia.org/wiki/South_America" title="South America">South American</a>&nbsp;country occupying a long, narrow strip of land between the&nbsp;<a href="https://en.wikipedia.org/wiki/Andes" title="Andes">Andes</a>&nbsp;to the east and the Pacific Ocean to the west. It borders&nbsp;<a href="https://en.wikipedia.org/wiki/Peru" title="Peru">Peru</a>&nbsp;to the north,&nbsp;<a href="https://en.wikipedia.org/wiki/Bolivia" title="Bolivia">Bolivia</a>&nbsp;to the northeast,&nbsp;<a href="https://en.wikipedia.org/wiki/Argentina" title="Argentina">Argentina</a>&nbsp;to the east, and the&nbsp;<a href="https://en.wikipedia.org/wiki/Drake_Passage" title="Drake Passage">Drake Passage</a>&nbsp;in the far south. Chilean territory includes the Pacific islands of&nbsp;<a href="https://en.wikipedia.org/wiki/Juan_Fern%C3%A1ndez_Islands" title="Juan Fernández Islands">Juan Fernández</a>,&nbsp;<a href="https://en.wikipedia.org/wiki/Salas_y_G%C3%B3mez" title="Salas y Gómez">Salas y Gómez</a>,&nbsp;<a href="https://en.wikipedia.org/wiki/Desventuradas_Islands" title="Desventuradas Islands">Desventuradas</a>, and&nbsp;<a href="https://en.wikipedia.org/wiki/Easter_Island" title="Easter Island">Easter Island</a>&nbsp;in&nbsp;<a href="https://en.wikipedia.org/wiki/Oceania" title="Oceania">Oceania</a>. Chile also claims about 1,250,000 square kilometres (480,000&nbsp;sq&nbsp;mi) of&nbsp;<a href="https://en.wikipedia.org/wiki/Antarctica" title="Antarctica">Antarctica</a>, although all claims are suspended under the<a href="https://en.wikipedia.org/wiki/Antarctic_Treaty" title="Antarctic Treaty">Antarctic Treaty</a>.<!--EndFragment--></p><p><br></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (10, N'Honduras', N'<p><img class="fr-fil fr-dib" alt="Honduras&amp;apos;s Flag" src="http://i.froala.com/download/231fbd105132eb75dd16ff94a503f019d1a6a314.png?1452674257" width="300" title="Honduras&amp;apos;s Flag"><!--StartFragment--><!--EndFragment--></p><p><!--StartFragment-->Honduras is a Central American country with Caribbean Sea coastlines to the north and the Pacific Ocean to the south (via the Gulf of Fonseca). In the jungle near Guatemala, the ancient Mayan ceremonial site Copán has stone-carved hieroglyphics and stelae, tall stone monuments. Offshore lie the Bay Islands, part of a massive barrier reef, which are popular for scuba diving.<!--EndFragment--><!--StartFragment--><!--EndFragment--><!--StartFragment--><!--EndFragment--></p>')
INSERT [dbo].[t_Country] ([Id], [Name], [About]) VALUES (11, N'Japan', N'<p><img class="fr-fil fr-dib" alt="Japan" src="http://i.froala.com/download/ae9d95b5bed583d402bfe06b7a18430c287ba130.png?1452674532" width="173" title="Japan"><!--StartFragment-->Japan is an island nation in the Pacific Ocean with high-rise-filled cities, imperial palaces, mountainous national parks and thousands of shrines and temples. Tokyo, the crowded capital, is known for its neon skyscrapers and pop culture. In contrast, Kyoto offers Buddhist temples, Shinto shrines, gardens and cherry blossoms. Sushi, the national dish, is served everywhere from casual pubs to gourmet restaurants.<!--EndFragment--></p><p><br></p>')
SET IDENTITY_INSERT [dbo].[t_Country] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_t_City]    Script Date: 13-Jan-16 8:40:30 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_City] ON [dbo].[t_City]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_t_Country]    Script Date: 13-Jan-16 8:40:30 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_Country] ON [dbo].[t_Country]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_City]  WITH CHECK ADD  CONSTRAINT [FK_t_City_t_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[t_Country] ([Id])
GO
ALTER TABLE [dbo].[t_City] CHECK CONSTRAINT [FK_t_City_t_Country]
GO
USE [master]
GO
ALTER DATABASE [CountryInformationDB] SET  READ_WRITE 
GO

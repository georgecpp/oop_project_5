ALTER DATABASE [CleverPocket] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CleverPocket].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CleverPocket] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CleverPocket] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CleverPocket] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CleverPocket] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CleverPocket] SET ARITHABORT OFF 
GO
ALTER DATABASE [CleverPocket] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CleverPocket] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CleverPocket] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CleverPocket] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CleverPocket] SET CURSOR_DEFAULT  GLOBAL 
GO[dbo].[Sessions]
ALTER DATABASE [CleverPocket] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CleverPocket] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CleverPocket] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CleverPocket] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CleverPocket] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CleverPocket] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CleverPocket] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CleverPocket] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CleverPocket] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CleverPocket] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CleverPocket] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CleverPocket] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CleverPocket] SET RECOVERY FULL 
GO
ALTER DATABASE [CleverPocket] SET  MULTI_USER 
GO
ALTER DATABASE [CleverPocket] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CleverPocket] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CleverPocket] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CleverPocket] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CleverPocket] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CleverPocket] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'CleverPocket', N'ON'
GO
ALTER DATABASE [CleverPocket] SET QUERY_STORE = OFF
GO
USE [CleverPocket]
GO
/****** Object:  Table [dbo].[Countries]    Script Date: 13/04/2021 17:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Countries](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [nvarchar](50) NOT NULL,
	[PhoneCode] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sessions]    Script Date: 13/04/2021 17:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sessions](
	[PatID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[PAT] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Sessions] PRIMARY KEY CLUSTERED 
(
	[PatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 13/04/2021 17:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[CountryID] [int] NOT NULL,
	[PhoneNumber] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Countries] ON 

INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (1, N'Greece', N'+30')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (2, N'Netherlands', N'+31')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (3, N'Belgium', N'+32')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (4, N'France', N'+33')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (5, N'Spain', N'+34')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (6, N'Gibraltar', N'+350')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (7, N'Portugal', N'+351')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (8, N'Madeira (landlines only)', N'+351 291')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (9, N'Azores (landlines only, Horta, Azores area)', N'+351 292')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (10, N'Azores (landlines only, Angra do Heroísmo area)', N'+351 295')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (12, N'Luxembourg', N'+352')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (13, N'Ireland', N'+353')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (14, N'Iceland', N'+354')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (15, N'Albania', N'+355')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (16, N'Malta', N'+356')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (17, N'Cyprus (including  Akrotiri and Dhekelia)', N'+357')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (18, N'Finland', N'+358')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (19, N'Åland Islands', N'+358 18')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (20, N'Bulgaria', N'+359')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (21, N'Hungary', N'+36')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (22, N'Lithuania', N'+370')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (23, N'Latvia', N'+371')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (24, N'Estonia', N'+372')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (25, N'Moldova', N'+373')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (26, N'Armenia', N'+374')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (27, N'Artsakh', N'+374 47')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (28, N'Belarus', N'+375')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (29, N'Andorra', N'+376')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (30, N'Monaco', N'+377')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (31, N'San Marino', N'+378')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (32, N'Ukraine', N'+380')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (33, N'Serbia', N'+381')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (34, N'Montenegro', N'+382')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (35, N'Kosovo', N'+383')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (36, N'Croatia', N'+385')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (37, N'Slovenia', N'+386')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (38, N'Bosnia and Herzegovina', N'+387')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (39, N'North Macedonia', N'+389')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (40, N'Italy', N'+39')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (41, N'Vatican City', N'+39 06 698')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (42, N'Italy', N'+41 91')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (43, N'Romania', N'+40')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (44, N'Switzerland', N'+41')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (45, N'Czech Republic', N'+420')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (46, N'Slovakia', N'+421')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (47, N'Liechtenstein', N'+423')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (48, N'Austria', N'+43')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (49, N'United Kingdom', N'+44')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (50, N'Guernsey', N'+44 1481')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (51, N'Jersey', N'+44 1534')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (52, N'Isle of Man', N'+44 1624')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (53, N'Denmark', N'+45')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (54, N'Sweden', N'+46')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (55, N'Norway', N'+47')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (56, N'Svalbard', N'+47 79')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (57, N'Poland', N'+48')
INSERT [dbo].[Countries] ([CountryID], [CountryName], [PhoneCode]) VALUES (58, N'Germany', N'+49')
SET IDENTITY_INSERT [dbo].[Countries] OFF
GO
ALTER TABLE [dbo].[Sessions]  WITH CHECK ADD  CONSTRAINT [FK_Sessions_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Sessions] CHECK CONSTRAINT [FK_Sessions_Users]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Countries] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Countries] ([CountryID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Countries]
GO
USE [master]
GO
ALTER DATABASE [CleverPocket] SET  READ_WRITE 
GO

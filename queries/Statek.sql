INSERT INTO [dbo].[Statek]
           ([Silnik]
           ,[Rok_produkcji]
           ,[Cena_za_dob�]
           ,[Typ_statku_Typ_statku_ID])
     VALUES
           ('M5000', 2014, 5000, 
		   (SELECT [Typ_statku_ID]
			FROM [dbo].[Typ_statku]
			WHERE [Nazwa_typu] = 'Gwiazda �mierci'
		   )),
		   ('T600', 2014, 2000, 
		   (SELECT [Typ_statku_ID]
			FROM [dbo].[Typ_statku]
			WHERE [Nazwa_typu] = 'Niszczyciel'
		   )),
		   ('T600', 2014, 2000, 
		   (SELECT [Typ_statku_ID]
			FROM [dbo].[Typ_statku]
			WHERE [Nazwa_typu] = 'Niszczyciel'
		   )),
		   ('MG8700', 2014, 3000, 
		   (SELECT [Typ_statku_ID]
			FROM [dbo].[Typ_statku]
			WHERE [Nazwa_typu] = 'My�liwiec'
		   ))



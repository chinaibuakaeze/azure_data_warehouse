/*#########################################################################*/
/* SCRIPT FOR RIDER STAGING TABLE*/



IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'bikedatafs_bikedatastc_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [bikedatafs_bikedatastc_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://bikedatafs@bikedatastc.dfs.core.windows.net', 
		TYPE = HADOOP 
	)
GO

CREATE EXTERNAL TABLE staging_trip (
	[C1] varchar(100),
	[C2] varchar(100),
	[C3] varchar(50),
	[C4] varchar(50),
	[C5] varchar(100),
	[C6] varchar(100),
	[C7] bigint
	)
	WITH (
	LOCATION = 'publictrip.csv',
	DATA_SOURCE = [bikedatafs_bikedatastc_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_trip
GO


/*#########################################################################*/
/* SCRIPT FOR STATION STAGING TABLE*/

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'bikedatafs_bikedatastc_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [bikedatafs_bikedatastc_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://bikedatafs@bikedatastc.dfs.core.windows.net', 
		TYPE = HADOOP 
	)
GO

CREATE EXTERNAL TABLE staging_station (
	[C1] varchar(100),
	[C2] varchar(100),
	[C3] float,
	[C4] float
	)
	WITH (
	LOCATION = 'publicstation.csv',
	DATA_SOURCE = [bikedatafs_bikedatastc_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_station
GO



/*#########################################################################*/
/* SCRIPT FOR RIDER STAGING TABLE*/
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'bikedatafs_bikedatastc_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [bikedatafs_bikedatastc_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://bikedatafs@bikedatastc.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE staging_rider (
	[C1] bigint,
	[C2] varchar(100),
	[C3] varchar(100),
	[C4] varchar(100),
	[C5] varchar(100),
	[C6] varchar(100),
	[C7] varchar(100),
	[C8] bit
	)
	WITH (
	LOCATION = 'publicrider.csv',
	DATA_SOURCE = [bikedatafs_bikedatastc_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_rider
GO


/*#########################################################################*/
/* SCRIPT FOR PAYMENT STAGING TABLE*/


IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'bikedatafs_bikedatastc_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [bikedatafs_bikedatastc_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://bikedatafs@bikedatastc.dfs.core.windows.net', 
		TYPE = HADOOP 
	)
GO

CREATE EXTERNAL TABLE staging_payment (
	[C1] bigint,
	[C2] varchar(50),
	[C3] float,
	[C4] bigint
	)
	WITH (
	LOCATION = 'publicpayment.csv',
	DATA_SOURCE = [bikedatafs_bikedatastc_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_payment
GO
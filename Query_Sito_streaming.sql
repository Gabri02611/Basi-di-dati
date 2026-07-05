CREATE database IF NOT EXISTS Sito_Streaming;
USE Sito_Streaming;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Abbonamento;
CREATE TABLE Abbonamento (
    ID_ABBONAMENTO INT PRIMARY KEY,
    Piano VARCHAR(45),
    Data_Sottoscrizone DATETIME,
    Data_Scadenza DATETIME,
    FOREIGN KEY (Piano) REFERENCES Catalogo_Piani(Tipo)
);

DROP TABLE IF EXISTS Account;
CREATE TABLE Account (
    ID_ACCOUNT INT PRIMARY KEY,
    Nome VARCHAR(45),
    Cognome VARCHAR(45),
    Email VARCHAR(45),
    Password VARCHAR(45),
    Metodo_di_Pagamento VARCHAR(45),
    Regione VARCHAR(45),
    Data_Iscrizione DATE,
    Abbonamento INT,
    FOREIGN KEY (Abbonamento) REFERENCES Abbonamento(ID_ABBONAMENTO)
);

DROP TABLE IF EXISTS Acquisto;
CREATE TABLE Acquisto (
    ID_ACQUISTO INT PRIMARY KEY,
    Data_Transazione datetime,
    Data_Scadenza datetime,
    Spesa FLOAT,
    Account INT,
    Contenuto INT,
    FOREIGN KEY (Account) REFERENCES Account(ID_ACCOUNT),
    FOREIGN KEY (Contenuto) REFERENCES Contenuto(ID_CONTENUTO)
);

DROP TABLE IF EXISTS Acquisto_Stagione;
CREATE TABLE Acquisto_Stagione (
    ID_ACQUISTO_TV INT PRIMARY KEY,
    Data_Transazione datetime,
    Data_Scadenza datetime,
    Spesa FLOAT,
    Account INT,
    Stagione INT,
    Serie_TV INT,
    FOREIGN KEY (Account) REFERENCES Account(ID_ACCOUNT),
    FOREIGN KEY (Stagione,Serie_TV) REFERENCES Stagione(Numero,Serie_TV)
);

DROP TABLE IF EXISTS Appartiene;
CREATE TABLE Appartiene (
    Contenuto INT,
    Genere VARCHAR(45),
    PRIMARY KEY (Contenuto, Genere),
    FOREIGN KEY (Contenuto) REFERENCES Contenuto(ID_CONTENUTO),
    FOREIGN KEY (Genere) REFERENCES Genere(Nome)
);

DROP TABLE IF EXISTS Appartiene_TV;
CREATE TABLE Appartiene_TV(
	Serie_TV INT,
    Genere VARCHAR(45),
    PRIMARY KEY  (Serie_TV, Genere),
    FOREIGN KEY (Serie_TV) REFERENCES Serie_TV(ID_SERIE),
    FOREIGN KEY (Genere) REFERENCES Genere_TV(Nome)
);

DROP TABLE IF EXISTS Attore;
CREATE TABLE Attore (
    ID_ATTORE INT PRIMARY KEY,
    Nome VARCHAR(45),
    Cognome VARCHAR(45),
    Data_di_Nascita DATE
);

DROP TABLE IF EXISTS Casa_di_Produzione;
CREATE TABLE Casa_di_Produzione (
    Nome VARCHAR(45) PRIMARY KEY
);

DROP TABLE IF EXISTS Catalogo_piani;
CREATE TABLE Catalogo_piani (
    Tipo VARCHAR(10) PRIMARY KEY,
    Costo FLOAT,
    CONSTRAINT tipologie_abbonamenti CHECK (Tipo IN ('Base', 'Silver', 'Gold'))
    
);

DROP TABLE IF EXISTS Collegamento;
CREATE TABLE Collegamento (
    Account INT,
    Dispositivo INT,
    PRIMARY KEY (Account, Dispositivo),
    FOREIGN KEY (Account) REFERENCES Account(ID_ACCOUNT),
    FOREIGN KEY (Dispositivo) REFERENCES Dispositivo(ID_DEVICE)
);

DROP TABLE IF EXISTS Contenuto;
CREATE TABLE Contenuto (
    ID_CONTENUTO INT PRIMARY KEY,
    Titolo VARCHAR(45),
    Tipo VARCHAR(45),
    Descrizione TEXT,
    Prezzo FLOAT,
    PEGI VARCHAR(7),
    Valutazione INT,
    Durata TIME, 
    Data_Uscita DATE,
    Data_Aggiunta_Catalogo date,
    CONSTRAINT chk_pegi_valido CHECK (PEGI IN ('Bambini', 'Ragazzi', 'Adulti'))
);

DROP TABLE IF EXISTS Creatore;
CREATE TABLE Creatore (
    Nome VARCHAR(45),
    Cognome VARCHAR(45),
    Data_di_Nascita DATE,
    PRIMARY KEY (Nome, Cognome)
);

DROP TABLE IF EXISTS Creazione;
CREATE TABLE Creazione (
    Nome_Creatore VARCHAR(45),
    Cognome_Creatore VARCHAR(45),
    Serie_TV INT,
    PRIMARY KEY (Nome_Creatore, Cognome_Creatore, Serie_TV),
    FOREIGN KEY (Nome_Creatore, Cognome_Creatore) REFERENCES Creatore(Nome, Cognome),
    FOREIGN KEY (Serie_TV) REFERENCES Serie_TV(ID_SERIE)
);

DROP TABLE IF EXISTS Dispositivo;
CREATE TABLE Dispositivo (
    ID_DEVICE INT PRIMARY KEY,
    Nome VARCHAR(45),
    Tipo VARCHAR(15),
    Modello VARCHAR(45),
    CONSTRAINT tipi_dev CHECK (Tipo IN ('SmartPhone', 'PC', 'SmartTv'))
    
);

DROP TABLE IF EXISTS Episodio;
CREATE TABLE Episodio(
    ID_EPISODIO INT PRIMARY KEY,
    Stagione INT,
    Serie_TV INT,
    FOREIGN KEY (Stagione,Serie_TV) REFERENCES Stagione(Numero, Serie_TV),
	FOREIGN KEY (ID_EPISODIO) REFERENCES Contenuto(ID_CONTENUTO)
);

DROP TABLE IF EXISTS Genere;
CREATE TABLE Genere (
    Nome VARCHAR(45) PRIMARY KEY
);

DROP TABLE IF EXISTS Genere_TV;
CREATE TABLE Genere_TV(
	Nome VARCHAR(45) PRIMARY KEY
);

DROP TABLE IF EXISTS Interpretazione;
CREATE TABLE Interpretazione (
    Attore INTEGER,
    Contenuto INT,
    PRIMARY KEY (Attore, Contenuto),
    FOREIGN KEY (Attore) REFERENCES Attore(ID_ATTORE),
    FOREIGN KEY (Contenuto) REFERENCES Contenuto(ID_CONTENUTO)
);

DROP TABLE IF EXISTS Lista;
CREATE TABLE Lista (
    Data_Aggiunta TIMESTAMP,
    Profilo INT,
    Contenuto INT,
    PRIMARY KEY (Profilo, Contenuto),
    FOREIGN KEY (Profilo) REFERENCES Profilo(ID_PROFILO),
    FOREIGN KEY (Contenuto) REFERENCES Contenuto(ID_CONTENUTO)
);

DROP TABLE IF EXISTS Lista_Stagione;
CREATE TABLE Lista_Stagione (
    Data_Aggiunta TIMESTAMP,
    Profilo INT,
    Stagione INT,
    Serie_TV INT,
    PRIMARY KEY (Data_Aggiunta, Profilo, Stagione, Serie_TV),
    FOREIGN KEY (Profilo) REFERENCES Profilo(ID_PROFILO),
    FOREIGN KEY (Stagione, Serie_TV) REFERENCES Stagione(Numero, Serie_TV)
);

DROP TABLE IF EXISTS Prodotto;
CREATE TABLE Prodotto (
    Casa VARCHAR(45),
    Contenuto INT,
    PRIMARY KEY (Casa, Contenuto),
    FOREIGN KEY (Casa) REFERENCES Casa_di_Produzione(Nome),
    FOREIGN KEY (Contenuto) REFERENCES Contenuto(ID_CONTENUTO)
);

DROP TABLE IF EXISTS Profilo;
CREATE TABLE Profilo (
    ID_PROFILO INT PRIMARY KEY,
    Nome VARCHAR(45),
    Tipo VARCHAR(45),
    Data_Creazione DATE,
    Account INT,
    FOREIGN KEY (Account) REFERENCES Account(ID_ACCOUNT),
    #Due Profili associati allo stesso account non possono avere lo stesso nome
    CONSTRAINT chk_profilo_unico UNIQUE (Account, Nome)
);

DROP TABLE IF EXISTS Regia;
CREATE TABLE Regia (
    Nome_Regista VARCHAR(45),
    Cognome_Regista VARCHAR(45),
    Contenuto INT,
    PRIMARY KEY (Nome_Regista, Cognome_Regista, Contenuto),
    FOREIGN KEY (Nome_Regista, Cognome_Regista) REFERENCES Regista(Nome, Cognome),
    FOREIGN KEY (Contenuto) REFERENCES Contenuto(ID_CONTENUTO)
);

DROP TABLE IF EXISTS Regista;
CREATE TABLE Regista (
    Nome VARCHAR(45),
    Cognome VARCHAR(45),
    Data_Nascita DATE, 
    PRIMARY KEY (Nome, Cognome)
);

DROP TABLE IF EXISTS Serie_TV;
CREATE TABLE Serie_TV (
    ID_SERIE INT PRIMARY KEY,
    Titolo VARCHAR(45),
    Incipit TEXT
);

DROP TABLE IF EXISTS Sessione;
CREATE TABLE Sessione (
    ID_SESSIONE INT PRIMARY KEY,
    Ora_Inizio TIMESTAMP,
    Ora_Fine TIMESTAMP,
    Lingua VARCHAR(45),
    Profilo INT,
    Dispositivo INT,
    Contenuto INT,
    FOREIGN KEY (Profilo) REFERENCES Profilo(ID_PROFILO),
    FOREIGN KEY (Dispositivo) REFERENCES Dispositivo(ID_DEVICE),
    FOREIGN KEY (Contenuto) REFERENCES Contenuto(ID_CONTENUTO)
);

DROP TABLE IF EXISTS Stagione;
CREATE TABLE Stagione (
    Numero INT,
    Serie_TV INT,
    Prezzo FLOAT,
    Emittente VARCHAR(45),
    PRIMARY KEY (Numero, Serie_TV),
    FOREIGN KEY (Serie_TV) REFERENCES Serie_TV(ID_SERIE) 
);

DROP TABLE IF EXISTS Valutazione;
CREATE TABLE Valutazione (
    Voto INT,
    Data DATE,
    Profilo INT,
    Contenuto INT,
    PRIMARY KEY (Profilo, Contenuto),
    FOREIGN KEY (Profilo) REFERENCES Profilo(ID_PROFILO),
    FOREIGN KEY (Contenuto) REFERENCES Contenuto(ID_CONTENUTO)
);
SET FOREIGN_KEY_CHECKS = 1;
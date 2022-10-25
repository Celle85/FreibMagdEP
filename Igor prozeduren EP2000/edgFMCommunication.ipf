#pragma rtGlobals=1		// Use modern global access method.


// 2014-02-24	mehr Sicherheitsprüfungen beim Anlegen neuer Datensätze
// 2010-03-04	begonnen, ausgelagert aus EP2000-Plot


StrConstant kNameOfDatabase = "EDIAG-Datei_.fp7"		// only relevant for Freiburg ;-)


function /S FM_GetDiagnosisFromDatabase(searchFieldName, searchContent, layoutName, diagnosisFieldName)
	string searchFieldName, searchContent, layoutName, diagnosisFieldName
	FM_tellFileMakerTo("activate")
	if (strsearch(FM_tellFileMakerTo("get number of databases"), "0", 0) != -1)
		FM_tellFileMakerTo("getURL \"FMP7://ha21020/"+kNameOfDatabase+"\" ")
	endif
	sleep /S 1.0
	FM_tellFileMakerTo("tell database 1 to show every record")
	FM_tellFileMakerTo("tell database 1 to show layout \"Liste\"");  FM_tellFileMakerTo("try\rdelete every request\rend try")
	FM_tellFileMakerTo("create request")
	FM_tellFileMakerTo("set cell \""+searchFieldName+"\" of request 1 to \"" +searchContent + "\"")
	ExecuteScriptText /Z("tell application \"FileMaker Pro\" to find\r")
	if (V_Flag != 0) 
		return ""
	endif
	FM_tellFileMakerTo("show layout \""+layoutName+"\"")
	string befund =  FM_GetFieldString(diagnosisFieldName);  FM_tellFileMakerTo("tell database 1 to show layout \"Liste\"")
	FM_tellFileMakerTo("tell database 1 to show every record")
	ExecuteScriptText /Z("tell me to activate\r")
	befund = StringTrim(befund);  befund=StringTrim(befund[1, strlen(befund)-2])
	return befund
end


function FM_AddSubject2Database(subjectName, GDatum, UDatum, theDoctor, diagnosis, acuityOD, acuityOS, piz, edgNumberFieldName, edgNumberString)
	String subjectName, GDatum, UDatum, theDoctor, diagnosis, acuityOD, acuityOS, piz, edgNumberFieldName, edgNumberString
	FM_tellFileMakerTo("activate")
	if (strsearch(FM_tellFileMakerTo("get number of databases"), "0", 0) != -1)
		FM_tellFileMakerTo("getURL \"FMP7://ha21020/"+kNameOfDatabase+"\" ")
	endif
	FM_tellFileMakerTo("go to last record")	// unnötig, aber vielleicht vermeidet das die mysteriösen Überschreibungen 2014-02-24 mb
	FM_tellFileMakerTo("show layout \"Karteikarte\"")	// dito
	FM_tellFileMakerTo("create new record")
	FM_tellFileMakerTo("go to last record")
	FM_tellFileMakerTo("show layout \"Karteikarte\"")
	// nun prüfen ob das wirklich leer ist
	string s = FM_GetFieldString("Name")
	if (strlen(s) > 2) // bei leerem Feld wird 2x Gänsefüßchen zurückgeliefert…
		Abort "Abbruch der Datenübertragung: im Namensfeld steht bereits etwas drin."
	endif	
	s = FM_GetFieldString(edgNumberFieldName)
	if (strlen(s) > 2) 
		Abort "Abbruch der Datenübertragung: im ERG-Nummerfeld steht bereits etwas drin."
	endif	
	FM_SetField("Name", subjectName); 		FM_SetField("PIZ", piz)
	FM_SetField("GDatum", GDatum);			FM_SetField("UDatum", UDatum);		
	FM_SetField("AnfordArzt", theDoctor);	FM_SetField("klindg", diagnosis);		
	FM_SetField("VisusRA", acuityOD);  		FM_SetField("VisusLA", acuityOS);
	FM_SetField(edgNumberFieldName, edgNumberString)
	FM_tellFileMakerTo("show layout \"Liste\"")
end


function  FM_SetField(fieldName, value)
	string fieldName, value
	FM_tellFileMakerTo("set data cell \"" + fieldName + "\" of current record to \"" + value + "\"")
end


function /S FM_GetFieldString(fieldName)
	string fieldName
	ExecuteScriptText /Z ("tell application \"FileMaker Pro\" to get data cell\"" + fieldName + "\" of current record\r")
	return S_value
end


function /S FM_tellFileMakerTo(theCommand)
	string theCommand
	sleep /S 0.2;  ExecuteScriptText /Z ("tell application \"FileMaker Pro\" to activate\r")
	sleep /S 0.2;  ExecuteScriptText /Z ("tell application \"FileMaker Pro\" to " + theCommand + "\r")
	ErrorExitCheck(V_Flag, "Fehler Nr. " + num2str(V_Flag)+ ", Text: “" + S_value + "” bei folgendem Kommando: “" + theCommand + "”")
	return S_value
end

#pragma rtGlobals=1		// Use modern global access method.


// edgPlotUtils
//
//	2010-08-02	added "GetSubjectName"
//	2010-03-22	slight reformatting
//	2010-03-19	added GetPIZString, GetDateBornString, GetDateRecordingString
//	2010-03-11	begun (mb)
//

Function CopyAllLayouts2Notebook([IDString])
	String IDString
	if (ParamIsDefault(IDString))
		IDString = ""
	endif
	String nb = "Notebook4Printing", listOfLayouts = WinList("*", "; ", "WIN:4")	// all layouts, will be read backwards
	Variable i, n = ItemsInList(listOfLayouts)
	DoWindow /K $nb;  NewNotebook /N=$nb/F=1/K=1 as (IDString+nb)
	Notebook $nb margins={0, 0, 0}, pageMargins={0, 0, 0, 0}, footerControl={0 , 0 , 0}, headerControl={0, 0, 0}
	for (i = 0; i < n; i += 1)
		String theLayout = StringFromList(i, listOfLayouts)
		DoWindow /F $theLayout	// pull layout to front so we can draw on it
		SetDrawEnv linethick=1, fillpat=0, linefgc=(65530, 65530, 65530);  DrawRect  0, 0, 580, 827	// add a DIN A4 page frame
		Notebook $nb picture={$theLayout(0,0,0,0), 8, 1}	// add that layout as Quartz PDF in color
		if (i < (n-1))
			Notebook $nb specialChar={1, 0, ""}	// adding page breaks for all but the last one
		endif
	endfor
	DoWindow /F $nb;  PrintSettings /M copySource=Preferred_Settings
//	ExecuteScriptText /Z "tell application \"System Events\" to keystroke \"P\" using command down\r"
end


function ReplaceNumberByKeyInWavenote(key, newValue, theWave)
	string key;  variable newValue;  	wave theWave
	string s = note(theWave)
	Note /K $NameOfWave(theWave)
	s = ReplaceNumberByKey(key, s, newValue)
	Note $NameOfWave(theWave), s
end


function ReplaceStringByKeyInWavenote(key, newString, theWave)
	string key, newString;  wave theWave
	string s = note(theWave)
	Note /K $NameOfWave(theWave)
	s = ReplaceStringByKey(key, s, newString)
	Note $NameOfWave(theWave), s
end


Function /S GetEyeString(theWave)
	wave theWave
	return StringByKey(kKeyEyeKey, note(theWave))
end


Function GetEPNumber(theWave)
	wave theWave
	return NumberByKey(kKeyEPNumber, note(theWave))
end


Function /S GetEPNumberString(theWave)
	wave theWave
	return num2istr(GetEPNumber(theWave))
end


Function GetBlockNumber(theWave)
	wave theWave
	return NumberByKey(kKeyBlockNumber, note(theWave))
end


Function /S GetBlockString(theWave)
	wave theWave
	return num2char(char2num("A")+GetBlockNumber(theWave))
end


Function /S GetSequenceNameString(theWave)
	wave theWave
	return StringByKey(kKeySeqName, note(theWave))
end


function /S GetPIZString(theWave)
	wave theWave
	String s = StringByKey(kkeyPIZ, note(theWave))
	if (strlen(s) <2)
		s = StringByKey(kkeyPIZ2, note(theWave))
	endif
	return s
end


Function /S GetDateBornString(theWave)
	wave theWave
	return StringByKey(kKeyDateBorn, note(theWave))
end


Function /S GetDateRecordingString(theWave)
	wave theWave
	return StringByKey(kKeyDateRecording, note(theWave))
end


Function /S GetSubjectName(theWave)
	wave theWave
	return StringByKey(kKeySubjectName, note(theWave))
end

